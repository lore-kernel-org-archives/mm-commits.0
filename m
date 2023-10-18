Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6588CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbjJRPkx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjJRPkw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:40:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7716D111
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:40:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106DEC433C7;
        Wed, 18 Oct 2023 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643650;
        bh=1HniklLQfuoIB6SIPODENcgA4b8ZGrQogKCgtpu9v3c=;
        h=Date:To:From:Subject:From;
        b=qj0j6KwSeEdp7xb/1H2pBG39z9rdlmD+Gu1772V66OXkh9xgheImLyCr9JsHIQg1o
         8v4nCghVFTcWfJ0GJSd0vDnV8841wJVf1RxTB0l0Ahc1XLgp5C5ajLeh4IR88QpkMN
         mkh9UHRCH1jzRVGchYV+Pd2tYHmfpO4X3APtLVyw=
Date:   Wed, 18 Oct 2023 08:40:49 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-add-__find_and_remove_object.patch added to mm-unstable branch
Message-Id: <20231018154050.106DEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: add __find_and_remove_object()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-add-__find_and_remove_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-add-__find_and_remove_object.patch

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
Subject: mm: kmemleak: add __find_and_remove_object()
Date: Wed, 18 Oct 2023 18:29:51 +0800

Add new __find_and_remove_object() without kmemleak_lock protect, it is in
preparation for the next patch.

Link: https://lkml.kernel.org/r/20231018102952.3339837-7-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-add-__find_and_remove_object
+++ a/mm/kmemleak.c
@@ -583,6 +583,19 @@ static void __remove_object(struct kmeml
 	object->del_state |= DELSTATE_REMOVED;
 }
 
+static struct kmemleak_object *__find_and_remove_object(unsigned long ptr,
+							int alias,
+							bool is_phys)
+{
+	struct kmemleak_object *object;
+
+	object = __lookup_object(ptr, alias, is_phys);
+	if (object)
+		__remove_object(object);
+
+	return object;
+}
+
 /*
  * Look up an object in the object search tree and remove it from both
  * object_tree_root (or object_phys_tree_root) and object_list. The
@@ -596,9 +609,7 @@ static struct kmemleak_object *find_and_
 	struct kmemleak_object *object;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
-	object = __lookup_object(ptr, alias, is_phys);
-	if (object)
-		__remove_object(object);
+	object = __find_and_remove_object(ptr, alias, is_phys);
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
 
 	return object;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch
bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch
bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch
mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-kmemleak-use-mem_pool_free-to-free-object.patch
mm-kmemleak-add-__find_and_remove_object.patch
mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

