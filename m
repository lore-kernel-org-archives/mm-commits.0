From: akpm@linux-foundation.org
Subject: - vdso-print-fatal-signals-fix-compiling-error-bug-in.patch removed from -mm tree
Date: Sat, 19 May 2007 23:43:05 -0700
Message-ID: <200705200643.l4K6h5Ah017476@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758679AbXETGoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 02:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     vdso print fatal signals: fix compiling error bug in nommu arch
has been removed from the -mm tree.  Its filename was
     vdso-print-fatal-signals-fix-compiling-error-bug-in.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: vdso print fatal signals: fix compiling error bug in nommu arch
From: "Wu, Bryan" <bryan.wu@analog.com>

As struct mm_struct vm_mm is hidden in struct vm_area_struct in NOMMU
arch, this is a fixing method when compiling failure on blackfin arch.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/signal.c~vdso-print-fatal-signals-fix-compiling-error-bug-in kernel/signal.c
--- a/kernel/signal.c~vdso-print-fatal-signals-fix-compiling-error-bug-in
+++ a/kernel/signal.c
@@ -708,7 +708,11 @@ static void pad_len_spaces(int len)
 
 static int print_vma(struct vm_area_struct *vma)
 {
+#ifdef CONFIG_MMU
 	struct mm_struct *mm = vma->vm_mm;
+#else
+	struct mm_struct *mm = 0;
+#endif
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-on-chip-ethernet-mac-controller-driver.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
