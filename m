From: akpm@linux-foundation.org
Subject: + posix_types-make-it-possible-to-override-__kernel_fsid_t.patch added to -mm tree
Date: Wed, 08 Feb 2012 15:47:58 -0800
Message-ID: <20120208234758.4C99CA023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61249 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab2BHXsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 18:48:07 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so118795yen.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 15:48:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, jejb@parisc-linux.org, jesper.nilsson@axis.com, kyle@mcmartin.ca, lethal@linux-sh.org, linux@arm.linux.org.uk, mattst88@gmail.com, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com, yasutake.koichi@jp.panasonic.com, ysato@users.sourceforge.jp


The patch titled
     Subject: posix_types: make it possible to override __kernel_fsid_t
has been added to the -mm tree.  Its filename is
     posix_types-make-it-possible-to-override-__kernel_fsid_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: posix_types: make it possible to override __kernel_fsid_t

__kernel_fsid_t has members of type "long" on at least one architecture
(MIPS32), so make it possible to override the definition.

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

 include/asm-generic/posix_types.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/posix_types.h~posix_types-make-it-possible-to-override-__kernel_fsid_t include/asm-generic/posix_types.h
--- a/include/asm-generic/posix_types.h~posix_types-make-it-possible-to-override-__kernel_fsid_t
+++ a/include/asm-generic/posix_types.h
@@ -73,6 +73,12 @@ typedef long		__kernel_ptrdiff_t;
 #endif
 #endif
 
+#ifndef __kernel_fsid_t
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+#endif
+
 /*
  * anything below here should be completely generic
  */
@@ -86,10 +92,6 @@ typedef char *		__kernel_caddr_t;
 typedef unsigned short	__kernel_uid16_t;
 typedef unsigned short	__kernel_gid16_t;
 
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
 #ifdef __KERNEL__
 
 #undef __FD_SET
_
Subject: Subject: posix_types: make it possible to override __kernel_fsid_t

Patches currently in -mm which might be from hpa@zytor.com are

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
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
percpu-remove-percpu_xxx-functions.patch
smp-start-up-non-boot-cpus-asynchronously.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-make-__kernel_id32_t-default-to-unsigned-int.patch
posix_types-make-it-possible-to-override-__kernel_fsid_t.patch
alpha-use-generic-posix_typesh.patch
arm-use-generic-posix_typesh.patch
avr32-use-generic-posix_typesh.patch
cris-use-generic-posix_typesh.patch
frv-use-generic-posix_typesh.patch
h8300-use-generic-posix_typesh.patch
ia64-use-generic-posix_typesh.patch
m32r-use-generic-posix_typesh.patch
m68k-use-generic-posix_typesh.patch
mips-use-generic-posix_typesh.patch
mn10300-use-generic-posix_typesh.patch
parisc-use-generic-posix_typesh.patch
powerpc-use-generic-posix_typesh.patch
s390-use-generic-posix_typesh.patch
sh-remove-unnecessary-posix_typesh-type-overrides.patch
sparc-use-generic-posix_typesh.patch
x86-use-generic-posix_typesh.patch
xtensa-use-generic-posix_typesh.patch
posix_types-remove-fd_set-macros.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

