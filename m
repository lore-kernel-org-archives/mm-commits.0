From: akpm@osdl.org
Subject: + md-fix-potential-memalloc-deadlock-in-md.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:38:29 -0800
Message-ID: <200701250438.l0P4cTBd005961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46452 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211AbXAYEid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: fix potential memalloc deadlock in md
has been added to the -mm tree.  Its filename is
     md-fix-potential-memalloc-deadlock-in-md.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix potential memalloc deadlock in md
From: NeilBrown <neilb@suse.de>

If a GFP_KERNEL allocation is attempted in md while the mddev_lock is held,
it is possible for a deadlock to eventuate.

This happens if the array was marked 'clean', and the memalloc triggers a
write-out to the md device.

For the writeout to succeed, the array must be marked 'dirty', and that
requires getting the mddev_lock.

So, before attempting a GFP_KERNEL allocation while holding the lock, make
sure the array is marked 'dirty' (unless it is currently read-only).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c         |   29 +++++++++++++++++++++++++++++
 drivers/md/raid1.c      |    2 ++
 drivers/md/raid5.c      |    3 +++
 include/linux/raid/md.h |    2 +-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-fix-potential-memalloc-deadlock-in-md drivers/md/md.c
--- a/drivers/md/md.c~md-fix-potential-memalloc-deadlock-in-md
+++ a/drivers/md/md.c
@@ -3564,6 +3564,8 @@ static int get_bitmap_file(mddev_t * mdd
 	char *ptr, *buf = NULL;
 	int err = -ENOMEM;
 
+	md_allow_write(mddev);
+
 	file = kmalloc(sizeof(*file), GFP_KERNEL);
 	if (!file)
 		goto out;
@@ -5032,6 +5034,33 @@ void md_write_end(mddev_t *mddev)
 	}
 }
 
+/* md_allow_write(mddev)
+ * Calling this ensures that the array is marked 'active' so that writes
+ * may proceed without blocking.  It is important to call this before
+ * attempting a GFP_KERNEL allocation while holding the mddev lock.
+ * Must be called with mddev_lock held.
+ */
+void md_allow_write(mddev_t *mddev)
+{
+	if (!mddev->pers)
+		return;
+	if (mddev->ro)
+		return;
+
+	spin_lock_irq(&mddev->write_lock);
+	if (mddev->in_sync) {
+		mddev->in_sync = 0;
+		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+		if (mddev->safemode_delay &&
+		    mddev->safemode == 0)
+			mddev->safemode = 1;
+		spin_unlock_irq(&mddev->write_lock);
+		md_update_sb(mddev, 0);
+	} else
+		spin_unlock_irq(&mddev->write_lock);
+}
+EXPORT_SYMBOL_GPL(md_allow_write);
+
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 #define SYNC_MARKS	10
diff -puN drivers/md/raid1.c~md-fix-potential-memalloc-deadlock-in-md drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-fix-potential-memalloc-deadlock-in-md
+++ a/drivers/md/raid1.c
@@ -2104,6 +2104,8 @@ static int raid1_reshape(mddev_t *mddev)
 		return -EINVAL;
 	}
 
+	md_allow_write(mddev);
+
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
 	if (raid_disks < conf->raid_disks) {
diff -puN drivers/md/raid5.c~md-fix-potential-memalloc-deadlock-in-md drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-potential-memalloc-deadlock-in-md
+++ a/drivers/md/raid5.c
@@ -405,6 +405,8 @@ static int resize_stripes(raid5_conf_t *
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
 
+	md_allow_write(conf->mddev);
+
 	/* Step 1 */
 	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
 			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
@@ -3250,6 +3252,7 @@ raid5_store_stripe_cache_size(mddev_t *m
 		else
 			break;
 	}
+	md_allow_write(mddev);
 	while (new > conf->max_nr_stripes) {
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;
diff -puN include/linux/raid/md.h~md-fix-potential-memalloc-deadlock-in-md include/linux/raid/md.h
--- a/include/linux/raid/md.h~md-fix-potential-memalloc-deadlock-in-md
+++ a/include/linux/raid/md.h
@@ -94,7 +94,7 @@ extern int sync_page_io(struct block_dev
 			struct page *page, int rw);
 extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
-
+extern void md_allow_write(mddev_t *mddev);
 
 #endif /* CONFIG_MD */
 #endif 
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch
knfsd-fix-setting-of-acl-server-versions.patch
knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
md-update-email-address-and-status-for-md-in-maintainers.patch
md-make-repair-actually-work-for-raid1.patch
md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch
md-avoid-reading-past-the-end-of-a-bitmap-file.patch
knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd.patch
md-fix-potential-memalloc-deadlock-in-md.patch
nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
