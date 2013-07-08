From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:23:35 -0700
Message-ID: <51db11b7.yYdmlnyy0bf6Erwl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3GHTXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tm@tao.ma, sunil.mushran@gmail.com, srinivas.eeda@oracle.com, n_iwamatsu@jp.fujitsu.com, mfasheh@suse.com, jlbec@evilplan.org, gurudas.pai@oracle.com, jeff.liu@oracle.com

Subject: [merged] ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch removed from -mm tree
To: jeff.liu@oracle.com,gurudas.pai@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,n_iwamatsu@jp.fujitsu.com,srinivas.eeda@oracle.com,sunil.mushran@gmail.com,tm@tao.ma,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:35 -0700


The patch titled
     Subject: ocfs2: adjust switch_case syntax at o2net_state_change()
has been removed from the -mm tree.  Its filename was
     ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: adjust switch_case syntax at o2net_state_change()

Adjust switch..case syntax at o2net_state_change to meet the kernel coding
standard.

s/printk/pr_info/.

[akpm@linux-foundation.org: revert pr_foo() change]
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Gurudas Pai <gurudas.pai@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Cc: Srinivas Eeeda <srinivas.eeda@oracle.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Tao Ma <tm@tao.ma>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-adjust-switch_case-syntax-at-o2net_state_change fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-adjust-switch_case-syntax-at-o2net_state_change
+++ a/fs/ocfs2/cluster/tcp.c
@@ -633,19 +633,19 @@ static void o2net_state_change(struct so
 	state_change = sc->sc_state_change;
 
 	switch(sk->sk_state) {
-		/* ignore connecting sockets as they make progress */
-		case TCP_SYN_SENT:
-		case TCP_SYN_RECV:
-			break;
-		case TCP_ESTABLISHED:
-			o2net_sc_queue_work(sc, &sc->sc_connect_work);
-			break;
-		default:
-			printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
-			      " shutdown, state %d\n",
-			      SC_NODEF_ARGS(sc), sk->sk_state);
-			o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
-			break;
+	/* ignore connecting sockets as they make progress */
+	case TCP_SYN_SENT:
+	case TCP_SYN_RECV:
+		break;
+	case TCP_ESTABLISHED:
+		o2net_sc_queue_work(sc, &sc->sc_connect_work);
+		break;
+	default:
+		printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
+			" shutdown, state %d\n",
+			SC_NODEF_ARGS(sc), sk->sk_state);
+		o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
+		break;
 	}
 out:
 	read_unlock(&sk->sk_callback_lock);
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
linux-next.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

