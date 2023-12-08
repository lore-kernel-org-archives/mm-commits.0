Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519153B297
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m2j9aKuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99823C433C8;
	Fri,  8 Dec 2023 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065017;
	bh=8OSpTYbZGg1UHK9/v2zbD2KzT35REFWc+EdtF2WGGw4=;
	h=Date:To:From:Subject:From;
	b=m2j9aKuWWKZl2JbBg4hy1OuBlg9h5qmMH6M5+rDYhcLvHueHTnt/LNxUkOX9UPNrg
	 tCmIKF5Rec32f317OML5kKsDY3sCTJ0cAgILTWG0ktEgWUClShEFkALrvEvQ38Ln0y
	 2PVfhmVHOHhcQ3rhfOV73zGFY8qyzVlrFVJ5aZHA=
Date: Fri, 08 Dec 2023 11:50:16 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,ignat@cloudflare.com,eric_devolder@yahoo.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-kexec-change-dependency-of-object-files.patch added to mm-hotfixes-unstable branch
Message-Id: <20231208195017.99823C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: loongarch, kexec: change dependency of object files
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     loongarch-kexec-change-dependency-of-object-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-kexec-change-dependency-of-object-files.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: loongarch, kexec: change dependency of object files
Date: Fri, 8 Dec 2023 15:30:32 +0800

Patch series "kexec: fix the incorrect ifdeffery and dependency of
CONFIG_KEXEC".

The select of KEXEC for CRASH_DUMP in kernel/Kconfig.kexec will be
dropped, then compiling errors will be triggered if below config items are
set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

E.g on mips, below link error are seen:
--------------------------------------------------------------------
mipsel-linux-ld: kernel/kexec_core.o: in function `kimage_free':
kernel/kexec_core.c:(.text+0x2200): undefined reference to `machine_kexec_cleanup'
mipsel-linux-ld: kernel/kexec_core.o: in function `__crash_kexec':
kernel/kexec_core.c:(.text+0x2480): undefined reference to `machine_crash_shutdown'
mipsel-linux-ld: kernel/kexec_core.c:(.text+0x2488): undefined reference to `machine_kexec'
mipsel-linux-ld: kernel/kexec_core.o: in function `kernel_kexec':
kernel/kexec_core.c:(.text+0x29b8): undefined reference to `machine_shutdown'
mipsel-linux-ld: kernel/kexec_core.c:(.text+0x29c0): undefined reference to `machine_kexec'
--------------------------------------------------------------------

Here, change the incorrect dependency of building kexec_core related
object files, and the ifdeffery on architectures from CONFIG_KEXEC to
CONFIG_KEXEC_CORE.

Testing:
========
Passed on mips and loognarch with the LKP reproducer.


This patch (of 5):

Currently, in arch/loongarch/kernel/Makefile, building machine_kexec.o
relocate_kernel.o depends on CONFIG_KEXEC.

Whereas, since we will drop the select of KEXEC for CRASH_DUMP in
kernel/Kconfig.kexec, compiling error will be triggered if below config
items are set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

---------------------------------------------------------------
loongarch64-linux-ld: kernel/kexec_core.o: in function `.L209':
>> kexec_core.c:(.text+0x1660): undefined reference to `machine_kexec_cleanup'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L287':
>> kexec_core.c:(.text+0x1c5c): undefined reference to `machine_crash_shutdown'
>> loongarch64-linux-ld: kexec_core.c:(.text+0x1c64): undefined reference to `machine_kexec'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L2^B5':
>> kexec_core.c:(.text+0x2090): undefined reference to `machine_shutdown'
   loongarch64-linux-ld: kexec_core.c:(.text+0x20a0): undefined reference to `machine_kexec'
---------------------------------------------------------------

Here, change the dependency of machine_kexec.o relocate_kernel.o to
CONFIG_KEXEC_CORE can fix above building error.

Link: https://lkml.kernel.org/r/20231208073036.7884-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20231208073036.7884-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311300946.kHE9Iu71-lkp@intel.com/
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/Makefile~loongarch-kexec-change-dependency-of-object-files
+++ a/arch/loongarch/kernel/Makefile
@@ -57,7 +57,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 
 obj-$(CONFIG_RELOCATABLE)	+= relocate.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 
 obj-$(CONFIG_UNWINDER_GUESS)	+= unwind_guess.o
_

Patches currently in -mm which might be from bhe@redhat.com are

riscv-fix-vmallc_start-definition.patch
loongarch-kexec-change-dependency-of-object-files.patch
m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch
mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

