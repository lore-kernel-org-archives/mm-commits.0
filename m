From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-uapi.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:56 -0700
Message-ID: <55ef230c.DqaeyItgr1eliFZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbbIHSEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: uAPI
has been removed from the -mm tree.  Its filename was
     userfaultfd-uapi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: uAPI

Defines the uAPI of the userfaultfd, notably the ioctl numbers and protocol.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/ioctl-number.txt |    1 
 include/uapi/linux/Kbuild            |    1 
 include/uapi/linux/userfaultfd.h     |   83 +++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff -puN Documentation/ioctl/ioctl-number.txt~userfaultfd-uapi Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~userfaultfd-uapi
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -303,6 +303,7 @@ Code  Seq#(hex)	Include File		Comments
 0xA3	80-8F	Port ACL		in development:
 					<mailto:tlewis@mindspring.com>
 0xA3	90-9F	linux/dtlk.h
+0xAA	00-3F	linux/uapi/linux/userfaultfd.h
 0xAB	00-1F	linux/nbd.h
 0xAC	00-1F	linux/raw.h
 0xAD	00	Netfilter device	in development:
diff -puN include/uapi/linux/Kbuild~userfaultfd-uapi include/uapi/linux/Kbuild
--- a/include/uapi/linux/Kbuild~userfaultfd-uapi
+++ a/include/uapi/linux/Kbuild
@@ -456,3 +456,4 @@ header-y += xfrm.h
 header-y += xilinx-v4l2-controls.h
 header-y += zorro.h
 header-y += zorro_ids.h
+header-y += userfaultfd.h
diff -puN /dev/null include/uapi/linux/userfaultfd.h
--- /dev/null
+++ a/include/uapi/linux/userfaultfd.h
@@ -0,0 +1,83 @@
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
+#define UFFD_API ((__u64)0xAA)
+/* FIXME: add "|UFFD_BIT_WP" to UFFD_API_BITS after implementing it */
+#define UFFD_API_BITS (UFFD_BIT_WRITE)
+#define UFFD_API_IOCTLS				\
+	((__u64)1 << _UFFDIO_REGISTER |		\
+	 (__u64)1 << _UFFDIO_UNREGISTER |	\
+	 (__u64)1 << _UFFDIO_API)
+#define UFFD_API_RANGE_IOCTLS			\
+	((__u64)1 << _UFFDIO_WAKE)
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
+
+/*
+ * Valid bits below PAGE_SHIFT in the userfault address read through
+ * the read() syscall.
+ */
+#define UFFD_BIT_WRITE	(1<<0)	/* this was a write fault, MISSING or WP */
+#define UFFD_BIT_WP	(1<<1)	/* handle_userfault() reason VM_UFFD_WP */
+#define UFFD_BITS	2	/* two above bits used for UFFD_BIT_* mask */
+
+struct uffdio_api {
+	/* userland asks for an API number */
+	__u64 api;
+
+	/* kernel answers below with the available features for the API */
+	__u64 bits;
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
+	__u64 mode;
+
+	/*
+	 * kernel answers which ioctl commands are available for the
+	 * range, keep at the end as the last 8 bytes aren't read.
+	 */
+	__u64 ioctls;
+};
+
+#endif /* _LINUX_USERFAULTFD_H */
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

