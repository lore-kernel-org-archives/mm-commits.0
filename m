Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ECD2641CA
	for <mm-commits@vger.kernel.org>; Fri, 26 Sep 2025 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916910; cv=none; b=DHFfF45qmBZsklfQcPHR+KdaLAskVgsn91FtQ9KmWnjPeVo9+rB6g3ztj19Ftx8awoxoschdIEuczXmndEYZOzGAaRfkmvZKVw5aRxptJxLjG1cBthvewBHAavgc77UXqXAV8CEqoui4qxAEGcCme8boUPqeDe/j68CCy/tLPEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916910; c=relaxed/simple;
	bh=TFFsJ8R1CC1JyppmFbvQbD3uX5GTWTH/+ScdxO2Uf/c=;
	h=Date:To:From:Subject:Message-Id; b=OdOABn6AbnK8+S5DAbmQ7VAxLeCaZJdqFaggC/jL0naeCXfRypuToQYkiLB8UOW0fF8jW32HY2adEgr5IJdxE5jLyyA8oX1+vxSYiE9insvooPyQ4CW/a3qbIF702NhQodY1aZrHkmhidDWk/S4n2wHliW9frN61s0+gLLTuFXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E79dT+3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E79dT+3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A5FC4CEF4;
	Fri, 26 Sep 2025 20:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758916910;
	bh=TFFsJ8R1CC1JyppmFbvQbD3uX5GTWTH/+ScdxO2Uf/c=;
	h=Date:To:From:Subject:From;
	b=E79dT+3iiNrQKcf+GS5zxo7URC7tSDojWcPDSgHdyj4SoaG87anJl4lHHM0ICoFMf
	 QjjRA3BaOKrFhaFOozKSjP7+ubGbiqrqnks0gtoTxzgeYrLmFTuCccalWIC/tXAt0x
	 9nw9whq3twdJdEBFgkET8oKCJ5uxZnwVEbmUYWK4=
Date: Fri, 26 Sep 2025 13:01:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,elver@google.com,david@redhat.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-silence-data-race-in-update_hiwater_rss.patch added to mm-unstable branch
Message-Id: <20250926200150.36A5FC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: silence data-race in update_hiwater_rss
has been added to the -mm mm-unstable branch.  Its filename is
     mm-silence-data-race-in-update_hiwater_rss.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-silence-data-race-in-update_hiwater_rss.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: silence data-race in update_hiwater_rss
Date: Fri, 26 Sep 2025 17:24:26 +0800

KCSAN reports a data race on mm_cluster.hiwater_rss, which can be accessed
concurrently from various paths like page migration and memory unmapping
without synchronization.

Since hiwater_rss is a statistical field for accounting purposes, this
data race is benign.  Annotate both the read and write accesses with
data_race() to make KCSAN happy.

Link: https://lkml.kernel.org/r/20250926092426.43312-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/68d6364e.050a0220.3390a8.000d.GAE@google.com
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-silence-data-race-in-update_hiwater_rss
+++ a/include/linux/mm.h
@@ -2742,7 +2742,7 @@ static inline void update_hiwater_rss(st
 	unsigned long _rss = get_mm_rss(mm);
 
 	if (data_race(mm->hiwater_rss) < _rss)
-		(mm)->hiwater_rss = _rss;
+		data_race(mm->hiwater_rss = _rss);
 }
 
 static inline void update_hiwater_vm(struct mm_struct *mm)
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch
mm-silence-data-race-in-update_hiwater_rss.patch
mm-clean-up-is_guard_pte_marker.patch

