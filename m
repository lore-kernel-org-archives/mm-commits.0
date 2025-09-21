Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3790C29D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489909; cv=none; b=l24HJsMBobljMhCll5j9YjCTfHDxyoplUdro6tnEdUtQATLUtZ/LHx2OvGuLsOzBp2Hyv3KR5JwAxXJGbWn3NIyx3CZJwBi8PaCIMb6VxXhPasi4SRWl8oHNuM1zWWVDNGmL1zjt9pESv1/q8ZgRxSmK0hiBCH2jIY3AvydOKS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489909; c=relaxed/simple;
	bh=vFVfjdvEXHMIWbd6lxM25vsqZoEyG6YK+GqfDDpyAzI=;
	h=Date:To:From:Subject:Message-Id; b=rvSr0tMfe8Hz74U62CEWbty3sX9rR+hMUJ5zEyH0JeHuK6xhJHXtuLKWNong2//Dt5qNfqN6L27+kDfQQLx8NX37zvydnrbhLYRGD/+4YaWM9y8jYSNQLS/tgntLYCTEPqdXOI6c3Ig4sjs5WDtxAZK4iLIg63gESSCs+Vu6uZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MZpW9qJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MZpW9qJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD0BC4CEE7;
	Sun, 21 Sep 2025 21:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489909;
	bh=vFVfjdvEXHMIWbd6lxM25vsqZoEyG6YK+GqfDDpyAzI=;
	h=Date:To:From:Subject:From;
	b=MZpW9qJvEs+Aug4pQbcqWwdZgEZgcvwIM0zIWxj7mPeIarrimAALE8Gt0cgzaTMkz
	 mCez5et0oL4lQ7V9b9V1vwTbuBcbWAlIkvbbXIye8x9vK+9OyVYFUSqEBL0cC7NdQC
	 YNrGVQs4pOV7gKUq4o341Mz+TetQ777b7yvt2UFs=
Date: Sun, 21 Sep 2025 14:25:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,pyyjason@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-show_mem-add-trylock-while-printing-alloc-info.patch removed from -mm tree
Message-Id: <20250921212509.0CD0BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/show_mem: add trylock while printing alloc info
has been removed from the -mm tree.  Its filename was
     mm-show_mem-add-trylock-while-printing-alloc-info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yueyang Pan <pyyjason@gmail.com>
Subject: mm/show_mem: add trylock while printing alloc info
Date: Wed, 3 Sep 2025 04:16:14 -0700

In production, show_mem() can be called concurrently from two different
entities, for example one from oom_kill_process() another from
__alloc_pages_slowpath from another kthread.  This patch adds a spinlock
and invokes trylock before printing out the kernel alloc info in
show_mem().  This way two alloc info won't interleave with each other,
which then makes parsing easier.

Link: https://lkml.kernel.org/r/4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com
Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/show_mem.c~mm-show_mem-add-trylock-while-printing-alloc-info
+++ a/mm/show_mem.c
@@ -425,7 +425,9 @@ void __show_mem(unsigned int filter, nod
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	{
+	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
+
+	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
 		struct codetag_bytes tags[10];
 		size_t i, nr;
 
@@ -452,6 +454,7 @@ void __show_mem(unsigned int filter, nod
 						  ct->lineno, ct->function);
 			}
 		}
+		spin_unlock(&mem_alloc_profiling_spinlock);
 	}
 #endif
 }
_

Patches currently in -mm which might be from pyyjason@gmail.com are


