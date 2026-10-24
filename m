Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832532;
	b=aBDqIqHcQO/SOCDVWclmTPsUb8CjssYKo/s2pU9TwhKqLlsgh9NTM6nkTijYhqqOqSSP
	 6+hQ6N5CovBNVnKwMgNPonazg8QCtmsDX6W+HgiMCwIhpgM7AWdjKODHiRnUWLSOCV/SF
	 dLEDZSNyv9dIZpRCD9A9zo8juqNEdP6wVU/45r2tINKG+Z1d05vLnWhjTMsB+7ppCULYp
	 MaWB2+PA/Taovz12F0FTuI0EYdm73INRkIi7j5ECqsJ2VAGECxk9XTI+sR8ToqVWfdcnu
	 GcxjDpJdZFqBmjoeWsWSmjUcUAc0tmyyo1mL0KTwEXbWeN7yzj2BLAJ8K1z1m2lDaxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832532;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=T6klcvmgP9sRTV5pY3hh0G0OuU29QLHZIFXmykc2zJ8=;
	b=EdYW7bUMmSF5XPFdhjbRLliCoZnb5m+nVKs7hDR2pvXj+421A8hQbYU2JJ5FQNnq73IM
	 UDBDKdjPOd5yq2jKDORPHCbZu3Pg2VvZgyLAc7LYzVw3qLmU/hUP2OtiOYMrAnOUSZEHM
	 l7xGtwAZz6wsJqV9G+8NlyyBOxOhbgm3A9X7jviNEVSoA8+zoGGXYXo1+ss1vhYJCjaZu
	 H5qn5WL/8DuLOsYc90y7SXoN7VyJgEicFcvaB1AgkJpZ4CyItLYXmdf+vNpt4g+D1zTXx
	 QN8bAsp3fDh7lSW3Hsa1xGWRNRn7/9ibAk47vR3b0+QIGaYggcIRpaLQMepgXACt/Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eCC0oJnw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB477606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eCC0oJnw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B00F1F01828;
	Sat, 24 Oct 2026 09:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832531;
	bh=T6klcvmgP9sRTV5pY3hh0G0OuU29QLHZIFXmykc2zJ8=;
	h=Date:To:From:Subject;
	b=eCC0oJnw/qnM7Z+1n/+/YOzkSs8cCNEBj96cCcFrdQkJh2kIBuygx3xbAEm92gDsK
	 tfY2LCe5wLFKhj5XYot7YpX6wJI/zTz3pI+RMmcCRYzymCvJE3JauaWc958WSFu1iX
	 s1NRBLAgqQROWkYcEHmks7Vl/EKJSOFVGxSndqpg=
Date: Sat, 24 Oct 2026 02:02:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,mj0123.lee@samsung.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,david@kernel.org,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch removed from -mm tree
Message-Id: <20261024090211.7B00F1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: bdi: reset min_ratio after the sysfs attributes are gone
has been removed from the -mm tree.  Its filename was
     mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jan Kara <jack@suse.cz>
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

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

