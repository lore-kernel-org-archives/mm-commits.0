From: akpm@linux-foundation.org
Subject: + cris-dont-include-bitopsh-in-posix_typesh.patch added to -mm tree
Date: Wed, 31 Oct 2007 10:25:40 -0700
Message-ID: <200710311725.l9VHPePA013875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbXJaR0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 13:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     CRIS don't include bitops.h in posix_types.h
has been added to the -mm tree.  Its filename is
     cris-dont-include-bitopsh-in-posix_typesh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRIS don't include bitops.h in posix_types.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

In file included from include/asm/byteorder.h:23,
                 from include/asm-generic/bitops/le.h:5,
                 from include/asm-generic/bitops/ext2-non-atomic.h:4,
                 from include/asm/bitops.h:163,
                 from include/linux/bitops.h:17,
                 from include/asm/posix_types.h:55,
                 from include/linux/posix_types.h:47,
                 from include/linux/types.h:11,
                 from include/linux/capability.h:16,
                 from include/linux/sched.h:49,
                 from arch/cris/kernel/asm-offsets.c:1:
include/linux/byteorder/little_endian.h:43: parse error before "__cpu_to_le64p"
include/linux/byteorder/little_endian.h:44: warning: return type defaults to `int'
include/linux/byteorder/little_endian.h: In function `__cpu_to_le64p':
include/linux/byteorder/little_endian.h:45: `__le64' undeclared (first use in this function)

Remove include of asm/bitops.h, not needed here, corrects compilation error
(__le64 undeclared).

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/posix_types.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-cris/posix_types.h~cris-dont-include-bitopsh-in-posix_typesh include/asm-cris/posix_types.h
--- a/include/asm-cris/posix_types.h~cris-dont-include-bitopsh-in-posix_typesh
+++ a/include/asm-cris/posix_types.h
@@ -52,7 +52,6 @@ typedef struct {
 } __kernel_fsid_t;
 
 #ifdef __KERNEL__
-#include <linux/bitops.h>
 
 #undef	__FD_SET
 #define __FD_SET(fd,fdsetp) set_bit(fd, (void *)(fdsetp))
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
