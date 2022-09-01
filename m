Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA23ECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 22:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiIAWyP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 18:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbiIAWyP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 18:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0D4760DA
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 15:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADDE762033
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 22:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D89C433D6;
        Thu,  1 Sep 2022 22:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662072853;
        bh=HKALoEFtBLkYZgKme568NbgAAWf3GVVMDA0v8bcjYes=;
        h=Date:To:From:Subject:From;
        b=AkFn68WhOTy8LENUQxnjIXg6yJp5jXtxfeKaSJznwII2OoPNvjs8lhkA5zie30atP
         8V+D6PdrYcneW1iGU/06IV5b43OTt9QDNUmfGvOEPuUSHIItcannzNrbq7+cNOdq2X
         qlNVyCMBnqxuwoicy3YGdo4mob4ygZw/tmI+ugcE=
Date:   Thu, 01 Sep 2022 15:54:12 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        catalin.marinas@arm.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-make-create_object-return-void.patch added to mm-unstable branch
Message-Id: <20220901225413.10D89C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: make create_object return void
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-make-create_object-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-make-create_object-return-void.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/kmemleak: make create_object return void
Date: Thu, 1 Sep 2022 10:30:07 +0800

No caller cares about the return value of create_object(), so make it
return void.

Link: https://lkml.kernel.org/r/20220901023007.3471887-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-make-create_object-return-void
+++ a/mm/kmemleak.c
@@ -604,9 +604,8 @@ static int __save_stack_trace(unsigned l
  * memory block and add it to the object_list and object_tree_root (or
  * object_phys_tree_root).
  */
-static struct kmemleak_object *__create_object(unsigned long ptr, size_t size,
-					     int min_count, gfp_t gfp,
-					     bool is_phys)
+static void __create_object(unsigned long ptr, size_t size,
+			    int min_count, gfp_t gfp, bool is_phys)
 {
 	unsigned long flags;
 	struct kmemleak_object *object, *parent;
@@ -618,7 +617,7 @@ static struct kmemleak_object *__create_
 	if (!object) {
 		pr_warn("Cannot allocate a kmemleak_object structure\n");
 		kmemleak_disable();
-		return NULL;
+		return;
 	}
 
 	INIT_LIST_HEAD(&object->object_list);
@@ -687,7 +686,6 @@ static struct kmemleak_object *__create_
 			 */
 			dump_object_info(parent);
 			kmem_cache_free(object_cache, object);
-			object = NULL;
 			goto out;
 		}
 	}
@@ -698,21 +696,20 @@ static struct kmemleak_object *__create_
 	list_add_tail_rcu(&object->object_list, &object_list);
 out:
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
-	return object;
 }
 
 /* Create kmemleak object which allocated with virtual address. */
-static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
-					     int min_count, gfp_t gfp)
+static void create_object(unsigned long ptr, size_t size,
+			  int min_count, gfp_t gfp)
 {
-	return __create_object(ptr, size, min_count, gfp, false);
+	__create_object(ptr, size, min_count, gfp, false);
 }
 
 /* Create kmemleak object which allocated with physical address. */
-static struct kmemleak_object *create_object_phys(unsigned long ptr, size_t size,
-					     int min_count, gfp_t gfp)
+static void create_object_phys(unsigned long ptr, size_t size,
+			       int min_count, gfp_t gfp)
 {
-	return __create_object(ptr, size, min_count, gfp, true);
+	__create_object(ptr, size, min_count, gfp, true);
 }
 
 /*
_

Patches currently in -mm which might be from liushixin2@huawei.com are

revert-frontswap-remove-support-for-multiple-ops.patch
revert-mm-mark-swap_lock-and-swap_active_head-static.patch
revert-frontswap-simplify-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch
mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch
mm-kmemleak-make-create_object-return-void.patch

