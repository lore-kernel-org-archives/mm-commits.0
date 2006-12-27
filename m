From: akpm@osdl.org
Subject: + pktcdvd-cleanup.patch added to -mm tree
Date: Wed, 27 Dec 2006 13:13:45 -0800
Message-ID: <200612272113.kBRLDjYE020342@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35223 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbWL0VOA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 16:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balagi@justmail.de, petero2@telia.com


The patch titled
     pktcdvd: cleanup
has been added to the -mm tree.  Its filename is
     pktcdvd-cleanup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pktcdvd: cleanup
From: "Thomas Maier" <balagi@justmail.de>

- update documentation

- use clear_bdi_congested/set_bdi_congested functions directly instead of
  old wrappers

- removed DECLARE_BUF_AS_STRING macro

Signed-off-by: Thomas Maier <balagi@justmail.de>
Cc: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/ABI/testing/debugfs-pktcdvd     |    5 +--
 Documentation/ABI/testing/sysfs-class-pktcdvd |    2 -
 Documentation/cdrom/packet-writing.txt        |    2 -
 drivers/block/pktcdvd.c                       |   26 ++++------------
 4 files changed, 11 insertions(+), 24 deletions(-)

diff -puN Documentation/ABI/testing/debugfs-pktcdvd~pktcdvd-cleanup Documentation/ABI/testing/debugfs-pktcdvd
--- a/Documentation/ABI/testing/debugfs-pktcdvd~pktcdvd-cleanup
+++ a/Documentation/ABI/testing/debugfs-pktcdvd
@@ -1,6 +1,6 @@
 What:           /debug/pktcdvd/pktcdvd[0-7]
 Date:           Oct. 2006
-KernelVersion:  2.6.19
+KernelVersion:  2.6.20
 Contact:        Thomas Maier <balagi@justmail.de>
 Description:
 
