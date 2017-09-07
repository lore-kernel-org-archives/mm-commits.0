From: akpm@linux-foundation.org
Subject: [merged]
 mm-shm-use-new-hugetlb-size-encoding-definitions.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:40:49 -0700
Message-ID: <20170907184049.XnB3OGQyM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755830AbdIGSku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, arnd@arndb.de, dbueso@suse.de, khandual@linux.vnet.ibm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, mtk.manpages@gmail.com, willy@infradead.org


The patch titled
     Subject: mm: shm: use new hugetlb size encoding definitions
has been removed from the -mm tree.  Its filename was
     mm-shm-use-new-hugetlb-size-encoding-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: shm: use new hugetlb size encoding definitions

Use the common definitions from hugetlb_encode.h header file for encoding
hugetlb size definitions in shmget system call flags.

In addition, move these definitions from the internal (kernel) to user
(uapi) header file.

Link: http://lkml.kernel.org/r/1501527386-10736-4-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shm.h      |   17 -----------------
 include/uapi/linux/shm.h |   31 +++++++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 19 deletions(-)

diff -puN include/linux/shm.h~mm-shm-use-new-hugetlb-size-encoding-definitions include/linux/shm.h
--- a/include/linux/shm.h~mm-shm-use-new-hugetlb-size-encoding-definitions
+++ a/include/linux/shm.h
@@ -27,23 +27,6 @@ struct shmid_kernel /* private to the ke
 /* shm_mode upper byte flags */
 #define	SHM_DEST	01000	/* segment will be destroyed on last detach */
 #define SHM_LOCKED      02000   /* segment will not be swapped */
-#define SHM_HUGETLB     04000   /* segment will use huge TLB pages */
-#define SHM_NORESERVE   010000  /* don't check for reservations */
-
-/* Bits [26:31] are reserved */
-
-/*
- * When SHM_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define SHM_HUGE_SHIFT  26
-#define SHM_HUGE_MASK   0x3f
-#define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
-#define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
 
 #ifdef CONFIG_SYSVIPC
 struct sysv_shm {
diff -puN include/uapi/linux/shm.h~mm-shm-use-new-hugetlb-size-encoding-definitions include/uapi/linux/shm.h
--- a/include/uapi/linux/shm.h~mm-shm-use-new-hugetlb-size-encoding-definitions
+++ a/include/uapi/linux/shm.h
@@ -3,6 +3,7 @@
 
 #include <linux/ipc.h>
 #include <linux/errno.h>
+#include <asm-generic/hugetlb_encode.h>
 #ifndef __KERNEL__
 #include <unistd.h>
 #endif
@@ -40,11 +41,37 @@ struct shmid_ds {
 /* Include the definition of shmid64_ds and shminfo64 */
 #include <asm/shmbuf.h>
 
-/* permission flag for shmget */
+/*
+ * shmget() shmflg values.
+ */
+/* The bottom nine bits are the same as open(2) mode flags */
 #define SHM_R		0400	/* or S_IRUGO from <linux/stat.h> */
 #define SHM_W		0200	/* or S_IWUGO from <linux/stat.h> */
+/* Bits 9 & 10 are IPC_CREAT and IPC_EXCL */
+#define SHM_HUGETLB	04000	/* segment will use huge TLB pages */
+#define SHM_NORESERVE	010000	/* don't check for reservations */
+
+/*
+ * Huge page size encoding when SHM_HUGETLB is specified, and a huge page
+ * size other than the default is desired.  See hugetlb_encode.h
+ */
+#define SHM_HUGE_SHIFT	HUGETLB_FLAG_ENCODE_SHIFT
+#define SHM_HUGE_MASK	HUGETLB_FLAG_ENCODE_MASK
+
+#define SHM_HUGE_64KB	HUGETLB_FLAG_ENCODE_64KB
+#define SHM_HUGE_512KB	HUGETLB_FLAG_ENCODE_512KB
+#define SHM_HUGE_1MB	HUGETLB_FLAG_ENCODE_1MB
+#define SHM_HUGE_2MB	HUGETLB_FLAG_ENCODE_2MB
+#define SHM_HUGE_8MB	HUGETLB_FLAG_ENCODE_8MB
+#define SHM_HUGE_16MB	HUGETLB_FLAG_ENCODE_16MB
+#define SHM_HUGE_256MB	HUGETLB_FLAG_ENCODE_256MB
+#define SHM_HUGE_1GB	HUGETLB_FLAG_ENCODE_1GB
+#define SHM_HUGE_2GB	HUGETLB_FLAG_ENCODE_2GB
+#define SHM_HUGE_16GB	HUGETLB_FLAG_ENCODE_16GB
 
-/* mode for attach */
+/*
+ * shmat() shmflg values
+ */
 #define	SHM_RDONLY	010000	/* read-only access */
 #define	SHM_RND		020000	/* round attach address to SHMLBA boundary */
 #define	SHM_REMAP	040000	/* take-over region on attach */
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


