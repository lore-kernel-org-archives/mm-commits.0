From: akpm@linux-foundation.org
Subject: + memstick-add-support-for-decoding-specfile-media-attributes.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:17:53 -0800
Message-ID: <200803052317.m25NHrOC026693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932887AbYCEXTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:19:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: add support for decoding "specfile" media attributes
has been added to the -mm tree.  Its filename is
     memstick-add-support-for-decoding-specfile-media-attributes.patch

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
Subject: memstick: add support for decoding "specfile" media attributes
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   49 ++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff -puN drivers/memstick/core/mspro_block.c~memstick-add-support-for-decoding-specfile-media-attributes drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-add-support-for-decoding-specfile-media-attributes
+++ a/drivers/memstick/core/mspro_block.c
@@ -109,6 +109,17 @@ struct mspro_mbr {
 	unsigned int  sectors_per_partition;
 } __attribute__((packed));
 
+struct mspro_specfile {
+	char           name[8];
+	char           ext[3];
+	unsigned char  attr;
+	unsigned char  reserved[10];
+	unsigned short time;
+	unsigned short date;
+	unsigned short cluster;
+	unsigned int   size;
+} __attribute__((packed));
+
 struct mspro_devinfo {
 	unsigned short cylinders;
 	unsigned short heads;
@@ -397,6 +408,41 @@ static ssize_t mspro_block_attr_show_mbr
 	return rc;
 }
 
+static ssize_t mspro_block_attr_show_specfile(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buffer)
+{
+	struct mspro_sys_attr *x_attr = container_of(attr,
+						     struct mspro_sys_attr,
+						     dev_attr);
+	struct mspro_specfile *x_spfile = x_attr->data;
+	char name[9], ext[4];
+	ssize_t rc = 0;
+
+	memcpy(name, x_spfile->name, 8);
+	name[8] = 0;
+	memcpy(ext, x_spfile->ext, 3);
+	ext[3] = 0;
+
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "name: %s\n", name);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "ext: %s\n", ext);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "attribute: %x\n",
+			x_spfile->attr);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "time: %d:%d:%d\n",
+			x_spfile->time >> 11,
+			(x_spfile->time >> 5) & 0x3f,
+			(x_spfile->time & 0x1f) * 2);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "date: %d-%d-%d\n",
+			(x_spfile->date >> 9) + 1980,
+			(x_spfile->date >> 5) & 0xf,
+			x_spfile->date & 0x1f);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "start cluster: %x\n",
+			x_spfile->cluster);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "size: %x\n",
+			x_spfile->size);
+	return rc;
+}
+
 static ssize_t mspro_block_attr_show_devinfo(struct device *dev,
 					     struct device_attribute *attr,
 					     char *buffer)
@@ -429,6 +475,9 @@ static sysfs_show_t mspro_block_attr_sho
 		return mspro_block_attr_show_modelname;
 	case MSPRO_BLOCK_ID_MBR:
 		return mspro_block_attr_show_mbr;
+	case MSPRO_BLOCK_ID_SPECFILEVALUES1:
+	case MSPRO_BLOCK_ID_SPECFILEVALUES2:
+		return mspro_block_attr_show_specfile;
 	case MSPRO_BLOCK_ID_DEVINFO:
 		return mspro_block_attr_show_devinfo;
 	default:
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-introduce-correct-definitions-in-the-header.patch
memstick-add-memstick_suspend-resume_host-methods.patch
memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch
memstick-drop-driver_version-numbers-as-meaningless.patch
tifm-fix-the-memorystick-host-fifo-handling-code.patch
tifm-fix-memorystick-host-initialization-code.patch
tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init.patch
memstick-add-support-for-decoding-specfile-media-attributes.patch
memstick-fix-parsing-of-assembly_date-attribute-field.patch
memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch.patch
memstick-add-support-for-jmicron-jmb38x-memorystick-host-controller.patch

