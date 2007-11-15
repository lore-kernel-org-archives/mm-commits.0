From: akpm@linux-foundation.org
Subject: - cris-dont-include-bitopsh-in-posix_typesh.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:00 -0800
Message-ID: <200711152112.lAFLC0XS015817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761042AbXKOVRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS don't include bitops.h in posix_types.h
has been removed from the -mm tree.  Its filename was
     cris-dont-include-bitopsh-in-posix_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Mikael Starvik <starvik@axis.com>
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

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
