Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36531211A15
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450032; cv=none; b=dl7DROb8rPclcagk1xilxfhISWz4EW8wXBdbPJpC7hj10AY+W0naA7qS90bSSqUS/hsmO3UGLvXdJwNL3Zy+aUvH1rwModmfRh/k5fDC1c5F9v4fpgmGsQv5PF7886H6ImNy/IsctVt6grKp8sQJY8pfeuKEHw/UYemb3DQ7BjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450032; c=relaxed/simple;
	bh=pzMxaZ34dacnX7TDGK1If+LRyoKdfcUyxzlGqlToUOE=;
	h=Date:To:From:Subject:Message-Id; b=cZ1zf2M2UZ1TI8hkRuRXsYxFOx3YJ7ir1EtEW86Uu17C+0JaTwkbyWhkO9c+uwo/CzTx/DAbd8273VYKhJrIjQK5IC+8RpuRR8x1Q+3NpSCXYxHU6lXzwWX0qOJrIL2lHo3FQwOFDdabB1w30oqt0sS32sS8UZzc/Uu4EPeMNWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0YmXJrez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0YmXJrez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA81CC4CEE3;
	Sun, 13 Jul 2025 23:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450032;
	bh=pzMxaZ34dacnX7TDGK1If+LRyoKdfcUyxzlGqlToUOE=;
	h=Date:To:From:Subject:From;
	b=0YmXJrez7+ZBgnQKiZ5kJ5XAGrxkRal/VBicm5KxE543OODBp0/c5BINfcgw244Ik
	 pDIW0JSjEBbKs5AURreBIIg7liaOe6+Z+fuuuqi0IPrbFhxpBP/6JRk4f9OP0aNWCT
	 Vh3uimVBvfCx3WBPbOSY//xFGc00cqobtUOxOrLQ=
Date: Sun, 13 Jul 2025 16:40:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,dennis@kernel.org,cl@gentwo.org,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch removed from -mm tree
Message-Id: <20250713234031.EA81CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu: prevent concurrency problem for pcpu_nr_populated read with spin lock
has been removed from the -mm tree.  Its filename was
     mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm/percpu: prevent concurrency problem for pcpu_nr_populated read with spin lock
Date: Thu, 3 Jul 2025 15:56:00 +0900

pcpu_nr_pages() reads pcpu_nr_populated without any protection, which
causes a data race between read/write.

However, since this is an intended race, we should add a data_race
annotation instead of add a spin lock.

[akpm@linux-foundation.org: move pcpu_nr_units multiplication outside data_race(), per Vlastimil]
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
+	return data_race(READ_ONCE(pcpu_nr_populated)) * pcpu_nr_units;
 }
 
 /*
_

Patches currently in -mm which might be from aha310510@gmail.com are


