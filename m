From: akpm@linux-foundation.org
Subject: + remove-duplicated-unlikely-in-is_err.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:40:18 -0800
Message-ID: <200803040940.m249eI0q001776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbYCDJzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:55:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hnakagawa@miraclelinux.com, James.Bottomley@HansenPartnership.com, a.zummo@towertech.it, aia21@cantab.net, cotte@de.ibm.com, davem@davemloft.net, david-b@pacbell.net, jeff@garzik.org, kaber@trash.net, lethal@linux-sh.org, mhalcrow@us.ibm.com, paul.clements@steeleye.com, perex@perex.cz, rpurdie@rpsys.net, tiwai@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Remove duplicated unlikely() in IS_ERR()
has been added to the -mm tree.  Its filename is
     remove-duplicated-unlikely-in-is_err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove duplicated unlikely() in IS_ERR()
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>

Some drivers have duplicated unlikely() macros.  IS_ERR() already has
unlikely() in itself.

This patch cleans up such pointless code.

Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c             |    2 +-
 drivers/leds/led-class.c        |    2 +-
 drivers/message/i2o/i2o_block.c |    2 +-
 drivers/net/myri10ge/myri10ge.c |    2 +-
 drivers/net/tg3.c               |    2 +-
 drivers/rtc/rtc-bfin.c          |    2 +-
 drivers/scsi/scsi_scan.c        |    2 +-
 fs/aio.c                        |    2 +-
 fs/ecryptfs/inode.c             |    2 +-
 fs/inotify_user.c               |    2 +-
 fs/ntfs/mft.c                   |    6 +++---
 kernel/auditfilter.c            |   10 +++++-----
 mm/filemap_xip.c                |    4 ++--
 net/core/dev.c                  |    2 +-
 net/ipv4/af_inet.c              |    2 +-
 net/ipv6/ipv6_sockglue.c        |    2 +-
 net/netfilter/nf_queue.c        |    2 +-
 net/xfrm/xfrm_output.c          |    2 +-
 sound/sh/aica.c                 |    2 +-
 19 files changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/block/nbd.c~remove-duplicated-unlikely-in-is_err drivers/block/nbd.c
--- a/drivers/block/nbd.c~remove-duplicated-unlikely-in-is_err
+++ a/drivers/block/nbd.c
@@ -331,7 +331,7 @@ static struct request *nbd_read_stat(str
 	}
 
 	req = nbd_find_request(lo, *(struct request **)reply.handle);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		result = PTR_ERR(req);
 		if (result != -ENOENT)
 			goto harderror;
