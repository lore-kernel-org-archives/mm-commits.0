Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E00DC43217
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 23:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08465613A9
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 23:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbhI1XfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243321AbhI1XfE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 19:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51F2D613A6;
        Tue, 28 Sep 2021 23:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632872004;
        bh=2HZhsbGFTDrapXU39I4bwdMfq2xGtUOtq4YZLDfWpJw=;
        h=Date:From:To:Subject:From;
        b=OZuVaJ9FNN8DOOiu7udrWsZp674ezuiQP7ZVqMzN8depJk5KUsUtxpsdaLKBIuP/t
         kwIk7x+fQL3RUsCgP7BmhQ3K+PcjKtZv8mPtAsMWHQXWm4SaeCsULAd3gj/r5djMe2
         tJund8dgX5GXJXW9HDxGK6IT24Ti0xmeoquQjceA=
Date:   Tue, 28 Sep 2021 16:33:23 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, heiko.carstens@de.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org
Subject:  +
 mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch added to
 -mm tree
Message-ID: <20210928233323.vWMUpy4kN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make generic arch_is_kernel_initmem_freed() do what it says
has been added to the -mm tree.  Its filename is
     mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: make generic arch_is_kernel_initmem_freed() do what it says

Commit 7a5da02de8d6 ("locking/lockdep: check for freed initmem in
static_obj()") added arch_is_kernel_initmem_freed() which is supposed to
report whether an object is part of already freed init memory.

For the time being, the generic version of arch_is_kernel_initmem_freed()
always reports 'false', allthough free_initmem() is generically called
on all architectures.

Therefore, change the generic version of arch_is_kernel_initmem_freed()
to check whether free_initmem() has been called. If so, then check
if a given address falls into init memory.

In order to use function init_section_contains(), the fonction is
moved at the end of asm-generic/section.h

Link: https://lkml.kernel.org/r/ec69cc95a98548c862c22b742936244fdb0c7984.1632813331.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/include/asm-generic/sections.h~mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says
+++ a/include/asm-generic/sections.h
@@ -80,20 +80,6 @@ static inline int arch_is_kernel_data(un
 }
 #endif
 
-/*
- * Check if an address is part of freed initmem. This is needed on architectures
- * with virt == phys kernel mapping, for code that wants to check if an address
- * is part of a static object within [_stext, _end]. After initmem is freed,
- * memory can be allocated from it, and such allocations would then have
- * addresses within the range [_stext, _end].
- */
-#ifndef arch_is_kernel_initmem_freed
-static inline int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	return 0;
-}
-#endif
-
 /**
  * memory_contains - checks if an object is contained within a memory region
  * @begin: virtual address of the beginning of the memory region
@@ -172,4 +158,21 @@ static inline bool is_kernel_rodata(unsi
 	       addr < (unsigned long)__end_rodata;
 }
 
+/*
+ * Check if an address is part of freed initmem. This is needed on architectures
+ * with virt == phys kernel mapping, for code that wants to check if an address
+ * is part of a static object within [_stext, _end]. After initmem is freed,
+ * memory can be allocated from it, and such allocations would then have
+ * addresses within the range [_stext, _end].
+ */
+#ifndef arch_is_kernel_initmem_freed
+static inline int arch_is_kernel_initmem_freed(unsigned long addr)
+{
+	if (system_state < SYSTEM_FREEING_INITMEM)
+		return 0;
+
+	return init_section_contains((void *)addr, 1);
+}
+#endif
+
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-create-a-new-system-state-and-fix-core_kernel_text.patch
mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch
powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

