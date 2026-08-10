Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B000F3A1A54
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402473; cv=none; b=F6z1vRwVPEf4T1X2LRGU3iGnbpWCUd3zMva4KpT5W/SMWnXuFnMy87u8PmlecHIaz4i0momM3MBwBxrXvXmaR66m7ePr8SDE1vDtd8fWiuIICgGQDlIzG37YF7Wn8Q4ezcrQ6GF6pV81zh9ntPnq4TarjwxpTKPobGfMqr89x0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402473; c=relaxed/simple;
	bh=EmPrk/zgSFFy//IzmA6AoLUcqrDV42yrFd/w6Hx0lIo=;
	h=Date:To:From:Subject:Message-Id; b=tT2A8pOwJDtLL4yDNFO7t6/cWQ0mPBG3S5PO8+p30kelOaLeVREqLMRakPu9R2Q7gGINjjR28OjXGMkTKj658qoTzoNMcIulb56WT6yRRgRlF/8RM7ShScDtSIaAYETqy1cKKw0hdu64P90phvFrwGmctBjiRCNE7knPScyS2cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UjDZ+RuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UjDZ+RuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2533B1F000E9;
	Mon, 10 Aug 2026 22:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786402472;
	bh=i/9npYiVWiU8dRnODPIIn2tVDfi7SieXaxV2MV1KoXw=;
	h=Date:To:From:Subject;
	b=UjDZ+RuYchhpVIfPgNJiyzjVtiS3QNkPczt5WPAd2BuZx1cRQ+k5pFpty6aC09aIV
	 3YeUEDVUXbS2YqDYkbRMaicHclyDHXy9r8ulS+nf8Tf1F3Pb5lQjWyStA2gZESGpgt
	 X0Sk5nKQcz+XTWAKdVPM9O+OR7lWLjghKn6scXGY=
Date: Mon, 10 Aug 2026 15:54:31 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,shikemeng@huaweicloud.com,sfrench@samba.org,ryncsn@gmail.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch added to mm-new branch
Message-Id: <20260810225432.2533B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: revert to single-folio writes for synchronous swap devices
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swap: revert to single-folio writes for synchronous swap devices
Date: Thu, 23 Jul 2026 07:46:04 +0200

Patch series "swap_ops updates", v2.

This series is a follow on to the swap ops series now in mm-unstable.

The first patch reintroduces direct folio writes for synchronous
swap files, the other two remove the double indirect for file
system based swap.


This patch (of 3):

Kairui Song reported that zram benefits from submitting each folio
directly instead of batching up I/O because the classic LRU scanning
benefits from clearing the folio writeback bit in the scan loop.

Accommodate that by kicking off writes for synchronous devices for each
iteration.

Link: https://lore.kernel.org/20260723054622.3460249-1-hch@lst.de
Link: https://lore.kernel.org/20260723054622.3460249-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/page_io.c~mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices
+++ a/mm/page_io.c
@@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_i
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+
+	/*
+	 * Write out the iocb if we filled it, or if the device is synchronous.
+	 *
+	 * The latter is to work around expectations in the classic LRU code
+	 * which make synchronous clearing of the folio writeback flag in the
+	 * reclaim path beneficial.
+	 */
+	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) ||
+	    (rw == WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
 		if (rw == WRITE)
 			swap_write_submit(ctx);
 		else
_

Patches currently in -mm which might be from hch@lst.de are

shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch
mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch
mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch
mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap.patch

