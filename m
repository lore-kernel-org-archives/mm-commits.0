From: akpm@linux-foundation.org
Subject: [merged] bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:13 -0800
Message-ID: <20130222203914.18AEB31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:38725 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3BVUjP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:15 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so103626qcr.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, adrian.hunter@intel.com, axboe@kernel.dk, dedekind1@gmail.com, ericvh@gmail.com, jack@suse.cz, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bdi: allow block devices to say that they require stable page writes
has been removed from the -mm tree.  Its filename was
     bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: bdi: allow block devices to say that they require stable page writes

This patchset ("stable page writes, part 2") makes some key modifications
to the original 'stable page writes' patchset.  First, it provides
creators (devices and filesystems) of a backing_dev_info a flag that
declares whether or not it is necessary to ensure that page contents
cannot change during writeout.  It is no longer assumed that this is true
of all devices (which was never true anyway).  Second, the flag is used to
relaxed the wait_on_page_writeback calls so that wait only occurs if the
device needs it.  Third, it fixes up the remaining disk-backed filesystems
to use this improved conditional-wait logic to provide stable page writes
on those filesystems.

It is hoped that (for people not using checksumming devices, anyway) this
patchset will give back unnecessary performance decreases since the
original stable page write patchset went into 3.0.  Sorry about not fixing
it sooner.

Complaints were registered by several people about the long write
latencies introduced by the original stable page write patchset. 
Generally speaking, the kernel ought to allocate as little extra memory as
possible to facilitate writeout, but for people who simply cannot wait, a
second page stability strategy is (re)introduced: snapshotting page
contents.  The waiting behavior is still the default strategy; to enable
page snapshotting, a superblock flag (MS_SNAP_STABLE) must be set.  This
flag is used to bandaid^Henable stable page writeback on ext3[1], and is
not used anywhere else.

Given that there are already a few storage devices and network FSes that
have rolled their own page stability wait/page snapshot code, it would be
nice to move towards consolidating all of these.  It seems possible that
iscsi and raid5 may wish to use the new stable page write support to
enable zero-copy writeout.

Thank you to Jan Kara for helping fix a couple more filesystems.

Per Andrew Morton's request, here are the result of using dbench to measure
latencies on ext2:

3.8.0-rc3:
 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 WriteX        109347     0.028    59.817
 ReadX         347180     0.004     3.391
 Flush          15514    29.828   287.283

Throughput 57.429 MB/sec  4 clients  4 procs  max_latency=287.290 ms

3.8.0-rc3 + patches:
 WriteX        105556     0.029     4.273
 ReadX         335004     0.005     4.112
 Flush          14982    30.540   298.634

Throughput 55.4496 MB/sec  4 clients  4 procs  max_latency=298.650 ms

As you can see, for ext2 the maximum write latency decreases from ~60ms on a
laptop hard disk to ~4ms.  I'm not sure why the flush latencies increase,
though I suspect that being able to dirty pages faster gives the flusher more
work to do.

On ext4, the average write latency decreases as well as all the maximum
latencies:

3.8.0-rc3:
 WriteX         85624     0.152    33.078
 ReadX         272090     0.010    61.210
 Flush          12129    36.219   168.260

Throughput 44.8618 MB/sec  4 clients  4 procs  max_latency=168.276 ms

3.8.0-rc3 + patches:
 WriteX         86082     0.141    30.928
 ReadX         273358     0.010    36.124
 Flush          12214    34.800   165.689

Throughput 44.9941 MB/sec  4 clients  4 procs  max_latency=165.722 ms

XFS seems to exhibit similar latency improvements as ext2:

3.8.0-rc3:
 WriteX        125739     0.028   104.343
 ReadX         399070     0.005     4.115
 Flush          17851    25.004   131.390

Throughput 66.0024 MB/sec  4 clients  4 procs  max_latency=131.406 ms

3.8.0-rc3 + patches:
 WriteX        123529     0.028     6.299
 ReadX         392434     0.005     4.287
 Flush          17549    25.120   188.687

Throughput 64.9113 MB/sec  4 clients  4 procs  max_latency=188.704 ms

...and btrfs, just to round things out, also shows some latency decreases:

3.8.0-rc3:
 WriteX         67122     0.083    82.355
 ReadX         212719     0.005     2.828
 Flush           9547    47.561   147.418

Throughput 35.3391 MB/sec  4 clients  4 procs  max_latency=147.433 ms

