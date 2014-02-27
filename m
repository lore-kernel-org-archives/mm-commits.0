From: akpm@linux-foundation.org
Subject: + rtc-fix-chardev-initialization-races.patch added to -mm tree
Date: Wed, 26 Feb 2014 16:35:06 -0800
Message-ID: <530e883a.q3tHau+hXH5aztDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaB0AfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 19:35:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, iamjoonsoo.kim@lge.com, a.zummo@towertech.it, alnovak@suse.cz

Subject: + rtc-fix-chardev-initialization-races.patch added to -mm tree
To: alnovak@suse.cz,a.zummo@towertech.it,iamjoonsoo.kim@lge.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 16:35:06 -0800


The patch titled
     Subject: rtc: fix chardev initialization races
has been added to the -mm tree.  Its filename is
     rtc-fix-chardev-initialization-races.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-fix-chardev-initialization-races.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-fix-chardev-initialization-races.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ales Novak <alnovak@suse.cz>
Subject: rtc: fix chardev initialization races

In many rtc modules, the chardevice file in rtc module probe is being
created prematurely.  If the probe fails after the chardevice file has
been created (e.g.  after rtc_device_register), it's possible for a
program to open() it, which subsequently can cause memory corruption.

The race looks like that (thanks Jiri):

CPU0:                                CPU1:
sys_load_module()
 do_init_module()
  do_one_initcall()
   cmos_do_probe()
    rtc_device_register()
     __register_chrdev()
     cdev->owner = struct module*
                                     open("/dev/rtc0")
    rtc_device_unregister()
  module_put()
  free_module()
   module_free(mod->module_core)
   /* struct module *module is now
      freed */
                                      chrdev_open()
                                       spin_lock(cdev_lock)
                                       cdev_get()
                                        try_module_get()
                                         module_is_live()
                                         /* dereferences already
                                            freed struct module* */

This patch is proposing a solution, splitting the function
{devm_,}rtc_device_register into {devm_,}rtc_device_register{_fs,}.  The
{devm_}rtc_device_register_fs which is creating the files, should be
called after it is clear that the probe will pass.  It will set the
RTC_DEV_FILES_EXIST into rtc_device->flags.

In case of probe not passing, the rtc_device_unregister will try to delete
the files only if RTC_DEV_FILES_EXIST is set in rtc_device->flags.

Signed-off-by: Ales Novak <alnovak@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c        |   47 ++++++++++++++++++++++++-----------
 drivers/rtc/rtc-ab8500.c   |    1 
 drivers/rtc/rtc-at91sam9.c |    2 +
 drivers/rtc/rtc-bfin.c     |    2 +
 drivers/rtc/rtc-cmos.c     |    2 +
 drivers/rtc/rtc-davinci.c  |    2 +
 drivers/rtc/rtc-ds1305.c   |    2 +
 drivers/rtc/rtc-ds1307.c   |    2 +
 drivers/rtc/rtc-ds1511.c   |    2 +
 drivers/rtc/rtc-ds1553.c   |    2 +
 drivers/rtc/rtc-ds1672.c   |    2 +
 drivers/rtc/rtc-ds1742.c   |    2 +
 drivers/rtc/rtc-ds3232.c   |    2 +
 drivers/rtc/rtc-ep93xx.c   |    2 +
 drivers/rtc/rtc-isl1208.c  |    2 +
 drivers/rtc/rtc-jz4740.c   |    2 +
 drivers/rtc/rtc-m41t80.c   |    2 +
 drivers/rtc/rtc-m48t59.c   |    2 +
 drivers/rtc/rtc-max8998.c  |    1 
 drivers/rtc/rtc-mrst.c     |    2 +
 drivers/rtc/rtc-nuc900.c   |    2 +
 drivers/rtc/rtc-omap.c     |    2 +
 drivers/rtc/rtc-pcap.c     |    2 +
 drivers/rtc/rtc-pcf2123.c  |    1 
 drivers/rtc/rtc-pl031.c    |    2 +
 drivers/rtc/rtc-r9701.c    |    2 +
 drivers/rtc/rtc-rp5c01.c   |    2 +
 drivers/rtc/rtc-rs5c372.c  |    2 +
 drivers/rtc/rtc-rv3029c2.c |    1 
 drivers/rtc/rtc-rx8025.c   |    2 +
 drivers/rtc/rtc-spear.c    |    2 +
 drivers/rtc/rtc-stk17ta8.c |    2 +
 drivers/rtc/rtc-stmp3xxx.c |    2 +
 drivers/rtc/rtc-tegra.c    |    2 +
 drivers/rtc/rtc-test.c     |    2 +
 drivers/rtc/rtc-twl.c      |    3 ++
 drivers/rtc/rtc-tx4939.c   |    3 ++
 drivers/rtc/rtc-vr41xx.c   |    2 +
 drivers/rtc/rtc-vt8500.c   |    2 +
 drivers/rtc/rtc-x1205.c    |    2 +
 include/linux/rtc.h        |    7 ++++-
 41 files changed, 115 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/class.c~rtc-fix-chardev-initialization-races drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/class.c
