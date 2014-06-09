From: akpm@linux-foundation.org
Subject: [merged] ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:37:27 -0700
Message-ID: <53960cf7.TGr0/hUC84HhsnW7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaFITh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, kosaki.motohiro@jp.fujitsu.com, davidlohr@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr@hp.com,kosaki.motohiro@jp.fujitsu.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:27 -0700


The patch titled
     Subject: ipc/shm.c: increase the defaults for SHMALL, SHMMAX
has been removed from the -mm tree.  Its filename was
     ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/shm.c: increase the defaults for SHMALL, SHMMAX

System V shared memory

a) can be abused to trigger out-of-memory conditions and the standard
   measures against out-of-memory do not work:

    - it is not possible to use setrlimit to limit the size of shm segments.

    - segments can exist without association with any processes, thus
      the oom-killer is unable to free that memory.

b) is typically used for shared information - today often multiple GB.
   (e.g. database shared buffers)

The current default is a maximum segment size of 32 MB and a maximum total
size of 8 GB. This is often too much for a) and not enough for b), which
means that lots of users must change the defaults.

This patch increases the default limits (nearly) to the maximum, which is
perfect for case b). The defaults are used after boot and as the initial
value for each new namespace.

Admins/distros that need a protection against a) should reduce the limits
and/or enable shm_rmid_forced.

Unix has historically required setting these limits for shared memory, and
Linux inherited such behavior.  The consequence of this is added
complexity for users and administrators.  One very common example are
Database setup/installation documents and scripts, where users must
manually calculate the values for these limits.  This also requires (some)
knowledge of how the underlying memory management works, thus causing, in
many occasions, the limits to just be flat out wrong.  Disabling these
limits sooner could have saved companies a lot of time, headaches and
money for support.  But it's never too late, simplify users life now.

Further notes:
- The patch only changes default, overrides behave as before:
        # sysctl kernel.shmall=33554432
  would recreate the previous limit for SHMMAX (for the current namespace).

- Disabling sysv shm allocation is possible with:
        # sysctl kernel.shmall=0
  (not a new feature, also per-namespace)

- The limits are intentionally set to a value slightly less than ULONG_MAX,
  to avoid triggering overflows in user space apps.
  [not unreasonable, see http://marc.info/?l=linux-mm&m=139638334330127]

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reported-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shm.h      |    3 +--
 include/uapi/linux/shm.h |    8 +++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN include/linux/shm.h~ipc-shmc-increase-the-defaults-for-shmall-shmmax include/linux/shm.h
--- a/include/linux/shm.h~ipc-shmc-increase-the-defaults-for-shmall-shmmax
+++ a/include/linux/shm.h
@@ -3,9 +3,8 @@
 
 #include <asm/page.h>
 #include <uapi/linux/shm.h>
-
-#define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
 #include <asm/shmparam.h>
+
 struct shmid_kernel /* private to the kernel */
 {	
 	struct kern_ipc_perm	shm_perm;
diff -puN include/uapi/linux/shm.h~ipc-shmc-increase-the-defaults-for-shmall-shmmax include/uapi/linux/shm.h
--- a/include/uapi/linux/shm.h~ipc-shmc-increase-the-defaults-for-shmall-shmmax
+++ a/include/uapi/linux/shm.h
@@ -9,15 +9,13 @@
 
 /*
  * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
- * be increased by sysctl
+ * be modified by sysctl.
  */
 
-#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
-#ifndef __KERNEL__
-#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
-#endif
+#define SHMMAX (ULONG_MAX - (1L<<24))	 /* max shared seg size (bytes) */
+#define SHMALL (ULONG_MAX - (1L<<24))	 /* max shm system wide (pages) */
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

