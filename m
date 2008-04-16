From: akpm@linux-foundation.org
Subject: + afs-do-not-describe-debug-parameters-with-their-value.patch added to -mm tree
Date: Wed, 16 Apr 2008 11:21:46 -0700
Message-ID: <200804161821.m3GILkga029424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbYDPSWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 14:22:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, dhowells@redhat.com


The patch titled
     afs: do not describe debug parameters with their value
has been added to the -mm tree.  Its filename is
     afs-do-not-describe-debug-parameters-with-their-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: do not describe debug parameters with their value
From: Paul Bolle <pebolle@tiscali.nl>

Describe debug parameters with their names (and not their values).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/main.c        |    2 +-
 net/rxrpc/af_rxrpc.c |    2 +-
 net/rxrpc/rxkad.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/afs/main.c~afs-do-not-describe-debug-parameters-with-their-value fs/afs/main.c
--- a/fs/afs/main.c~afs-do-not-describe-debug-parameters-with-their-value
+++ a/fs/afs/main.c
@@ -22,7 +22,7 @@ MODULE_LICENSE("GPL");
 
 unsigned afs_debug;
 module_param_named(debug, afs_debug, uint, S_IWUSR | S_IRUGO);
-MODULE_PARM_DESC(afs_debug, "AFS debugging mask");
+MODULE_PARM_DESC(debug, "AFS debugging mask");
 
 static char *rootcell;
 
diff -puN net/rxrpc/af_rxrpc.c~afs-do-not-describe-debug-parameters-with-their-value net/rxrpc/af_rxrpc.c
--- a/net/rxrpc/af_rxrpc.c~afs-do-not-describe-debug-parameters-with-their-value
+++ a/net/rxrpc/af_rxrpc.c
@@ -27,7 +27,7 @@ MODULE_ALIAS_NETPROTO(PF_RXRPC);
 
 unsigned rxrpc_debug; // = RXRPC_DEBUG_KPROTO;
 module_param_named(debug, rxrpc_debug, uint, S_IWUSR | S_IRUGO);
-MODULE_PARM_DESC(rxrpc_debug, "RxRPC debugging mask");
+MODULE_PARM_DESC(debug, "RxRPC debugging mask");
 
 static int sysctl_rxrpc_max_qlen __read_mostly = 10;
 
diff -puN net/rxrpc/rxkad.c~afs-do-not-describe-debug-parameters-with-their-value net/rxrpc/rxkad.c
--- a/net/rxrpc/rxkad.c~afs-do-not-describe-debug-parameters-with-their-value
+++ a/net/rxrpc/rxkad.c
@@ -31,7 +31,7 @@
 
 unsigned rxrpc_debug;
 module_param_named(debug, rxrpc_debug, uint, S_IWUSR | S_IRUGO);
-MODULE_PARM_DESC(rxrpc_debug, "rxkad debugging mask");
+MODULE_PARM_DESC(debug, "rxkad debugging mask");
 
 struct rxkad_level1_hdr {
 	__be32	data_size;	/* true data size (excluding padding) */
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

origin.patch
afs-do-not-describe-debug-parameters-with-their-value.patch

