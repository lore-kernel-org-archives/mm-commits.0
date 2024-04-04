Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8233415EA6
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 18:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256939; cv=none; b=lbSLJgbEYoZtqK2zFlyuGU5XfilChJ91EplwUwglRfpyvbnHAr2+WT4U2KbZjQWxRqcWQGL2aaLscMnVUp2vwDmtkJmm99EPB2NPEtzjgpnAJPymIc0SDIP+ho9h1G5gUUtSro+v8yhFDq0AFi17S3YUNSiMrl2cqTHyYtQbICg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256939; c=relaxed/simple;
	bh=HaGJj46iikc0jhwkBBzR0Wc7gjBBeWgR26kWlIXQmLU=;
	h=Date:To:From:Subject:Message-Id; b=kXgjpbPt7+3wMiQ5Zm7t5aw54eSL9Ig8EK2h4gYZeQDmplyfD7GhzF36cVqw91jsbJhUkisk2YDqKQiN0MiA4ELrwHCkrUmG6RtvT3YfhMZrZBLLlqihct7k/2wIV9OU4EI5vcWcUoXybfRj7aC6btAktJq1Bu9vpd32bkWHmag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IK/v88Kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IK/v88Kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0277CC433F1;
	Thu,  4 Apr 2024 18:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712256939;
	bh=HaGJj46iikc0jhwkBBzR0Wc7gjBBeWgR26kWlIXQmLU=;
	h=Date:To:From:Subject:From;
	b=IK/v88Kda77Zdwqn4msVkjAgE51/07sjNSe0eRsovOACokGFf50JrvZyW+3oYCnKM
	 0ZaQ0qKFWXYXSBccu5GuzSkIPbGTomd4IigUCBneZf0vJMUhn127h5iwVIkf6stP8s
	 YMOMfmDDvA3OIEha00ihQdOdj/u4Z1t9swA2HMo8=
Date: Thu, 04 Apr 2024 11:55:38 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,peterz@infradead.org,peterx@redhat.com,david@redhat.com,broonie@kernel.org,axelrasmussen@google.com,aarcange@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-additional-build-errors-for-selftests.patch added to mm-unstable branch
Message-Id: <20240404185539.0277CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix additional build errors for selftests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-additional-build-errors-for-selftests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-additional-build-errors-for-selftests.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix additional build errors for selftests
Date: Wed, 27 Mar 2024 20:34:18 -0700

These build errors only occur if one fails to first run "make headers". 
However, that is a non-obvious and instrusive requirement, and so there
was a discussion on how to get rid of it [1].  This uses that solution.

These two files were created by taking a snapshot of the generated header
files that are created via "make headers".  These two files were copied
from ./usr/include/linux/ to ./tools/include/uapi/linux/ .

That fixes the selftests/mm build on today's Arch Linux (which required
the userfaultfd.h) and Ubuntu 23.04 (which additionally required memfd.h).

[1] https://lore.kernel.org/all/783a4178-1dec-4e30-989a-5174b8176b09@redhat.com/

Link: https://lkml.kernel.org/r/20240328033418.203790-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/memfd.h       |   39 ++
 tools/include/uapi/linux/userfaultfd.h |  386 +++++++++++++++++++++++
 2 files changed, 425 insertions(+)

