Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B0026C385
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756855202; cv=none; b=Z1NlZ5rtZHATWiCvLTsDtOnSM/jiN9bCqZWpAEqHk9E40xHBmwBrnFKuahNXHar5SzBmNMElYkMXuquHrF4uN4N6PRYd02L44xV7ySRCoVtLljvVybxLTQOxeFAOsgXKt6MajEYQFFtJVNj9d/XgffsSbrrW2zwYkqLlIEsvpyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756855202; c=relaxed/simple;
	bh=yJaeDAc2u++q77C15ndlZwbAMh+JP9gujpuXR0Ez9fc=;
	h=Date:To:From:Subject:Message-Id; b=Fs62JFiytec2SticiYXIuV1aOjSpN+2KLtFJO0bIdC9u6yoXUR3qsWm8PrjSuP4BhYVMjgGR4lM8xz02oV433TbNvX5MQZpDzRFKxkZrok5GbGBfA2S5+V+kgR6qhasPcSkiLCKIHlnpGkLt4exEHPYRdVFir5qCj0sL/FBGfRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wLt9OanX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLt9OanX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A27C4CEF4;
	Tue,  2 Sep 2025 23:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756855201;
	bh=yJaeDAc2u++q77C15ndlZwbAMh+JP9gujpuXR0Ez9fc=;
	h=Date:To:From:Subject:From;
	b=wLt9OanXOtoCxySHzE7bf/ts8K/neM8sfBYfS932uYhZMasfjVEnX5lcWL5E5VdBX
	 TJuWrTJNiKJV4ksTe2uLibGa9W0FvG5d1Oqs1m8wvc5MQZiAHbGFcQwi4YE2CBX73m
	 R2dUcMFTUgTcPnm15mH/DD9PPEWAD529edmlx8ek=
Date: Tue, 02 Sep 2025 16:20:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,pyyjason@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-add-trylock-while-printing-alloc-info.patch added to mm-new branch
Message-Id: <20250902232001.D4A27C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/show_mem: add trylock while printing alloc info
has been added to the -mm mm-new branch.  Its filename is
     mm-show_mem-add-trylock-while-printing-alloc-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-add-trylock-while-printing-alloc-info.patch

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
From: Yueyang Pan <pyyjason@gmail.com>
Subject: mm/show_mem: add trylock while printing alloc info
Date: Tue, 2 Sep 2025 08:57:51 -0700

In production, show_mem() can be called concurrently from two different
entities, for example one from oom_kill_process() another from
__alloc_pages_slowpath from another kthread.  This patch adds a spinlock
and invokes trylock before printing out the kernel alloc info in
show_mem().  This way two alloc info won't interleave with each other,
which then makes parsing easier.

Link: https://lkml.kernel.org/r/1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com
Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/show_mem.c~mm-show_mem-add-trylock-while-printing-alloc-info
+++ a/mm/show_mem.c
@@ -400,6 +400,7 @@ static void show_free_areas(unsigned int
 
 void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 {
+	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
 	unsigned long total = 0, reserved = 0, highmem = 0;
 	struct zone *zone;
 
@@ -425,7 +426,7 @@ void __show_mem(unsigned int filter, nod
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	{
+	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
 		struct codetag_bytes tags[10];
 		size_t i, nr;
 
@@ -453,6 +454,7 @@ void __show_mem(unsigned int filter, nod
 						  ct->lineno, ct->function);
 			}
 		}
+		spin_unlock(&mem_alloc_profiling_spinlock);
 	}
 #endif
 }
_

Patches currently in -mm which might be from pyyjason@gmail.com are

mm-damon-paddr-move-filters-existence-check-function-to-ops-common.patch
mm-damon-vaddr-support-stat-purpose-damos-filters.patch
mm-show_mem-dump-the-status-of-the-mem-alloc-profiling-before-printing.patch
mm-show_mem-add-trylock-while-printing-alloc-info.patch

