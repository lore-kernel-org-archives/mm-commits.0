Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9381636F421
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622918; cv=none; b=jqSGkRWXoACl3fT2VfIn24KjEZTGjoniYLBR191pPgcHq1CUqyd5/BmaSAtgxYEE3gGgIpnWgr5ogdwQylTKxDQo7Hc3/XHO5LxRgDRXsPL8dkyAsGX9XyAmOq8cO1drKGr0agTant+FA/QsJoqFytjxoW3+0Qtm53CNBgymhno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622918; c=relaxed/simple;
	bh=makfLUsq3gGlwSWWTFcLbBJn0/4XoHW4npbAmXBY4KE=;
	h=Date:To:From:Subject:Message-Id; b=hbkqzjQ4Vc0tccc5PgJ9MaxDx1a5k1oSOJUfXJVnk9ThwM3K4iFI+imXnHaO0p0Rdq1KIAvwbc9IyAiVmrOUi84lguXDv/HPmk292hnVH6KLdFs5Ft8vEFIkdYhVfnhQToGkG1ngYg0pYZW95KUPozjNknor34+luxVo9ayWCGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8gUKaM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8gUKaM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CA31F000E9;
	Tue, 25 Aug 2026 01:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622916;
	bh=rLxSn68NlsWA5o0J4W8XYhgOZ2nvxTstHvuwegzK6JE=;
	h=Date:To:From:Subject;
	b=N8gUKaM/cNHoWAdiY5jI+WPpm7I9IBVcmziKeyJzVbJCL1BXPbJ7WZJ5Od1nY6gwe
	 r+oeHwHJQEdnumWENapljZ5Zx5VFSkBuXeiirIpxWt3ZUkcA4pN93PQnoC371ysPty
	 qvdK+aQ2waqscgfcVAyyz9daOjroUApzBT1+j4SM=
Date: Mon, 24 Aug 2026 18:55:16 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,shikemeng@huaweicloud.com,sfrench@samba.org,ryncsn@gmail.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch removed from -mm tree
Message-Id: <20260825015516.69CA31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: revert to single-folio writes for synchronous swap devices
has been removed from the -mm tree.  Its filename was
     mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


