From: akpm@linux-foundation.org
Subject: +
 block-partition-add-partition-specific-uevent-callbacks-for-partition-info.patch added to -mm tree
Date: Mon, 08 Feb 2016 16:27:38 -0800
Message-ID: <56b9327a.El3gQ0feG5HWyu0B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbcBIA1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 19:27:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: san@google.com, axboe@kernel.dk, dima@android.com, harald@redhat.com, jmoyer@redhat.com, john.stultz@linaro.org, kay@vrfy.org, keescook@chromium.org, kernel-team@android.com, romlem@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: partition: add partition specific uevent callbacks for partition info
has been added to the -mm tree.  Its filename is
     block-partition-add-partition-specific-uevent-callbacks-for-partition-info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-partition-add-partition-specific-uevent-callbacks-for-partition-info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-partition-add-partition-specific-uevent-callbacks-for-partition-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

block-partition-add-partition-specific-uevent-callbacks-for-partition-info.patch

