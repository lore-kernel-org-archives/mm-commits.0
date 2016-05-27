From: akpm@linux-foundation.org
Subject: + ocfs2-bump-up-o2cb-network-protocol-version.patch added to -mm
 tree
Date: Fri, 27 May 2016 12:49:07 -0700
Message-ID: <5748a4b3.EoQTv7Wj7RpZXbHa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbcE0TtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 15:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: bump up o2cb network protocol version
has been added to the -mm tree.  Its filename is
     ocfs2-bump-up-o2cb-network-protocol-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-bump-up-o2cb-network-protocol-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-bump-up-o2cb-network-protocol-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: bump up o2cb network protocol version

Two new messages are added to support negotiating hb timeout.  Stop nodes
frmo talking an old version to mount as they will cause the negotiation to
fail.

Link: http://lkml.kernel.org/r/1464231615-27939-1-git-send-email-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp_internal.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp_internal.h~ocfs2-bump-up-o2cb-network-protocol-version fs/ocfs2/cluster/tcp_internal.h
--- a/fs/ocfs2/cluster/tcp_internal.h~ocfs2-bump-up-o2cb-network-protocol-version
+++ a/fs/ocfs2/cluster/tcp_internal.h
@@ -44,6 +44,9 @@
  * version here in tcp_internal.h should not need to be bumped for
  * filesystem locking changes.
  *
+ * New in version 12
+ *	- Negotiate hb timeout when storage is down.
+ *
  * New in version 11
  * 	- Negotiation of filesystem locking in the dlm join.
  *
@@ -75,7 +78,7 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 11ULL
+#define O2NET_PROTOCOL_VERSION 12ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch
ocfs2-bump-up-o2cb-network-protocol-version.patch

