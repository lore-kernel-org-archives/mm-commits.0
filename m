From: akpm@linux-foundation.org
Subject: [merged] posix_types-make-__kernel_id32_t-default-to-unsigned-int.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:21 -0800
Message-ID: <20120227222921.325A5A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:46454 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2B0W30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:26 -0500
Received: by mail-ww0-f74.google.com with SMTP id dt11so67256wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, jejb@parisc-linux.org, jesper.nilsson@axis.com, kyle@mcmartin.ca, lethal@linux-sh.org, linux@arm.linux.org.uk, mattst88@gmail.com, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com, yasutake.koichi@jp.panasonic.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: posix_types: make __kernel_[ug]id32_t default to unsigned int
has been removed from the -mm tree.  Its filename was
     posix_types-make-__kernel_id32_t-default-to-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: posix_types: make __kernel_[ug]id32_t default to unsigned int

All ports use unsigned int for __kernel_[ug]id32_t, but not all ports use
unsigned int for __kernel_[ug]id_t.  Thus, change the default for the "32"
types so ports don't need to override them.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/posix_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/posix_types.h~posix_types-make-__kernel_id32_t-default-to-unsigned-int include/asm-generic/posix_types.h
--- a/include/asm-generic/posix_types.h~posix_types-make-__kernel_id32_t-default-to-unsigned-int
+++ a/include/asm-generic/posix_types.h
@@ -44,8 +44,8 @@ typedef int		__kernel_daddr_t;
 #endif
 
 #ifndef __kernel_uid32_t
-typedef __kernel_uid_t	__kernel_uid32_t;
-typedef __kernel_gid_t	__kernel_gid32_t;
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
 #endif
 
 #ifndef __kernel_old_uid_t
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
linux-next.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
platform-x86-kill-off-moorestown.patch
intel_scu_ipc-remove-moorestown-support.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch
x86-olpc-add-debugfs-interface-for-ec-commands.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable-fix.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
percpu-remove-percpu_xxx-functions.patch
smp-start-up-non-boot-cpus-asynchronously.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

