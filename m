Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0CC19B590
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518401; cv=none; b=AV55gO1DUF2gaKwXIMEqD3+fgPa2ZHSZBccTOwrHrSP1Rqysl3xjX3t/OYK2jx8kgYpxlhHdk85YqJjV2GpY7VucT1P4ghPJpwuQiOTK/kmmhDHddBQpKTxaTy1R7jCijdSzEs85rSaAX6JXHt0XzEiGIzbJZwAAezPXch9gpXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518401; c=relaxed/simple;
	bh=P4w3QLZfWFcSt0CZydhbLUjzZF3GPkKSw177TbUb+YQ=;
	h=Date:To:From:Subject:Message-Id; b=IPD6lczLCN5Izs4Nw9mJCCG/BHpNMJhmXsXvw+B9YBlKLULsvlK6qFUJBFj0TlKBmIU+/2bfG3A1CgaG0KlluDOJ3iHMGkN34X/xoY0u9ddTOAEMAMJnMJQQVogDuMPDtP/MfOAfITy3doXM4uelvVz/vczIXGtOmdFrr+1T2AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O4u7TUpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O4u7TUpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93931C4AF09;
	Thu, 27 Jun 2024 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719518401;
	bh=P4w3QLZfWFcSt0CZydhbLUjzZF3GPkKSw177TbUb+YQ=;
	h=Date:To:From:Subject:From;
	b=O4u7TUpHrfqAYawLIpJh0A0BF1zB6C1pCsbciyemE749RLKt8WiEgZp0QlU1A4BKY
	 XCNKD25QfBMjkx5Vaadgpi/0MWdJYdXPmLHIvTUYqL+CCBDLiyJjBWJIajfHka4A9R
	 9+TuGq9xd4dvIJLW08ct9PnE3ujE5lCFAeIV/cig=
Date: Thu, 27 Jun 2024 13:00:01 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,rppt@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch added to mm-unstable branch
Message-Id: <20240627200001.93931C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: sync uapi/linux/fs.h header into tools subdir
has been added to the -mm mm-unstable branch.  Its filename is
     tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: tools: sync uapi/linux/fs.h header into tools subdir
Date: Thu, 27 Jun 2024 10:08:57 -0700

We need this UAPI header in tools/include subdirectory for using it from
BPF selftests.

Link: https://lkml.kernel.org/r/20240627170900.1672542-6-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/fs.h |  180 ++++++++++++++++++++++++++++++--
 1 file changed, 170 insertions(+), 10 deletions(-)

--- a/tools/include/uapi/linux/fs.h~tools-sync-uapi-linux-fsh-header-into-tools-subdir
+++ a/tools/include/uapi/linux/fs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _LINUX_FS_H
-#define _LINUX_FS_H
+#ifndef _UAPI_LINUX_FS_H
+#define _UAPI_LINUX_FS_H
 
 /*
  * This file has definitions for some important file table structures
@@ -13,10 +13,14 @@
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#ifndef __KERNEL__
 #include <linux/fscrypt.h>
+#endif
 
 /* Use of MS_* flags within the kernel is restricted to core mount(2) code. */
+#if !defined(__KERNEL__)
 #include <linux/mount.h>
+#endif
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -308,29 +312,31 @@ struct fsxattr {
 typedef int __bitwise __kernel_rwf_t;
 
 /* high priority request, poll if possible */
-#define RWF_HIPRI	((__kernel_rwf_t)0x00000001)
+#define RWF_HIPRI	((__force __kernel_rwf_t)0x00000001)
 
 /* per-IO O_DSYNC */
-#define RWF_DSYNC	((__kernel_rwf_t)0x00000002)
+#define RWF_DSYNC	((__force __kernel_rwf_t)0x00000002)
 
 /* per-IO O_SYNC */
-#define RWF_SYNC	((__kernel_rwf_t)0x00000004)
+#define RWF_SYNC	((__force __kernel_rwf_t)0x00000004)
 
 /* per-IO, return -EAGAIN if operation would block */
-#define RWF_NOWAIT	((__kernel_rwf_t)0x00000008)
+#define RWF_NOWAIT	((__force __kernel_rwf_t)0x00000008)
 
 /* per-IO O_APPEND */
-#define RWF_APPEND	((__kernel_rwf_t)0x00000010)
+#define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
 
 /* per-IO negation of O_APPEND */
-#define RWF_NOAPPEND	((__kernel_rwf_t)0x00000020)
+#define RWF_NOAPPEND	((__force __kernel_rwf_t)0x00000020)
 
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND | RWF_NOAPPEND)
 
