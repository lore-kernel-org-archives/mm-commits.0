From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-fixed-potential-race-condition-checkpatch-fixes.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:11:48 -0700
Message-ID: <533dce94.Q6bhPMtC6Y+XFxy4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaDCVLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srikanth.srinivasan@freescale.com, shc_work@mail.ru, s.hauer@pengutronix.de, lee.jones@linaro.org, jkosina@suse.cz, iamjoonsoo.kim@lge.com, anemo@mba.ocn.ne.jp, alnovak@suse.cz, a.zummo@towertech.it, akpm@linux-foundation.org

Subject: [folded-merged] rtc-fixed-potential-race-condition-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,a.zummo@towertech.it,alnovak@suse.cz,anemo@mba.ocn.ne.jp,iamjoonsoo.kim@lge.com,jkosina@suse.cz,lee.jones@linaro.org,s.hauer@pengutronix.de,shc_work@mail.ru,srikanth.srinivasan@freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:11:48 -0700


The patch titled
     Subject: rtc-fixed-potential-race-condition-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-fixed-potential-race-condition-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-fixed-potential-race-condition.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-fixed-potential-race-condition-checkpatch-fixes

WARNING: line over 80 characters
#181: FILE: drivers/rtc/rtc-ds1307.c:969:
+			err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);

WARNING: line over 80 characters
#183: FILE: drivers/rtc/rtc-ds1307.c:971:
+				dev_err(&client->dev, "unable to create sysfs file: %s\n", ds1307->nvram->attr.name);

WARNING: line over 80 characters
#186: FILE: drivers/rtc/rtc-ds1307.c:974:
+				dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);

WARNING: line over 80 characters
#227: FILE: drivers/rtc/rtc-ds1511.c:515:
+	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &ds1511_rtc_ops,

WARNING: braces {} are not necessary for single statement blocks
#246: FILE: drivers/rtc/rtc-ds1511.c:535:
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n", ds1511_nvram_attr.attr.name);
+	}

WARNING: line over 80 characters
#247: FILE: drivers/rtc/rtc-ds1511.c:536:
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n", ds1511_nvram_attr.attr.name);

WARNING: braces {} are not necessary for single statement blocks
#291: FILE: drivers/rtc/rtc-ds1553.c:330:
+	if (ret) {
+		dev_err(&pdev->dev, "unable to create sysfs file: %s\n", ds1553_nvram_attr.attr.name);
+	}

WARNING: line over 80 characters
#292: FILE: drivers/rtc/rtc-ds1553.c:331:
+		dev_err(&pdev->dev, "unable to create sysfs file: %s\n", ds1553_nvram_attr.attr.name);

WARNING: braces {} are not necessary for single statement blocks
#322: FILE: drivers/rtc/rtc-ds1672.c:190:
+	if (err) {
+		dev_err(&client->dev, "Unable to create sysfs entry: %s\n", dev_attr_control.attr.name);
+	}

WARNING: line over 80 characters
#323: FILE: drivers/rtc/rtc-ds1672.c:191:
+		dev_err(&client->dev, "Unable to create sysfs entry: %s\n", dev_attr_control.attr.name);

WARNING: braces {} are not necessary for single statement blocks
#341: FILE: drivers/rtc/rtc-ds1742.c:207:
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n", pdata->nvram_attr.attr.name);
+	}

WARNING: line over 80 characters
#342: FILE: drivers/rtc/rtc-ds1742.c:208:
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n", pdata->nvram_attr.attr.name);

WARNING: braces {} are not necessary for single statement blocks
#386: FILE: drivers/rtc/rtc-test.c:111:
+	if (err) {
+		dev_err(&plat_dev->dev, "Unable to create sysfs entry: %s\n", dev_attr_irq.attr.name);
+	}

WARNING: line over 80 characters
#387: FILE: drivers/rtc/rtc-test.c:112:
+		dev_err(&plat_dev->dev, "Unable to create sysfs entry: %s\n", dev_attr_irq.attr.name);

WARNING: braces {} are not necessary for single statement blocks
#409: FILE: drivers/rtc/rtc-x1205.c:662:
+	if (err) {
+		dev_err(&client->dev, "Unable to create sysfs entries\n");
+	}

total: 0 errors, 15 warnings, 268 lines checked

./patches/rtc-fixed-potential-race-condition.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ales Novak <alnovak@suse.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Shiyan <shc_work@mail.ru>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Srikanth Srinivasan <srikanth.srinivasan@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   10 +++++++---
 drivers/rtc/rtc-ds1511.c |   10 +++++-----
 drivers/rtc/rtc-ds1553.c |    6 +++---
 drivers/rtc/rtc-ds1672.c |    6 +++---
 drivers/rtc/rtc-ds1742.c |    6 +++---
 drivers/rtc/rtc-test.c   |    6 +++---
 drivers/rtc/rtc-x1205.c  |    3 +--
 7 files changed, 25 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-fixed-potential-race-condition-checkpatch-fixes drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-fixed-potential-race-condition-checkpatch-fixes
