From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-fix-shmat-mmap-nil-page-protection.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:50:50 -0800
Message-ID: <58b5e2aa.dsWOfIM2NDFsnbK9%akpm__2358.59750905565$1488315221$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751837AbdB1Uve (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, gareth.evans@contextis.co.uk, manfred@colorfullife.com, mtk.manpages@googlemail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: Fix shmat mmap nil-page protection
has been removed from the -mm tree.  Its filename was
     ipc-shm-fix-shmat-mmap-nil-page-protection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/shm: Fix shmat mmap nil-page protection

The issue is described here, with a nice testcase:

    https://bugzilla.kernel.org/show_bug.cgi?id=192931

The problem is that shmat() calls do_mmap_pgoff() with MAP_FIXED, and the
address rounded down to 0.  For the regular mmap case, the protection
mentioned above is that the kernel gets to generate the address --
arch_get_unmapped_area() will always check for MAP_FIXED and return that
address.  So by the time we do security_mmap_addr(0) things get funky for
shmat().

The testcase itself shows that while a regular user crashes, root will not
have a problem attaching a nil-page.  There are two possible fixes to
this.  The first, and which this patch does, is to simply allow root to
crash as well -- this is also regular mmap behavior, ie when hacking up
the testcase and adding mmap(...  |MAP_FIXED).  While this approach is the
safer option, the second alternative is to ignore SHM_RND if the rounded
address is 0, thus only having MAP_SHARED flags.  This makes the behavior
of shmat() identical to the mmap() case.  The downside of this is
obviously user visible, but does make sense in that it maintains semantics
after the round-down wrt 0 address and mmap.

Passes shm related ltp tests.

Link: http://lkml.kernel.org/r/1486050195-18629-1-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reported-by: Gareth Evans <gareth.evans@contextis.co.uk>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN ipc/shm.c~ipc-shm-fix-shmat-mmap-nil-page-protection ipc/shm.c
--- a/ipc/shm.c~ipc-shm-fix-shmat-mmap-nil-page-protection
+++ a/ipc/shm.c
@@ -1091,8 +1091,8 @@ out_unlock1:
  * "raddr" thing points to kernel space, and there has to be a wrapper around
  * this.
  */
-long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
-	      unsigned long shmlba)
+long do_shmat(int shmid, char __user *shmaddr, int shmflg,
+	      ulong *raddr, unsigned long shmlba)
 {
 	struct shmid_kernel *shp;
 	unsigned long addr;
@@ -1113,8 +1113,13 @@ long do_shmat(int shmid, char __user *sh
 		goto out;
 	else if ((addr = (ulong)shmaddr)) {
 		if (addr & (shmlba - 1)) {
-			if (shmflg & SHM_RND)
-				addr &= ~(shmlba - 1);	   /* round down */
+			/*
+			 * Round down to the nearest multiple of shmlba.
+			 * For sane do_mmap_pgoff() parameters, avoid
+			 * round downs that trigger nil-page and MAP_FIXED.
+			 */
+			if ((shmflg & SHM_RND) && addr >= shmlba)
+				addr &= ~(shmlba - 1);
 			else
 #ifndef __ARCH_FORCE_SHMLBA
 				if (addr & ~PAGE_MASK)
_

Patches currently in -mm which might be from dave@stgolabs.net are