3.8.0-rc3 + patches:
 WriteX         64898     0.101    71.631
 ReadX         206673     0.005     7.123
 Flush           9190    47.963   219.034

Throughput 34.0795 MB/sec  4 clients  4 procs  max_latency=219.044 ms

Before this patchset, all filesystems would block, regardless of whether
or not it was necessary.  ext3 would wait, but still generate occasional
checksum errors.  The network filesystems were left to do their own thing,
so they'd wait too.

After this patchset, all the disk filesystems except ext3 and btrfs will
wait only if the hardware requires it.  ext3 (if necessary) snapshots
pages instead of blocking, and btrfs provides its own bdi so the mm will
never wait.  Network filesystems haven't been touched, so either they
provide their own wait code, or they don't block at all.  The blocking
behavior is back to what it was before 3.0 if you don't have a disk
requiring stable page writes.

This patchset has been tested on 3.8.0-rc3 on x64 with ext3, ext4, and xfs.
I've spot-checked 3.8.0-rc4 and seem to be getting the same results as -rc3.

[1] The alternative fixes to ext3 include fixing the locking order and page bit
handling like we did for ext4 (but then why not just use ext4?), or setting
PG_writeback so early that ext3 becomes extremely slow.  I tried that, but the
number of write()s I could initiate dropped by nearly an order of magnitude.
That was a bit much even for the author of the stable page series! :)


This patch:

Creates a per-backing-device flag that tracks whether or not pages must be
held immutable during writeout.  Eventually it will be used to waive
wait_for_page_writeback() if nothing requires stable pages.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    5 +++++
 block/blk-integrity.c                     |    4 ++++
 include/linux/backing-dev.h               |    6 ++++++
 mm/backing-dev.c                          |   11 +++++++++++
 4 files changed, 26 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-class-bdi~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes Documentation/ABI/testing/sysfs-class-bdi
--- a/Documentation/ABI/testing/sysfs-class-bdi~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -48,3 +48,8 @@ max_ratio (read-write)
 	most of the write-back cache.  For example in case of an NFS
 	mount that is prone to get stuck, or a FUSE mount which cannot
 	be trusted to play fair.
+
+stable_pages_required (read-only)
+
+	If set, the backing device requires that all pages comprising a write
+	request must not be changed until writeout is complete.
diff -puN block/blk-integrity.c~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes block/blk-integrity.c
--- a/block/blk-integrity.c~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes
+++ a/block/blk-integrity.c
@@ -420,6 +420,8 @@ int blk_integrity_register(struct gendis
 	} else
 		bi->name = bi_unsupported_name;
 
+	disk->queue->backing_dev_info.capabilities |= BDI_CAP_STABLE_WRITES;
+
 	return 0;
 }
 EXPORT_SYMBOL(blk_integrity_register);
@@ -438,6 +440,8 @@ void blk_integrity_unregister(struct gen
 	if (!disk || !disk->integrity)
 		return;
 
+	disk->queue->backing_dev_info.capabilities &= ~BDI_CAP_STABLE_WRITES;
+
 	bi = disk->integrity;
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
diff -puN include/linux/backing-dev.h~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes
+++ a/include/linux/backing-dev.h
@@ -254,6 +254,7 @@ int bdi_set_max_ratio(struct backing_dev
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
+#define BDI_CAP_STABLE_WRITES	0x00000200
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
@@ -308,6 +309,11 @@ long wait_iff_congested(struct zone *zon
 int pdflush_proc_obsolete(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
 
+static inline bool bdi_cap_stable_pages_required(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_STABLE_WRITES;
+}
+
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
 	return !(bdi->capabilities & BDI_CAP_NO_WRITEBACK);
diff -puN mm/backing-dev.c~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes mm/backing-dev.c
--- a/mm/backing-dev.c~bdi-allow-block-devices-to-say-that-they-require-stable-page-writes
+++ a/mm/backing-dev.c
@@ -221,12 +221,23 @@ static ssize_t max_ratio_store(struct de
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
 
+static ssize_t stable_pages_required_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *page)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n",
+			bdi_cap_stable_pages_required(bdi) ? 1 : 0);
+}
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
 	__ATTR_RW(read_ahead_kb),
 	__ATTR_RW(min_ratio),
 	__ATTR_RW(max_ratio),
+	__ATTR_RO(stable_pages_required),
 	__ATTR_NULL,
 };
 
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

origin.patch
linux-next.patch

