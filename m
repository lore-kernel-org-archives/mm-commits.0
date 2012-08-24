From: akpm@linux-foundation.org
Subject: + init-reduce-partuuid-min-length-to-1-from-36.patch added to -mm tree
Date: Fri, 24 Aug 2012 15:23:49 -0700
Message-ID: <20120824222350.B4C0D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:45647 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760204Ab2HXWXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2012 18:23:54 -0400
Received: by lagw12 with SMTP id w12so111555lag.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:23:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swarren@nvidia.com, axboe@kernel.dk, kay.sievers@vrfy.org, tj@kernel.org, wad@chromium.org


The patch titled
     Subject: init: reduce PARTUUID min length to 1 from 36
has been added to the -mm tree.  Its filename is
     init-reduce-partuuid-min-length-to-1-from-36.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: init: reduce PARTUUID min length to 1 from 36

Reduce the minimum length for a root=PARTUUID= parameter to be considered
valid from 36 to 1.  EFI/GPT partition UUIDs are always exactly 36
characters long, hence the previous limit.  However, the next patch will
support DOS/MBR UUIDs too, which have a different, shorter, format. 
Instead of validating any particular length, just ensure that at least
some non-empty value was given by the user.

Also, consider a missing UUID value to be a parsing error, in the same
vein as if /PARTNROFF exists and can't be parsed.  As such, make both
error cases print a message and disable rootwait.  Convert to pr_err while
we're at it.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN init/do_mounts.c~init-reduce-partuuid-min-length-to-1-from-36 init/do_mounts.c
--- a/init/do_mounts.c~init-reduce-partuuid-min-length-to-1-from-36
+++ a/init/do_mounts.c
@@ -119,27 +119,29 @@ static dev_t devt_from_partuuid(const ch
 	struct gendisk *disk;
 	struct hd_struct *part;
 	int offset = 0;
-
-	if (strlen(uuid_str) < 36)
-		goto done;
+	bool clear_root_wait = false;
+	char *slash;
 
 	cmp.uuid = uuid_str;
-	cmp.len = 36;
 
+	slash = strchr(uuid_str, '/');
 	/* Check for optional partition number offset attributes. */
-	if (uuid_str[36]) {
+	if (slash) {
 		char c = 0;
 		/* Explicitly fail on poor PARTUUID syntax. */
-		if (sscanf(&uuid_str[36],
-			   "/PARTNROFF=%d%c", &offset, &c) != 1) {
-			printk(KERN_ERR "VFS: PARTUUID= is invalid.\n"
-			 "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
-			if (root_wait)
-				printk(KERN_ERR
-				     "Disabling rootwait; root= is invalid.\n");
-			root_wait = 0;
+		if (sscanf(slash + 1,
+			   "PARTNROFF=%d%c", &offset, &c) != 1) {
+			clear_root_wait = true;
 			goto done;
 		}
+		cmp.len = slash - uuid_str;
+	} else {
+		cmp.len = strlen(uuid_str);
+	}
+
+	if (!cmp.len) {
+		clear_root_wait = true;
+		goto done;
 	}
 
 	dev = class_find_device(&block_class, NULL, &cmp,
@@ -164,6 +166,13 @@ static dev_t devt_from_partuuid(const ch
 no_offset:
 	put_device(dev);
 done:
+	if (clear_root_wait) {
+		pr_err("VFS: PARTUUID= is invalid.\n"
+		       "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
+		if (root_wait)
+			pr_err("Disabling rootwait; root= is invalid.\n");
+		root_wait = 0;
+	}
 	return res;
 }
 #endif
_

Patches currently in -mm which might be from swarren@nvidia.com are

linux-next.patch
block-store-partition_meta_infouuid-as-a-string.patch
init-reduce-partuuid-min-length-to-1-from-36.patch
block-partition-msdos-provide-uuids-for-partitions.patch
rtc-add-max8907-rtc-driver.patch

