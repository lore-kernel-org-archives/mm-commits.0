From: akpm@linux-foundation.org
Subject: + ocfs2-o2net-silence-uninitialized-variable-warning.patch added
 to -mm tree
Date: Fri, 23 Jan 2015 14:24:12 -0800
Message-ID: <54c2ca0c.NoJu5yQPwHZwfJLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbAWWYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jan 2015 17:24:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2net: silence uninitialized variable warning
has been added to the -mm tree.  Its filename is
     ocfs2-o2net-silence-uninitialized-variable-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2net-silence-uninitialized-variable-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2net-silence-uninitialized-variable-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: o2net: silence uninitialized variable warning

Smatch complains that, if o2net_tx_can_proceed() returns false, then "sc"
and "ret" are uninialized or maybe we are re-using the data from previous
iteration.  I do not know if we can hit this bug in real life but checking
the return value is harmless and we may as well silence the static checker
warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-silence-uninitialized-variable-warning fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-silence-uninitialized-variable-warning
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1016,7 +1016,8 @@ void o2net_fill_node_map(unsigned long *
 
 	memset(map, 0, bytes);
 	for (node = 0; node < O2NM_MAX_NODES; ++node) {
-		o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret);
+		if (!o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret))
+			continue;
 		if (!ret) {
 			set_bit(node, map);
 			sc_put(sc);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ocfs2-o2net-silence-uninitialized-variable-warning.patch
linux-next.patch