+#define PROCFS_IOCTL_MAGIC 'f'
+
 /* Pagemap ioctl */
-#define PAGEMAP_SCAN	_IOWR('f', 16, struct pm_scan_arg)
+#define PAGEMAP_SCAN	_IOWR(PROCFS_IOCTL_MAGIC, 16, struct pm_scan_arg)
 
 /* Bitmasks provided in pm_scan_args masks and reported in page_region.categories. */
 #define PAGE_IS_WPALLOWED	(1 << 0)
@@ -389,4 +395,158 @@ struct pm_scan_arg {
 	__u64 return_mask;
 };
 
-#endif /* _LINUX_FS_H */
+/* /proc/<pid>/maps ioctl */
+#define PROCMAP_QUERY	_IOWR(PROCFS_IOCTL_MAGIC, 17, struct procmap_query)
+
+enum procmap_query_flags {
+	/*
+	 * VMA permission flags.
+	 *
+	 * Can be used as part of procmap_query.query_flags field to look up
+	 * only VMAs satisfying specified subset of permissions. E.g., specifying
+	 * PROCMAP_QUERY_VMA_READABLE only will return both readable and read/write VMAs,
+	 * while having PROCMAP_QUERY_VMA_READABLE | PROCMAP_QUERY_VMA_WRITABLE will only
+	 * return read/write VMAs, though both executable/non-executable and
+	 * private/shared will be ignored.
+	 *
+	 * PROCMAP_QUERY_VMA_* flags are also returned in procmap_query.vma_flags
+	 * field to specify actual VMA permissions.
+	 */
+	PROCMAP_QUERY_VMA_READABLE		= 0x01,
+	PROCMAP_QUERY_VMA_WRITABLE		= 0x02,
+	PROCMAP_QUERY_VMA_EXECUTABLE		= 0x04,
+	PROCMAP_QUERY_VMA_SHARED		= 0x08,
+	/*
+	 * Query modifier flags.
+	 *
+	 * By default VMA that covers provided address is returned, or -ENOENT
+	 * is returned. With PROCMAP_QUERY_COVERING_OR_NEXT_VMA flag set, closest
+	 * VMA with vma_start > addr will be returned if no covering VMA is
+	 * found.
+	 *
+	 * PROCMAP_QUERY_FILE_BACKED_VMA instructs query to consider only VMAs that
+	 * have file backing. Can be combined with PROCMAP_QUERY_COVERING_OR_NEXT_VMA
+	 * to iterate all VMAs with file backing.
+	 */
+	PROCMAP_QUERY_COVERING_OR_NEXT_VMA	= 0x10,
+	PROCMAP_QUERY_FILE_BACKED_VMA		= 0x20,
+};
+
+/*
+ * Input/output argument structured passed into ioctl() call. It can be used
+ * to query a set of VMAs (Virtual Memory Areas) of a process.
+ *
+ * Each field can be one of three kinds, marked in a short comment to the
+ * right of the field:
+ *   - "in", input argument, user has to provide this value, kernel doesn't modify it;
+ *   - "out", output argument, kernel sets this field with VMA data;
+ *   - "in/out", input and output argument; user provides initial value (used
+ *     to specify maximum allowable buffer size), and kernel sets it to actual
+ *     amount of data written (or zero, if there is no data).
+ *
+ * If matching VMA is found (according to criterias specified by
+ * query_addr/query_flags, all the out fields are filled out, and ioctl()
+ * returns 0. If there is no matching VMA, -ENOENT will be returned.
+ * In case of any other error, negative error code other than -ENOENT is
+ * returned.
+ *
+ * Most of the data is similar to the one returned as text in /proc/<pid>/maps
+ * file, but procmap_query provides more querying flexibility. There are no
+ * consistency guarantees between subsequent ioctl() calls, but data returned
+ * for matched VMA is self-consistent.
+ */
+struct procmap_query {
+	/* Query struct size, for backwards/forward compatibility */
+	__u64 size;
+	/*
+	 * Query flags, a combination of enum procmap_query_flags values.
+	 * Defines query filtering and behavior, see enum procmap_query_flags.
+	 *
+	 * Input argument, provided by user. Kernel doesn't modify it.
+	 */
+	__u64 query_flags;		/* in */
+	/*
+	 * Query address. By default, VMA that covers this address will
+	 * be looked up. PROCMAP_QUERY_* flags above modify this default
+	 * behavior further.
+	 *
+	 * Input argument, provided by user. Kernel doesn't modify it.
+	 */
+	__u64 query_addr;		/* in */
+	/* VMA starting (inclusive) and ending (exclusive) address, if VMA is found. */
+	__u64 vma_start;		/* out */
+	__u64 vma_end;			/* out */
+	/* VMA permissions flags. A combination of PROCMAP_QUERY_VMA_* flags. */
+	__u64 vma_flags;		/* out */
+	/* VMA backing page size granularity. */
+	__u64 vma_page_size;		/* out */
+	/*
+	 * VMA file offset. If VMA has file backing, this specifies offset
+	 * within the file that VMA's start address corresponds to.
+	 * Is set to zero if VMA has no backing file.
+	 */
+	__u64 vma_offset;		/* out */
+	/* Backing file's inode number, or zero, if VMA has no backing file. */
+	__u64 inode;			/* out */
+	/* Backing file's device major/minor number, or zero, if VMA has no backing file. */
+	__u32 dev_major;		/* out */
+	__u32 dev_minor;		/* out */
+	/*
+	 * If set to non-zero value, signals the request to return VMA name
+	 * (i.e., VMA's backing file's absolute path, with " (deleted)" suffix
+	 * appended, if file was unlinked from FS) for matched VMA. VMA name
+	 * can also be some special name (e.g., "[heap]", "[stack]") or could
+	 * be even user-supplied with prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME).
+	 *
+	 * Kernel will set this field to zero, if VMA has no associated name.
+	 * Otherwise kernel will return actual amount of bytes filled in
+	 * user-supplied buffer (see vma_name_addr field below), including the
+	 * terminating zero.
+	 *
+	 * If VMA name is longer that user-supplied maximum buffer size,
+	 * -E2BIG error is returned.
+	 *
+	 * If this field is set to non-zero value, vma_name_addr should point
+	 * to valid user space memory buffer of at least vma_name_size bytes.
+	 * If set to zero, vma_name_addr should be set to zero as well
+	 */
+	__u32 vma_name_size;		/* in/out */
+	/*
+	 * If set to non-zero value, signals the request to extract and return
+	 * VMA's backing file's build ID, if the backing file is an ELF file
+	 * and it contains embedded build ID.
+	 *
+	 * Kernel will set this field to zero, if VMA has no backing file,
+	 * backing file is not an ELF file, or ELF file has no build ID
+	 * embedded.
+	 *
+	 * Build ID is a binary value (not a string). Kernel will set
+	 * build_id_size field to exact number of bytes used for build ID.
+	 * If build ID is requested and present, but needs more bytes than
+	 * user-supplied maximum buffer size (see build_id_addr field below),
+	 * -E2BIG error will be returned.
+	 *
+	 * If this field is set to non-zero value, build_id_addr should point
+	 * to valid user space memory buffer of at least build_id_size bytes.
+	 * If set to zero, build_id_addr should be set to zero as well
+	 */
+	__u32 build_id_size;		/* in/out */
+	/*
+	 * User-supplied address of a buffer of at least vma_name_size bytes
+	 * for kernel to fill with matched VMA's name (see vma_name_size field
+	 * description above for details).
+	 *
+	 * Should be set to zero if VMA name should not be returned.
+	 */
+	__u64 vma_name_addr;		/* in */
+	/*
+	 * User-supplied address of a buffer of at least build_id_size bytes
+	 * for kernel to fill with matched VMA's ELF build ID, if available
+	 * (see build_id_size field description above for details).
+	 *
+	 * Should be set to zero if build ID should not be returned.
+	 */
+	__u64 build_id_addr;		/* in */
+};
+
+#endif /* _UAPI_LINUX_FS_H */
_

Patches currently in -mm which might be from andrii@kernel.org are

fs-procfs-extract-logic-for-getting-vma-name-constituents.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

