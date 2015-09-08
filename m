From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-rename-uffd_apibits-into-features.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:20 -0700
Message-ID: <55ef2324.VmJKxGaOd4/+xwRe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbbIHSE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: Rename uffd_api.bits into .features
has been removed from the -mm tree.  Its filename was
     userfaultfd-rename-uffd_apibits-into-features.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: userfaultfd: Rename uffd_api.bits into .features

This is (seems to be) the minimal thing that is required to unblock
standard uffd usage from the non-cooperative one.  Now more bits can be
added to the features field indicating e.g.  UFFD_FEATURE_FORK and others
needed for the latter use-case.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
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

 fs/userfaultfd.c                 |    4 ++--
 include/uapi/linux/userfaultfd.h |   12 +++++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-rename-uffd_apibits-into-features fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-rename-uffd_apibits-into-features
+++ a/fs/userfaultfd.c
@@ -884,7 +884,7 @@ static int userfaultfd_api(struct userfa
 		goto out;
 	}
 	/* careful not to leak info, we only read the first 8 bytes */
-	uffdio_api.bits = UFFD_API_BITS;
+	uffdio_api.features = UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
@@ -941,7 +941,7 @@ static void userfaultfd_show_fdinfo(stru
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, UFFD_API_BITS,
+		   pending, total, UFFD_API, UFFD_API_FEATURES,
 		   UFFD_API_IOCTLS|UFFD_API_RANGE_IOCTLS);
 }
 #endif
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-rename-uffd_apibits-into-features include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-rename-uffd_apibits-into-features
+++ a/include/uapi/linux/userfaultfd.h
@@ -12,8 +12,8 @@
 #include <linux/types.h>
 
 #define UFFD_API ((__u64)0xAA)
-/* FIXME: add "|UFFD_BIT_WP" to UFFD_API_BITS after implementing it */
-#define UFFD_API_BITS (UFFD_BIT_WRITE)
+/* FIXME: add "|UFFD_FEATURE_WP" to UFFD_API_FEATURES after implementing it */
+#define UFFD_API_FEATURES (UFFD_FEATURE_WRITE_BIT)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -53,12 +53,18 @@
 #define UFFD_BIT_WP	(1<<1)	/* handle_userfault() reason VM_UFFD_WP */
 #define UFFD_BITS	2	/* two above bits used for UFFD_BIT_* mask */
 
+/*
+ * Features reported in uffdio_api.features field
+ */
+#define UFFD_FEATURE_WRITE_BIT	(1<<0) /* Corresponds to UFFD_BIT_WRITE */
+#define UFFD_FEATURE_WP_BIT	(1<<1) /* Corresponds to UFFD_BIT_WP */
+
 struct uffdio_api {
 	/* userland asks for an API number */
 	__u64 api;
 
 	/* kernel answers below with the available features for the API */
-	__u64 bits;
+	__u64 features;
 	__u64 ioctls;
 };
 
_

Patches currently in -mm which might be from xemul@parallels.com are


