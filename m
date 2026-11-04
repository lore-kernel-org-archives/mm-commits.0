Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777180;
	b=Tj8IvkAIawO+3+v/vYlQ9E3gFKX2F7GZPJdbzaRxt35OCvFcQg0xVr/wugzlapvziJ84
	 9Vxjd23IBxFc+6Emhe3GMhquX7EDQfb6vklL9poDweV0rIEM9dZs0d+0EJcZlBKkxGDI2
	 edPGeXyGT0htpVp+bVCicVgoMWtpuG4O4rcsO/Psy+i3/EMNFZKRD0NiSK9WSK3Kkgs5y
	 9pim9LC4dyD2gp0fCyDypjlCHVsnakLPGRHizhRgZlI5HYkOiue9Rj3aH/PJI9ufRtxAz
	 D4TGBttOdlpyi+TzA1veGkg17UIrBn9tK7nJmgxTTIUF/hRYHRf1dpbma/9tCz9qFsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777180;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6pn/se9i4IkrTuRc0MxRG1wLmkbpCksXbf8iZf7Czew=;
	b=AT41bYKvloKpFSux0GH1IpLD9VRxahGFprcvM4u2nT5uBcuFE9DH8QZBFIvHEL7Cz5rU
	 owuwytZbzak8VsUuUtIuzN7iMSdljLCXV9wNGMsevjuvYc9YJH2hZ5UBZWvmyAThFYFQI
	 lFEblcnQVH9T6E7LXIWecBWtyhCaalAmlxAITgpq4rw91iOLcVU/jHXebrjVjo1af9zbl
	 r3ouQWX7HBCwmc6OYndjTdnc21BjZKbUrt/tyDRxHjHQN1PEAEHn1ftneuU74R1duFkQ6
	 jMByNvPHejmW0WVjmHmZw+gUwRxpRmGEzxf0gfbttT6JSIHO1DEPelJUKOXHsd3EZ3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=raRAhdQj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCC7606A338
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 07:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=raRAhdQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71F91F000C1;
	Wed,  4 Nov 2026 07:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793777179;
	bh=6pn/se9i4IkrTuRc0MxRG1wLmkbpCksXbf8iZf7Czew=;
	h=Date:To:From:Subject;
	b=raRAhdQj1qvI9c1BZ9NzlNYJC2QCjbGEpOmhEI0/+KXAT0X3+upO70TfJN/xAaEbg
	 HBx/VPV7asuuZOHDeP4M/aAsu1i8QQcCJ/Ouq96c4BpsozBnqmex3ZBI2dyO75Xpl3
	 /f4nvXPOMLwinTHFpnJ1y72wI13wy8idtFPk4A6c=
Date: Tue, 03 Nov 2026 23:26:19 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,yosry@kernel.org,
	vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,
	shikemeng@huaweicloud.com,ryncsn@gmail.com,rppt@kernel.org,nphamcs@gmail.com,
	neil@brown.name,mt4022@columbia.edu,mhocko@suse.com,mason@kernel.org,
	ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hch@lst.de,
	hannes@cmpxchg.org,hanchuanhua@oppo.com,david@kernel.org,chrisl@kernel.org,
	chengming.zhou@linux.dev,baoquan.he@linux.dev,baohua@kernel.org,
	josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-account-synchronous-swap-reads-as-memory-stall.patch added to mm-new branch
Message-Id: <20261104072619.D71F91F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/swap: account synchronous swap reads as memory stall
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-account-synchronous-swap-reads-as-memory-stall.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-account-synchronous-swap-reads-as-memory-stall.patch

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/swap: account synchronous swap reads as memory stall
Date: Wed, 04 Nov 2026 00:18:16 +0800

Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
counted in PSI memory pressure or in the swapin and thrashing delays of
delay accounting.  Refaults of the workingset from zram, the main input
to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
become invisible in /proc/pressure/memory.

swap_read_folio() opens the accounting window with
psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
means to count the submission time.  For synchronous devices the
submission is the entire read: swap_bdev_submit_read() does
submit_bio_wait() and completes the folio.  Since reads are batched in
a swap_iocb, swap_read_folio() only queues the folio with
swap_add_folio(), and the bio is submitted later by swap_read_submit()
in the caller, e.g. swapin_sync(), after the window has been closed.
By then the folio is uptodate and unlocked, so the fault does not wait
on the folio lock either and the read time is not counted anywhere.

Fix by submitting synchronous reads from within swap_read_folio(), as
was done before the batching, rather than from the caller.  This gives
up batching of readahead for synchronous devices, which do their I/O
inline anyway, in exchange for keeping the accounting simple and in one
place.

Link: https://lore.kernel.org/20261104-swap-fixes-v2-3-204be064be5b@tencent.com
Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <mason@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/page_io.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/page_io.c~mm-swap-account-synchronous-swap-reads-as-memory-stall
+++ a/mm/page_io.c
@@ -500,6 +500,13 @@ void swap_read_folio(struct swap_io_ctx
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
 
+	/*
+	 * Synchronous devices do the whole read at submission time, submit
+	 * it here so that it is accounted as memory stall and delay.
+	 */
+	if (synchronous)
+		swap_read_submit(ctx);
+
 finish:
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch
mm-swap-account-synchronous-swap-reads-as-memory-stall.patch
zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

