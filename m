Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB21347C3
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755323211; cv=none; b=uMMlhehTgPxXCGX6ST0tFepzoUfAKyTnwNJWOiia3YVXdvPr+0NpXxiA8U6KFB211/TK7XCX3bAdXP6fV+viCjApWuSLg3YPj+fvZwIvgy5Cmdm514LSR53G7b6qgZPxuwn3gqg06kGLFRzrKTpFDtvXJxdXU+EH0uu7a0dzSvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755323211; c=relaxed/simple;
	bh=CoPZbM8jnvvdhGMEHf8hpPvkCXVPv5ZTOL70r6pdM48=;
	h=Date:To:From:Subject:Message-Id; b=KxEafwXKIEhyMOqxbH7IA0DOcg9jp5Ox+KlD8ZmOSU2N7+sMXh0JZRa4cvtDVD2tVy6l83D0QBesxK40oDH64syCDKW39L7KQzqgXfUgPThZj4EGjJSE6k04pJhZqVmg+YZLjUnZzEZh64KhT19yEjC0qkxs6wyrO+V/+ZVSxdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X0XJiJdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X0XJiJdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626ADC4CEEF;
	Sat, 16 Aug 2025 05:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755323211;
	bh=CoPZbM8jnvvdhGMEHf8hpPvkCXVPv5ZTOL70r6pdM48=;
	h=Date:To:From:Subject:From;
	b=X0XJiJdBlIGa+CU7Q41EhQHJPRSyC0e1msk8vf/+0IL9mGjhPQAm0rzIq1b0gN1LG
	 94DKEI5tr154G15Mep+fkNWyemQPySyh5DxYe+ztHbwj1s16jgbgmby9g0Yu0MYPqh
	 9yYTf4rsM9cGyVMVQSazzoakqiHiK3ijK7Tcp2WA=
Date: Fri, 15 Aug 2025 22:46:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-improve-mmap_miss-heuristic-for-concurrent-faults.patch added to mm-new branch
Message-Id: <20250816054651.626ADC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: readahead: improve mmap_miss heuristic for concurrent faults
has been added to the -mm mm-new branch.  Its filename is
     mm-readahead-improve-mmap_miss-heuristic-for-concurrent-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-improve-mmap_miss-heuristic-for-concurrent-faults.patch

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
Subject: mm: readahead: improve mmap_miss heuristic for concurrent faults
Date: Fri, 15 Aug 2025 11:32:24 -0700

If two or more threads of an application faulting on the same folio, the
mmap_miss counter can be decreased multiple times.  It breaks the
mmap_miss heuristic and keeps the readahead enabled even under extreme
levels of memory pressure.

It happens often if file folios backing a multi-threaded application are
getting evicted and re-faulted.

Fix it by skipping decreasing mmap_miss if the folio is locked.

This change was evaluated on several hundred thousands hosts in Google's
production over a couple of weeks.  The number of containers being stuck
in a vicious reclaim cycle for a long time was reduced several fold
(~10-20x), as well as the overall fleet-wide cpu time spent in direct
memory reclaim was meaningfully reduced.  No regressions were observed.

Link: https://lkml.kernel.org/r/20250815183224.62007-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-readahead-improve-mmap_miss-heuristic-for-concurrent-faults
+++ a/mm/filemap.c
@@ -3324,9 +3324,17 @@ static struct file *do_async_mmap_readah
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
 
-	mmap_miss = READ_ONCE(ra->mmap_miss);
-	if (mmap_miss)
-		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
+	/*
+	 * If the folio is locked, we're likely racing against another fault.
+	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
+	 * times for a single folio and break the balance with mmap_miss
+	 * increase in do_sync_mmap_readahead().
+	 */
+	if (likely(!folio_test_locked(folio))) {
+		mmap_miss = READ_ONCE(ra->mmap_miss);
+		if (mmap_miss)
+			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
+	}
 
 	if (folio_test_readahead(folio)) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-readahead-improve-mmap_miss-heuristic-for-concurrent-faults.patch

