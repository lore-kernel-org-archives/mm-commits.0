Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE787C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9589061354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhKKCrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCrI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857E861108;
        Thu, 11 Nov 2021 02:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598659;
        bh=0zXuhTvM0kJ73VX1kt7pQx6A/kpQ7yXqQu8MtIqQm7c=;
        h=Date:From:To:Subject:From;
        b=FBwoZ6u0fWiJgrr12v56ZUNkmqARYMZ74D763U8YGkIuSi5ySV1UHhynpIXa2oWZU
         44cKCKZ6G7/jK1n9AOITk/HB1swSJHn4pU5hfOMJWT3BtlQnDRHTmv4C9nxtNjN21n
         aLdHzBkSV0AbfLUbhDcOTc+LKAUyWZati6jaZr8Y=
Date:   Wed, 10 Nov 2021 18:44:19 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org,
        wangkefeng.wang@huawei.com
Subject:  [merged]
 mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch removed
 from -mm tree
Message-ID: <20211111024419.zMWTmLkW7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make generic arch_is_kernel_initmem_freed() do what it says
has been removed from the -mm tree.  Its filename was
     mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: make generic arch_is_kernel_initmem_freed() do what it says

Commit 7a5da02de8d6 ("locking/lockdep: check for freed initmem in
static_obj()") added arch_is_kernel_initmem_freed() which is supposed to
report whether an object is part of already freed init memory.

For the time being, the generic version of arch_is_kernel_initmem_freed()
always reports 'false', allthough free_initmem() is generically called on
all architectures.

Therefore, change the generic version of arch_is_kernel_initmem_freed() to
check whether free_initmem() has been called.  If so, then check if a
given address falls into init memory.

To ease the use of system_state, move it out of line into its only caller
which is lockdep.c

Link: https://lkml.kernel.org/r/1d40783e676e07858be97d881f449ee7ea8adfb1.1633001016.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |   14 --------------
 kernel/locking/lockdep.c       |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 14 deletions(-)

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
--- a/kernel/locking/lockdep.c~mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says
+++ a/kernel/locking/lockdep.c
@@ -788,6 +788,21 @@ static int very_verbose(struct lock_clas
  * Is this the address of a static object:
  */
 #ifdef __KERNEL__
+/*
+ * Check if an address is part of freed initmem. After initmem is freed,
+ * memory can be allocated from it, and such allocations would then have
+ * addresses within the range [_stext, _end].
+ */
+#ifndef arch_is_kernel_initmem_freed
+static int arch_is_kernel_initmem_freed(unsigned long addr)
+{
+	if (system_state < SYSTEM_FREEING_INITMEM)
+		return 0;
+
+	return init_section_contains((void *)addr, 1);
+}
+#endif
+
 static int static_obj(const void *obj)
 {
 	unsigned long start = (unsigned long) &_stext,
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


