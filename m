From: akpm@linux-foundation.org
Subject: - net-9p-trans_fdc-remove-unused-variable.patch removed from -mm tree
Date: Mon, 24 Mar 2008 12:24:58 -0700
Message-ID: <200803241924.m2OJOwE7021480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759400AbYCXTZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 15:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     net/9p/trans_fd.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     net-9p-trans_fdc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/9p/trans_fd.c: remove unused variable
From: Julia Lawall <julia@diku.dk>

The variable cb is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_fd.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN net/9p/trans_fd.c~net-9p-trans_fdc-remove-unused-variable net/9p/trans_fd.c
--- a/net/9p/trans_fd.c~net-9p-trans_fdc-remove-unused-variable
+++ a/net/9p/trans_fd.c
@@ -954,7 +954,6 @@ static void p9_mux_free_request(struct p
 
 static void p9_mux_flush_cb(struct p9_req *freq, void *a)
 {
-	p9_conn_req_callback cb;
 	int tag;
 	struct p9_conn *m;
 	struct p9_req *req, *rreq, *rptr;
@@ -965,7 +964,6 @@ static void p9_mux_flush_cb(struct p9_re
 		freq->tcall->params.tflush.oldtag);
 
 	spin_lock(&m->lock);
-	cb = NULL;
 	tag = freq->tcall->params.tflush.oldtag;
 	req = NULL;
 	list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-udf.patch
git-net.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