@@ -230,13 +230,6 @@ struct rtc_device *rtc_device_register(c
 		goto exit_kfree;
 	}
 
-	rtc_dev_add_device(rtc);
-	rtc_sysfs_add_device(rtc);
-	rtc_proc_add_device(rtc);
-
-	dev_info(dev, "rtc core: registered %s as %s\n",
-			rtc->name, dev_name(&rtc->dev));
-
 	return rtc;
 
 exit_kfree:
@@ -252,6 +245,21 @@ exit:
 }
 EXPORT_SYMBOL_GPL(rtc_device_register);
 
+/**
+ * rtc_device_register_fs - creates dev+sysfs+proc files
+ * for rtc device
+ */
+void rtc_device_register_fs(struct device *dev, struct rtc_device *rtc)
+{
+	rtc_dev_add_device(rtc);
+	rtc_sysfs_add_device(rtc);
+	rtc_proc_add_device(rtc);
+
+	set_bit(RTC_DEV_FILES_EXIST, &rtc->flags);
+	dev_info(dev, "rtc core: registered %s as %s\n",
+			rtc->name, dev_name(&rtc->dev));
+}
+EXPORT_SYMBOL_GPL(rtc_device_register_fs);
 
 /**
  * rtc_device_unregister - removes the previously registered RTC class device
@@ -262,13 +270,15 @@ void rtc_device_unregister(struct rtc_de
 {
 	if (get_device(&rtc->dev) != NULL) {
 		mutex_lock(&rtc->ops_lock);
-		/* remove innards of this RTC, then disable it, before
-		 * letting any rtc_class_open() users access it again
-		 */
-		rtc_sysfs_del_device(rtc);
-		rtc_dev_del_device(rtc);
-		rtc_proc_del_device(rtc);
-		device_unregister(&rtc->dev);
+		if (test_and_clear_bit(RTC_DEV_FILES_EXIST, &rtc->flags)) {
+			/* remove innards of this RTC, then disable it, before
+			 * letting any rtc_class_open() users access it again
+			 */
+			rtc_sysfs_del_device(rtc);
+			rtc_dev_del_device(rtc);
+			rtc_proc_del_device(rtc);
+			device_unregister(&rtc->dev);
+		}
 		rtc->ops = NULL;
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
@@ -328,6 +338,15 @@ struct rtc_device *devm_rtc_device_regis
 EXPORT_SYMBOL_GPL(devm_rtc_device_register);
 
 /**
+ * devm_rtc_device_register_fs - create proc&dev&sys files for the rtc device
+ */
+void devm_rtc_device_register_fs(struct device *dev, struct rtc_device *rtc)
+{
+	rtc_device_register_fs(dev, rtc);
+}
+EXPORT_SYMBOL_GPL(devm_rtc_device_register_fs);
+
+/**
  * devm_rtc_device_unregister - resource managed devm_rtc_device_unregister()
  * @dev: the device to unregister
  * @rtc: the RTC class device to unregister
diff -puN drivers/rtc/rtc-ab8500.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ab8500.c
@@ -503,6 +503,7 @@ static int ab8500_rtc_probe(struct platf
 		dev_err(&pdev->dev, "sysfs RTC failed to register\n");
 		return err;
 	}
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-at91sam9.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -369,6 +369,8 @@ static int at91_rtc_probe(struct platfor
 		dev_warn(&pdev->dev, "%s: SET TIME!\n",
 				dev_name(&rtc->rtcdev->dev));
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-bfin.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-bfin.c
@@ -380,6 +380,8 @@ static int bfin_rtc_probe(struct platfor
 	bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc->rtc_dev);
+
 	return 0;
 
 err:
diff -puN drivers/rtc/rtc-cmos.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-cmos.c
@@ -784,6 +784,8 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
+	rtc_device_register_fs(dev, cmos_rtc.rtc);
+
 	dev_info(dev, "%s%s, %zd bytes nvram%s\n",
 		!is_valid_irq(rtc_irq) ? "no alarms" :
 			cmos_rtc.mon_alrm ? "alarms up to one year" :
diff -puN drivers/rtc/rtc-davinci.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-davinci.c
@@ -531,6 +531,8 @@ static int __init davinci_rtc_probe(stru
 
 	device_init_wakeup(&pdev->dev, 0);
 
+	devm_rtc_device_register_fs(&pdev->dev, davinci_rtc->rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-ds1305.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ds1305.c
@@ -771,6 +771,8 @@ static int ds1305_probe(struct spi_devic
 		return status;
 	}
 
+	devm_rtc_device_register_fs(&spi->dev, ds1305->rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-ds1307.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ds1307.c
@@ -1153,6 +1153,8 @@ read_rtc:
 		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
 
+	devm_rtc_device_register_fs(&client->dev, ds1307->rtc);
+
 	return 0;
 
 err_irq:
diff -puN drivers/rtc/rtc-ds1511.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ds1511.c
@@ -534,6 +534,8 @@ static int ds1511_rtc_probe(struct platf
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff -puN drivers/rtc/rtc-ds1553.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ds1553.c
@@ -329,6 +329,8 @@ static int ds1553_rtc_probe(struct platf
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff -puN drivers/rtc/rtc-ds1672.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ds1672.c
@@ -189,6 +189,8 @@ static int ds1672_probe(struct i2c_clien
 	if (err)
 		goto exit_devreg;
 
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 
  exit_devreg:
diff -puN drivers/rtc/rtc-ds1742.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ds1742.c
@@ -205,6 +205,8 @@ static int ds1742_rtc_probe(struct platf
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff -puN drivers/rtc/rtc-ds3232.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ds3232.c
@@ -427,6 +427,8 @@ static int ds3232_probe(struct i2c_clien
 		}
 	}
 
+	devm_rtc_device_register_fs(&client->dev, ds3232->rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-ep93xx.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -156,6 +156,8 @@ static int ep93xx_rtc_probe(struct platf
 	if (err)
 		goto exit;
 
+	devm_rtc_device_register_fs(&pdev->dev, ep93xx_rtc->rtc);
+
 	return 0;
 
 exit:
diff -puN drivers/rtc/rtc-isl1208.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-isl1208.c
@@ -681,6 +681,8 @@ isl1208_probe(struct i2c_client *client,
 	if (rc)
 		return rc;
 
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-jz4740.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-jz4740.c
@@ -263,6 +263,8 @@ static int jz4740_rtc_probe(struct platf
 		}
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc->rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-m41t80.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-m41t80.c
@@ -707,6 +707,8 @@ static int m41t80_probe(struct i2c_clien
 		}
 	}
 #endif
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 
 st_err:
diff -puN drivers/rtc/rtc-m48t59.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-m48t59.c
@@ -489,6 +489,8 @@ static int m48t59_rtc_probe(struct platf
 	if (ret)
 		return ret;
 
+	devm_rtc_device_register_fs(&pdev->dev, m48t59->rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-max8998.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-max8998.c
--- a/drivers/rtc/rtc-max8998.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-max8998.c
@@ -300,6 +300,7 @@ no_irq:
 		dev_warn(&pdev->dev, "LP3974 with RTC REGERR option."
 				" RTC updates will be extremely slow.\n");
 	}
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-mrst.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-mrst.c
@@ -374,6 +374,7 @@ static int vrtc_mrst_do_probe(struct dev
 			goto cleanup1;
 		}
 	}
+	rtc_device_register_fs(dev, mrst_rtc.rtc);
 	dev_dbg(dev, "initialised\n");
 	return 0;
 
@@ -403,6 +404,7 @@ static void rtc_mrst_do_remove(struct de
 	if (mrst->irq)
 		free_irq(mrst->irq, mrst->rtc);
 
+	rtc_device_unregister_fs(mrst->rtc);
 	rtc_device_unregister(mrst->rtc);
 	mrst->rtc = NULL;
 
diff -puN drivers/rtc/rtc-nuc900.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-nuc900.c
@@ -256,6 +256,8 @@ static int __init nuc900_rtc_probe(struc
 		return -EBUSY;
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, nuc900_rtc->rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-omap.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-omap.c
@@ -449,6 +449,8 @@ static int __init omap_rtc_probe(struct
 	if (reg != new_ctrl)
 		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return 0;
 
 fail0:
diff -puN drivers/rtc/rtc-pcap.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-pcap.c
--- a/drivers/rtc/rtc-pcap.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-pcap.c
@@ -172,6 +172,8 @@ static int __init pcap_rtc_probe(struct
 	if (err)
 		return err;
 
+	devm_rtc_device_register_fs(&pdev->dev, pcap_rtc->rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-pcf2123.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -313,6 +313,7 @@ static int pcf2123_probe(struct spi_devi
 			goto sysfs_exit;
 		}
 	}
+	devm_rtc_device_register_fs(&spi->dev, rtc);
 
 	return 0;
 
diff -puN drivers/rtc/rtc-pl031.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-pl031.c
@@ -306,6 +306,7 @@ static int pl031_remove(struct amba_devi
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);
 
 	free_irq(adev->irq[0], ldata);
+	rtc_device_unregister_fs(ldata->rtc);
 	rtc_device_unregister(ldata->rtc);
 	iounmap(ldata->base);
 	kfree(ldata);
@@ -384,6 +385,7 @@ static int pl031_probe(struct amba_devic
 		goto out_no_irq;
 	}
 
+	rtc_device_register_fs(&adev->dev, ldata->rtc);
 	return 0;
 
 out_no_irq:
diff -puN drivers/rtc/rtc-r9701.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-r9701.c
@@ -161,6 +161,8 @@ static int r9701_probe(struct spi_device
 
 	spi_set_drvdata(spi, rtc);
 
+	devm_rtc_device_register_fs(&spi->dev, rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-rp5c01.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-rp5c01.c
--- a/drivers/rtc/rtc-rp5c01.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-rp5c01.c
@@ -259,6 +259,8 @@ static int __init rp5c01_rtc_probe(struc
 	if (error)
 		return error;
 
+	devm_rtc_device_register_fs(&dev->dev, rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-rs5c372.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -668,6 +668,8 @@ static int rs5c372_probe(struct i2c_clie
 	if (err)
 		goto exit;
 
+	devm_rtc_device_register_fs(&client->dev, rs5c372->rtc);
+
 	return 0;
 
 exit:
diff -puN drivers/rtc/rtc-rv3029c2.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-rv3029c2.c
--- a/drivers/rtc/rtc-rv3029c2.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-rv3029c2.c
@@ -408,6 +408,7 @@ static int rv3029c2_probe(struct i2c_cli
 		dev_err(&client->dev, "reading status failed\n");
 		return rc;
 	}
+	devm_rtc_device_register_fs(&client->dev, rtc);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-rx8025.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-rx8025.c
--- a/drivers/rtc/rtc-rx8025.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-rx8025.c
@@ -596,6 +596,8 @@ static int rx8025_probe(struct i2c_clien
 	if (err)
 		goto errout_irq;
 
+	devm_rtc_device_register_fs(&client->dev, rx8025->rtc);
+
 	return 0;
 
 errout_irq:
diff -puN drivers/rtc/rtc-spear.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-spear.c
@@ -412,6 +412,8 @@ static int spear_rtc_probe(struct platfo
 	if (!device_can_wakeup(&pdev->dev))
 		device_init_wakeup(&pdev->dev, 1);
 
+	devm_rtc_device_register_fs(&pdev->dev, config->rtc);
+
 	return 0;
 
 err_disable_clock:
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -338,6 +338,8 @@ static int stk17ta8_rtc_probe(struct pla
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, pdata->rtc);
+
 	return ret;
 }
 
diff -puN drivers/rtc/rtc-stmp3xxx.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -304,6 +304,8 @@ static int stmp3xxx_rtc_probe(struct pla
 		return err;
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc_data->rtc);
+
 	stmp3xxx_wdt_register(pdev);
 	return 0;
 }
diff -puN drivers/rtc/rtc-tegra.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-tegra.c
@@ -365,6 +365,8 @@ static int __init tegra_rtc_probe(struct
 
 	dev_notice(&pdev->dev, "Tegra internal Real Time Clock\n");
 
+	devm_rtc_device_register_fs(&pdev->dev, info->rtc_dev);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-test.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-test.c
@@ -114,6 +114,8 @@ static int test_probe(struct platform_de
 
 	platform_set_drvdata(plat_dev, rtc);
 
+	devm_rtc_device_register_fs(&plat_dev->dev, rtc);
+
 	return 0;
 
 err:
diff -puN drivers/rtc/rtc-twl.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-twl.c
@@ -544,6 +544,9 @@ static int twl_rtc_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, rtc);
+
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-tx4939.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-tx4939.c
@@ -269,6 +269,9 @@ static int __init tx4939_rtc_probe(struc
 	pdata->rtc = rtc;
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
 
+	if (!ret)
+		devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -355,6 +355,8 @@ static int rtc_probe(struct platform_dev
 	disable_irq(aie_irq);
 	disable_irq(pie_irq);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	dev_info(&pdev->dev, "Real Time Clock of NEC VR4100 series\n");
 
 	return 0;
diff -puN drivers/rtc/rtc-vt8500.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-vt8500.c
@@ -251,6 +251,8 @@ static int vt8500_rtc_probe(struct platf
 		goto err_return;
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, vt8500_rtc->rtc);
+
 	return 0;
 
 err_return:
diff -puN drivers/rtc/rtc-x1205.c~rtc-fix-chardev-initialization-races drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-fix-chardev-initialization-races
+++ a/drivers/rtc/rtc-x1205.c
@@ -662,6 +662,8 @@ static int x1205_probe(struct i2c_client
 	if (err)
 		return err;
 
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 }
 
diff -puN include/linux/rtc.h~rtc-fix-chardev-initialization-races include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-fix-chardev-initialization-races
+++ a/include/linux/rtc.h
@@ -81,7 +81,9 @@ struct rtc_timer {
 
 
 /* flags */
-#define RTC_DEV_BUSY 0
+#define RTC_DEV_BUSY        0
+/* flag indicating the files for the device have been created */
+#define RTC_DEV_FILES_EXIST 1
 
 struct rtc_device
 {
@@ -133,10 +135,13 @@ extern struct rtc_device *rtc_device_reg
 					struct device *dev,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
+
+extern void rtc_device_register_fs(struct device *dev, struct rtc_device *rtc);
 extern struct rtc_device *devm_rtc_device_register(struct device *dev,
 					const char *name,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
+extern void devm_rtc_device_register_fs(struct device *dev, struct rtc_device *rtc);
 extern void rtc_device_unregister(struct rtc_device *rtc);
 extern void devm_rtc_device_unregister(struct device *dev,
 					struct rtc_device *rtc);
_

Patches currently in -mm which might be from alnovak@suse.cz are

rtc-fix-chardev-initialization-races.patch

