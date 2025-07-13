Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF3910E5
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449553; cv=none; b=Bz+U8WhD4YlXyZmq6239PDaGrd3MOdZTIRoZiyjZPmMQ1nQOf4qK71pskSjDUVQrvmDuqcuyIZSu/3FYm9fTg352H+eE1CgztAjKnrupZfo5Ez5cR/LDkb2KpKGnhdvIp1uyMIfinBF2BhDK9EMsuKlrk9sIqa2GId3mCy6ty/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449553; c=relaxed/simple;
	bh=1wWsyji5ce6+Px28W6RNxYp1D+06e63ld1aJiBEvRAo=;
	h=Date:To:From:Subject:Message-Id; b=WY+rm31pNACECkvHkXT5TVWPlI4IvlM4d57SZ7W/+UIraFfCnhFQmM4gRtLH9IrQVElQZkQYeTcg4MJiv743ce71MoZ2BPWEQSc5Thwy00QDxuMkPBs+g/XTd4l3HoVSopBt1IrWrApal+1HazS4+hxKUtrnT/twvUHp/wURSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ruCl1t98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ruCl1t98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3A7C4CEE3;
	Sun, 13 Jul 2025 23:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449552;
	bh=1wWsyji5ce6+Px28W6RNxYp1D+06e63ld1aJiBEvRAo=;
	h=Date:To:From:Subject:From;
	b=ruCl1t98xTYdGQd9PWznCqKZwKLC21RTBhWMX+2SQmP0s6bLwNrTuKd1ZFCvM887l
	 zB2SVdwouVBhcSjn5y5rOWaqSYijeb8jnB80y+0YfHHENHlq8DJ9t3VwjLeBqh0nH9
	 T1p3enWODrvM5kXvb4V0D90XL8yQHH5Lreo1F+4E=
Date: Sun, 13 Jul 2025 16:32:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,dennis@kernel.org,cl@gentwo.org,aha310510@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch removed from -mm tree
Message-Id: <20250713233232.CE3A7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix
has been removed from the -mm tree.  Its filename was
     mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch

This patch was dropped because it was folded into mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch

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

mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

