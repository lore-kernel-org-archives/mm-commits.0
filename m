From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:28:56 -0700
Message-ID: <55ea1b28./pDVNhaCfMqQUeQe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch

This patch was dropped because it was folded into userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix

use __packed

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix
+++ a/include/uapi/linux/userfaultfd.h
@@ -11,6 +11,8 @@
 
 #include <linux/types.h>
 
+#include <linux/compiler.h>
+
 #define UFFD_API ((__u64)0xAA)
 /*
  * After implementing the respective features it will become:
@@ -70,7 +72,7 @@ struct uffd_msg {
 			__u64	reserved3;
 		} reserved;
 	} arg;
-} __attribute__((packed));
+} __packed;
 
 /*
  * Start at 0x12 and not at 0 to be more strict against bugs.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-activate-syscall-fix-2.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

