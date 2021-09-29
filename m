Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE20CC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 03:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FA5613E8
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 03:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243993AbhI2Dc5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243950AbhI2Dc5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 23:32:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F421613CE;
        Wed, 29 Sep 2021 03:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632886276;
        bh=VhZN1eiEzPdW1JiS2zfuiIQC0PFZA6AB8pFzLi2ZgfQ=;
        h=Date:From:To:Subject:From;
        b=Qwh97heQ1KDcfzX/KHOE4Y9uKjxQGNvkoXgBNzZF1qWjDlCVZV1XIuk8IqLrwdUoS
         pDk8ubIbNDV6iRkZ9LU4MUoy1ac/oGWuuhOjtNZGpsJdZeNk7WYPlYsCs3gTyeqX6K
         q0N098AHubO9xYq+mGq6/uoX2Xgz62qoAodFUJk0=
Date:   Tue, 28 Sep 2021 20:31:16 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org, sfr@canb.auug.org.au
Subject:  [to-be-updated]
 mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch removed
 from -mm tree
Message-ID: <20210929033116.3Anu-VkKN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make generic arch_is_kernel_initmem_freed() do what it says
has been removed from the -mm tree.  Its filename was
     mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch

This patch was dropped because an updated version will be merged

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
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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

powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

