From: akpm@linux-foundation.org
Subject: - sunrpc-fix-rpc-debugging.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:23 -0700
Message-ID: <200710301806.l9UI6NYR020515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbXJ3SHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, davem@davemloft.net, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sunrpc: fix rpc debugging
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-rpc-debugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sunrpc: fix rpc debugging
From: J. Bruce Fields <bfields@citi.umich.edu>

Commit baa3a2a0d24ebcf1c451bec8e5bee3d3467f4cbb, by removing initialization
of the ctl_name field, broke this conditional, preventing the display of
rpc_tasks that you previously got when turning on rpc debugging.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/sunrpc/sysctl.c~sunrpc-fix-rpc-debugging net/sunrpc/sysctl.c
--- a/net/sunrpc/sysctl.c~sunrpc-fix-rpc-debugging
+++ a/net/sunrpc/sysctl.c
@@ -87,9 +87,8 @@ proc_dodebug(ctl_table *table, int write
 			left--, s++;
 		*(unsigned int *) table->data = value;
 		/* Display the RPC tasks on writing to rpc_debug */
-		if (table->ctl_name == CTL_RPCDEBUG) {
+		if (strcmp(table->procname, "rpc_debug") == 0)
 			rpc_show_tasks();
-		}
 	} else {
 		if (!access_ok(VERIFY_WRITE, buffer, left))
 			return -EFAULT;
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
reiser4.patch
