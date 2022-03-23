Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EE5C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345518AbiCWXJK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345490AbiCWXIz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB4490CC0
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6EB617F1
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5168EC340EE;
        Wed, 23 Mar 2022 23:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076839;
        bh=tl3Vpw1b/ZTsG2DUIPp96zuks4WVQhE/4KiH9Q+hMRs=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=yrBEw+g9HCY6Iwe57esN4w0xMOSqPTExvHUTm23tNESs9BU6mscjhDTkOrzkyqOsR
         ClIqVCC0noIAWdVvwKpnkmJWNuownN+XhuAOQ2BjcKEe8i89HvtnRbe2qdS+d9qJnk
         SRGIH/9+vENJn6U8YB/ZzEyqTv7U05NoOWfM3zp4=
Date:   Wed, 23 Mar 2022 16:07:18 -0700
To:     david@redhat.com, dan.j.williams@intel.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 40/41] kernel/resource: fix kfree() of bootmem memory again
Message-Id: <20220323230719.5168EC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: kernel/resource: fix kfree() of bootmem memory again

Since commit ebff7d8f270d ("mem hotunplug: fix kfree() of bootmem
memory"), we could get a resource allocated during boot via
alloc_resource().  And it's required to release the resource using
free_resource().  Howerver, many people use kfree directly which will
result in kernel BUG.  In order to fix this without fixing every call
site, just leak a couple of bytes in such corner case.

Link: https://lkml.kernel.org/r/20220217083619.19305-1-linmiaohe@huawei.com
Fixes: ebff7d8f270d ("mem hotunplug: fix kfree() of bootmem memory")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

--- a/kernel/resource.c~kernel-resource-fix-kfree-of-bootmem-memory-again
+++ a/kernel/resource.c
@@ -56,14 +56,6 @@ struct resource_constraint {
 
 static DEFINE_RWLOCK(resource_lock);
 
-/*
- * For memory hotplug, there is no way to free resource entries allocated
- * by boot mem after the system is up. So for reusing the resource entry
- * we need to remember the resource.
- */
-static struct resource *bootmem_resource_free;
-static DEFINE_SPINLOCK(bootmem_resource_lock);
-
 static struct resource *next_resource(struct resource *p)
 {
 	if (p->child)
@@ -160,36 +152,19 @@ __initcall(ioresources_init);
 
 static void free_resource(struct resource *res)
 {
-	if (!res)
-		return;
-
-	if (!PageSlab(virt_to_head_page(res))) {
-		spin_lock(&bootmem_resource_lock);
-		res->sibling = bootmem_resource_free;
-		bootmem_resource_free = res;
-		spin_unlock(&bootmem_resource_lock);
-	} else {
+	/**
+	 * If the resource was allocated using memblock early during boot
+	 * we'll leak it here: we can only return full pages back to the
+	 * buddy and trying to be smart and reusing them eventually in
+	 * alloc_resource() overcomplicates resource handling.
+	 */
+	if (res && PageSlab(virt_to_head_page(res)))
 		kfree(res);
-	}
 }
 
 static struct resource *alloc_resource(gfp_t flags)
 {
-	struct resource *res = NULL;
-
-	spin_lock(&bootmem_resource_lock);
-	if (bootmem_resource_free) {
-		res = bootmem_resource_free;
-		bootmem_resource_free = res->sibling;
-	}
-	spin_unlock(&bootmem_resource_lock);
-
-	if (res)
-		memset(res, 0, sizeof(struct resource));
-	else
-		res = kzalloc(sizeof(struct resource), flags);
-
-	return res;
+	return kzalloc(sizeof(struct resource), flags);
 }
 
 /* Return the conflict entry if you can't request it */
_
