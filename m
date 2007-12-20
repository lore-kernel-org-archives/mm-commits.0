From: akpm@linux-foundation.org
Subject: - wireless-libertas-dont-cast-a-pointer-to-pointer-of-list_head.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:03 -0800
Message-ID: <200712202338.lBKNc3uZ018955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbXLTXtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:49:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, dcbw@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     wireless/libertas: don't cast a pointer to pointer of list_head
has been removed from the -mm tree.  Its filename was
     wireless-libertas-dont-cast-a-pointer-to-pointer-of-list_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: wireless/libertas: don't cast a pointer to pointer of list_head
From: Li Zefan <lizf@cn.fujitsu.com>

Don't cast struct foo * to struct list_head *, it's safe only when
the list member is the first member of struct foo.

Also don't cast struct list_head * to struct foo *.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/cmd.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/net/wireless/libertas/cmd.c~wireless-libertas-dont-cast-a-pointer-to-pointer-of-list_head drivers/net/wireless/libertas/cmd.c
--- a/drivers/net/wireless/libertas/cmd.c~wireless-libertas-dont-cast-a-pointer-to-pointer-of-list_head
+++ a/drivers/net/wireless/libertas/cmd.c
@@ -1016,11 +1016,10 @@ void lbs_queue_cmd(struct lbs_adapter *a
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
 	if (addtail) {
-		list_add_tail((struct list_head *)cmdnode,
-			      &adapter->cmdpendingq);
+		list_add_tail(&cmdnode->list, &adapter->cmdpendingq);
 		adapter->nr_cmd_pending++;
 	} else
-		list_add((struct list_head *)cmdnode, &adapter->cmdpendingq);
+		list_add(&cmdnode->list, &adapter->cmdpendingq);
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
@@ -1139,7 +1138,7 @@ void __lbs_cleanup_and_insert_cmd(struct
 		return;
 
 	cleanup_cmdnode(ptempcmd);
-	list_add_tail((struct list_head *)ptempcmd, &adapter->cmdfreeq);
+	list_add_tail(&ptempcmd->list, &adapter->cmdfreeq);
 }
 
 static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
@@ -1637,8 +1636,9 @@ struct cmd_ctrl_node *lbs_get_free_cmd_c
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
 	if (!list_empty(&adapter->cmdfreeq)) {
-		tempnode = (struct cmd_ctrl_node *)adapter->cmdfreeq.next;
-		list_del((struct list_head *)tempnode);
+		tempnode = list_first_entry(&adapter->cmdfreeq,
+					    struct cmd_ctrl_node, list);
+		list_del(&tempnode->list);
 	} else {
 		lbs_deb_host("GET_CMD_NODE: cmd_ctrl_node is not available\n");
 		tempnode = NULL;
@@ -1735,8 +1735,8 @@ int lbs_execute_next_command(struct lbs_
 	}
 
 	if (!list_empty(&adapter->cmdpendingq)) {
-		cmdnode = (struct cmd_ctrl_node *)
-		    adapter->cmdpendingq.next;
+		cmdnode = list_first_entry(&adapter->cmdpendingq,
+					   struct cmd_ctrl_node, list);
 	}
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
@@ -1800,7 +1800,7 @@ int lbs_execute_next_command(struct lbs_
 				    cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					list_del((struct list_head *)cmdnode);
+					list_del(&cmdnode->list);
 					lbs_cleanup_and_insert_cmd(priv, cmdnode);
 
 					ret = 0;
@@ -1811,7 +1811,7 @@ int lbs_execute_next_command(struct lbs_
 				    (adapter->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					list_del((struct list_head *)cmdnode);
+					list_del(&cmdnode->list);
 					lbs_cleanup_and_insert_cmd(priv, cmdnode);
 					adapter->needtowakeup = 1;
 
@@ -1823,7 +1823,7 @@ int lbs_execute_next_command(struct lbs_
 				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
 			}
 		}
-		list_del((struct list_head *)cmdnode);
+		list_del(&cmdnode->list);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmdptr->command));
 		DownloadcommandToStation(priv, cmdnode);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

git-powerpc.patch
git-drm.patch
git-hid.patch
git-net.patch
git-netdev-all.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
