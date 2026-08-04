Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57793314C4;
	Tue,  4 Aug 2026 20:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785874256; cv=none; b=s/ytNg+H12HSIBrqdw3Z1/fd6ZEJL4ya2E4OlTX98JLEM4PqXX83uB1na61/OevbxvY+A4asWiiHPYqHgJ+oPe5Cork6A7We2G7jjbUmQijzRecaV5RHhsn+h6TMUMae8JpT6qZkMw8BUS8YqzEgzdcgmhJzGq+Ii8aZ0vDWjP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785874256; c=relaxed/simple;
	bh=T7nmMAk59SNDivRK0G2GHNfk5LxBtLamPl7hg0gBg+I=;
	h=Date:To:From:Subject:Message-Id; b=jOCMxb3cOpHDWMAf9xSMF5aPfEp1JmhSvVtbeZJXPE2P8zaeajvJCOT+0FCRdKGB4kCDFIK8QDNmABd5PUEhbjjj5VAMsVpGVnydvHbU3SXWGc/FcOfxyyjaWrtv+KwLJ4pgsSNQ5SpCsmja4aYflwMaEgWejKt9+Ejj4H/ibl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWRHAlBh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWRHAlBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AF21F000E9;
	Tue,  4 Aug 2026 20:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785874254;
	bh=vOgIvI/GUR47yVOT5RxRKwEaNJeYF7UKRzFIhAV8oE8=;
	h=Date:To:From:Subject;
	b=uWRHAlBhuiZUoxvGRCstexT+RqvHxnUUGoB5ffnmx2A2K5wSYWnebaELZMFVvVgpM
	 UqYDBLQHEaBJSZAG8qygV4LCuLYvOSqg07cf4bO2yt3KPqqO5vAzJ7h2voFyz2eyT2
	 HVLR8WxWtUAA5f8Te+DYKHoiPxXAa0TyWD/jJTbo=
Date: Tue, 04 Aug 2026 13:10:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-out-of-bounds-access-in-writeback_store.patch added to mm-new branch
Message-Id: <20260804201054.43AF21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix out-of-bounds access in writeback_store()
has been added to the -mm mm-new branch.  Its filename is
     zram-fix-out-of-bounds-access-in-writeback_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-out-of-bounds-access-in-writeback_store.patch

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
Subject: zram: fix out-of-bounds access in writeback_store()
Date: Tue, 4 Aug 2026 14:59:18 +0800

Patch series "zram: fix stale scan bounds after reinitialization".

Both writeback_store() and read_block_state() derive their table scan
bounds from zram->disksize before acquiring dev_lock.  If the device is
reset and reinitialized with a smaller disksize between that read and lock
acquisition, the bound can describe the old table while the scan operates
on the new one.  This can lead to out-of-bounds slot accesses.

Move both bound calculations under dev_lock so each bound remains
consistent with the table throughout its scan.  Keep the fixes separate
because the affected interfaces originate from different commits and can
be backported independently.


This patch (of 2):

writeback_store() calculates the table scan bounds before taking dev_lock.
A reset followed by reconfiguration with a smaller disksize can therefore
replace zram->table while writeback_store() is waiting for the lock.  Once
it acquires the lock, it sees an initialized device but scans the new
table using the old upper bound, resulting in an out-of-bounds access.

Calculate the number of pages while holding dev_lock so the scan bound
matches the table protected by the lock.

Link: https://lore.kernel.org/20260804065919.3970386-1-xialonglong2025@163.com
Link: https://lore.kernel.org/20260804065919.3970386-2-xialonglong2025@163.com
Fixes: a939888ec38b ("zram: support idle/huge page writeback")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-out-of-bounds-access-in-writeback_store
+++ a/drivers/block/zram/zram_drv.c
@@ -1235,8 +1235,8 @@ static ssize_t writeback_store(struct de
 			       const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
-	unsigned long lo = 0, hi = nr_pages;
+	u64 nr_pages;
+	unsigned long lo = 0, hi;
 	struct zram_pp_ctl *pp_ctl = NULL;
 	struct zram_wb_ctl *wb_ctl = NULL;
 	char *args, *param, *val;
@@ -1250,6 +1250,9 @@ static ssize_t writeback_store(struct de
 	if (!zram->backing_dev)
 		return -ENODEV;
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+	hi = nr_pages;
+
 	pp_ctl = init_pp_ctl();
 	if (!pp_ctl)
 		return -ENOMEM;
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch
zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch

