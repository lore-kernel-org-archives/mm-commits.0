Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640266;
	b=i4OfkeHrNZGZbCvcAI3VXaKSeQJ8IAN4TIVFBW0lMRQWCiyiZNgKfpsKTRrRpjT4vZth
	 9nCh0UsiLKbnPCxiXKsXIQev+48gRQtCgeHRxUyBr7y5ag5MK63p1aK+fuoKZ1Pg1XwTV
	 WNvslfnsL46cuUfBVp1ZIOvdFioSY9yR4wgiLc/r+rKoXTS/n2R/1I100ZNPwkerBZyVc
	 U5xpB26pGjW2ZaAGSXQqwJPFeiG5TlrbCx81HLgAUDzR0dnKQa7C8GxsGz7OvjJcuOXqU
	 WGR6tQQhZxE64ckVpHt1+E9vE99YWRE9pW5U4eoE4MuNo1aDtverUV9l19HZDkEQ0Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640266;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Sd3dzq3mnppggMcQwv4IxmzTiMQsn1X+F2e0bjo5/W0=;
	b=FRcIpAM3sFXZo0Ck8jEkjGc+Y6UFG0PAT//jelRsDnzH4NHPcjoge/micfTJOqKAjpYR
	 6lRXZAqpQ7IsRYyOr02EZDOuAC1Bo+808lk3Oep/sYSoPdAY6akBbjbvysqNNAldDdAHx
	 HXdcDeUpLDGHv8kio/aKa86gmPuru4r8MbhYn4Br+pV/63RjZ+99uY68+DFzm1Gx5jenz
	 v5KTSgml5IR8jojJ7SAaePQMtnQJTUjMice1SKezKd/D0Fs27HfRQndUstvaJjS5Q70nk
	 7fgxHdQeZZVn0Wlvm/dUw5s6hyLanh+aqhLOP/GhnL5YlLDcodt2krsevpDlo0DZSog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xh7o1zWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A62B606B92E
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xh7o1zWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9B21F00A28;
	Mon,  2 Nov 2026 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640266;
	bh=Sd3dzq3mnppggMcQwv4IxmzTiMQsn1X+F2e0bjo5/W0=;
	h=Date:To:From:Subject;
	b=xh7o1zWEG/na3PwgX0l36fbxVQvEpuvQA+8tmQHjtdvgQsJZSDpFhEGALZ+NjVv3V
	 yOJmZgHo4sutmEf9qT55RRaDh3XLfocn5R9sdgf1r1lYWDA1EM3eXsVLBAECMa68rx
	 9xEdEWAzu24BBAS2sJKn1hG74/a+i0EsCd/INx60=
Date: Mon, 02 Nov 2026 09:24:25 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,sh@gentwo.org,
	ruanjinjie@huawei.com,manuelebnerli@mailbox.org,lienze@kylinos.cn,
	jaeyeon.lee.dev@gmail.com,adrianhuang0701@gmail.com,jm5905938@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch added to mm-new branch
Message-Id: <20261102172426.0C9B21F00A28@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/stat: avoid 32-bit overflow in idle percentiles
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Mon, 02 Nov 2026 07:07:51 -0800

On 32-bit, accounted_bytes * 100 can wrap before division by total_sz.
Some entries in memory_idle_ms_percentiles then keep their old values
instead of being updated.

For example, a 256 MiB i386 QEMU guest reported p0=19200 ms, but p50 and
p100 were both zero.  The issue was also shared with another mail [1].

Cast accounted_bytes to u64 before multiplying and use div64_ul() for
the division. Compute the percentage once per region.

Link: https://lore.kernel.org/20261102150757.93058-5-sj@kernel.org
Link: https://lore.kernel.org/r/CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com [1]
Link: https://lore.kernel.org/179207592479.3.11595453180868898703@gmail.com
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
---

 mm/damon/stat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles
+++ a/mm/damon/stat.c
@@ -114,7 +114,7 @@ static void damon_stat_set_idletime_perc
 {
 	struct damon_region **sorted_regions, *region;
 	int nr_regions;
-	unsigned long total_sz, accounted_bytes = 0;
+	unsigned long total_sz, accounted_bytes = 0, percentile;
 	int err, i, next_percentile = 0;
 
 	err = damon_stat_sort_regions(c, &sorted_regions, &nr_regions,
@@ -124,7 +124,8 @@ static void damon_stat_set_idletime_perc
 	for (i = 0; i < nr_regions; i++) {
 		region = sorted_regions[i];
 		accounted_bytes += region->ar.end - region->ar.start;
-		while (next_percentile <= accounted_bytes * 100 / total_sz)
+		percentile = div64_ul((u64)accounted_bytes * 100, total_sz);
+		while (next_percentile <= percentile)
 			memory_idle_ms_percentiles[next_percentile++] =
 				damon_stat_idletime(region) *
 				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch

