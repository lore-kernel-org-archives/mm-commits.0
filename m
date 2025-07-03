Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1F230269
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 21:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751578760; cv=none; b=dI+hWybLXKBTy8Vp6k3ReCXDwAIrtW1w0NS0RZu4wRqGU6ffZwVZ1tvsF+rO0jZQbbDCPL4CWJFS68AdD8KqxrAEYHkCKPJ3HBSuQkbC+UnIqPwbbN4D276Abz7K3dGldVUtWil9yPmELUbmjNbcHQ55nYlKE+0wEqWrAaMNML0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751578760; c=relaxed/simple;
	bh=AW5Pgp/3i+s1AeYgiMPA3+fbNB490H3HtoX23k3ztiM=;
	h=Date:To:From:Subject:Message-Id; b=KFC57u+vkhiJ4Cb6mRx3JuEoDbF60VKaNWRFkToTsvJzzXnij769eoNDPoiPcR1EX5bY0fLPlsjpUKdxPGDfUmqUIehrRLQx/J2LOGgys1kSA5ShWge1US9jIb+vywYL+jhlvEBUc5jU4tfk/v+uFsz4Hsj8szc8aEM8Uyffh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmaTC3bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmaTC3bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D22CC4CEE3;
	Thu,  3 Jul 2025 21:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751578760;
	bh=AW5Pgp/3i+s1AeYgiMPA3+fbNB490H3HtoX23k3ztiM=;
	h=Date:To:From:Subject:From;
	b=gmaTC3bj//ZGiEfttvD+VRsPgJq1Nu1loDz/fm1PuBQEOa1Zw6O9j405fNpfYq0nf
	 QNfZFmAgYtf7rxkdYVOPwsVzA40yDIFU1eduo7GlnFokxb0TNaSngGkDBzAekRybZD
	 hMRePWr4GQtH3c6qAhIQZ9UWNmF7ZwwAZ+WWz1ws=
Date: Thu, 03 Jul 2025 14:39:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,dennis@kernel.org,cl@gentwo.org,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch added to mm-unstable branch
Message-Id: <20250703213920.0D22CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: prevent concurrency problem for pcpu_nr_populated read with spin lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch

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
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm/percpu: prevent concurrency problem for pcpu_nr_populated read with spin lock
Date: Thu, 3 Jul 2025 15:56:00 +0900

pcpu_nr_pages() reads pcpu_nr_populated without any protection, which
causes a data race between read/write.

However, since this is an intended race, we should add a data_race
annotation instead of add a spin lock.

Link: https://lkml.kernel.org/r/20250703065600.132221-1-aha310510@gmail.com
Fixes: 7e8a6304d541 ("/proc/meminfo: add percpu populated pages count")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot+e5bd32b79413e86f389e@syzkaller.appspotmail.com
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock
+++ a/mm/percpu.c
@@ -3355,7 +3355,7 @@ void __init setup_per_cpu_areas(void)
  */
 unsigned long pcpu_nr_pages(void)
 {
-	return pcpu_nr_populated * pcpu_nr_units;
+	return data_race(READ_ONCE(pcpu_nr_populated) * pcpu_nr_units);
 }
 
 /*
_

Patches currently in -mm which might be from aha310510@gmail.com are

mm-maps-execute-procmap_query-ioctl-under-per-vma-locks-fix.patch
mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch

