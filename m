From: akpm@linux-foundation.org
Subject: [patch 07/19] ocfs2: bump up o2cb network protocol version
Date: Fri, 27 May 2016 14:27:16 -0700
Message-ID: <5748bbb4.6RGti2yvg8UA7UfV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbcE0V1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de

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
