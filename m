Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63662FCFC4
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 20:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752181072; cv=none; b=c7uim011L0fSt8nGVSYInjV2Cjx5ql5gqWc2tEIf2LvG/brPRG7SfuomTIfUhE7EUXMJQ42t1UnsqJevJwBUblIlCNf0hIZjdkVRMeoQRQt4eSDFjP4uw/oBcS/0U+39HQqYcm8kXUfJPAibh6Wr5ArYrkklOinqaej8GNGDliU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752181072; c=relaxed/simple;
	bh=PEH/dLEhEMKpQBB4oZJ2NAuu0+Aqnr5oYe8AOov6EtU=;
	h=Date:To:From:Subject:Message-Id; b=L+pPKUfm1UJLHxb65RjHK5XbCs4iULr8SQCOlcfdI/lPQJxwldGmmI6dlrixGHTS3phjZ7gVFEuFItWcFhA3X6hriwsJgNoGr2M1It4xqjIl1bgZvWADv+ZRlpMgT/uElIFRaU05HH97Rc7jQC5YBlOYAjNmh/QPMTzhHWnPdng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZaYpcayK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZaYpcayK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C769C4CEE3;
	Thu, 10 Jul 2025 20:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752181072;
	bh=PEH/dLEhEMKpQBB4oZJ2NAuu0+Aqnr5oYe8AOov6EtU=;
	h=Date:To:From:Subject:From;
	b=ZaYpcayKdv2b1vfzt6kl49S21RPQPN1GkzBGF7kTSMWV2iU6ePBL0bqNs27kVgy4c
	 KyewiCgxQtKdnzuW/03qp4e9D+zy1hrEeENAHo3mlEsUK4EcTU4LS8MEy65+U0HPsz
	 6Ol5a+t5rNdhsc3b6g1EjEbSIDnd8XJfW99fEuak=
Date: Thu, 10 Jul 2025 13:57:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,liushixin2@huawei.com,jack@suse.cz,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consider-disabling-readahead-if-there-are-signs-of-thrashing.patch added to mm-new branch
Message-Id: <20250710205752.2C769C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: consider disabling readahead if there are signs of thrashing
has been added to the -mm mm-new branch.  Its filename is
     mm-consider-disabling-readahead-if-there-are-signs-of-thrashing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consider-disabling-readahead-if-there-are-signs-of-thrashing.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: consider disabling readahead if there are signs of thrashing
Date: Thu, 10 Jul 2025 12:52:32 -0700

We've noticed in production that under a very heavy memory pressure the
readahead behavior becomes unstable causing spikes in memory pressure and
CPU contention on zone locks.

The current mmap_miss heuristics considers minor pagefaults as a good
reason to decrease mmap_miss and conditionally start async readahead. 
This creates a vicious cycle: asynchronous readahead loads more pages,
which in turn causes more minor pagefaults.  This problem is especially
pronounced when multiple threads of an application fault on consecutive
pages of an evicted executable, aggressively lowering the mmap_miss
counter and preventing readahead from being disabled.

To improve the logic let's check for !uptodate and workingset folios in
do_async_mmap_readahead().  The presence of such pages is a strong
indicator of thrashing, which is also used by the delay accounting code,
e.g.  in folio_wait_bit_common().  So instead of decreasing mmap_miss and
lower chances to disable readahead, let's do the opposite and bump it by
MMAP_LOTSAMISS / 2.

Link: https://lkml.kernel.org/r/20250710195232.124790-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/filemap.c~mm-consider-disabling-readahead-if-there-are-signs-of-thrashing
+++ a/mm/filemap.c
@@ -3324,6 +3324,17 @@ static struct file *do_async_mmap_readah
 		return fpin;
 
 	mmap_miss = READ_ONCE(ra->mmap_miss);
+	if (unlikely(!folio_test_uptodate(folio) &&
+		     folio_test_workingset(folio))) {
+		/*
+		 * If there are signs of thrashing, take a big step
+		 * towards disabling readahead.
+		 */
+		mmap_miss += MMAP_LOTSAMISS / 2;
+		mmap_miss = min(mmap_miss, MMAP_LOTSAMISS * 10);
+		WRITE_ONCE(ra->mmap_miss, mmap_miss);
+		return fpin;
+	}
 	if (mmap_miss)
 		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-consider-disabling-readahead-if-there-are-signs-of-thrashing.patch

