From: akpm@linux-foundation.org
Subject: + fs-partitions-checkc-add-error-handling-for.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:15:07 -0700
Message-ID: <200710250315.l9P3F7hR029073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbXJYDPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     fs/partitions/check.c: add error handling for kobject_add
has been added to the -mm tree.  Its filename is
     fs-partitions-checkc-add-error-handling-for.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/partitions/check.c: add error handling for kobject_add
From: Borislav Petkov <bbpetkov@yahoo.de>

Add error handling to the kobject_add()-call and signal (the even highly
unlikely) error condition.

(akpm: clashes hugely with the presently-reverted
gregkh-driver-block-device.patch)

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/partitions/check.c~fs-partitions-checkc-add-error-handling-for fs/partitions/check.c
--- a/fs/partitions/check.c~fs-partitions-checkc-add-error-handling-for
+++ a/fs/partitions/check.c
@@ -371,11 +371,12 @@ void delete_partition(struct gendisk *di
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
+	int err = -EINVAL;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return;
-	
+
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = part;
@@ -390,7 +391,13 @@ void add_partition(struct gendisk *disk,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+
+	err = kobject_add(&p->kobj);
+	if (err) {
+		pr_err("%s: error adding %s to sysfs.\n", __FUNCTION__,
+				kobject_name(&p->kobj));
+	}
+
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
 	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

fs-partitions-checkc-add-error-handling-for.patch
