From: akpm@linux-foundation.org
Subject: [patch 102/119] mm/shmem: add hugetlbfs support to
 memfd_create()
Date: Wed, 06 Sep 2017 16:24:16 -0700
Message-ID: <20170906232416.pDEhJTF45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754023AbdIFXYS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/shmem: add hugetlbfs support to memfd_create()

This patch came out of discussions in this e-mail thread:
http://lkml.kernel.org/r/1499357846-7481-1-git-send-email-mike.kravetz%40oracle.com

The Oracle JVM team is developing a new garbage collection model.  This
new model requires multiple mappings of the same anonymous memory.  One
straight forward way to accomplish this is with memfd_create.  They can
use the returned fd to create multiple mappings of the same memory.

The JVM today has an option to use (static hugetlb) huge pages.  If this
option is specified, they would like to use the same garbage collection
model requiring multiple mappings to the same memory.  Using hugetlbfs, it
is possible to explicitly mount a filesystem and specify file paths in
order to get an fd that can be used for multiple mappings.  However, this
introduces additional system admin work and coordination.

Ideally they would like to get a hugetlbfs fd without requiring explicit
mounting of a filesystem.  Today, mmap and shmget can make use of
hugetlbfs without explicitly mounting a filesystem.  The patch adds this
functionality to memfd_create.

Add a new flag MFD_HUGETLB to memfd_create() that will specify the file to
be created resides in the hugetlbfs filesystem.  This is the generic
hugetlbfs filesystem not associated with any specific mount point.  As
with other system calls that request hugetlbfs backed pages, there is the
ability to encode huge page size in the flag arguments.

hugetlbfs does not support sealing operations, therefore specifying
MFD_ALLOW_SEALING with MFD_HUGETLB will result in EINVAL.

Of course, the memfd_man page would need updating if this type of
functionality moves forward.

Link: http://lkml.kernel.org/r/1502149672-7759-2-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/memfd.h |   24 ++++++++++++++++++++++
 mm/shmem.c                 |   37 +++++++++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 6 deletions(-)

diff -puN include/uapi/linux/memfd.h~mm-shmem-add-hugetlbfs-support-to-memfd_create include/uapi/linux/memfd.h
--- a/include/uapi/linux/memfd.h~mm-shmem-add-hugetlbfs-support-to-memfd_create
+++ a/include/uapi/linux/memfd.h
@@ -1,8 +1,32 @@
 #ifndef _UAPI_LINUX_MEMFD_H
 #define _UAPI_LINUX_MEMFD_H
 
+#include <asm-generic/hugetlb_encode.h>
+
 /* flags for memfd_create(2) (unsigned int) */
 #define MFD_CLOEXEC		0x0001U
 #define MFD_ALLOW_SEALING	0x0002U
+#define MFD_HUGETLB		0x0004U
+
+/*
+ * Huge page size encoding when MFD_HUGETLB is specified, and a huge page
+ * size other than the default is desired.  See hugetlb_encode.h.
+ * All known huge page size encodings are provided here.  It is the
+ * responsibility of the application to know which sizes are supported on
+ * the running system.  See mmap(2) man page for details.
+ */
+#define MFD_HUGE_SHIFT	HUGETLB_FLAG_ENCODE_SHIFT
+#define MFD_HUGE_MASK	HUGETLB_FLAG_ENCODE_MASK
+
+#define MFD_HUGE_64KB	HUGETLB_FLAG_ENCODE_64KB
+#define MFD_HUGE_512KB	HUGETLB_FLAG_ENCODE_512KB
+#define MFD_HUGE_1MB	HUGETLB_FLAG_ENCODE_1MB
+#define MFD_HUGE_2MB	HUGETLB_FLAG_ENCODE_2MB
+#define MFD_HUGE_8MB	HUGETLB_FLAG_ENCODE_8MB
+#define MFD_HUGE_16MB	HUGETLB_FLAG_ENCODE_16MB
+#define MFD_HUGE_256MB	HUGETLB_FLAG_ENCODE_256MB
+#define MFD_HUGE_1GB	HUGETLB_FLAG_ENCODE_1GB
+#define MFD_HUGE_2GB	HUGETLB_FLAG_ENCODE_2GB
+#define MFD_HUGE_16GB	HUGETLB_FLAG_ENCODE_16GB
 
 #endif /* _UAPI_LINUX_MEMFD_H */
diff -puN mm/shmem.c~mm-shmem-add-hugetlbfs-support-to-memfd_create mm/shmem.c
--- a/mm/shmem.c~mm-shmem-add-hugetlbfs-support-to-memfd_create
+++ a/mm/shmem.c
@@ -34,6 +34,7 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/khugepaged.h>
+#include <linux/hugetlb.h>
 
 #include <asm/tlbflush.h> /* for arch/microblaze update_mmu_cache() */
 
@@ -3652,7 +3653,7 @@ static int shmem_show_options(struct seq
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING)
+#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB)
 
 SYSCALL_DEFINE2(memfd_create,
 		const char __user *, uname,
@@ -3664,8 +3665,18 @@ SYSCALL_DEFINE2(memfd_create,
 	char *name;
 	long len;
 
-	if (flags & ~(unsigned int)MFD_ALL_FLAGS)
-		return -EINVAL;
+	if (!(flags & MFD_HUGETLB)) {
+		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
+			return -EINVAL;
+	} else {
+		/* Sealing not supported in hugetlbfs (MFD_HUGETLB) */
+		if (flags & MFD_ALLOW_SEALING)
+			return -EINVAL;
+		/* Allow huge page size encoding in flags. */
+		if (flags & ~(unsigned int)(MFD_ALL_FLAGS |
+				(MFD_HUGE_MASK << MFD_HUGE_SHIFT)))
+			return -EINVAL;
+	}
 
 	/* length includes terminating zero */
 	len = strnlen_user(uname, MFD_NAME_MAX_LEN + 1);
@@ -3696,16 +3707,30 @@ SYSCALL_DEFINE2(memfd_create,
 		goto err_name;
 	}
 
-	file = shmem_file_setup(name, 0, VM_NORESERVE);
+	if (flags & MFD_HUGETLB) {
+		struct user_struct *user = NULL;
+
+		file = hugetlb_file_setup(name, 0, VM_NORESERVE, &user,
+					HUGETLB_ANONHUGE_INODE,
+					(flags >> MFD_HUGE_SHIFT) &
+					MFD_HUGE_MASK);
+	} else
+		file = shmem_file_setup(name, 0, VM_NORESERVE);
 	if (IS_ERR(file)) {
 		error = PTR_ERR(file);
 		goto err_fd;
 	}
-	info = SHMEM_I(file_inode(file));
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |= O_RDWR | O_LARGEFILE;
-	if (flags & MFD_ALLOW_SEALING)
+
+	if (flags & MFD_ALLOW_SEALING) {
+		/*
+		 * flags check at beginning of function ensures
+		 * this is not a hugetlbfs (MFD_HUGETLB) file.
+		 */
+		info = SHMEM_I(file_inode(file));
 		info->seals &= ~F_SEAL_SEAL;
+	}
 
 	fd_install(fd, file);
 	kfree(name);
_
