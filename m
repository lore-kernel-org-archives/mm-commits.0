From: akpm@linux-foundation.org
Subject: + w1-add-list-masters-w1-command.patch added to -mm tree
Date: Mon, 08 Dec 2008 13:59:02 -0800
Message-ID: <200812082159.mB8Lx3uS020033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYLHV7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 16:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net, frederik.deweerdt@xprog.eu, paul.alfille@gmail.com, randy.dunlap@oracle.com


The patch titled
     w1: add list masters w1 command
has been added to the -mm tree.  Its filename is
     w1-add-list-masters-w1-command.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: add list masters w1 command
From: Evgeniy Polyakov <zbr@ioremap.net>

This patch series introduces and extends several userspace commands
used with netlink protocol.

Touch block command allows to write data and return sampled data to
the userspace.

Extended search and alarm seach commands to return list of slave
devices found during given search.

List masters command allows to send all registered master IDs to the
userspace.

Great thanks to Paul Alfille (owfs) who
tested this implementation and wrote w1-to-network daemon
http://sourceforge.net/projects/w1repeater/ and 

Frederik Deweerdt and Randy Dunlap for review.



This patch:

Returns list of registered bus master devices.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Paul Alfille <paul.alfille@gmail.com>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_netlink.c |   56 ++++++++++++++++++++++++++++++++++++++
 drivers/w1/w1_netlink.h |    1 
 2 files changed, 57 insertions(+)

diff -puN drivers/w1/w1_netlink.c~w1-add-list-masters-w1-command drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-add-list-masters-w1-command
+++ a/drivers/w1/w1_netlink.c
@@ -128,6 +128,59 @@ static int w1_process_command_slave(stru
 	return err;
 }
 
+static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mcmd)
+{
+	struct w1_master *m;
+	struct cn_msg *cn;
+	struct w1_netlink_msg *w;
+	u32 *id;
+
+	if (mcmd->type != W1_LIST_MASTERS) {
+		printk(KERN_NOTICE "%s: msg: %x.%x, wrong type: %u, len: %u.\n",
+				__func__, msg->id.idx, msg->id.val, mcmd->type, mcmd->len);
+		return -EPROTO;
+	}
+
+	cn = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cn)
+		return -ENOMEM;
+
+	cn->id.idx = CN_W1_IDX;
+	cn->id.val = CN_W1_VAL;
+
+	cn->seq = msg->seq;
+	cn->ack = 1;
+	cn->len = sizeof(struct w1_netlink_msg);
+	w = (struct w1_netlink_msg *)(cn + 1);
+
+	w->type = W1_LIST_MASTERS;
+	w->reserved = 0;
+	w->len = 0;
+	id = (u32 *)(w + 1);
+
+	mutex_lock(&w1_mlock);
+	list_for_each_entry(m, &w1_masters, w1_master_entry) {
+		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
+			cn_netlink_send(cn, 0, GFP_KERNEL);
+			cn->ack++;
+			cn->len = sizeof(struct w1_netlink_msg);
+			w->len = 0;
+			id = (u32 *)(w + 1);
+		}
+
+		*id = m->id;
+		w->len += sizeof(*id);
+		cn->len += sizeof(*id);
+		id++;
+	}
+	cn->ack = 0;
+	cn_netlink_send(cn, 0, GFP_KERNEL);
+	mutex_unlock(&w1_mlock);
+
+	kfree(cn);
+	return 0;
+}
+
 static void w1_cn_callback(void *data)
 {
 	struct cn_msg *msg = data;
@@ -164,6 +217,9 @@ static void w1_cn_callback(void *data)
 			sl = w1_search_slave(&id);
 			if (sl)
 				dev = sl->master;
+		} else {
+			err = w1_process_command_root(msg, m);
+			goto out_cont;
 		}
 
 		if (!dev) {
diff -puN drivers/w1/w1_netlink.h~w1-add-list-masters-w1-command drivers/w1/w1_netlink.h
--- a/drivers/w1/w1_netlink.h~w1-add-list-masters-w1-command
+++ a/drivers/w1/w1_netlink.h
@@ -34,6 +34,7 @@ enum w1_netlink_message_types {
 	W1_MASTER_REMOVE,
 	W1_MASTER_CMD,
 	W1_SLAVE_CMD,
+	W1_LIST_MASTERS,
 };
 
 struct w1_netlink_msg
_

Patches currently in -mm which might be from zbr@ioremap.net are

mx2-add-w1-device-resources.patch
mx31-add-w1-platform_device-and-resources.patch
mx2-pcm038-add-1-wire-master-support.patch
pcm037-add-1wire-support.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch
w1-add-list-masters-w1-command.patch
w1-add-touch-block-command.patch
w1-list-slaves-commands.patch
w1-documentation-update.patch

