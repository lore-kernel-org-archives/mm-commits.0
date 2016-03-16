From: akpm@linux-foundation.org
Subject: [merged]
 block-partition-add-partition-specific-uevent-callbacks-for-partition-info.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:26 -0700
Message-ID: <56e9b9b6.cIXfOgKJRm/1YHCG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcCPTx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: san@google.com, axboe@kernel.dk, dima@android.com, harald@redhat.com, jmoyer@redhat.com, john.stultz@linaro.org, kay@vrfy.org, keescook@chromium.org, kernel-team@android.com, romlem@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: partition: add partition specific uevent callbacks for partition info
has been removed from the -mm tree.  Its filename was
     block-partition-add-partition-specific-uevent-callbacks-for-partition-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: San Mehat <san@google.com>
Subject: block: partition: add partition specific uevent callbacks for partition info

This patch has been carried in the Android tree for quite some time and is
one of the few patches required to get a mainline kernel up and running
with an exsiting Android userspace.  So I wanted to submit it for review
and consideration if it should be merged.

For partitions, add new uevent parameters 'PARTN' which specifies the
partitions index in the table, and 'PARTNAME', which specifies PARTNAME
specifices the partition name of a partition device.

Android's userspace uses this for creating device node links from the
partition name and number: ie:
	/dev/block/platform/soc/by-name/system
or
	/dev/block/platform/soc/by-num/p1

One can see its usage here:
https://android.googlesource.com/platform/system/core/+/master/init/devices.cpp#355
and
https://android.googlesource.com/platform/system/core/+/master/init/devices.cpp#494

[john.stultz@linaro.org: dropped NPARTS and reworded commit message for context]
Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Rom Lemarchand <romlem@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: <harald@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partition-generic.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN block/partition-generic.c~block-partition-add-partition-specific-uevent-callbacks-for-partition-info block/partition-generic.c
--- a/block/partition-generic.c~block-partition-add-partition-specific-uevent-callbacks-for-partition-info
+++ a/block/partition-generic.c
@@ -217,10 +217,21 @@ static void part_release(struct device *
 	kfree(p);
 }
 
+static int part_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct hd_struct *part = dev_to_part(dev);
+
+	add_uevent_var(env, "PARTN=%u", part->partno);
+	if (part->info && part->info->volname[0])
+		add_uevent_var(env, "PARTNAME=%s", part->info->volname);
+	return 0;
+}
+
 struct device_type part_type = {
 	.name		= "partition",
 	.groups		= part_attr_groups,
 	.release	= part_release,
+	.uevent		= part_uevent,
 };
 
 static void delete_partition_rcu_cb(struct rcu_head *head)
_

Patches currently in -mm which might be from san@google.com are