+++ a/drivers/rtc/rtc-ds1307.c
@@ -966,12 +966,16 @@ read_rtc:
 			ds1307->nvram->size = chip->nvram_size;
 			ds1307->nvram_offset = chip->nvram_offset;
 
-			err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
+			err = sysfs_create_bin_file(&client->dev.kobj,
+						    ds1307->nvram);
 			if (err) {
-				dev_err(&client->dev, "unable to create sysfs file: %s\n", ds1307->nvram->attr.name);
+				dev_err(&client->dev,
+					"unable to create sysfs file: %s\n",
+					ds1307->nvram->attr.name);
 			} else {
 				set_bit(HAS_NVRAM, &ds1307->flags);
-				dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
+				dev_info(&client->dev, "%zu bytes nvram\n",
+					 ds1307->nvram->size);
 			}
 		}
 	}
diff -puN drivers/rtc/rtc-ds1511.c~rtc-fixed-potential-race-condition-checkpatch-fixes drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-fixed-potential-race-condition-checkpatch-fixes
+++ a/drivers/rtc/rtc-ds1511.c
@@ -512,8 +512,8 @@ static int ds1511_rtc_probe(struct platf
 	spin_lock_init(&pdata->lock);
 	platform_set_drvdata(pdev, pdata);
 
-	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &ds1511_rtc_ops,
-					THIS_MODULE);
+	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					      &ds1511_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pdata->rtc))
 		return PTR_ERR(pdata->rtc);
 
@@ -532,9 +532,9 @@ static int ds1511_rtc_probe(struct platf
 	}
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n", ds1511_nvram_attr.attr.name);
-	}
+	if (ret)
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n",
+			ds1511_nvram_attr.attr.name);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-ds1553.c~rtc-fixed-potential-race-condition-checkpatch-fixes drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-fixed-potential-race-condition-checkpatch-fixes
+++ a/drivers/rtc/rtc-ds1553.c
@@ -327,9 +327,9 @@ static int ds1553_rtc_probe(struct platf
 	}
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
-	if (ret) {
-		dev_err(&pdev->dev, "unable to create sysfs file: %s\n", ds1553_nvram_attr.attr.name);
-	}
+	if (ret)
+		dev_err(&pdev->dev, "unable to create sysfs file: %s\n",
+			ds1553_nvram_attr.attr.name);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-ds1672.c~rtc-fixed-potential-race-condition-checkpatch-fixes drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-fixed-potential-race-condition-checkpatch-fixes
+++ a/drivers/rtc/rtc-ds1672.c
@@ -187,9 +187,9 @@ static int ds1672_probe(struct i2c_clien
 
 	/* Register sysfs hooks */
 	err = device_create_file(&client->dev, &dev_attr_control);
-	if (err) {
-		dev_err(&client->dev, "Unable to create sysfs entry: %s\n", dev_attr_control.attr.name);
-	}
+	if (err)
+		dev_err(&client->dev, "Unable to create sysfs entry: %s\n",
+			dev_attr_control.attr.name);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-ds1742.c~rtc-fixed-potential-race-condition-checkpatch-fixes drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-fixed-potential-race-condition-checkpatch-fixes
+++ a/drivers/rtc/rtc-ds1742.c
@@ -204,9 +204,9 @@ static int ds1742_rtc_probe(struct platf
 		return PTR_ERR(rtc);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n", pdata->nvram_attr.attr.name);
-	}
+	if (ret)
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n",
+			pdata->nvram_attr.attr.name);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-test.c~rtc-fixed-potential-race-condition-checkpatch-fixes drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-fixed-potential-race-condition-checkpatch-fixes
+++ a/drivers/rtc/rtc-test.c
@@ -108,9 +108,9 @@ static int test_probe(struct platform_de
 	}
 
 	err = device_create_file(&plat_dev->dev, &dev_attr_irq);
-	if (err) {
-		dev_err(&plat_dev->dev, "Unable to create sysfs entry: %s\n", dev_attr_irq.attr.name);
-	}
+	if (err)
+		dev_err(&plat_dev->dev, "Unable to create sysfs entry: %s\n",
+			dev_attr_irq.attr.name);
 
 	platform_set_drvdata(plat_dev, rtc);
 
diff -puN drivers/rtc/rtc-x1205.c~rtc-fixed-potential-race-condition-checkpatch-fixes drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-fixed-potential-race-condition-checkpatch-fixes
+++ a/drivers/rtc/rtc-x1205.c
@@ -659,9 +659,8 @@ static int x1205_probe(struct i2c_client
 	}
 
 	err = x1205_sysfs_register(&client->dev);
-	if (err) {
+	if (err)
 		dev_err(&client->dev, "Unable to create sysfs entries\n");
-	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-process_vm_accessc-mark-function-as-static.patch
drop_caches-add-some-documentation-and-info-message.patch
sys_sysfs-add-config_sysfs_syscall.patch
kernel-groupsc-remove-return-value-of-set_groups.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
rtc-fixed-potential-race-condition.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

