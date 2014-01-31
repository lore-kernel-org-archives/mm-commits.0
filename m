From: akpm@linux-foundation.org
Subject: +
 tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch added to -mm tree
Date: Fri, 31 Jan 2014 13:15:54 -0800
Message-ID: <52ec128a.Pxc2IqctSp4Sjty5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaAaVPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:15:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, cmetcalf@tilera.com, heiko.carstens@de.ibm.com

Subject: + tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch added to -mm tree
To: heiko.carstens@de.ibm.com,cmetcalf@tilera.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:15:54 -0800


The patch titled
     Subject: tile: remove compat_sys_lookup_dcookie declaration to fix compile error
has been added to the -mm tree.  Its filename is
     tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
tile-remove-compat_sys_lookup_dcookie-declaration-to-fix-compile-error.patch
linux-next.patch

