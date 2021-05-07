Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B44CC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D10D613CE
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhEGBG2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhEGBG2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A2E61289;
        Fri,  7 May 2021 01:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349528;
        bh=7ERy2ZZbsEHG/m9AjEK9+0IixZwrY09GcpZIRJZKmOw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1vX5ztBf9ef6UNb6fPoxxvEceHbhOgPuTXN1HRhB9ZhanhbFBU41v9MYhcUefmRjb
         nSB+v6GOQe2TeI3pURXMXkDpoWQEZpaiMu/f3AJ9eCLEPSRKTd0GKQs/Cj2T2oYaBO
         cwc2E1Q5Y5vqudCYop6qHJ4h9qETa8KgXVuuxZ4w=
Date:   Thu, 06 May 2021 18:05:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        bsingharora@gmail.com, dan.j.williams@intel.com,
        daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, smuchun@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 65/91] kernel/resource: refactor __request_region
 to allow external locking
Message-ID: <20210507010527.ZLYcR2wON%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>
Subject: kernel/resource: refactor __request_region to allow external locking

Refactor the portion of __request_region() done whilst holding the
resource_lock into a separate function to allow callers to hold the lock.

Link: https://lkml.kernel.org/r/20210419070109.4780-2-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Muchun Song <smuchun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   52 +++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

--- a/kernel/resource.c~kernel-resource-refactor-__request_region-to-allow-external-locking
+++ a/kernel/resource.c
@@ -1160,31 +1160,16 @@ struct address_space *iomem_get_mapping(
 	return smp_load_acquire(&iomem_inode)->i_mapping;
 }
 
-/**
- * __request_region - create a new busy resource region
- * @parent: parent resource descriptor
- * @start: resource start address
- * @n: resource region size
- * @name: reserving caller's ID string
- * @flags: IO resource flags
- */
-struct resource * __request_region(struct resource *parent,
+static int __request_region_locked(struct resource *res, struct resource *parent,
 				   resource_size_t start, resource_size_t n,
 				   const char *name, int flags)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	struct resource *res = alloc_resource(GFP_KERNEL);
-	struct resource *orig_parent = parent;
-
-	if (!res)
-		return NULL;
 
 	res->name = name;
 	res->start = start;
 	res->end = start + n - 1;
 
-	write_lock(&resource_lock);
-
 	for (;;) {
 		struct resource *conflict;
 
@@ -1220,13 +1205,40 @@ struct resource * __request_region(struc
 			continue;
 		}
 		/* Uhhuh, that didn't work out.. */
-		free_resource(res);
-		res = NULL;
-		break;
+		return -EBUSY;
 	}
+
+	return 0;
+}
+
+/**
+ * __request_region - create a new busy resource region
+ * @parent: parent resource descriptor
+ * @start: resource start address
+ * @n: resource region size
+ * @name: reserving caller's ID string
+ * @flags: IO resource flags
+ */
+struct resource *__request_region(struct resource *parent,
+				  resource_size_t start, resource_size_t n,
+				  const char *name, int flags)
+{
+	struct resource *res = alloc_resource(GFP_KERNEL);
+	int ret;
+
+	if (!res)
+		return NULL;
+
+	write_lock(&resource_lock);
+	ret = __request_region_locked(res, parent, start, n, name, flags);
 	write_unlock(&resource_lock);
 
-	if (res && orig_parent == &iomem_resource)
+	if (ret) {
+		free_resource(res);
+		return NULL;
+	}
+
+	if (parent == &iomem_resource)
 		revoke_iomem(res);
 
 	return res;
_
