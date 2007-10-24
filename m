From: akpm@linux-foundation.org
Subject: + sunrpc-fix-rpc-debugging.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:35:50 -0700
Message-ID: <200710242335.l9ONZox4018253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbXJXXf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, davem@davemloft.net, ebiederm@xmission.com


The patch titled
     sunrpc: fix rpc debugging
has been added to the -mm tree.  Its filename is
     sunrpc-fix-rpc-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sunrpc: fix rpc debugging
From: J. Bruce Fields <bfields@citi.umich.edu>

Commit baa3a2a0d24ebcf1c451bec8e5bee3d3467f4cbb, by removing initialization
of the ctl_name field, broke this conditional, preventing the display of
rpc_tasks that you previously got when turning on rpc debugging.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/sysctl.c~sunrpc-fix-rpc-debugging net/sunrpc/sysctl.c
--- a/net/sunrpc/sysctl.c~sunrpc-fix-rpc-debugging
+++ a/net/sunrpc/sysctl.c
@@ -87,7 +87,7 @@ proc_dodebug(ctl_table *table, int write
 			left--, s++;
 		*(unsigned int *) table->data = value;
 		/* Display the RPC tasks on writing to rpc_debug */
-		if (table->ctl_name == CTL_RPCDEBUG) {
+		if (strcmp(table->procname, "rpc_debug") == 0) {
 			rpc_show_tasks();
 		}
 	} else {
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

sunrpc-fix-rpc-debugging.patch
reiser4.patch
