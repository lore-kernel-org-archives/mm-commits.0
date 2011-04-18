From: akpm@linux-foundation.org
Subject: + w1-have-netlink-search-update-kernel-list.patch added to -mm tree
Date: Mon, 18 Apr 2011 15:17:30 -0700
Message-ID: <201104182217.p3IMHUfB028118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab1DRWST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 18:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: David@Fries.net, johnpol@2ka.mipt.ru


The patch titled
     w1: have netlink search update kernel list
has been added to the -mm tree.  Its filename is
     w1-have-netlink-search-update-kernel-list.patch

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
Subject: w1: have netlink search update kernel list
From: David Fries <David@Fries.net>

Reorganize so the netlink connector one wire search command will update
the kernel list of detected slave devices.  Otherwise, a newly detected
device is unusable because unless it's in the kernel list of known devices
any commands will result in ENODEV status.

Signed-off-by: David Fries <David@Fries.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c         |   12 +++++++++---
 drivers/w1/w1.h         |    4 +++-
 drivers/w1/w1_netlink.c |    5 ++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff -puN drivers/w1/w1.c~w1-have-netlink-search-update-kernel-list drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-have-netlink-search-update-kernel-list
+++ a/drivers/w1/w1.c
@@ -827,7 +827,7 @@ void w1_reconnect_slaves(struct w1_famil
 	mutex_unlock(&w1_mlock);
 }
 
-static void w1_slave_found(struct w1_master *dev, u64 rn)
+void w1_slave_found(struct w1_master *dev, u64 rn)
 {
 	struct w1_slave *sl;
 	struct w1_reg_num *tmp;
@@ -933,14 +933,15 @@ void w1_search(struct w1_master *dev, u8
 	}
 }
 
-void w1_search_process(struct w1_master *dev, u8 search_type)
+void w1_search_process_cb(struct w1_master *dev, u8 search_type,
+	w1_slave_found_callback cb)
 {
 	struct w1_slave *sl, *sln;
 
 	list_for_each_entry(sl, &dev->slist, w1_slave_entry)
 		clear_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
 
-	w1_search_devices(dev, search_type, w1_slave_found);
+	w1_search_devices(dev, search_type, cb);
 
 	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
 		if (!test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags) && !--sl->ttl)
@@ -953,6 +954,11 @@ void w1_search_process(struct w1_master 
 		dev->search_count--;
 }
 
+static void w1_search_process(struct w1_master *dev, u8 search_type)
+{
+	w1_search_process_cb(dev, search_type, w1_slave_found);
+}
+
 int w1_process(void *data)
 {
 	struct w1_master *dev = (struct w1_master *) data;
diff -puN drivers/w1/w1.h~w1-have-netlink-search-update-kernel-list drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-have-netlink-search-update-kernel-list
+++ a/drivers/w1/w1.h
@@ -194,7 +194,9 @@ void w1_destroy_master_attributes(struct
 void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
 void w1_search_devices(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
 struct w1_slave *w1_search_slave(struct w1_reg_num *id);
-void w1_search_process(struct w1_master *dev, u8 search_type);
+void w1_slave_found(struct w1_master *dev, u64 rn);
+void w1_search_process_cb(struct w1_master *dev, u8 search_type,
+	w1_slave_found_callback cb);
 struct w1_master *w1_search_master_id(u32 id);
 
 /* Disconnect and reconnect devices in the given family.  Used for finding
diff -puN drivers/w1/w1_netlink.c~w1-have-netlink-search-update-kernel-list drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-have-netlink-search-update-kernel-list
+++ a/drivers/w1/w1_netlink.c
@@ -55,6 +55,9 @@ static void w1_send_slave(struct w1_mast
 	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
 	int avail;
 
+	/* update kernel slave list */
+	w1_slave_found(dev, rn);
+
 	avail = dev->priv_size - cmd->len;
 
 	if (avail > 8) {
@@ -85,7 +88,7 @@ static int w1_process_search_command(str
 	dev->priv = msg;
 	dev->priv_size = avail;
 
-	w1_search_devices(dev, search_type, w1_send_slave);
+	w1_search_process_cb(dev, search_type, w1_send_slave);
 
 	msg->ack = 0;
 	cn_netlink_send(msg, 0, GFP_KERNEL);
_

Patches currently in -mm which might be from David@Fries.net are

w1-have-netlink-search-update-kernel-list.patch

