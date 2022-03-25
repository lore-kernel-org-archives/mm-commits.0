Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAB0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357448AbiCYBhN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357529AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D1532E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C519260A50
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29667C340ED;
        Fri, 25 Mar 2022 01:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172060;
        bh=3j0qs0Tx7rHPjlUX39c+EwomxUsgLmr9jcN+3OMHOJc=;
        h=Date:To:From:Subject:From;
        b=19JqsVUS+r7OmagFhB8y2m8N83273p8k89d8RGlqD/I+RdypVxQc5cCDntrgQplE3
         uDpzcsmWJN5ELqx+/x+I6rJ89+wwXjOhw6L9vf4nxQ1Dck2bTnkW/7enyMrYvBB+4Q
         AzbSXPPFAxUU9I3NGrXZ+Jpl+prT54E33W3V5QME=
Date:   Thu, 24 Mar 2022 18:34:19 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        dan.j.williams@intel.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kernel-resource-fix-kfree-of-bootmem-memory-again.patch removed from -mm tree
Message-Id: <20220325013420.29667C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: fix kfree() of bootmem memory again
has been removed from the -mm tree.  Its filename was
     kernel-resource-fix-kfree-of-bootmem-memory-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

