From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + zram-rework-reset-and-destroy-path-fix.patch added to -mm
 tree
Date: Wed, 4 Feb 2015 14:29:59 -0800
Message-ID: <20150204142959.de8ddfef8374132b27a5d0c2__24039.2049229287$1423089054$gmane$org@linux-foundation.org>
References: <54d155bf.k9GCVwDVqT17beYC%akpm@linux-foundation.org>
	<20150204010720.GC527@swordfish>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbbBDWaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:30:00 -0500
In-Reply-To: <20150204010720.GC527@swordfish>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: linux-kernel@vger.kernel.org, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org

On Wed, 4 Feb 2015 10:07:20 +0900 Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:

> Set dev_id to zero and fix zram_devices allocation error handling
> path, can pass uninit dev_id to destroy_devices().
> 
> cosmetic:
> change destroy_devices() message from pr_debug() to pr_info(), as
> proposed by Minchan Kim.
> 

Seems unnecessarily complicated.  What about

--- a/drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix-2-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1141,7 +1141,8 @@ static void destroy_devices(unsigned int
 
 static int __init zram_init(void)
 {
-	int ret = -ENOMEM, dev_id = 0;
+	int ret;
+	int dev_id;
 
 	if (num_devices > max_num_devices) {
 		pr_warn("Invalid value for num_devices: %u\n",
@@ -1157,20 +1158,23 @@ static int __init zram_init(void)
 
 	/* Allocate the device array and initialize each one */
 	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
-	if (!zram_devices)
-		goto out_error;
+	if (!zram_devices) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	for (dev_id = 0; dev_id < num_devices; dev_id++) {
 		ret = create_device(&zram_devices[dev_id], dev_id);
 		if (ret)
-			goto out_error;
+			goto out_devices;
 	}
 
 	pr_info("Created %u device(s)\n", num_devices);
 	return 0;
 
-out_error:
+out_devices:
 	destroy_devices(dev_id);
+out:
 	return ret;
 }

which yields

static int __init zram_init(void)
{
	int ret;
	int dev_id;

	if (num_devices > max_num_devices) {
		pr_warn("Invalid value for num_devices: %u\n",
				num_devices);
		return -EINVAL;
	}

	zram_major = register_blkdev(0, "zram");
	if (zram_major <= 0) {
		pr_warn("Unable to get major number\n");
		return -EBUSY;
	}

	/* Allocate the device array and initialize each one */
	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
	if (!zram_devices) {
		ret = -ENOMEM;
		goto out;
	}

	for (dev_id = 0; dev_id < num_devices; dev_id++) {
		ret = create_device(&zram_devices[dev_id], dev_id);
		if (ret)
			goto out_devices;
	}

	pr_info("Created %u device(s)\n", num_devices);
	return 0;

out_devices:
	destroy_devices(dev_id);
out:
	return ret;
}

 
_

