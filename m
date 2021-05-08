Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02A7C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9563261456
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWzR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B9786142D;
        Sat,  8 May 2021 22:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514455;
        bh=9u74SgKxLm0s68HoCRLklPzQ9eYDCPaj1Wm4yAJdz14=;
        h=Date:From:To:Subject:From;
        b=h8NfnELghvXF71xk13oE8HoaLQYp8LVmw6Ty8O+pXAjY+2naco2T9JxGAAZafW9Lq
         8dERDVru+IqAYovmeMAh2NxnwGdeCZXPZGo3AEsK9CtHrgXQsMcx5257rKFeZ/7D3W
         CgPxM6/Vn6FhOUfofb1fdWSA58MqZOrLNq8TeF6Q=
Date:   Sat, 08 May 2021 15:54:15 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com,
        dan.j.williams@intel.com, daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, smuchun@gmail.com
Subject:  [merged]
 kernel-resource-refactor-__request_region-to-allow-external-locking.patch
 removed from -mm tree
Message-ID: <20210508225415.d8Tm1Oxya%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: refactor __request_region to allow external locking
has been removed from the -mm tree.  Its filename was
     kernel-resource-refactor-__request_region-to-allow-external-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from apopple@nvidia.com are