diff -puN drivers/leds/led-class.c~remove-duplicated-unlikely-in-is_err drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~remove-duplicated-unlikely-in-is_err
+++ a/drivers/leds/led-class.c
@@ -95,7 +95,7 @@ int led_classdev_register(struct device 
 
 	led_cdev->dev = device_create(leds_class, parent, 0, "%s",
 					    led_cdev->name);
-	if (unlikely(IS_ERR(led_cdev->dev)))
+	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
 	dev_set_drvdata(led_cdev->dev, led_cdev);
diff -puN drivers/message/i2o/i2o_block.c~remove-duplicated-unlikely-in-is_err drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~remove-duplicated-unlikely-in-is_err
+++ a/drivers/message/i2o/i2o_block.c
@@ -371,7 +371,7 @@ static int i2o_block_prep_req_fn(struct 
 	/* connect the i2o_block_request to the request */
 	if (!req->special) {
 		ireq = i2o_block_request_alloc();
-		if (unlikely(IS_ERR(ireq))) {
+		if (IS_ERR(ireq)) {
 			osm_debug("unable to allocate i2o_block_request!\n");
 			return BLKPREP_DEFER;
 		}
diff -puN drivers/net/myri10ge/myri10ge.c~remove-duplicated-unlikely-in-is_err drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~remove-duplicated-unlikely-in-is_err
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -2437,7 +2437,7 @@ static int myri10ge_sw_tso(struct sk_buf
 	int status;
 
 	segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO6);
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		goto drop;
 
 	while (segs) {
diff -puN drivers/net/tg3.c~remove-duplicated-unlikely-in-is_err drivers/net/tg3.c
--- a/drivers/net/tg3.c~remove-duplicated-unlikely-in-is_err
+++ a/drivers/net/tg3.c
@@ -4279,7 +4279,7 @@ static int tg3_tso_bug(struct tg3 *tp, s
 	}
 
 	segs = skb_gso_segment(skb, tp->dev->features & ~NETIF_F_TSO);
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		goto tg3_tso_bug_end;
 
 	do {
diff -puN drivers/rtc/rtc-bfin.c~remove-duplicated-unlikely-in-is_err drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~remove-duplicated-unlikely-in-is_err
+++ a/drivers/rtc/rtc-bfin.c
@@ -419,7 +419,7 @@ static int __devinit bfin_rtc_probe(stru
 		return -ENOMEM;
 
 	rtc->rtc_dev = rtc_device_register(pdev->name, &pdev->dev, &bfin_rtc_ops, THIS_MODULE);
-	if (unlikely(IS_ERR(rtc))) {
+	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc->rtc_dev);
 		goto err;
 	}
diff -puN drivers/scsi/scsi_scan.c~remove-duplicated-unlikely-in-is_err drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~remove-duplicated-unlikely-in-is_err
+++ a/drivers/scsi/scsi_scan.c
@@ -1824,7 +1824,7 @@ void scsi_scan_host(struct Scsi_Host *sh
 	}
 
 	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		do_scan_async(data);
 }
 EXPORT_SYMBOL(scsi_scan_host);
diff -puN fs/aio.c~remove-duplicated-unlikely-in-is_err fs/aio.c
--- a/fs/aio.c~remove-duplicated-unlikely-in-is_err
+++ a/fs/aio.c
@@ -1585,7 +1585,7 @@ static int io_submit_one(struct kioctx *
 		 * event using the eventfd_signal() function.
 		 */
 		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
-		if (unlikely(IS_ERR(req->ki_eventfd))) {
+		if (IS_ERR(req->ki_eventfd)) {
 			ret = PTR_ERR(req->ki_eventfd);
 			goto out_put_req;
 		}
diff -puN fs/ecryptfs/inode.c~remove-duplicated-unlikely-in-is_err fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~remove-duplicated-unlikely-in-is_err
+++ a/fs/ecryptfs/inode.c
@@ -111,7 +111,7 @@ ecryptfs_do_create(struct inode *directo
 
 	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
-	if (unlikely(IS_ERR(lower_dir_dentry))) {
+	if (IS_ERR(lower_dir_dentry)) {
 		ecryptfs_printk(KERN_ERR, "Error locking directory of "
 				"dentry\n");
 		rc = PTR_ERR(lower_dir_dentry);
diff -puN fs/inotify_user.c~remove-duplicated-unlikely-in-is_err fs/inotify_user.c
--- a/fs/inotify_user.c~remove-duplicated-unlikely-in-is_err
+++ a/fs/inotify_user.c
@@ -598,7 +598,7 @@ asmlinkage long sys_inotify_init(void)
 	}
 
 	ih = inotify_init(&inotify_user_ops);
-	if (unlikely(IS_ERR(ih))) {
+	if (IS_ERR(ih)) {
 		ret = PTR_ERR(ih);
 		goto out_free_dev;
 	}
diff -puN fs/ntfs/mft.c~remove-duplicated-unlikely-in-is_err fs/ntfs/mft.c
--- a/fs/ntfs/mft.c~remove-duplicated-unlikely-in-is_err
+++ a/fs/ntfs/mft.c
@@ -1191,7 +1191,7 @@ static int ntfs_mft_bitmap_find_and_allo
 		if (size) {
 			page = ntfs_map_page(mftbmp_mapping,
 					ofs >> PAGE_CACHE_SHIFT);
-			if (unlikely(IS_ERR(page))) {
+			if (IS_ERR(page)) {
 				ntfs_error(vol->sb, "Failed to read mft "
 						"bitmap, aborting.");
 				return PTR_ERR(page);
@@ -2118,7 +2118,7 @@ static int ntfs_mft_record_format(const 
 	}
 	/* Read, map, and pin the page containing the mft record. */
 	page = ntfs_map_page(mft_vi->i_mapping, index);
-	if (unlikely(IS_ERR(page))) {
+	if (IS_ERR(page)) {
 		ntfs_error(vol->sb, "Failed to map page containing mft record "
 				"to format 0x%llx.", (long long)mft_no);
 		return PTR_ERR(page);
@@ -2519,7 +2519,7 @@ mft_rec_already_initialized:
 	ofs = (bit << vol->mft_record_size_bits) & ~PAGE_CACHE_MASK;
 	/* Read, map, and pin the page containing the mft record. */
 	page = ntfs_map_page(vol->mft_ino->i_mapping, index);
-	if (unlikely(IS_ERR(page))) {
+	if (IS_ERR(page)) {
 		ntfs_error(vol->sb, "Failed to map page containing allocated "
 				"mft record 0x%llx.", (long long)bit);
 		err = PTR_ERR(page);
diff -puN kernel/auditfilter.c~remove-duplicated-unlikely-in-is_err kernel/auditfilter.c
--- a/kernel/auditfilter.c~remove-duplicated-unlikely-in-is_err
+++ a/kernel/auditfilter.c
@@ -272,7 +272,7 @@ static int audit_to_watch(struct audit_k
 		return -EINVAL;
 
 	watch = audit_init_watch(path);
-	if (unlikely(IS_ERR(watch)))
+	if (IS_ERR(watch))
 		return PTR_ERR(watch);
 
 	audit_get_watch(watch);
@@ -848,7 +848,7 @@ static struct audit_watch *audit_dupe_wa
 		return ERR_PTR(-ENOMEM);
 
 	new = audit_init_watch(path);
-	if (unlikely(IS_ERR(new))) {
+	if (IS_ERR(new)) {
 		kfree(path);
 		goto out;
 	}
@@ -989,7 +989,7 @@ static void audit_update_watch(struct au
 			audit_set_auditable(current->audit_context);
 
 		nwatch = audit_dupe_watch(owatch);
-		if (unlikely(IS_ERR(nwatch))) {
+		if (IS_ERR(nwatch)) {
 			mutex_unlock(&audit_filter_mutex);
 			audit_panic("error updating watch, skipping");
 			return;
@@ -1004,7 +1004,7 @@ static void audit_update_watch(struct au
 			list_del_rcu(&oentry->list);
 
 			nentry = audit_dupe_rule(&oentry->rule, nwatch);
-			if (unlikely(IS_ERR(nentry)))
+			if (IS_ERR(nentry))
 				audit_panic("error updating watch, removing");
 			else {
 				int h = audit_hash_ino((u32)ino);
@@ -1785,7 +1785,7 @@ int audit_update_lsm_rules(void)
 			watch = entry->rule.watch;
 			tree = entry->rule.tree;
 			nentry = audit_dupe_rule(&entry->rule, watch);
-			if (unlikely(IS_ERR(nentry))) {
+			if (IS_ERR(nentry)) {
 				/* save the first error encountered for the
 				 * return value */
 				if (!err)
diff -puN mm/filemap_xip.c~remove-duplicated-unlikely-in-is_err mm/filemap_xip.c
--- a/mm/filemap_xip.c~remove-duplicated-unlikely-in-is_err
+++ a/mm/filemap_xip.c
@@ -90,7 +90,7 @@ do_xip_mapping_read(struct address_space
 			index*(PAGE_SIZE/512), 0);
 		if (!page)
 			goto no_xip_page;
-		if (unlikely(IS_ERR(page))) {
+		if (IS_ERR(page)) {
 			if (PTR_ERR(page) == -ENODATA) {
 				/* sparse */
 				page = ZERO_PAGE(0);
@@ -425,7 +425,7 @@ xip_truncate_page(struct address_space *
 					    index*(PAGE_SIZE/512), 0);
 	if (!page)
 		return -ENOMEM;
-	if (unlikely(IS_ERR(page))) {
+	if (IS_ERR(page)) {
 		if (PTR_ERR(page) == -ENODATA)
 			/* Hole? No need to truncate */
 			return 0;
diff -puN net/core/dev.c~remove-duplicated-unlikely-in-is_err net/core/dev.c
--- a/net/core/dev.c~remove-duplicated-unlikely-in-is_err
+++ a/net/core/dev.c
@@ -1524,7 +1524,7 @@ static int dev_gso_segment(struct sk_buf
 	if (!segs)
 		return 0;
 
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		return PTR_ERR(segs);
 
 	skb->next = segs;
diff -puN net/ipv4/af_inet.c~remove-duplicated-unlikely-in-is_err net/ipv4/af_inet.c
--- a/net/ipv4/af_inet.c~remove-duplicated-unlikely-in-is_err
+++ a/net/ipv4/af_inet.c
@@ -1215,7 +1215,7 @@ static struct sk_buff *inet_gso_segment(
 		segs = ops->gso_segment(skb, features);
 	rcu_read_unlock();
 
-	if (!segs || unlikely(IS_ERR(segs)))
+	if (!segs || IS_ERR(segs))
 		goto out;
 
 	skb = segs;
diff -puN net/ipv6/ipv6_sockglue.c~remove-duplicated-unlikely-in-is_err net/ipv6/ipv6_sockglue.c
--- a/net/ipv6/ipv6_sockglue.c~remove-duplicated-unlikely-in-is_err
+++ a/net/ipv6/ipv6_sockglue.c
@@ -149,7 +149,7 @@ static struct sk_buff *ipv6_gso_segment(
 	}
 	rcu_read_unlock();
 
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		goto out;
 
 	for (skb = segs; skb; skb = skb->next) {
diff -puN net/netfilter/nf_queue.c~remove-duplicated-unlikely-in-is_err net/netfilter/nf_queue.c
--- a/net/netfilter/nf_queue.c~remove-duplicated-unlikely-in-is_err
+++ a/net/netfilter/nf_queue.c
@@ -214,7 +214,7 @@ int nf_queue(struct sk_buff *skb,
 
 	segs = skb_gso_segment(skb, 0);
 	kfree_skb(skb);
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		return 1;
 
 	do {
diff -puN net/xfrm/xfrm_output.c~remove-duplicated-unlikely-in-is_err net/xfrm/xfrm_output.c
--- a/net/xfrm/xfrm_output.c~remove-duplicated-unlikely-in-is_err
+++ a/net/xfrm/xfrm_output.c
@@ -150,7 +150,7 @@ static int xfrm_output_gso(struct sk_buf
 
 	segs = skb_gso_segment(skb, 0);
 	kfree_skb(skb);
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		return PTR_ERR(segs);
 
 	do {
diff -puN sound/sh/aica.c~remove-duplicated-unlikely-in-is_err sound/sh/aica.c
--- a/sound/sh/aica.c~remove-duplicated-unlikely-in-is_err
+++ a/sound/sh/aica.c
@@ -663,7 +663,7 @@ static int __init aica_init(void)
 		return err;
 	pd = platform_device_register_simple(SND_AICA_DRIVER, -1,
 					     aica_memory_space, 2);
-	if (unlikely(IS_ERR(pd))) {
+	if (IS_ERR(pd)) {
 		platform_driver_unregister(&snd_aica_driver);
 		return PTR_ERR(pd);
 	}
_

Patches currently in -mm which might be from hnakagawa@miraclelinux.com are

remove-duplicated-unlikely-in-is_err.patch

