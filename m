From: akpm@linux-foundation.org
Subject: [merged] ipcshm-document-new-limits-in-the-uapi-header.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:37:32 -0700
Message-ID: <53960cfc.FIyUPCwJQi7b3Xoi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFIThd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, manfred@colorfullife.com, davidlohr@hp.com

Subject: [merged] ipcshm-document-new-limits-in-the-uapi-header.patch removed from -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:32 -0700


The patch titled
     Subject: ipc,shm: document new limits in the uapi header
has been removed from the -mm tree.  Its filename was
     ipcshm-document-new-limits-in-the-uapi-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,shm: document new limits in the uapi header

This is useful in the future and allows users to better understand the
reasoning behind the changes.

Also use UL as we're dealing with it anyways.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/shm.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header include/uapi/linux/shm.h
--- a/include/uapi/linux/shm.h~ipcshm-document-new-limits-in-the-uapi-header
+++ a/include/uapi/linux/shm.h
@@ -8,17 +8,20 @@
 #endif
 
 /*
- * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
- * be modified by sysctl.
+ * SHMMNI, SHMMAX and SHMALL are default upper limits which can be
+ * modified by sysctl. The SHMMAX and SHMALL values have been chosen to
+ * be as large possible without facilitating scenarios where userspace
+ * causes overflows when adjusting the limits via operations of the form
+ * "retrieve current limit; add X; update limit". It is therefore not
+ * advised to make SHMMAX and SHMALL any larger. These limits are
+ * suitable for both 32 and 64-bit systems.
  */
-
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
-#define SHMMAX (ULONG_MAX - (1L<<24))	 /* max shared seg size (bytes) */
-#define SHMALL (ULONG_MAX - (1L<<24))	 /* max shm system wide (pages) */
+#define SHMMAX (ULONG_MAX - (1UL << 24)) /* max shared seg size (bytes) */
+#define SHMALL (ULONG_MAX - (1UL << 24)) /* max shm system wide (pages) */
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
