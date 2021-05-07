Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE21C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D3BD613C2
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhEGBHY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234197AbhEGBHY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2895E613C5;
        Fri,  7 May 2021 01:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349585;
        bh=NhV7fcjOBKdT5DvTLPjGwXzxAyeeL/nSUy67Ojf0g58=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I8DpRi6fY4G0s7a8Yt2J9udNJ7EYI/jk9+bJ4RyFtl+p1IZ9EzGZPgyn/1MtTKWOQ
         IFve3UKajdgrNagqmniUZZt/IKD8/gMOZyqg359Xy2qWFCqWVktDLpD7/L2DWD//je
         gRqPHdc7XwKarpCv4WRaUyO2ajRd386cA0nabpZg=
Date:   Thu, 06 May 2021 18:06:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 82/91] include/linux/pgtable.h: few spelling fixes
Message-ID: <20210507010624.Zqii-RSQf%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: include/linux/pgtable.h: few spelling fixes

Few spelling fixes throughout the file.

Link: https://lkml.kernel.org/r/20210318201404.6380-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
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
