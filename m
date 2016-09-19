From: akpm@linux-foundation.org
Subject: [patch 19/20] Revert "ocfs2: bump up o2cb network protocol
 version"
Date: Mon, 19 Sep 2016 14:44:44 -0700
Message-ID: <57e05c4c.9F5zxIgjnVhw1S6q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbcISVoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 17:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Revert "ocfs2: bump up o2cb network protocol version"

This reverts commit 38b52efd218bf ("ocfs2: bump up o2cb network
protocol version").

This commit made rolling upgrade fail.  When one node is upgraded to new
version with this commit, the remaining nodes will fail to establish
connections to it, then the application like VMs on the remaining nodes
can't be live migrated to the upgraded one.  This will cause an outage. 
Since negotiate hb timeout behavior didn't change without this commit, so
revert it.

Fixes: 38b52efd218bf ("ocfs2: bump up o2cb network protocol version")
Link: http://lkml.kernel.org/r/1471396924-10375-1-git-send-email-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp_internal.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/cluster/tcp_internal.h~revert-ocfs2-bump-up-o2cb-network-protocol-version fs/ocfs2/cluster/tcp_internal.h
--- a/fs/ocfs2/cluster/tcp_internal.h~revert-ocfs2-bump-up-o2cb-network-protocol-version
+++ a/fs/ocfs2/cluster/tcp_internal.h
@@ -44,9 +44,6 @@
  * version here in tcp_internal.h should not need to be bumped for
  * filesystem locking changes.
  *
- * New in version 12
- *	- Negotiate hb timeout when storage is down.
- *
  * New in version 11
  * 	- Negotiation of filesystem locking in the dlm join.
  *
@@ -78,7 +75,7 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 12ULL
+#define O2NET_PROTOCOL_VERSION 11ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
_
