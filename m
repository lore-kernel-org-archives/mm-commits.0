From: akpm@linux-foundation.org
Subject: + m68knommu-fix-pread-pwrite-defines.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:03 -0700
Message-ID: <200711022135.lA2LZ3KB011978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbXKBVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: fix pread/pwrite defines
has been added to the -mm tree.  Its filename is
     m68knommu-fix-pread-pwrite-defines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: fix pread/pwrite defines
From: Greg Ungerer <gerg@snapgear.com>

Fix system call defines for system call 180 and 181 to match the underlying
system call table function entries.  System call 180 calls sys_pread64, and
181 calls sys_pwrite64, so make the definitions match.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68knommu/unistd.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-m68knommu/unistd.h~m68knommu-fix-pread-pwrite-defines include/asm-m68knommu/unistd.h
--- a/include/asm-m68knommu/unistd.h~m68knommu-fix-pread-pwrite-defines
+++ a/include/asm-m68knommu/unistd.h
@@ -185,8 +185,8 @@
 #define __NR_rt_sigtimedwait	177
 #define __NR_rt_sigqueueinfo	178
 #define __NR_rt_sigsuspend	179
-#define __NR_pread		180
-#define __NR_pwrite		181
+#define __NR_pread64		180
+#define __NR_pwrite64		181
 #define __NR_lchown		182
 #define __NR_getcwd		183
 #define __NR_capget		184
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-fix-pread-pwrite-defines.patch
m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
add-build-support-for-new-coldfire-serial-driver.patch
add-configure-support-for-new-coldfire-serial-driver.patch
m68knommu-platform-setup-for-5206-coldfire-uarts.patch
m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
m68knommu-platform-setup-for-520x-coldfire-uarts.patch
m68knommu-platform-setup-for-5249-coldfire-uarts.patch
m68knommu-platform-setup-for-5272-coldfire-uarts.patch
add-cmpxchg_local-to-m68knommu.patch
