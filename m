Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0048C2579
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711389287; cv=none; b=kiJDQto5zNvVG9uxnJMJm2b1TedTQeb2UlegjBo3u2iTB84HR76VUMrM1x4kZQrTvAL35LUwVhPmdvSosL062ZdTla46AJeNDqCcZz5cBA0Kx2qEPorz3+6FQcB9jc+vodfZdbhYadJVX3AELDUUzypyeU1u/n83J57A84s1MhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711389287; c=relaxed/simple;
	bh=2oZ9TD9aX8Nf1mz8FgL/V4MszUpszECcQ1AmJWIKliY=;
	h=Date:To:From:Subject:Message-Id; b=qtcENVvTLPUryScSC9Tdw9QuxONhvkMFlIfeIT3FJKbSI/ltH6mq3LF2tFJeLisTEcxE+Y+Dp33Ay0uaQPoiTQCv0YRbfJ7l/AP5KjjKyKVAEf4ZW4p1Xx8bdnK6cyrqizP7O8HWHb/VjJqHFqutGByonasqNR6tTbzX75vhAus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dG7Ao9zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dG7Ao9zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF82C43390;
	Mon, 25 Mar 2024 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711389286;
	bh=2oZ9TD9aX8Nf1mz8FgL/V4MszUpszECcQ1AmJWIKliY=;
	h=Date:To:From:Subject:From;
	b=dG7Ao9zSJGQhIfey9HIjJNGBiI3utruNM5SKbiCni9TjteKGDMmdd4dXqEYckA2L6
	 uVlqBZuqUpx7Zy1iMGuQreiVasKZzDtvrxIGGpvuobyeNl7ewpqMrUSP6jyiwww3xA
	 o0Wxq2pcCvAc4WQ/Fc+hTCfFvsdxJJK8mbwHc98o=
Date: Mon, 25 Mar 2024 10:54:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch added to mm-unstable branch
Message-Id: <20240325175446.5DF82C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: return early if failed to allocate memory for split
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/filemap: return early if failed to allocate memory for split
Date: Tue, 26 Mar 2024 01:14:02 +0800

Patch series "mm/filemap: optimize folio adding and splitting", v2.

Currently, at least 3 tree walks are needed for filemap folio adding if
the folio is previously evicted.  One for getting the order of current
slot, one for ranged conflict check, and one for another order retrieving.
If a split is needed, more walks are needed.

This series is trying to merge these walks, and speed up
filemap_add_folio, I see a 7.5% - 12.5% performance gain for fio stress
test.

So instead of doing multiple tree walks, do one optimism range check with
lock hold, and exit if raced with another insertion.  If a shadow exists,
check it with a new xas_get_order helper before releasing the lock to
avoid redundant tree walks for getting its order.

Drop the lock and do the allocation only if a split is needed.

In the best case, it only need to walk the tree once.  If it needs to
alloc and split, 3 walks are issued (One for first ranged conflict check
and order retrieving, one for the second check after allocation, one for
the insert after split).

Testing with 4K pages, in an 8G cgroup, with 16G brd as block device:

  echo 3 > /proc/sys/vm/drop_caches

  fio -name=cached --numjobs=16 --filename=/mnt/test.img \
    --buffered=1 --ioengine=mmap --rw=randread --time_based \
    --ramp_time=30s --runtime=5m --group_reporting

Before:
bw (  MiB/s): min= 1027, max= 3520, per=100.00%, avg=2445.02, stdev=18.90, samples=8691
iops        : min=263001, max=901288, avg=625924.36, stdev=4837.28, samples=8691

After (+7.3%):
bw (  MiB/s): min=  493, max= 3947, per=100.00%, avg=2625.56, stdev=25.74, samples=8651
iops        : min=126454, max=1010681, avg=672142.61, stdev=6590.48, samples=8651

Test result with THP (do a THP randread then switch to 4K page in hope it
issues a lot of splitting):

  echo 3 > /proc/sys/vm/drop_caches

  fio -name=cached --numjobs=16 --filename=/mnt/test.img \
      --buffered=1 --ioengine=mmap -thp=1 --readonly \
      --rw=randread --time_based --ramp_time=30s --runtime=10m \
      --group_reporting

  fio -name=cached --numjobs=16 --filename=/mnt/test.img \
      --buffered=1 --ioengine=mmap \
      --rw=randread --time_based --runtime=5s --group_reporting

Before:
bw (  KiB/s): min= 4141, max=14202, per=100.00%, avg=7935.51, stdev=96.85, samples=18976
iops        : min= 1029, max= 3548, avg=1979.52, stdev=24.23, samples=18976·

READ: bw=4545B/s (4545B/s), 4545B/s-4545B/s (4545B/s-4545B/s), io=64.0KiB (65.5kB), run=14419-14419msec

After (+10.4%):
bw (  KiB/s): min= 4611, max=15370, per=100.00%, avg=8928.74, stdev=105.17, samples=19146
iops        : min= 1151, max= 3842, avg=2231.27, stdev=26.29, samples=19146

READ: bw=4635B/s (4635B/s), 4635B/s-4635B/s (4635B/s-4635B/s), io=64.0KiB (65.5kB), run=14137-14137msec

The performance is better for both 4K (+7.5%) and THP (+12.5%) cached
read.


This patch (of 4):

xas_split_alloc could fail with NOMEM, and in such case, it should abort
early instead of keep going and fail the xas_split below.

Link: https://lkml.kernel.org/r/20240325171405.99971-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-return-early-if-failed-to-allocate-memory-for-split
+++ a/mm/filemap.c
@@ -880,9 +880,12 @@ noinline int __filemap_add_folio(struct
 		unsigned int order = xa_get_order(xas.xa, xas.xa_index);
 		void *entry, *old = NULL;
 
-		if (order > folio_order(folio))
+		if (order > folio_order(folio)) {
 			xas_split_alloc(&xas, xa_load(xas.xa, xas.xa_index),
 					order, gfp);
+			if (xas_error(&xas))
+				goto error;
+		}
 		xas_lock_irq(&xas);
 		xas_for_each_conflict(&xas, entry) {
 			old = entry;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch
mm-filemap-clean-up-hugetlb-exclusion-code.patch
lib-xarray-introduce-a-new-helper-xas_get_order.patch
mm-filemap-optimize-filemap-folio-adding.patch