--- /dev/null
+++ a/tools/include/uapi/linux/memfd.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_MEMFD_H
+#define _LINUX_MEMFD_H
+
+#include <asm-generic/hugetlb_encode.h>
+
+/* flags for memfd_create(2) (unsigned int) */
+#define MFD_CLOEXEC		0x0001U
+#define MFD_ALLOW_SEALING	0x0002U
+#define MFD_HUGETLB		0x0004U
+/* not executable and sealed to prevent changing to executable. */
+#define MFD_NOEXEC_SEAL		0x0008U
+/* executable */
+#define MFD_EXEC		0x0010U
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
+#define MFD_HUGE_32MB	HUGETLB_FLAG_ENCODE_32MB
+#define MFD_HUGE_256MB	HUGETLB_FLAG_ENCODE_256MB
+#define MFD_HUGE_512MB	HUGETLB_FLAG_ENCODE_512MB
+#define MFD_HUGE_1GB	HUGETLB_FLAG_ENCODE_1GB
+#define MFD_HUGE_2GB	HUGETLB_FLAG_ENCODE_2GB
+#define MFD_HUGE_16GB	HUGETLB_FLAG_ENCODE_16GB
+
+#endif /* _LINUX_MEMFD_H */
--- /dev/null
+++ a/tools/include/uapi/linux/userfaultfd.h
@@ -0,0 +1,386 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ *  include/linux/userfaultfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *  Copyright (C) 2015  Red Hat, Inc.
+ *
+ */
+
+#ifndef _LINUX_USERFAULTFD_H
+#define _LINUX_USERFAULTFD_H
+
+#include <linux/types.h>
+
+/* ioctls for /dev/userfaultfd */
+#define USERFAULTFD_IOC 0xAA
+#define USERFAULTFD_IOC_NEW _IO(USERFAULTFD_IOC, 0x00)
+
+/*
+ * If the UFFDIO_API is upgraded someday, the UFFDIO_UNREGISTER and
+ * UFFDIO_WAKE ioctls should be defined as _IOW and not as _IOR.  In
+ * userfaultfd.h we assumed the kernel was reading (instead _IOC_READ
+ * means the userland is reading).
+ */
+#define UFFD_API ((__u64)0xAA)
+#define UFFD_API_REGISTER_MODES (UFFDIO_REGISTER_MODE_MISSING |	\
+				 UFFDIO_REGISTER_MODE_WP |	\
+				 UFFDIO_REGISTER_MODE_MINOR)
+#define UFFD_API_FEATURES (UFFD_FEATURE_PAGEFAULT_FLAG_WP |	\
+			   UFFD_FEATURE_EVENT_FORK |		\
+			   UFFD_FEATURE_EVENT_REMAP |		\
+			   UFFD_FEATURE_EVENT_REMOVE |		\
+			   UFFD_FEATURE_EVENT_UNMAP |		\
+			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
+			   UFFD_FEATURE_MISSING_SHMEM |		\
+			   UFFD_FEATURE_SIGBUS |		\
+			   UFFD_FEATURE_THREAD_ID |		\
+			   UFFD_FEATURE_MINOR_HUGETLBFS |	\
+			   UFFD_FEATURE_MINOR_SHMEM |		\
+			   UFFD_FEATURE_EXACT_ADDRESS |		\
+			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM |	\
+			   UFFD_FEATURE_WP_UNPOPULATED |	\
+			   UFFD_FEATURE_POISON |		\
+			   UFFD_FEATURE_WP_ASYNC |		\
+			   UFFD_FEATURE_MOVE)
+#define UFFD_API_IOCTLS				\
+	((__u64)1 << _UFFDIO_REGISTER |		\
+	 (__u64)1 << _UFFDIO_UNREGISTER |	\
+	 (__u64)1 << _UFFDIO_API)
+#define UFFD_API_RANGE_IOCTLS			\
+	((__u64)1 << _UFFDIO_WAKE |		\
+	 (__u64)1 << _UFFDIO_COPY |		\
+	 (__u64)1 << _UFFDIO_ZEROPAGE |		\
+	 (__u64)1 << _UFFDIO_MOVE |		\
+	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
+	 (__u64)1 << _UFFDIO_CONTINUE |		\
+	 (__u64)1 << _UFFDIO_POISON)
+#define UFFD_API_RANGE_IOCTLS_BASIC		\
+	((__u64)1 << _UFFDIO_WAKE |		\
+	 (__u64)1 << _UFFDIO_COPY |		\
+	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
+	 (__u64)1 << _UFFDIO_CONTINUE |		\
+	 (__u64)1 << _UFFDIO_POISON)
+
+/*
+ * Valid ioctl command number range with this API is from 0x00 to
+ * 0x3F.  UFFDIO_API is the fixed number, everything else can be
+ * changed by implementing a different UFFD_API. If sticking to the
+ * same UFFD_API more ioctl can be added and userland will be aware of
+ * which ioctl the running kernel implements through the ioctl command
+ * bitmask written by the UFFDIO_API.
+ */
+#define _UFFDIO_REGISTER		(0x00)
+#define _UFFDIO_UNREGISTER		(0x01)
+#define _UFFDIO_WAKE			(0x02)
+#define _UFFDIO_COPY			(0x03)
+#define _UFFDIO_ZEROPAGE		(0x04)
+#define _UFFDIO_MOVE			(0x05)
+#define _UFFDIO_WRITEPROTECT		(0x06)
+#define _UFFDIO_CONTINUE		(0x07)
+#define _UFFDIO_POISON			(0x08)
+#define _UFFDIO_API			(0x3F)
+
+/* userfaultfd ioctl ids */
+#define UFFDIO 0xAA
+#define UFFDIO_API		_IOWR(UFFDIO, _UFFDIO_API,	\
+				      struct uffdio_api)
+#define UFFDIO_REGISTER		_IOWR(UFFDIO, _UFFDIO_REGISTER, \
+				      struct uffdio_register)
+#define UFFDIO_UNREGISTER	_IOR(UFFDIO, _UFFDIO_UNREGISTER,	\
+				     struct uffdio_range)
+#define UFFDIO_WAKE		_IOR(UFFDIO, _UFFDIO_WAKE,	\
+				     struct uffdio_range)
+#define UFFDIO_COPY		_IOWR(UFFDIO, _UFFDIO_COPY,	\
+				      struct uffdio_copy)
+#define UFFDIO_ZEROPAGE		_IOWR(UFFDIO, _UFFDIO_ZEROPAGE,	\
+				      struct uffdio_zeropage)
+#define UFFDIO_MOVE		_IOWR(UFFDIO, _UFFDIO_MOVE,	\
+				      struct uffdio_move)
+#define UFFDIO_WRITEPROTECT	_IOWR(UFFDIO, _UFFDIO_WRITEPROTECT, \
+				      struct uffdio_writeprotect)
+#define UFFDIO_CONTINUE		_IOWR(UFFDIO, _UFFDIO_CONTINUE,	\
+				      struct uffdio_continue)
+#define UFFDIO_POISON		_IOWR(UFFDIO, _UFFDIO_POISON, \
+				      struct uffdio_poison)
+
+/* read() structure */
+struct uffd_msg {
+	__u8	event;
+
+	__u8	reserved1;
+	__u16	reserved2;
+	__u32	reserved3;
+
+	union {
+		struct {
+			__u64	flags;
+			__u64	address;
+			union {
+				__u32 ptid;
+			} feat;
+		} pagefault;
+
+		struct {
+			__u32	ufd;
+		} fork;
+
+		struct {
+			__u64	from;
+			__u64	to;
+			__u64	len;
+		} remap;
+
+		struct {
+			__u64	start;
+			__u64	end;
+		} remove;
+
+		struct {
+			/* unused reserved fields */
+			__u64	reserved1;
+			__u64	reserved2;
+			__u64	reserved3;
+		} reserved;
+	} arg;
+} __attribute__((packed));
+
+/*
+ * Start at 0x12 and not at 0 to be more strict against bugs.
+ */
+#define UFFD_EVENT_PAGEFAULT	0x12
+#define UFFD_EVENT_FORK		0x13
+#define UFFD_EVENT_REMAP	0x14
+#define UFFD_EVENT_REMOVE	0x15
+#define UFFD_EVENT_UNMAP	0x16
+
+/* flags for UFFD_EVENT_PAGEFAULT */
+#define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
+#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
+#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
+
+struct uffdio_api {
+	/* userland asks for an API number and the features to enable */
+	__u64 api;
+	/*
+	 * Kernel answers below with the all available features for
+	 * the API, this notifies userland of which events and/or
+	 * which flags for each event are enabled in the current
+	 * kernel.
+	 *
+	 * Note: UFFD_EVENT_PAGEFAULT and UFFD_PAGEFAULT_FLAG_WRITE
+	 * are to be considered implicitly always enabled in all kernels as
+	 * long as the uffdio_api.api requested matches UFFD_API.
+	 *
+	 * UFFD_FEATURE_MISSING_HUGETLBFS means an UFFDIO_REGISTER
+	 * with UFFDIO_REGISTER_MODE_MISSING mode will succeed on
+	 * hugetlbfs virtual memory ranges. Adding or not adding
+	 * UFFD_FEATURE_MISSING_HUGETLBFS to uffdio_api.features has
+	 * no real functional effect after UFFDIO_API returns, but
+	 * it's only useful for an initial feature set probe at
+	 * UFFDIO_API time. There are two ways to use it:
+	 *
+	 * 1) by adding UFFD_FEATURE_MISSING_HUGETLBFS to the
+	 *    uffdio_api.features before calling UFFDIO_API, an error
+	 *    will be returned by UFFDIO_API on a kernel without
+	 *    hugetlbfs missing support
+	 *
+	 * 2) the UFFD_FEATURE_MISSING_HUGETLBFS can not be added in
+	 *    uffdio_api.features and instead it will be set by the
+	 *    kernel in the uffdio_api.features if the kernel supports
+	 *    it, so userland can later check if the feature flag is
+	 *    present in uffdio_api.features after UFFDIO_API
+	 *    succeeded.
+	 *
+	 * UFFD_FEATURE_MISSING_SHMEM works the same as
+	 * UFFD_FEATURE_MISSING_HUGETLBFS, but it applies to shmem
+	 * (i.e. tmpfs and other shmem based APIs).
+	 *
+	 * UFFD_FEATURE_SIGBUS feature means no page-fault
+	 * (UFFD_EVENT_PAGEFAULT) event will be delivered, instead
+	 * a SIGBUS signal will be sent to the faulting process.
+	 *
+	 * UFFD_FEATURE_THREAD_ID pid of the page faulted task_struct will
+	 * be returned, if feature is not requested 0 will be returned.
+	 *
+	 * UFFD_FEATURE_MINOR_HUGETLBFS indicates that minor faults
+	 * can be intercepted (via REGISTER_MODE_MINOR) for
+	 * hugetlbfs-backed pages.
+	 *
+	 * UFFD_FEATURE_MINOR_SHMEM indicates the same support as
+	 * UFFD_FEATURE_MINOR_HUGETLBFS, but for shmem-backed pages instead.
+	 *
+	 * UFFD_FEATURE_EXACT_ADDRESS indicates that the exact address of page
+	 * faults would be provided and the offset within the page would not be
+	 * masked.
+	 *
+	 * UFFD_FEATURE_WP_HUGETLBFS_SHMEM indicates that userfaultfd
+	 * write-protection mode is supported on both shmem and hugetlbfs.
+	 *
+	 * UFFD_FEATURE_WP_UNPOPULATED indicates that userfaultfd
+	 * write-protection mode will always apply to unpopulated pages
+	 * (i.e. empty ptes).  This will be the default behavior for shmem
+	 * & hugetlbfs, so this flag only affects anonymous memory behavior
+	 * when userfault write-protection mode is registered.
+	 *
+	 * UFFD_FEATURE_WP_ASYNC indicates that userfaultfd write-protection
+	 * asynchronous mode is supported in which the write fault is
+	 * automatically resolved and write-protection is un-set.
+	 * It implies UFFD_FEATURE_WP_UNPOPULATED.
+	 *
+	 * UFFD_FEATURE_MOVE indicates that the kernel supports moving an
+	 * existing page contents from userspace.
+	 */
+#define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
+#define UFFD_FEATURE_EVENT_FORK			(1<<1)
+#define UFFD_FEATURE_EVENT_REMAP		(1<<2)
+#define UFFD_FEATURE_EVENT_REMOVE		(1<<3)
+#define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
+#define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
+#define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
+#define UFFD_FEATURE_SIGBUS			(1<<7)
+#define UFFD_FEATURE_THREAD_ID			(1<<8)
+#define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
+#define UFFD_FEATURE_MINOR_SHMEM		(1<<10)
+#define UFFD_FEATURE_EXACT_ADDRESS		(1<<11)
+#define UFFD_FEATURE_WP_HUGETLBFS_SHMEM		(1<<12)
+#define UFFD_FEATURE_WP_UNPOPULATED		(1<<13)
+#define UFFD_FEATURE_POISON			(1<<14)
+#define UFFD_FEATURE_WP_ASYNC			(1<<15)
+#define UFFD_FEATURE_MOVE			(1<<16)
+	__u64 features;
+
+	__u64 ioctls;
+};
+
+struct uffdio_range {
+	__u64 start;
+	__u64 len;
+};
+
+struct uffdio_register {
+	struct uffdio_range range;
+#define UFFDIO_REGISTER_MODE_MISSING	((__u64)1<<0)
+#define UFFDIO_REGISTER_MODE_WP		((__u64)1<<1)
+#define UFFDIO_REGISTER_MODE_MINOR	((__u64)1<<2)
+	__u64 mode;
+
+	/*
+	 * kernel answers which ioctl commands are available for the
+	 * range, keep at the end as the last 8 bytes aren't read.
+	 */
+	__u64 ioctls;
+};
+
+struct uffdio_copy {
+	__u64 dst;
+	__u64 src;
+	__u64 len;
+#define UFFDIO_COPY_MODE_DONTWAKE		((__u64)1<<0)
+	/*
+	 * UFFDIO_COPY_MODE_WP will map the page write protected on
+	 * the fly.  UFFDIO_COPY_MODE_WP is available only if the
+	 * write protected ioctl is implemented for the range
+	 * according to the uffdio_register.ioctls.
+	 */
+#define UFFDIO_COPY_MODE_WP			((__u64)1<<1)
+	__u64 mode;
+
+	/*
+	 * "copy" is written by the ioctl and must be at the end: the
+	 * copy_from_user will not read the last 8 bytes.
+	 */
+	__s64 copy;
+};
+
+struct uffdio_zeropage {
+	struct uffdio_range range;
+#define UFFDIO_ZEROPAGE_MODE_DONTWAKE		((__u64)1<<0)
+	__u64 mode;
+
+	/*
+	 * "zeropage" is written by the ioctl and must be at the end:
+	 * the copy_from_user will not read the last 8 bytes.
+	 */
+	__s64 zeropage;
+};
+
+struct uffdio_writeprotect {
+	struct uffdio_range range;
+/*
+ * UFFDIO_WRITEPROTECT_MODE_WP: set the flag to write protect a range,
+ * unset the flag to undo protection of a range which was previously
+ * write protected.
+ *
+ * UFFDIO_WRITEPROTECT_MODE_DONTWAKE: set the flag to avoid waking up
+ * any wait thread after the operation succeeds.
+ *
+ * NOTE: Write protecting a region (WP=1) is unrelated to page faults,
+ * therefore DONTWAKE flag is meaningless with WP=1.  Removing write
+ * protection (WP=0) in response to a page fault wakes the faulting
+ * task unless DONTWAKE is set.
+ */
+#define UFFDIO_WRITEPROTECT_MODE_WP		((__u64)1<<0)
+#define UFFDIO_WRITEPROTECT_MODE_DONTWAKE	((__u64)1<<1)
+	__u64 mode;
+};
+
+struct uffdio_continue {
+	struct uffdio_range range;
+#define UFFDIO_CONTINUE_MODE_DONTWAKE		((__u64)1<<0)
+	/*
+	 * UFFDIO_CONTINUE_MODE_WP will map the page write protected on
+	 * the fly.  UFFDIO_CONTINUE_MODE_WP is available only if the
+	 * write protected ioctl is implemented for the range
+	 * according to the uffdio_register.ioctls.
+	 */
+#define UFFDIO_CONTINUE_MODE_WP			((__u64)1<<1)
+	__u64 mode;
+
+	/*
+	 * Fields below here are written by the ioctl and must be at the end:
+	 * the copy_from_user will not read past here.
+	 */
+	__s64 mapped;
+};
+
+struct uffdio_poison {
+	struct uffdio_range range;
+#define UFFDIO_POISON_MODE_DONTWAKE		((__u64)1<<0)
+	__u64 mode;
+
+	/*
+	 * Fields below here are written by the ioctl and must be at the end:
+	 * the copy_from_user will not read past here.
+	 */
+	__s64 updated;
+};
+
+struct uffdio_move {
+	__u64 dst;
+	__u64 src;
+	__u64 len;
+	/*
+	 * Especially if used to atomically remove memory from the
+	 * address space the wake on the dst range is not needed.
+	 */
+#define UFFDIO_MOVE_MODE_DONTWAKE		((__u64)1<<0)
+#define UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES	((__u64)1<<1)
+	__u64 mode;
+	/*
+	 * "move" is written by the ioctl and must be at the end: the
+	 * copy_from_user will not read the last 8 bytes.
+	 */
+	__s64 move;
+};
+
+/*
+ * Flags for the userfaultfd(2) system call itself.
+ */
+
+/*
+ * Create a userfaultfd that can handle page faults only in user mode.
+ */
+#define UFFD_USER_MODE_ONLY 1
+
+#endif /* _LINUX_USERFAULTFD_H */
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

huge_memoryc-document-huge-page-splitting-rules-more-thoroughly.patch
selftests-break-the-dependency-upon-local-header-files.patch
selftests-mm-fix-additional-build-errors-for-selftests.patch