@@ -11,8 +11,7 @@ The pktcdvd module (packet writing drive
 these files in debugfs:
 
 /debug/pktcdvd/pktcdvd[0-7]/
-    info            (0444) Lots of human readable driver
-                           statistics and infos. Multiple lines!
+    info            (0444) Lots of driver statistics and infos.
 
 Example:
 -------
diff -puN Documentation/ABI/testing/sysfs-class-pktcdvd~pktcdvd-cleanup Documentation/ABI/testing/sysfs-class-pktcdvd
--- a/Documentation/ABI/testing/sysfs-class-pktcdvd~pktcdvd-cleanup
+++ a/Documentation/ABI/testing/sysfs-class-pktcdvd
@@ -1,6 +1,6 @@
 What:           /sys/class/pktcdvd/
 Date:           Oct. 2006
-KernelVersion:  2.6.19
+KernelVersion:  2.6.20
 Contact:        Thomas Maier <balagi@justmail.de>
 Description:
 
diff -puN Documentation/cdrom/packet-writing.txt~pktcdvd-cleanup Documentation/cdrom/packet-writing.txt
--- a/Documentation/cdrom/packet-writing.txt~pktcdvd-cleanup
+++ a/Documentation/cdrom/packet-writing.txt
@@ -93,7 +93,7 @@ Notes
 Using the pktcdvd sysfs interface
 ---------------------------------
 
-Since Linux 2.6.19, the pktcdvd module has a sysfs interface
+Since Linux 2.6.20, the pktcdvd module has a sysfs interface
 and can be controlled by it. For example the "pktcdvd" tool uses
 this interface. (see http://people.freenet.de/BalaGi#pktcdvd )
 
diff -puN drivers/block/pktcdvd.c~pktcdvd-cleanup drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-cleanup
+++ a/drivers/block/pktcdvd.c
@@ -190,15 +190,6 @@ static struct attribute *kobj_pkt_attrs_
 	NULL
 };
 
-/* declares a char buffer[64] _dbuf, copies data from
- * _b with length _l into it and ensures that _dbuf ends
- * with a \0 character.
- */
-#define DECLARE_BUF_AS_STRING(_dbuf, _b, _l) \
-	char _dbuf[64]; int dlen = (_l) < 0 ? 0 : (_l); \
-	if (dlen >= sizeof(_dbuf)) dlen = sizeof(_dbuf)-1; \
-	memcpy(_dbuf, _b, dlen); _dbuf[dlen] = 0
-
 static ssize_t kobj_pkt_show(struct kobject *kobj,
 			struct attribute *attr, char *data)
 {
@@ -264,9 +255,8 @@ static ssize_t kobj_pkt_store(struct kob
 {
 	struct pktcdvd_device *pd = to_pktcdvdkobj(kobj)->pd;
 	int val;
-	DECLARE_BUF_AS_STRING(dbuf, data, len); /* ensure sscanf scans a string */
 
-	if (strcmp(attr->name, "reset") == 0 && dlen > 0) {
+	if (strcmp(attr->name, "reset") == 0 && len > 0) {
 		pd->stats.pkt_started = 0;
 		pd->stats.pkt_ended = 0;
 		pd->stats.secs_w = 0;
@@ -274,7 +264,7 @@ static ssize_t kobj_pkt_store(struct kob
 		pd->stats.secs_r = 0;
 
 	} else if (strcmp(attr->name, "congestion_off") == 0
-		   && sscanf(dbuf, "%d", &val) == 1) {
+		   && sscanf(data, "%d", &val) == 1) {
 		spin_lock(&pd->lock);
 		pd->write_congestion_off = val;
 		init_write_congestion_marks(&pd->write_congestion_off,
@@ -282,7 +272,7 @@ static ssize_t kobj_pkt_store(struct kob
 		spin_unlock(&pd->lock);
 
 	} else if (strcmp(attr->name, "congestion_on") == 0
-		   && sscanf(dbuf, "%d", &val) == 1) {
+		   && sscanf(data, "%d", &val) == 1) {
 		spin_lock(&pd->lock);
 		pd->write_congestion_on = val;
 		init_write_congestion_marks(&pd->write_congestion_off,
@@ -369,8 +359,7 @@ static ssize_t class_pktcdvd_store_add(s
 					size_t count)
 {
 	unsigned int major, minor;
-	DECLARE_BUF_AS_STRING(dbuf, buf, count);
-	if (sscanf(dbuf, "%u:%u", &major, &minor) == 2) {
+	if (sscanf(buf, "%u:%u", &major, &minor) == 2) {
 		pkt_setup_dev(MKDEV(major, minor), NULL);
 		return count;
 	}
@@ -381,8 +370,7 @@ static ssize_t class_pktcdvd_store_remov
 					size_t count)
 {
 	unsigned int major, minor;
-	DECLARE_BUF_AS_STRING(dbuf, buf, count);
-	if (sscanf(dbuf, "%u:%u", &major, &minor) == 2) {
+	if (sscanf(buf, "%u:%u", &major, &minor) == 2) {
 		pkt_remove_dev(MKDEV(major, minor));
 		return count;
 	}
@@ -1390,7 +1378,7 @@ try_next_bio:
 	 		&& pd->bio_queue_size <= pd->write_congestion_off);
 	spin_unlock(&pd->lock);
 	if (wakeup)
-		blk_clear_queue_congested(pd->disk->queue, WRITE);
+		clear_bdi_congested(&pd->disk->queue->backing_dev_info, WRITE);
 
 	pkt->sleep_time = max(PACKET_WAIT_TIME, 1);
 	pkt_set_state(pkt, PACKET_WAITING_STATE);
@@ -2611,7 +2599,7 @@ static int pkt_make_request(request_queu
 	spin_lock(&pd->lock);
 	if (pd->write_congestion_on > 0
 	    && pd->bio_queue_size >= pd->write_congestion_on) {
-		blk_set_queue_congested(q, WRITE);
+		set_bdi_congested(&q->backing_dev_info, WRITE);
 		do {
 			spin_unlock(&pd->lock);
 			congestion_wait(WRITE, HZ);
_

Patches currently in -mm which might be from balagi@justmail.de are

pktcdvd-cleanup.patch

