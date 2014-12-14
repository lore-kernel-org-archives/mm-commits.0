From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-increase-semmsl-semmni-semopm.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:10:08 -0800
Message-ID: <548d0da0.2WOquY3E0cKkwARp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaLNEKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, aquini@redhat.com, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: increase SEMMSL, SEMMNI, SEMOPM
has been removed from the -mm tree.  Its filename was
     ipc-semc-increase-semmsl-semmni-semopm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: increase SEMMSL, SEMMNI, SEMOPM

a)

SysV can be abused to allocate locked kernel memory.  For most systems, a
small limit doesn't make sense, see the discussion with regards to SHMMAX.

Therefore: Increase the sysv sem limits so that all known applications
will work with these defaults.

b)

With regards to the maximum supported:
Some of the specified hard limits are not correct anymore, therefore the
patch updates the documentation.

- SEMMNI must stay below IPCMNI, which is 32768.
  As for SHMMAX: Stay a bit below this limit.

- SEMMSL was limited to 8k, to ensure that the kmalloc for the kernel array
  was limited to 16 kB (order=2)

  This doesn't apply anymore:
   - the allocation size isn't sizeof(short)*nsems anymore.
   - ipc_alloc falls back to vmalloc

- SEMOPM should stay below 1000, to limit the kmalloc in semtimedop() to an
  order=1 allocation.
  Therefore: Leave it at 500 (order=0 allocation).

Note:
If an administrator must limit the memory allocations, then he can set the
values as necessary.

Or he can disable sysv entirely (as e.g. done by Android).

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/sem.h |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN include/uapi/linux/sem.h~ipc-semc-increase-semmsl-semmni-semopm include/uapi/linux/sem.h
--- a/include/uapi/linux/sem.h~ipc-semc-increase-semmsl-semmni-semopm
+++ a/include/uapi/linux/sem.h
@@ -63,10 +63,22 @@ struct  seminfo {
 	int semaem;
 };
 
-#define SEMMNI  128             /* <= IPCMNI  max # of semaphore identifiers */
-#define SEMMSL  250             /* <= 8 000 max num of semaphores per id */
+/*
+ * SEMMNI, SEMMSL and SEMMNS are default values which can be
+ * modified by sysctl.
+ * The values has been chosen to be larger than necessary for any
+ * known configuration.
+ *
+ * SEMOPM should not be increased beyond 1000, otherwise there is the
+ * risk that semop()/semtimedop() fails due to kernel memory fragmentation when
+ * allocating the sop array.
+ */
+
+
+#define SEMMNI  32000           /* <= IPCMNI  max # of semaphore identifiers */
+#define SEMMSL  32000           /* <= INT_MAX max num of semaphores per id */
 #define SEMMNS  (SEMMNI*SEMMSL) /* <= INT_MAX max # of semaphores in system */
-#define SEMOPM  32	        /* <= 1 000 max num of ops per semop call */
+#define SEMOPM  500	        /* <= 1 000 max num of ops per semop call */
 #define SEMVMX  32767           /* <= 32767 semaphore maximum value */
 #define SEMAEM  SEMVMX          /* adjust on exit max value */
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

