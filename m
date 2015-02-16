From: akpm@linux-foundation.org
Subject: [merged]
 input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:39 -0800
Message-ID: <54e25027.z8jjJ2hLtAG0toxK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbBPURP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: input: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: input: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Line termination only requires one extra space at the end of the
  buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/atkbd.c     |    4 ++--
 drivers/input/keyboard/gpio_keys.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/input/keyboard/atkbd.c~input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/input/keyboard/atkbd.c
@@ -1399,8 +1399,8 @@ static ssize_t atkbd_set_extra(struct at
 
 static ssize_t atkbd_show_force_release(struct atkbd *atkbd, char *buf)
 {
-	size_t len = bitmap_scnlistprintf(buf, PAGE_SIZE - 2,
-			atkbd->force_release_mask, ATKBD_KEYMAP_SIZE);
+	size_t len = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+			       ATKBD_KEYMAP_SIZE, atkbd->force_release_mask);
 
 	buf[len++] = '\n';
 	buf[len] = '\0';
diff -puN drivers/input/keyboard/gpio_keys.c~input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -190,7 +190,7 @@ static ssize_t gpio_keys_attr_show_helpe
 		__set_bit(bdata->button->code, bits);
 	}
 
-	ret = bitmap_scnlistprintf(buf, PAGE_SIZE - 2, bits, n_events);
+	ret = scnprintf(buf, PAGE_SIZE - 1, "%*pbl", n_events, bits);
 	buf[ret++] = '\n';
 	buf[ret] = '\0';
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

