From: akpm@linux-foundation.org
Subject: [merged]
 tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch removed from -mm tree
Date: Mon, 03 Feb 2014 12:17:07 -0800
Message-ID: <52eff943.6rkVXqQLc5yh9nZE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCURI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 15:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, cmetcalf@tilera.com, heiko.carstens@de.ibm.com

Subject: [merged] tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch removed from -mm tree
To: heiko.carstens@de.ibm.com,cmetcalf@tilera.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 12:17:07 -0800


The patch titled
     Subject: tile: remove compat_sys_lookup_dcookie declaration to fix compile error
has been removed from the -mm tree.  Its filename was
     tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: tile: remove compat_sys_lookup_dcookie declaration to fix compile error

With d8d14bd09cdd ("fs/compat: fix lookup_dcookie() parameter handling") I
changed the type of the len parameter of the lookup_dcookie() syscall.

However I missed that there was still a stale declaration in arch/tile/.. 
which now causes a compile error on tile:

In file included from fs/dcookies.c:28:0:
include/linux/compat.h:425:17: error: conflicting types for 'compat_sys_lookup_dcookie'
fs/dcookies.c:207:1: error: conflicting types for 'compat_sys_lookup_dcookie'

Simply remove the declaration in the tile architecture, which is only a
leftover from before the different compat lookup_dcookie() versions have
been merged.  The declaration is now in include/linux/compat.h

The build error was reported by Fenguang's build bot.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/compat.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/tile/include/asm/compat.h~tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error arch/tile/include/asm/compat.h
--- a/arch/tile/include/asm/compat.h~tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error
+++ a/arch/tile/include/asm/compat.h
@@ -281,7 +281,6 @@ long compat_sys_pread64(unsigned int fd,
 			u32 dummy, u32 low, u32 high);
 long compat_sys_pwrite64(unsigned int fd, char __user *ubuf, size_t count,
 			 u32 dummy, u32 low, u32 high);
-long compat_sys_lookup_dcookie(u32 low, u32 high, char __user *buf, size_t len);
 long compat_sys_sync_file_range2(int fd, unsigned int flags,
 				 u32 offset_lo, u32 offset_hi,
 				 u32 nbytes_lo, u32 nbytes_hi);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch

