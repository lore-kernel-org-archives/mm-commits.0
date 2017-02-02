From: akpm@linux-foundation.org
Subject: + ipc-shm-fix-shmat-mmap-nil-page-protection.patch added to -mm
 tree
Date: Thu, 02 Feb 2017 14:53:30 -0800
Message-ID: <5893b86a.CelHF/y8KGi1z0dI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdBBWxb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:53:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, gareth.evans@contextis.co.uk, manfred@colorfullife.com, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: Fix shmat mmap nil-page protection
has been added to the -mm tree.  Its filename is
     ipc-shm-fix-shmat-mmap-nil-page-protection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-fix-shmat-mmap-nil-page-protection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-fix-shmat-mmap-nil-page-protection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cris-use-generic-currenth.patch
m32r-use-generic-currenth.patch
score-remove-asm-currenth.patch
parisc-use-generic-currenth.patch
mmcompaction-serialize-waitqueue_active-checks.patch
alpha-use-generic-currenth.patch
ipc-shm-fix-shmat-mmap-nil-page-protection.patch

