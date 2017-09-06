From: akpm@linux-foundation.org
Subject: [patch 097/119] userfaultfd: provide pid in userfault msg
 - add feat union
Date: Wed, 06 Sep 2017 16:23:59 -0700
Message-ID: <20170906232359.SffPitwyO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51038 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbdIFXYB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.perevalov@samsung.com, aarcange@redhat.com, akpm@linux-foundation.org, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: provide pid in userfault msg - add feat union

No ABI change, but this will make it more explicit to software that ptid
is only available if requested by passing UFFD_FEATURE_THREAD_ID to
UFFDIO_API.  The fact it's a union will also self document it shouldn't be
taken for granted there's a tpid there.

Link: http://lkml.kernel.org/r/20170802165145.22628-7-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |    2 +-
 include/uapi/linux/userfaultfd.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-provide-pid-in-userfault-msg-add-feat-union fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-provide-pid-in-userfault-msg-add-feat-union
+++ a/fs/userfaultfd.c
@@ -204,7 +204,7 @@ static inline struct uffd_msg userfault_
 		 */
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
 	if (features & UFFD_FEATURE_THREAD_ID)
-		msg.arg.pagefault.ptid = task_pid_vnr(current);
+		msg.arg.pagefault.feat.ptid = task_pid_vnr(current);
 	return msg;
 }
 
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-provide-pid-in-userfault-msg-add-feat-union include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-provide-pid-in-userfault-msg-add-feat-union
+++ a/include/uapi/linux/userfaultfd.h
@@ -80,7 +80,9 @@ struct uffd_msg {
 		struct {
 			__u64	flags;
 			__u64	address;
-			__u32   ptid;
+			union {
+				__u32 ptid;
+			} feat;
 		} pagefault;
 
 		struct {
_
