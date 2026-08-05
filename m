Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59493AE18A;
	Wed,  5 Aug 2026 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785955684; cv=none; b=TKw3he0f8T5dIsPkXc6gf8cErvd1vAq2ky16WW1Qu5nZ6KuROSXEhv053alRHz2qST76+OtAWL5O9TPThRHl1TNukRzIYxP0eWv46EpHBrfOF6VZiowcCaDkwsRzRfmwmgoOPHg1CFLvvlA2RVYWZ3P1kNqZ2JYVItZH2TkpsZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785955684; c=relaxed/simple;
	bh=mM0lBjBojmqaUkHGF0MxkvHPSuIzasiW1rVh8jtPd7U=;
	h=Date:To:From:Subject:Message-Id; b=fh3xeBalxfupazbdcdhwotIYTpRDaABAPDDBn9QzGnK/iHPrD72WvqV6FZnwbuHVFsFpowrLjgrhjK5SwZhzraz3sNLN6L6uhLFmcIXt8HfyAL1eircJiFgtyv/rvdFw/FLmfl3DhPM93vHuRVZotUHY7XNJT2N/g5nwlyQn+MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mb+l3fV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mb+l3fV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F171F00A3A;
	Wed,  5 Aug 2026 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785955683;
	bh=4Four82+DJFUfCyi+3r4OGFOxvNlL6ygwzwPgPt3wis=;
	h=Date:To:From:Subject;
	b=mb+l3fV6G2QoHQUz08HjLOR/yjz2qfyw8NokJ3/0O5q9Qp6GY1+WIJQlkljdFwnTW
	 A9n56bssSbIZvhOiVrqGkh98i6pCDXnPlxCkBAIZh4BxLGiAw2wQJl6RtCqD/llFXM
	 y6kFsWBfbh603LoOYGNSzaTAYNjrF+AObBFmMnqA=
Date: Wed, 05 Aug 2026 11:48:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-reject-disksizes-that-exceed-slot-index-range.patch added to mm-new branch
Message-Id: <20260805184803.00F171F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: reject disksizes that exceed slot index range
has been added to the -mm mm-new branch.  Its filename is
     zram-reject-disksizes-that-exceed-slot-index-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-reject-disksizes-that-exceed-slot-index-range.patch

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: zram: reject disksizes that exceed slot index range
Date: Tue, 4 Aug 2026 22:38:32 +0800

zram uses u32 slot indexes, while disksize_store() accepts a u64 size.  On
32-bit systems, a disksize larger than U32_MAX pages is truncated when
zram_meta_alloc() assigns the page count to size_t.  array_size() then
sees only the truncated count, so a small table can be allocated while the
original capacity is published.  Valid I/O within that capacity can
subsequently access beyond zram->table.

The same oversized capacity also lets full-device scanners compare a u32
index with an upper bound larger than U32_MAX, so the index can wrap
instead of terminating.

Reject disksizes larger than U32_MAX pages before aligning and allocating
the table.  This keeps the table size, published capacity and slot index
range consistent.

Link: https://lore.kernel.org/20260804143832.146129-1-xialonglong2025@163.com
Fixes: 33863c21e69e ("Staging: zram: Replace ioctls with sysfs interface")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-reject-disksizes-that-exceed-slot-index-range
+++ a/drivers/block/zram/zram_drv.c
@@ -2881,6 +2881,9 @@ static ssize_t disksize_store(struct dev
 		return -EBUSY;
 	}
 
+	if (disksize > (u64)U32_MAX << PAGE_SHIFT)
+		return -EINVAL;
+
 	disksize = PAGE_ALIGN(disksize);
 	if (!zram_meta_alloc(zram, disksize))
 		return -ENOMEM;
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch
zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch
zram-reject-disksizes-that-exceed-slot-index-range.patch

