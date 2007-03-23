From: akpm@linux-foundation.org
Subject: + md-convert-compile-time-warnings-into-runtime-warnings.patch added to -mm tree
Date: Thu, 22 Mar 2007 23:54:21 -0800
Message-ID: <200703230754.l2N7sLxq009491@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422696AbXCWHyZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2007 03:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: convert compile time warnings into runtime warnings
has been added to the -mm tree.  Its filename is
     md-convert-compile-time-warnings-into-runtime-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: convert compile time warnings into runtime warnings
From: NeilBrown <neilb@suse.de>

...  still not sure why we need this ....

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c    |   41 +++++++++++++++++++++++++++++++----------
 drivers/md/raid5.c |   12 ++++++++++--
 2 files changed, 41 insertions(+), 12 deletions(-)

diff -puN drivers/md/md.c~md-convert-compile-time-warnings-into-runtime-warnings drivers/md/md.c
--- a/drivers/md/md.c~md-convert-compile-time-warnings-into-runtime-warnings
+++ a/drivers/md/md.c
@@ -1318,6 +1318,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 	char b[BDEVNAME_SIZE];
 	struct kobject *ko;
 	char *s;
+	int err;
 
 	if (rdev->mddev) {
 		MD_BUG();
@@ -1352,20 +1353,29 @@ static int bind_rdev_to_array(mdk_rdev_t
 	while ( (s=strchr(rdev->kobj.k_name, '/')) != NULL)
 		*s = '!';
 			
-	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
 
 	rdev->kobj.parent = &mddev->kobj;
-	kobject_add(&rdev->kobj);
+	if ((err = kobject_add(&rdev->kobj)))
+		goto fail;
 
 	if (rdev->bdev->bd_part)
 		ko = &rdev->bdev->bd_part->kobj;
 	else
 		ko = &rdev->bdev->bd_disk->kobj;
-	sysfs_create_link(&rdev->kobj, ko, "block");
+	if ((err = sysfs_create_link(&rdev->kobj, ko, "block"))) {
+		kobject_del(&rdev->kobj);
+		goto fail;
+	}
+	list_add(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev, mddev->gendisk);
 	return 0;
+
+ fail:
+	printk(KERN_WARNING "md: failed to register dev-%s for %s\n",
+	       b, mdname(mddev));
+	return err;
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -2966,7 +2976,9 @@ static struct kobject *md_probe(dev_t de
 	mddev->kobj.k_name = NULL;
 	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;
-	kobject_register(&mddev->kobj);
+	if (kobject_register(&mddev->kobj))
+		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
+		       disk->disk_name);
 	return NULL;
 }
 
@@ -3144,9 +3156,12 @@ static int do_md_run(mddev_t * mddev)
 		bitmap_destroy(mddev);
 		return err;
 	}
-	if (mddev->pers->sync_request)
-		sysfs_create_group(&mddev->kobj, &md_redundancy_group);
-	else if (mddev->ro == 2) /* auto-readonly not meaningful */
+	if (mddev->pers->sync_request) {
+		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
+			printk(KERN_WARNING
+			       "md: cannot register extra attributes for %s\n",
+			       mdname(mddev));
+	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
 		mddev->ro = 0;
 
  	atomic_set(&mddev->writes_pending,0);
@@ -3160,7 +3175,9 @@ static int do_md_run(mddev_t * mddev)
 		if (rdev->raid_disk >= 0) {
 			char nm[20];
 			sprintf(nm, "rd%d", rdev->raid_disk);
-			sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+			if (sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
+				printk("md: cannot register %s for %s\n",
+				       nm, mdname(mddev));
 		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -5386,8 +5403,12 @@ static int remove_and_add_spares(mddev_t
 				if (mddev->pers->hot_add_disk(mddev,rdev)) {
 					char nm[20];
 					sprintf(nm, "rd%d", rdev->raid_disk);
-					sysfs_create_link(&mddev->kobj,
-							  &rdev->kobj, nm);
+					if (sysfs_create_link(&mddev->kobj,
+							      &rdev->kobj, nm))
+						printk(KERN_WARNING
+						       "md: cannot register "
+						       "%s for %s\n",
+						       nm, mdname(mddev));
 					spares++;
 					md_new_event(mddev);
 				} else
diff -puN drivers/md/raid5.c~md-convert-compile-time-warnings-into-runtime-warnings drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-convert-compile-time-warnings-into-runtime-warnings
+++ a/drivers/md/raid5.c
@@ -3642,7 +3642,10 @@ static int run(mddev_t *mddev)
 	}
 
 	/* Ok, everything is just fine now */
-	sysfs_create_group(&mddev->kobj, &raid5_attrs_group);
+	if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
+		printk(KERN_WARNING
+		       "raid5: failed to create sysfs attributes for %s\n",
+		       mdname(mddev));
 
 	mddev->queue->unplug_fn = raid5_unplug_device;
 	mddev->queue->issue_flush_fn = raid5_issue_flush;
@@ -3951,7 +3954,12 @@ static int raid5_start_reshape(mddev_t *
 				added_devices++;
 				rdev->recovery_offset = 0;
 				sprintf(nm, "rd%d", rdev->raid_disk);
-				sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+				if (sysfs_create_link(&mddev->kobj,
+						      &rdev->kobj, nm))
+					printk(KERN_WARNING
+					       "raid5: failed to create "
+					       " link %s for %s\n",
+					       nm, mdname(mddev));
 			} else
 				break;
 		}
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch
knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace.patch
knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk.patch
knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch
md-allow-raid4-arrays-to-be-reshaped.patch
md-clear-the-congested_fn-when-stopping-a-raid5.patch
md-convert-compile-time-warnings-into-runtime-warnings.patch
net-sunrpc-svcsockc-fix-a-check.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
