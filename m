From: akpm@linux-foundation.org
Subject: + firmware-loader-use-statically-initialized-data-attribute.patch added to -mm tree
Date: Fri, 19 Mar 2010 13:34:07 -0700
Message-ID: <201003192034.o2JKY7bm010875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab0CSUen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 16:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, Valdis.Kletnieks@vt.edu, dtor@mail.ru, greg@kroah.com, peterz@infradead.org, tglx@linutronix.de, w.sang@pengutronix.de


The patch titled
     firmware loader: use statically initialized data attribute
has been added to the -mm tree.  Its filename is
     firmware-loader-use-statically-initialized-data-attribute.patch

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
Subject: firmware loader: use statically initialized data attribute
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

There is no reason why we are using a template for binary attribute and
copying it into per-firmware data before registering.  Using the original
works as well and gets rid of the following lockdep complaint:

 platform microcode: firmware: requesting intel-ucode/06-0f-0b
 BUG: key ffff88011371be70 not in .data!
 ------------[ cut here ]------------
 WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x125/0x140()
 Hardware name: Latitude D630
 Modules linked in: ...
 Pid: 738, comm: modprobe Tainted: P           2.6.34-rc1 #237
 Call Trace:
  [<ffffffff81048fb6>] warn_slowpath_common+0x76/0xb0
  [<ffffffff81048fff>] warn_slowpath_null+0xf/0x20
  [<ffffffff8107c915>] lockdep_init_map+0x125/0x140
  [<ffffffff8118485a>] sysfs_add_file_mode+0x6a/0xc0
  [<ffffffff811848bc>] sysfs_add_file+0xc/0x10
  [<ffffffff811870e1>] sysfs_create_bin_file+0x21/0x30
  [<ffffffff8130dff1>] fw_setup_device+0x81/0x120
  [<ffffffff8130e14f>] _request_firmware+0xbf/0x270
  [<ffffffff8130e38e>] request_firmware+0xe/0x10
  [<ffffffffa0064be1>] request_microcode_fw+0x61/0xa0 [microcode]
  [<ffffffffa00643b8>] microcode_init_cpu+0xb8/0xd0 [microcode]
  [<ffffffffa0064426>] mc_sysdev_add+0x56/0x70 [microcode]
  [<ffffffff813032ae>] sysdev_driver_register+0x9e/0x130
  [<ffffffffa006a000>] ? microcode_init+0x0/0x12a [microcode]
  [<ffffffffa006a0bd>] microcode_init+0xbd/0x12a [microcode]
  [<ffffffff810001d7>] do_one_initcall+0x37/0x190
  [<ffffffff8108d178>] sys_init_module+0xd8/0x250
  [<ffffffff81002fab>] system_call_fastpath+0x16/0x1b
 ---[ end trace 93c9f72439beee7f ]---

(akpm: that lockdep complaint will also be fixed by "lockdep: add
novalidate class for dev->mutex conversion").

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/base/firmware_class.c~firmware-loader-use-statically-initialized-data-attribute drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-loader-use-statically-initialized-data-attribute
+++ a/drivers/base/firmware_class.c
@@ -41,7 +41,6 @@ static DEFINE_MUTEX(fw_lock);
 struct firmware_priv {
 	char *fw_id;
 	struct completion completion;
-	struct bin_attribute attr_data;
 	struct firmware *fw;
 	unsigned long status;
 	struct page **pages;
@@ -345,8 +344,8 @@ out:
 	return retval;
 }
 
-static struct bin_attribute firmware_attr_data_tmpl = {
-	.attr = {.name = "data", .mode = 0644},
+static struct bin_attribute firmware_attr_data = {
+	.attr = { .name = "data", .mode = 0644 },
 	.size = 0,
 	.read = firmware_data_read,
 	.write = firmware_data_write,
@@ -391,7 +390,6 @@ static int fw_register_device(struct dev
 	}
 
 	init_completion(&fw_priv->completion);
-	fw_priv->attr_data = firmware_attr_data_tmpl;
 	fw_priv->fw_id = kstrdup(fw_name, GFP_KERNEL);
 	if (!fw_priv->fw_id) {
 		dev_err(device, "%s: Firmware name allocation failed\n",
@@ -444,7 +442,7 @@ static int fw_setup_device(struct firmwa
 
 	fw_priv->fw = fw;
 	sysfs_bin_attr_init(&fw_priv->attr_data);
-	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
+	retval = sysfs_create_bin_file(&f_dev->kobj, &firmware_attr_data);
 	if (retval) {
 		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
 		goto error_unreg;
_

Patches currently in -mm which might be from dmitry.torokhov@gmail.com are

origin.patch
linux-next.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
vfs-clarify-that-nonseekable_open-will-never-fail.patch
firmware-loader-use-statically-initialized-data-attribute.patch

