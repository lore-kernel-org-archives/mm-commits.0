Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866287D41D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103989; cv=none; b=OidYqjGWJ51u5Pc/ZWfpZm1pcTSrXH6iycLHwIpoUsR7w1VsqI3il3/ldoZ0VvCjB/iLZj29MCHKVZGZDw8T62AkEUtFtFUOnqD7aypSDufB6/04qmwXJQslonqCDV/zjdeWRj8AjeT3Xnij12uzjnFcib5OiTJXkTaA1isxoU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103989; c=relaxed/simple;
	bh=vyfAg77Vj8pzxL2ki089/sJ5lEvHGEVZ74w4L/Hhw7I=;
	h=Date:To:From:Subject:Message-Id; b=G7jkVDDk7udRdbvND6xDuk6SVBO4zs6xfUTO/ut3GFBNTWRxn0YekoYtvRysRqgtG3kqdW70NLOBYjN9fSuHuFd0jxqJ6XxKOKP7rnbGRGl1ffDxl2o44bkcnpTDhY8eueYJY0xs7FCJtJY3Pdbajh+cBuTR7a72TfzK39pBWp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1PE1yXDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1PE1yXDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0A9C113CD;
	Fri, 26 Apr 2024 03:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103989;
	bh=vyfAg77Vj8pzxL2ki089/sJ5lEvHGEVZ74w4L/Hhw7I=;
	h=Date:To:From:Subject:From;
	b=1PE1yXDsfprQr30MDTCEs5ZRu2TiqH6LN8u7IyC9ArDWh0M0qo3mjcDYbJugz3ub/
	 eTypbOKAIhGeL+9ddadhVwQe689qVs8arlreFycArTjKVjQnDl5f6Cckbc0aW++jBz
	 W0I5TnuzsobuQPFM3BrSRCGBIzNrt/wqgZx5AAtU=
Date: Thu, 25 Apr 2024 20:59:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch removed from -mm tree
Message-Id: <20240426035949.5F0A9C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: return early if failed to allocate memory for split
has been removed from the -mm tree.  Its filename was
     mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/filemap: return early if failed to allocate memory for split
Date: Tue, 16 Apr 2024 01:18:53 +0800

Patch series "mm/filemap: optimize folio adding and splitting", v4.

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

The performance is better for both 4K (+7.5%) and THP (+12.5%) cached read.


This patch (of 4):

xas_split_alloc could fail with NOMEM, and in such case, it should abort
early instead of keep going and fail the xas_split below.

Link: https://lkml.kernel.org/r/20240416071722.45997-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240415171857.19244-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240415171857.19244-2-ryncsn@gmail.com
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


