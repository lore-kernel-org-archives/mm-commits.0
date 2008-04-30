From: akpm@linux-foundation.org
Subject: - ipc-add-definitions-of-ushort_max-and-others.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:23 -0700
Message-ID: <200804300544.m3U5iNdt029410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760599AbYD3GMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, Nadia.Derbey@bull.net, clameter@sgi.com, peifferp@gmail.com, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     ipc: add definitions of USHORT_MAX and others
has been removed from the -mm tree.  Its filename was
     ipc-add-definitions-of-ushort_max-and-others.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: add definitions of USHORT_MAX and others
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

Add definitions of USHORT_MAX and others into kernel.  ipc uses it and slub
implementation might also use it.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Pierre Peiffer" <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 +++
 ipc/msg.c              |   12 ++++++------
 ipc/util.c             |    4 ++--
 ipc/util.h             |    1 -
 4 files changed, 11 insertions(+), 9 deletions(-)

diff -puN include/linux/kernel.h~ipc-add-definitions-of-ushort_max-and-others include/linux/kernel.h
--- a/include/linux/kernel.h~ipc-add-definitions-of-ushort_max-and-others
+++ a/include/linux/kernel.h
@@ -20,6 +20,9 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+#define USHORT_MAX	((u16)(~0U))
+#define SHORT_MAX	((s16)(USHORT_MAX>>1))
+#define SHORT_MIN	(-SHORT_MAX - 1)
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
diff -puN ipc/msg.c~ipc-add-definitions-of-ushort_max-and-others ipc/msg.c
--- a/ipc/msg.c~ipc-add-definitions-of-ushort_max-and-others
+++ a/ipc/msg.c
@@ -346,19 +346,19 @@ copy_msqid_to_user(void __user *buf, str
 		out.msg_rtime		= in->msg_rtime;
 		out.msg_ctime		= in->msg_ctime;
 
-		if (in->msg_cbytes > USHRT_MAX)
-			out.msg_cbytes	= USHRT_MAX;
+		if (in->msg_cbytes > USHORT_MAX)
+			out.msg_cbytes	= USHORT_MAX;
 		else
 			out.msg_cbytes	= in->msg_cbytes;
 		out.msg_lcbytes		= in->msg_cbytes;
 
-		if (in->msg_qnum > USHRT_MAX)
-			out.msg_qnum	= USHRT_MAX;
+		if (in->msg_qnum > USHORT_MAX)
+			out.msg_qnum	= USHORT_MAX;
 		else
 			out.msg_qnum	= in->msg_qnum;
 
-		if (in->msg_qbytes > USHRT_MAX)
-			out.msg_qbytes	= USHRT_MAX;
+		if (in->msg_qbytes > USHORT_MAX)
+			out.msg_qbytes	= USHORT_MAX;
 		else
 			out.msg_qbytes	= in->msg_qbytes;
 		out.msg_lqbytes		= in->msg_qbytes;
diff -puN ipc/util.c~ipc-add-definitions-of-ushort_max-and-others ipc/util.c
--- a/ipc/util.c~ipc-add-definitions-of-ushort_max-and-others
+++ a/ipc/util.c
@@ -133,8 +133,8 @@ void ipc_init_ids(struct ipc_ids *ids)
 	ids->seq = 0;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
-		if(seq_limit > USHRT_MAX)
-			ids->seq_max = USHRT_MAX;
+		if (seq_limit > USHORT_MAX)
+			ids->seq_max = USHORT_MAX;
 		 else
 		 	ids->seq_max = seq_limit;
 	}
diff -puN ipc/util.h~ipc-add-definitions-of-ushort_max-and-others ipc/util.h
--- a/ipc/util.h~ipc-add-definitions-of-ushort_max-and-others
+++ a/ipc/util.h
@@ -12,7 +12,6 @@
 
 #include <linux/err.h>
 
-#define USHRT_MAX 0xffff
 #define SEQ_MULTIPLIER	(IPCMNI)
 
 void sem_init (void);
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

origin.patch
git-slub.patch

