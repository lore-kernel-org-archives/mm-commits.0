From: akpm@linux-foundation.org
Subject: - nf_conntrack-fix-use-after-free-in-helper-destroy-callback.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:32 -0700
Message-ID: <200705212009.l4LK9VmO018774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965650AbXEUULZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, buga@buvoshetes.hu, mm-commits@vger.kernel.org


The patch titled
     nf_conntrack: fix use-after-free in helper destroy callback
has been removed from the -mm tree.  Its filename was
     nf_conntrack-fix-use-after-free-in-helper-destroy-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nf_conntrack: fix use-after-free in helper destroy callback
From: Patrick McHardy <kaber@trash.net>

When the helper module is removed for a master connection that has a
fulfilled expectation, but has already timed out and got removed from the
hash tables, nf_conntrack_helper_unregister can't find the master
connection to unset the helper, causing a use-after-free when the expected
connection is destroyed and releases the last reference to the master.

The helper destroy callback was introduced for the PPtP helper to clean up
expectations and expected connections when the master connection times out,
but doing this from the destroy_conntrack only works for unfulfilled
expectations since expected connections hold a reference to the master and
it is not destroyed.  Move the destroy callback to the timeout function,
which fixes both problems.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Cc: Gabor Burjan <buga@buvoshetes.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_conntrack_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN net/netfilter/nf_conntrack_core.c~nf_conntrack-fix-use-after-free-in-helper-destroy-callback net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c~nf_conntrack-fix-use-after-free-in-helper-destroy-callback
+++ a/net/netfilter/nf_conntrack_core.c
@@ -298,7 +298,6 @@ static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
-	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_l4proto *l4proto;
 	typeof(nf_conntrack_destroyed) destroyed;
 
@@ -309,9 +308,6 @@ destroy_conntrack(struct nf_conntrack *n
 	nf_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
-	if (help && help->helper && help->helper->destroy)
-		help->helper->destroy(ct);
-
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -353,6 +349,10 @@ destroy_conntrack(struct nf_conntrack *n
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
+	struct nf_conn_help *help = nfct_help(ct);
+
+	if (help && help->helper && help->helper->destroy)
+		help->helper->destroy(ct);
 
 	write_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
_

Patches currently in -mm which might be from kaber@trash.net are

origin.patch
networking-fix-sending-netlink-message-when-replace-route.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
