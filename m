Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CEA1A2632
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752359336; cv=none; b=YxNeJHf9eOw4xEJ+41QB4zHiI34jG6csnnyjpexD1oqU//FWTmYJeqL1GOBtQc/WiZsy+L2VmiV3N8jaUrVaZkz/7ajLhyGqCbCxVhbV/GlJpLn4YS60mSUyv02B3NRHXQyHVEQYNzqYRceD39XTM6CiY0PDRhS9vCJsqHkQtBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752359336; c=relaxed/simple;
	bh=fVniPuRfbe/P5Zg6jT8pW0J9txeEG3LLXezbQBDr8h4=;
	h=Date:To:From:Subject:Message-Id; b=PaeU1v8ZMZLIN7wK4vDdhgmNtdACxgMgZly+q2WAASFg7UKVrRoR/Qg7w7wPx7Hly50uoZJ4rIw1UX7YJAUTCyFiJtOFChxaGu4KTXPq+Ck2A/ANnrcZoEI9ID/3cBlW/el4/yxWsBpsmuSxWB4g9aoY8luFdiGIN0nVWvVSLbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dx7B02db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dx7B02db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9966C4CEEF;
	Sat, 12 Jul 2025 22:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752359335;
	bh=fVniPuRfbe/P5Zg6jT8pW0J9txeEG3LLXezbQBDr8h4=;
	h=Date:To:From:Subject:From;
	b=Dx7B02dbxNmjuS/m+fCJB4scYq0/DjxPOKTVDHFfHWkRo1Tk7fRsGb4tt3XYkx88J
	 JKe0rTxoRfQkrXvU3bPx9Hf2fGCID+Yt5McXSVPqdvYFn9PrjwZXnLJKzdxIz7VCYl
	 Pp2gyGaddXfhgVy6ESBqwuTDNptPPhYkpc80rp0E=
Date: Sat, 12 Jul 2025 15:28:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,dennis@kernel.org,cl@gentwo.org,aha310510@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch added to mm-unstable branch
Message-Id: <20250712222855.B9966C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix
Date: Sat Jul 12 03:26:58 PM PDT 2025

move pcpu_nr_units multiplication outside data_race(), per Vlastimil

Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix
+++ a/mm/percpu.c
@@ -3355,7 +3355,7 @@ void __init setup_per_cpu_areas(void)
  */
 unsigned long pcpu_nr_pages(void)
 {
-	return data_race(READ_ONCE(pcpu_nr_populated) * pcpu_nr_units);
+	return data_race(READ_ONCE(pcpu_nr_populated)) * pcpu_nr_units;
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

