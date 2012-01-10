From: akpm@linux-foundation.org
Subject: [folded] ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:55:05 -0800
Message-ID: <20120110235506.0FAB51E0473@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:43817 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2AJXzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:55:06 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so22249ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:55:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@google.com, amwang@redhat.com, dledford@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@google.com>
Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes

Cc: Amerigo Wang <amwang@redhat.com>

ERROR: Macros with complex values should be enclosed in parenthesis
#87: FILE: include/linux/ipc_namespace.h:126:
+#define DFLT_MSGSIZEMAX		1024*1024

ERROR: Macros with complex values should be enclosed in parenthesis
#88: FILE: include/linux/ipc_namespace.h:127:
+#define HARD_MSGSIZEMAX	     16*1024*1024

total: 2 errors, 0 warnings, 75 lines checked

./patches/ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes
+++ a/include/linux/ipc_namespace.h
@@ -123,8 +123,8 @@ extern int mq_init_ns(struct ipc_namespa
 #define HARD_MSGMAX		    65536
 #define MIN_MSGSIZEMAX		      128
 #define DFLT_MSGSIZE		     8192U
-#define DFLT_MSGSIZEMAX		1024*1024
-#define HARD_MSGSIZEMAX	     16*1024*1024
+#define DFLT_MSGSIZEMAX		(1024*1024)
+#define HARD_MSGSIZEMAX	     (16*1024*1024)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
_

Patches currently in -mm which might be from akpm@google.com are

linux-next.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

