Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EF6C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99BC761970
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCSWwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 18:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhCSWvv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 18:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D37C661970;
        Fri, 19 Mar 2021 22:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616194310;
        bh=lmmpEjR+ai9f5l/qKPvipku1aZ06LOMyvMw6KSST5PA=;
        h=Date:From:To:Subject:From;
        b=Y8zUoVeuzaGfUcSHVMKdx7mCoWxHIW5Wp4h/mXU9Jl6t5AhjMyBl/rqubiFuA7qO4
         IjGkqVaSxllj7ZKtSKS3pKDBfrj3CmV6wl5HW5xN9pqTOguEcDxHQsW17UrZG1auEx
         EKJyaXfDsfTOK5Lifl9jqlpLLIpYbOMuSKHqwW9s=
Date:   Fri, 19 Mar 2021 15:51:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  + mm-few-spelling-fixes.patch added to -mm tree
Message-ID: <20210319225150.8rc5zt78i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/pgtable.h: few spelling fixes
has been added to the -mm tree.  Its filename is
     mm-few-spelling-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-few-spelling-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-few-spelling-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: include/linux/pgtable.h: few spelling fixes

Few spelling fixes throughout the file.

Link: https://lkml.kernel.org/r/20210318201404.6380-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-few-spelling-fixes
+++ a/include/linux/pgtable.h
@@ -426,7 +426,7 @@ static inline void ptep_set_wrprotect(st
 
 /*
  * On some architectures hardware does not set page access bit when accessing
- * memory page, it is responsibilty of software setting this bit. It brings
+ * memory page, it is responsibility of software setting this bit. It brings
  * out extra page fault penalty to track page access bit. For optimization page
  * access bit can be set during all page fault flow on these arches.
  * To be differentiate with macro pte_mkyoung, this macro is used on platforms
@@ -519,7 +519,7 @@ extern pgtable_t pgtable_trans_huge_with
 /*
  * This is an implementation of pmdp_establish() that is only suitable for an
  * architecture that doesn't have hardware dirty/accessed bits. In this case we
- * can't race with CPU which sets these bits and non-atomic aproach is fine.
+ * can't race with CPU which sets these bits and non-atomic approach is fine.
  */
 static inline pmd_t generic_pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
@@ -852,7 +852,7 @@ static inline void __ptep_modify_prot_co
  * updates, but to prevent any updates it may make from being lost.
  *
  * This does not protect against other software modifications of the
- * pte; the appropriate pte lock must be held over the transation.
+ * pte; the appropriate pte lock must be held over the transaction.
  *
  * Note that this interface is intended to be batchable, meaning that
  * ptep_modify_prot_commit may not actually update the pte, but merely
@@ -1281,13 +1281,13 @@ static inline int pmd_none_or_trans_huge
 	 *
 	 * The complete check uses is_pmd_migration_entry() in linux/swapops.h
 	 * But using that requires moving current function and pmd_trans_unstable()
-	 * to linux/swapops.h to resovle dependency, which is too much code move.
+	 * to linux/swapops.h to resolve dependency, which is too much code move.
 	 *
 	 * !pmd_present() is equivalent to is_pmd_migration_entry() currently,
 	 * because !pmd_present() pages can only be under migration not swapped
 	 * out.
 	 *
-	 * pmd_none() is preseved for future condition checks on pmd migration
+	 * pmd_none() is preserved for future condition checks on pmd migration
 	 * entries and not confusing with this function name, although it is
 	 * redundant with !pmd_present().
 	 */
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
mm-few-spelling-fixes.patch
kernel-fix-a-typo-in-the-file-upc.patch
lib-fix-a-typo-in-the-file-bchc.patch
ipc-semc-couple-of-spelling-fixes.patch

