Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2097425B31D
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753484826; cv=none; b=NFN5NVoFbyuG7PQDb9xOduekpb4cjkhD5QzGKPJfb/za+FH7qTvdJzh3+hreyFAKEldHp2ZbVS1AC53bKkcfRD792m6Ddh/H478sOcbRIkLGJk8Jb3RHUAk95kzKbTL6szWrc9/KR1CTvD0Bksjf+fbk9XLfjQveb5Z00L2/FEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753484826; c=relaxed/simple;
	bh=hg2frJ98c9X3CLGiPeo5stS+F14FN2oAAPoKdb1ynLE=;
	h=Date:To:From:Subject:Message-Id; b=inbVX3so9Y/m+meMurWHIdc/jGfmp1Azq4UfbLI76zRMjKFeZizGBgfVO98B0OGLJE0GmJX9mKOjo0GPxqkPmLufiEgOMG/bI/kdouvTGIpV+lnolEZJfALezbsUl757xfURKcE8K4Ar+LLl+1+Mk3yJyccGUR5sOKAzV7Y4OIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HVOoah7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HVOoah7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869F2C4CEE7;
	Fri, 25 Jul 2025 23:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753484825;
	bh=hg2frJ98c9X3CLGiPeo5stS+F14FN2oAAPoKdb1ynLE=;
	h=Date:To:From:Subject:From;
	b=HVOoah7kNIy5UBl3JVUX9eyjdy+kv8fLDSHjyjwunq1xrhM3GzildO4MJEB3nX2QH
	 7eTo/3aRf9OKFvGVOwuQZ46nrDnQahg8mS3t954BJ5CgCpeRVJh9PJ2OecJnJgm0y/
	 0UasqfFI63hUxD0mUynno/s19wAFSUUkHvQOCCnY=
Date: Fri, 25 Jul 2025 16:07:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,liushixin2@huawei.com,jack@suse.cz,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-consider-disabling-readahead-if-there-are-signs-of-thrashing.patch removed from -mm tree
Message-Id: <20250725230705.869F2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: consider disabling readahead if there are signs of thrashing
has been removed from the -mm tree.  Its filename was
     mm-consider-disabling-readahead-if-there-are-signs-of-thrashing.patch

This patch was dropped because an updated version will be issued

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


