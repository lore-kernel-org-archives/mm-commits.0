From: akpm@linux-foundation.org
Subject: [merged] net-9p-fix-crash-due-to-bad-mount-parameters.patch removed from -mm tree
Date: Sun, 05 Jul 2009 11:36:03 -0700
Message-ID: <200907051836.n65Ia3Zx004965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbZGESgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 5 Jul 2009 14:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adkulkar@umail.iu.edu, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     net/9p: fix crash due to bad mount parameters
has been removed from the -mm tree.  Its filename was
     net-9p-fix-crash-due-to-bad-mount-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/9p: fix crash due to bad mount parameters
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>

It is not safe to use match_int without checking the token type returned
by match_token (especially when the token type returned is Opt_err and
args is empty).  Fix it.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_fd.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN net/9p/trans_fd.c~net-9p-fix-crash-due-to-bad-mount-parameters net/9p/trans_fd.c
--- a/net/9p/trans_fd.c~net-9p-fix-crash-due-to-bad-mount-parameters
+++ a/net/9p/trans_fd.c
@@ -735,12 +735,14 @@ static int parse_opts(char *params, stru
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
-		r = match_int(&args[0], &option);
-		if (r < 0) {
-			P9_DPRINTK(P9_DEBUG_ERROR,
-			 "integer field, but no integer?\n");
-			ret = r;
-			continue;
+		if (token != Opt_err) {
+			r = match_int(&args[0], &option);
+			if (r < 0) {
+				P9_DPRINTK(P9_DEBUG_ERROR,
+				"integer field, but no integer?\n");
+				ret = r;
+				continue;
+			}
 		}
 		switch (token) {
 		case Opt_port:
_

Patches currently in -mm which might be from adkulkar@umail.iu.edu are

linux-next.patch
9p-fix-incorrect-parameters-to-v9fs_file_readn.patch

