From: akpm@linux-foundation.org
Subject: - arch-i386-xen-mmuc-must-include-linux-schedh.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:34 -0700
Message-ID: <200707181852.l6IIqYYs023688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763445AbXGRSxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     arch/i386/xen/mmu.c must #include <linux/sched.h>
has been removed from the -mm tree.  Its filename was
     arch-i386-xen-mmuc-must-include-linux-schedh.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: arch/i386/xen/mmu.c must #include <linux/sched.h>
=46rom: Adrian Bunk <bunk@stusta.de>

This patch fixes the following compile error:

<--  snip  -->

=2E..
  CC      arch/i386/xen/mmu.o
In file included from
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.c:46=
:
include2/asm/mmu_context.h: In function =E2=80=98switch_mm=E2=80=99:
include2/asm/mmu_context.h:45: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:50: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:53: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:58: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:58: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:59: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:66: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:70: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:71: error: dereferencing pointer to incomple=
te type
=2E..
make[2]: *** [arch/i386/xen/mmu.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/mmu.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/xen/mmu.c~arch-i386-xen-mmuc-must-include-linux-sch=
edh arch/i386/xen/mmu.c
--- a/arch/i386/xen/mmu.c~arch-i386-xen-mmuc-must-include-linux-schedh
+++ a/arch/i386/xen/mmu.c
@@ -39,6 +39,7 @@
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
 #include <linux/highmem.h>
+#include <linux/sched.h>
=20
 #include <asm/bug.h>
 #include <asm/pgtable.h>
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
mm-variable-length-argument-support.patch
kernel-relayc-make-functions-static.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-ratin=
g-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-dvb.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-=
dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-xen-event-channels.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
drivers-edac-core-make-functions-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
