From: akpm@linux-foundation.org
Subject: +
 o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
 added to -mm tree
Date: Tue, 12 Aug 2014 14:44:22 -0700
Message-ID: <53ea8ab6.48o5+xkvfXxHe/iU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:43242 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaHLVoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 17:44:24 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1107411igd.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 14:44:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivas.eeda@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: o2dlm: fix NULL pointer dereference in o2dlm_blocking_ast_wrapper
has been added to the -mm tree.  Its filename is
     o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmast.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmast.c~o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper fs/ocfs2/dlm/dlmast.c
--- a/fs/ocfs2/dlm/dlmast.c~o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper
+++ a/fs/ocfs2/dlm/dlmast.c
@@ -385,8 +385,13 @@ int dlm_proxy_ast_handler(struct o2net_m
 		head = &res->granted;
 
 	list_for_each_entry(lock, head, list) {
-		if (lock->ml.cookie == cookie)
-			goto do_ast;
+		/* if lock is found but unlock is pending ignore the bast */
+		if (lock->ml.cookie == cookie) {
+			if (lock->unlock_pending)
+				break;
+			else
+				goto do_ast;
+		}
 	}
 
 	mlog(0, "Got %sast for unknown lock! cookie=%u:%llu, name=%.*s, "
_

Patches currently in -mm which might be from srinivas.eeda@oracle.com are

o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-o2net-dont-shutdown-connection-when-idle-timeout.patch
ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch
ocfs2-quorum-add-a-log-for-node-not-fenced.patch

