From: akpm@linux-foundation.org
Subject: - w1-allow-master-io-commands-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:23:04 -0800
Message-ID: <200901072323.n07NN4aN006565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbZAGXXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:23:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, paul.alfille@gmail.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     w1-allow-master-io-commands-fix
has been removed from the -mm tree.  Its filename was
     w1-allow-master-io-commands-fix.patch

This patch was dropped because it was folded into w1-allow-master-io-commands.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-allow-master-io-commands-fix
From: Andrew Morton <akpm@linux-foundation.org>

reindent switch statements.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Paul Alfille <paul.alfille@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_netlink.c |   54 +++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff -puN drivers/w1/w1_netlink.c~w1-allow-master-io-commands-fix drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-allow-master-io-commands-fix
+++ a/drivers/w1/w1_netlink.c
@@ -140,20 +140,20 @@ static int w1_process_command_io(struct 
 	int err = 0;
 
 	switch (cmd->cmd) {
-		case W1_CMD_TOUCH:
-			w1_touch_block(dev, cmd->data, cmd->len);
-			w1_send_read_reply(msg, hdr, cmd);
-			break;
-		case W1_CMD_READ:
-			w1_read_block(dev, cmd->data, cmd->len);
-			w1_send_read_reply(msg, hdr, cmd);
-			break;
-		case W1_CMD_WRITE:
-			w1_write_block(dev, cmd->data, cmd->len);
-			break;
-		default:
-			err = -1;
-			break;
+	case W1_CMD_TOUCH:
+		w1_touch_block(dev, cmd->data, cmd->len);
+		w1_send_read_reply(msg, hdr, cmd);
+		break;
+	case W1_CMD_READ:
+		w1_read_block(dev, cmd->data, cmd->len);
+		w1_send_read_reply(msg, hdr, cmd);
+		break;
+	case W1_CMD_WRITE:
+		w1_write_block(dev, cmd->data, cmd->len);
+		break;
+	default:
+		err = -1;
+		break;
 	}
 
 	return err;
@@ -187,20 +187,20 @@ static int w1_process_command_master(str
 	cmd->len = 0;
 
 	switch (cmd->cmd) {
-		case W1_CMD_SEARCH:
-		case W1_CMD_ALARM_SEARCH:
-			err = w1_process_search_command(dev, msg,
+	case W1_CMD_SEARCH:
+	case W1_CMD_ALARM_SEARCH:
+		err = w1_process_search_command(dev, msg,
 				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
-			break;
-		case W1_CMD_READ:
-		case W1_CMD_WRITE:
-		case W1_CMD_TOUCH:
-			err = w1_process_command_io(dev, msg, hdr, cmd);
-			break;
-		default:
-			cmd->res = EINVAL;
-			cn_netlink_send(msg, 0, GFP_KERNEL);
-			break;
+		break;
+	case W1_CMD_READ:
+	case W1_CMD_WRITE:
+	case W1_CMD_TOUCH:
+		err = w1_process_command_io(dev, msg, hdr, cmd);
+		break;
+	default:
+		cmd->res = EINVAL;
+		cn_netlink_send(msg, 0, GFP_KERNEL);
+		break;
 	}
 
 	kfree(msg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
w1-allow-master-io-commands.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

