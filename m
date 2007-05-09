From: akpm@linux-foundation.org
Subject: + dm-raid1-add-handle_errors-feature-flag.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:54 -0700
Message-ID: <200705090054.l490ssGY006394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968375AbXEIAzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com


The patch titled
     dm raid1: add handle_errors feature flag
has been added to the -mm tree.  Its filename is
     dm-raid1-add-handle_errors-feature-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm raid1: add handle_errors feature flag
From: Jonathan E Brassow <jbrassow@redhat.com>

This patch adds the ability to specify desired features in the mirror
constructor/mapping table.

The first feature of interest is "handle_errors".  Currently, mirroring will
ignore any I/O errors from the devices.  Subsequent patches will check for
this flag and handle the errors.  If flag/feature is not present, mirror will
do nothing - maintaining backwards compatibility.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-raid1.c |   65 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 63 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1-add-handle_errors-feature-flag drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1-add-handle_errors-feature-flag
+++ a/drivers/md/dm-raid1.c
@@ -22,6 +22,8 @@
 
 #define DM_MSG_PREFIX "raid1"
 
+#define DM_RAID1_HANDLE_ERRORS 0x01
+
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
 /*-----------------------------------------------------------------
@@ -118,6 +120,7 @@ struct mirror_set {
 	struct list_head list;
 	struct region_hash rh;
 	struct kcopyd_client *kcopyd_client;
+	uint64_t features;
 
 	spinlock_t lock;	/* protects the next two lists */
 	struct bio_list reads;
@@ -1010,14 +1013,54 @@ static struct dirty_log *create_dirty_lo
 	return dl;
 }
 
+static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
+			  unsigned *args_used)
+{
+	unsigned num_features;
+	struct dm_target *ti = ms->ti;
+
+	*args_used = 0;
+
+	if (!argc)
+		return 0;
+
+	if (sscanf(argv[0], "%u", &num_features) != 1) {
+		ti->error = "Invalid number of features";
+		return -EINVAL;
+	}
+
+	argc--;
+	argv++;
+	(*args_used)++;
+
+	if (num_features > argc) {
+		ti->error = "Not enough arguments to support feature count";
+		return -EINVAL;
+	}
+
+	if (!strcmp("handle_errors", argv[0]))
+		ms->features |= DM_RAID1_HANDLE_ERRORS;
+	else {
+		ti->error = "Unrecognised feature requested";
+		return -EINVAL;
+	}
+
+	(*args_used)++;
+
+	return 0;
+}
+
 /*
  * Construct a mirror mapping:
  *
  * log_type #log_params <log_params>
  * #mirrors [mirror_path offset]{2,}
+ * [#features <features>]
  *
  * log_type is "core" or "disk"
  * #log_params is between 1 and 3
+ *
+ * If present, features must be "handle_errors".
  */
 #define DM_IO_PAGES 64
 static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
@@ -1043,8 +1086,8 @@ static int mirror_ctr(struct dm_target *
 
 	argv++, argc--;
 
-	if (argc != nr_mirrors * 2) {
-		ti->error = "Wrong number of mirror arguments";
+	if (argc < nr_mirrors * 2) {
+		ti->error = "Too few mirror arguments";
 		dm_destroy_dirty_log(dl);
 		return -EINVAL;
 	}
@@ -1077,6 +1120,21 @@ static int mirror_ctr(struct dm_target *
 	}
 	INIT_WORK(&ms->kmirrord_work, do_mirror);
 
+	r = parse_features(ms, argc, argv, &args_used);
+	if (r) {
+		free_context(ms, ti, ms->nr_mirrors);
+		return r;
+	}
+
+	argv += args_used;
+	argc -= args_used;
+
+	if (argc) {
+		ti->error = "Too many mirror arguments";
+		free_context(ms, ti, ms->nr_mirrors);
+		return -EINVAL;
+	}
+
 	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
 	if (r) {
 		destroy_workqueue(ms->kmirrord_wq);
@@ -1230,6 +1288,9 @@ static int mirror_status(struct dm_targe
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
 				(unsigned long long)ms->mirror[m].offset);
+
+		if (ms->features & DM_RAID1_HANDLE_ERRORS)
+			DMEMIT(" 1 handle_errors");
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-log-fault-detection.patch
dm-log-report-fault-status.patch
dm-raid1-add-handle_errors-feature-flag.patch
dm-raid1-fix-to-commit-pending-clear-region-requests.patch
dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
dm-log-fix-resume-failed-log-device.patch
