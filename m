From: akpm@linux-foundation.org
Subject: [merged] firmware-consolidate-kmap-read-write-logic.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:26 -0700
Message-ID: <57a2340a.qcXhM/JHuymrA79V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbcHCSNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.boyd@linaro.org, broonie@kernel.org, gregkh@linuxfoundation.org, markivx@codeaurora.org, ming.lei@canonical.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware: consolidate kmap/read/write logic
has been removed from the -mm tree.  Its filename was
     firmware-consolidate-kmap-read-write-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <stephen.boyd@linaro.org>
Subject: firmware: consolidate kmap/read/write logic

Some systems are memory constrained but they need to load very large
firmwares.  The firmware subsystem allows drivers to request this firmware
be loaded from the filesystem, but this requires that the entire firmware
be loaded into kernel memory first before it's provided to the driver. 
This can lead to a situation where we map the firmware twice, once to load
the firmware into kernel memory and once to copy the firmware into the
final resting place.

This design creates needless memory pressure and delays loading because we
have to copy from kernel memory to somewhere else.  This patch sets adds
support to the request firmware API to load the firmware directly into a
pre-allocated buffer, skipping the intermediate copying step and
alleviating memory pressure during firmware loading.  The drawback is that
we can't use the firmware caching feature because the memory for the
firmware cache is not managed by the firmware layer.


This patch (of 3):

We use similar structured code to read and write the kmapped firmware
pages.  The only difference is read copies from the kmap region and write
copies to it.  Consolidate this into one function to reduce duplication.

Link: http://lkml.kernel.org/r/20160607164741.31849-2-stephen.boyd@linaro.org
Signed-off-by: Stephen Boyd <stephen.boyd@linaro.org>
Cc: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |   57 ++++++++++++++------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff -puN drivers/base/firmware_class.c~firmware-consolidate-kmap-read-write-logic drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-consolidate-kmap-read-write-logic
+++ a/drivers/base/firmware_class.c
@@ -691,6 +691,29 @@ out:
 
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
+static void firmware_rw(struct firmware_buf *buf, char *buffer,
+			loff_t offset, size_t count, bool read)
+{
+	while (count) {
+		void *page_data;
+		int page_nr = offset >> PAGE_SHIFT;
+		int page_ofs = offset & (PAGE_SIZE-1);
+		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
+
+		page_data = kmap(buf->pages[page_nr]);
+
+		if (read)
+			memcpy(buffer, page_data + page_ofs, page_cnt);
+		else
+			memcpy(page_data + page_ofs, buffer, page_cnt);
+
+		kunmap(buf->pages[page_nr]);
+		buffer += page_cnt;
+		offset += page_cnt;
+		count -= page_cnt;
+	}
+}
+
 static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buffer, loff_t offset, size_t count)
@@ -715,21 +738,8 @@ static ssize_t firmware_data_read(struct
 
 	ret_count = count;
 
-	while (count) {
-		void *page_data;
-		int page_nr = offset >> PAGE_SHIFT;
-		int page_ofs = offset & (PAGE_SIZE-1);
-		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
-
-		page_data = kmap(buf->pages[page_nr]);
-
-		memcpy(buffer, page_data + page_ofs, page_cnt);
+	firmware_rw(buf, buffer, offset, count, true);
 
-		kunmap(buf->pages[page_nr]);
-		buffer += page_cnt;
-		offset += page_cnt;
-		count -= page_cnt;
-	}
 out:
 	mutex_unlock(&fw_lock);
 	return ret_count;
@@ -809,24 +819,9 @@ static ssize_t firmware_data_write(struc
 		goto out;
 
 	retval = count;
+	firmware_rw(buf, buffer, offset, count, false);
 
-	while (count) {
-		void *page_data;
-		int page_nr = offset >> PAGE_SHIFT;
-		int page_ofs = offset & (PAGE_SIZE - 1);
-		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
-
-		page_data = kmap(buf->pages[page_nr]);
-
-		memcpy(page_data + page_ofs, buffer, page_cnt);
-
-		kunmap(buf->pages[page_nr]);
-		buffer += page_cnt;
-		offset += page_cnt;
-		count -= page_cnt;
-	}
