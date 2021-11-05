Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFF2C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B35F6126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhKEUnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE306127B;
        Fri,  5 Nov 2021 20:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144844;
        bh=uqY2/gVbPyS5qLzegr4HW5humpqDu9VdY0HZpdQttqk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R9vy29+ykrMm9N8JHadqqy7zOXn7kQZHSvtIIvOyhO7GLQzRfd69a9ZND5+PBFF5a
         Q1gg92urT/Di9nC70Rdglh0W/+H74wYxXc3rlhzWz/DmIgV3WgmVuKQ3wRYiMwRjWh
         IZjRFWJOs2MBqq3JBhjlblu3UK3wWBHj2zcduAnw=
Date:   Fri, 05 Nov 2021 13:40:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        paulus@ozlabs.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 116/262] mm: make generic
 arch_is_kernel_initmem_freed() do what it says
Message-ID: <20211105204043.z5Hpw2DQg%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
