From: akpm@linux-foundation.org
Subject: + arm-mm-support-arch_mmap_rnd_bits-fix.patch added to -mm tree
Date: Mon, 30 Nov 2015 14:15:11 -0800
Message-ID: <565cca6f.FA4bowyeGHMuZ3MA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbbK3WPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 17:15:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dcashman@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: avoid ARCH_MMAP_RND_BITS for NOMMU
has been added to the -mm tree.  Its filename is
     arm-mm-support-arch_mmap_rnd_bits-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-support-arch_mmap_rnd_bits-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-support-arch_mmap_rnd_bits-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ARM: avoid ARCH_MMAP_RND_BITS for NOMMU

ARM kernels with MMU disabled fail to build because of CONFIG_ARCH_MMAP_RND_BITS:

kernel/built-in.o:(.data+0x754): undefined reference to `mmap_rnd_bits'
kernel/built-in.o:(.data+0x76c): undefined reference to `mmap_rnd_bits_min'
kernel/built-in.o:(.data+0x770): undefined reference to `mmap_rnd_bits_max'

This changes the newly added line to only select this allow for
MMU-enabled kernels.

Fixes: 14570b3fd31a ("arm: mm: support ARCH_MMAP_RND_BITS")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Cashman <dcashman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits-fix arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits-fix
+++ a/arch/arm/Kconfig
@@ -35,7 +35,7 @@ config ARM
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32
-	select HAVE_ARCH_MMAP_RND_BITS
+	select HAVE_ARCH_MMAP_RND_BITS if MMU
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
_

Patches currently in -mm which might be from arnd@arndb.de are

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-mm-support-arch_mmap_rnd_bits-fix.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
memstick-use-sector_div-instead-of-do_div.patch

