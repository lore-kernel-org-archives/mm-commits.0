Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122FFC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F146B61107
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhGFTQZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231748AbhGFTQY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3F1460FE3;
        Tue,  6 Jul 2021 19:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598826;
        bh=VKHRD2S8z2Auzc7/7CqMVkd8jDjC0EkJSHB9aqaCoFg=;
        h=Date:From:To:Subject:From;
        b=CnmXsund5O7ZM6uK8sGCzw/EgjDr4VPGAY8jYZdtWlczSPzXT+pMYazUN5dNwUJAO
         Fb6et56ogOSl4fZyIfJL2UbbVTh0IrN5sTY8GMPoGV526MuGo689DQipJc0KVO94Io
         EWc+HxPkv5HIZXjAhBFEN4rsVvNllH++Rvi3iqDU=
Date:   Tue, 06 Jul 2021 12:13:45 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aneesh.kumar@linux.ibm.com,
        bsingharora@gmail.com, christophe.leroy@csgroup.eu, dja@axtens.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 mm-define-default-max_ptrs_per_-in-include-pgtableh.patch removed from -mm
 tree
Message-ID: <20210706191345.e8Nvb9Xgi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: define default MAX_PTRS_PER_* in include/pgtable.h
has been removed from the -mm tree.  Its filename was
     mm-define-default-max_ptrs_per_-in-include-pgtableh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: mm: define default MAX_PTRS_PER_* in include/pgtable.h

Commit c65e774fb3f6 ("x86/mm: Make PGDIR_SHIFT and PTRS_PER_P4D variable")
made PTRS_PER_P4D variable on x86 and introduced MAX_PTRS_PER_P4D as a
constant for cases which need a compile-time constant (e.g.  fixed-size
arrays).

powerpc likewise has boot-time selectable MMU features which can cause
other mm "constants" to vary.  For KASAN, we have some static
PTE/PMD/PUD/P4D arrays so we need compile-time maximums for all these
constants.  Extend the MAX_PTRS_PER_ idiom, and place default definitions
in include/pgtable.h.  These define MAX_PTRS_PER_x to be PTRS_PER_x unless
an architecture has defined MAX_PTRS_PER_x in its arch headers.

Clean up pgtable-nop4d.h and s390's MAX_PTRS_PER_P4D definitions while
we're at it: both can just pick up the default now.

Link: https://lkml.kernel.org/r/20210624034050.511391-4-dja@axtens.net
Signed-off-by: Daniel Axtens <dja@axtens.net>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h     |    2 --
 include/asm-generic/pgtable-nop4d.h |    1 -
 include/linux/pgtable.h             |   22 ++++++++++++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~mm-define-default-max_ptrs_per_-in-include-pgtableh
+++ a/arch/s390/include/asm/pgtable.h
@@ -344,8 +344,6 @@ static inline int is_module_addr(void *a
 #define PTRS_PER_P4D	_CRST_ENTRIES
 #define PTRS_PER_PGD	_CRST_ENTRIES
 
-#define MAX_PTRS_PER_P4D	PTRS_PER_P4D
-
 /*
  * Segment table and region3 table entry encoding
  * (R = read-only, I = invalid, y = young bit):
--- a/include/asm-generic/pgtable-nop4d.h~mm-define-default-max_ptrs_per_-in-include-pgtableh
+++ a/include/asm-generic/pgtable-nop4d.h
@@ -9,7 +9,6 @@
 typedef struct { pgd_t pgd; } p4d_t;
 
 #define P4D_SHIFT		PGDIR_SHIFT
-#define MAX_PTRS_PER_P4D	1
 #define PTRS_PER_P4D		1
 #define P4D_SIZE		(1UL << P4D_SHIFT)
 #define P4D_MASK		(~(P4D_SIZE-1))
--- a/include/linux/pgtable.h~mm-define-default-max_ptrs_per_-in-include-pgtableh
+++ a/include/linux/pgtable.h
@@ -1592,4 +1592,26 @@ typedef unsigned int pgtbl_mod_mask;
 #define pte_leaf_size(x) PAGE_SIZE
 #endif
 
+/*
+ * Some architectures have MMUs that are configurable or selectable at boot
+ * time. These lead to variable PTRS_PER_x. For statically allocated arrays it
+ * helps to have a static maximum value.
+ */
+
+#ifndef MAX_PTRS_PER_PTE
+#define MAX_PTRS_PER_PTE PTRS_PER_PTE
+#endif
+
+#ifndef MAX_PTRS_PER_PMD
+#define MAX_PTRS_PER_PMD PTRS_PER_PMD
+#endif
+
+#ifndef MAX_PTRS_PER_PUD
+#define MAX_PTRS_PER_PUD PTRS_PER_PUD
+#endif
+
+#ifndef MAX_PTRS_PER_P4D
+#define MAX_PTRS_PER_P4D PTRS_PER_P4D
+#endif
+
 #endif /* _LINUX_PGTABLE_H */
_

Patches currently in -mm which might be from dja@axtens.net are


