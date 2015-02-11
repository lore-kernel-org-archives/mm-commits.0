From: akpm@linux-foundation.org
Subject: [merged]
 o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:30 -0800
Message-ID: <54dbb9ca.4gWOlFqoCIdqEaDE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbBKUVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivas.eeda@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: o2dlm: fix NULL pointer dereference in o2dlm_blocking_ast_wrapper
has been removed from the -mm tree.  Its filename was
     o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Srinivas Eeda <srinivas.eeda@oracle.com>
Subject: o2dlm: fix NULL pointer dereference in o2dlm_blocking_ast_wrapper

A tiny race between BAST and unlock message causes the NULL dereference.

A node sends an unlock request to master and receives a response.  Before
processing the response it receives a BAST from the master.  Since both
requests are processed by different threads it creates a race.  While the
BAST is being processed, lock can get freed by unlock code.

This patch makes bast to return immediately if lock is found but unlock is
pending.  The code should handle this race.  We also have to fix master
node to skip sending BAST after receiving unlock message.

Below is the crash stack

BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
IP: [<ffffffffa015e023>] o2dlm_blocking_ast_wrapper+0xd/0x16
[<ffffffffa034e3db>] dlm_do_local_bast+0x8e/0x97 [ocfs2_dlm]
[<ffffffffa034f366>] dlm_proxy_ast_handler+0x838/0x87e [ocfs2_dlm]
[<ffffffffa0308abe>] o2net_process_message+0x395/0x5b8 [ocfs2_nodemanager]
[<ffffffffa030aac8>] o2net_rx_until_empty+0x762/0x90d [ocfs2_nodemanager]
[<ffffffff81071802>] worker_thread+0x14d/0x1ed

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmast.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmast.c~o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper fs/ocfs2/dlm/dlmast.c
--- a/fs/ocfs2/dlm/dlmast.c~o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper
+++ a/fs/ocfs2/dlm/dlmast.c
@@ -385,8 +385,12 @@ int dlm_proxy_ast_handler(struct o2net_m
 		head = &res->granted;
 
 	list_for_each_entry(lock, head, list) {
-		if (lock->ml.cookie == cookie)
+		/* if lock is found but unlock is pending ignore the bast */
+		if (lock->ml.cookie == cookie) {
+			if (lock->unlock_pending)
+				break;
 			goto do_ast;
+		}
 	}
 
 	mlog(0, "Got %sast for unknown lock! cookie=%u:%llu, name=%.*s, "
_

Patches currently in -mm which might be from srinivas.eeda@oracle.com are

origin.patch

