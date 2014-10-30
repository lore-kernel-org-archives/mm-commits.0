From: akpm@linux-foundation.org
Subject: + tile-neaten-early_printk-uses.patch added to -mm tree
Date: Thu, 30 Oct 2014 14:55:31 -0700
Message-ID: <5452b3d3.ZLya0ev/D/cnt0l1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161234AbaJ3Vzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 17:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: neaten early_printk uses
has been added to the -mm tree.  Its filename is
     tile-neaten-early_printk-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-neaten-early_printk-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-neaten-early_printk-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: tile: neaten early_printk uses

Coalesce the formats and align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/setup.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN arch/tile/kernel/setup.c~tile-neaten-early_printk-uses arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~tile-neaten-early_printk-uses
+++ a/arch/tile/kernel/setup.c
@@ -1208,9 +1208,8 @@ static void __init validate_hv(void)
 	 * We use a struct cpumask for this, so it must be big enough.
 	 */
 	if ((smp_height * smp_width) > nr_cpu_ids)
-		early_panic("Hypervisor %d x %d grid too big for Linux"
-			    " NR_CPUS %d\n", smp_height, smp_width,
-			    nr_cpu_ids);
+		early_panic("Hypervisor %d x %d grid too big for Linux NR_CPUS %d\n",
+			    smp_height, smp_width, nr_cpu_ids);
 #endif
 
 	/*
@@ -1265,10 +1264,9 @@ static void __init validate_va(void)
 
 	/* Kernel PCs must have their high bit set; see intvec.S. */
 	if ((long)VMALLOC_START >= 0)
-		early_panic(
-			"Linux VMALLOC region below the 2GB line (%#lx)!\n"
-			"Reconfigure the kernel with smaller VMALLOC_RESERVE.\n",
-			VMALLOC_START);
+		early_panic("Linux VMALLOC region below the 2GB line (%#lx)!\n"
+			    "Reconfigure the kernel with smaller VMALLOC_RESERVE\n",
+			    VMALLOC_START);
 #endif
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
printk-remove-used-once-early_vprintk.patch
tile-neaten-early_printk-uses.patch
tile-use-pr_warn-instead-of-pr_warning.patch
maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
checkpatch-reduce-maintainers-update-message-frequency.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

