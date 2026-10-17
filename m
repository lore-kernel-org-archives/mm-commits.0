Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8FE3CBE96
	for <mm-commits@vger.kernel.org>; Sat, 17 Oct 2026 20:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792268813; cv=none; b=O8vU513BLyNMlKgqaupgxUS9JgFX9RMOU/T21sME7TcPuHSoxSDQmuNWXyCbl1UAE+tvsqLIlMKatPigilSMLBHGXynyXlq9WVTXaBD6mcbjVSVPZFSBu2rd8W5ak2v+7f7Cncv+o/QUM2/BgjdtFQOoiHvoPLeb6oE0EuakuqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792268813; c=relaxed/simple;
	bh=KwaYQStJ4agftObHmNASEWNAmOFeop58jYm9EUI5Eqg=;
	h=Date:To:From:Subject:Message-Id; b=TH78WrZNsNxWG5nEtY4eUokAh2Q0J7Tf2hm3nl8GgNy3nsAO3bLPUFFG2XU3Ze5k3QDIgr/a91ixZA7Dal7iZGjjBUUBW9+3vZoULBOkYFv2gmQqXGg8GqPf39fVjuFao5Iqhb4ow85oaABi3DrMowPQn/tfqWOmoSQDf75Im4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ohxPUP16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ohxPUP16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC79F1F000C4;
	Sat, 17 Oct 2026 20:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792268811;
	bh=1XaSh+mVWM/R0Pk0Ydbq7OR1/3wi9VQix9aWYlWg0Dg=;
	h=Date:To:From:Subject;
	b=ohxPUP16xrRpdIvKM4NRwghQ+rEdFD5WNUgqyKW1i33KNCHm/7vh46NpxIWUxHWot
	 4MuLZ0OCBBx4sYUE8XfwFXWG91fnfSE+R/D7TwTq9jRvVozGQGP0P4LKx7FUouLD7b
	 obB42DpX9jncDfrgOdL00NHiHCXiFdfiI4K/3UYQ=
Date: Sat, 17 Oct 2026 13:26:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,mj0123.lee@samsung.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,david@kernel.org,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch added to mm-unstable branch
Message-Id: <20261017202651.BC79F1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: bdi: reset min_ratio after the sysfs attributes are gone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: mm: bdi: reset min_ratio after the sysfs attributes are gone
Date: Fri, 16 Oct 2026 23:06:20 -0400

A write to /sys/class/bdi/<dev>/min_ratio (or min_ratio_fine or min_bytes)
that races with the removal of the device leaves the global sum of minimum
dirty shares charged for a bdi that no longer exists.  Until the next
reboot, that share of the dirty threshold is withheld from every other bdi
(__wb_calc_thresh() scales by 100 % minus the sum), and a later min_ratio
store on any bdi that would push the sum to 100 % fails with EINVAL
although every bdi reads 0.  Root privilege is needed for the store; the
removal is any del_gendisk() (a disk or loop device going away) or the
unmount of a filesystem with its own bdi.  On an x86_64 defconfig kernel
(v7.3-rc7), 2000 rounds of LOOP_CTL_ADD/LOOP_CTL_REMOVE on one loop device
with a second thread writing 50 to its min_ratio leak the share on the
first round the store lands in the window; afterwards `echo 99 >
min_ratio` on another loop device fails with EINVAL.  With the fix the
same run keeps the sum at 0 and the store succeeds.  Affected since v5.16,
when the reset in bdi_unregister() was added.

bdi_unregister() gives the bdi's share back with bdi_set_min_ratio(bdi, 0)
and only then calls device_unregister(), which removes the sysfs
attributes.  A min_ratio_store() that gets its kernfs active reference
before the removal runs to completion after the reset:
__bdi_set_min_ratio() takes bdi_lock, sees bdi->min_ratio == 0, adds the
new value to bdi_min_ratio and stores it in the bdi, which bdi_put() then
frees.  Nothing gives that share back.

Move the reset after device_unregister(): once the attributes are gone no
store can run, and bdi_set_min_ratio() needs nothing from the device.

Found while formally verifying bdi_unregister() against the kernel binary.

Link: https://lore.kernel.org/20261017030620.793108-1-nickolai@csail.mit.edu
Fixes: 3c376dfafbf7 ("mm: bdi: initialize bdi_min_ratio when bdi is unregistered")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Manjong Lee <mj0123.lee@samsung.com>
Cc: Jan Kara <jack@suse.cz>
---

 mm/backing-dev.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/backing-dev.c~mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone
+++ a/mm/backing-dev.c
@@ -1162,19 +1162,20 @@ void bdi_unregister(struct backing_dev_i
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_unregister(bdi);
 
-	/*
-	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
-	 * update the global bdi_min_ratio.
-	 */
-	if (bdi->min_ratio)
-		bdi_set_min_ratio(bdi, 0);
-
 	if (bdi->dev) {
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
 	}
 
+	/*
+	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
+	 * update the global bdi_min_ratio. After device_unregister(): the
+	 * sysfs min_ratio stores can no longer run and set it again.
+	 */
+	if (bdi->min_ratio)
+		bdi_set_min_ratio(bdi, 0);
+
 	if (bdi->owner) {
 		put_device(bdi->owner);
 		bdi->owner = NULL;
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch
mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch
resource-report-a-devm_request_resource-conflict-under-the-lock.patch
mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch

