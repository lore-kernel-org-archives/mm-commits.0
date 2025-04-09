Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766332676DD
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744212656; cv=none; b=FcSdv3BFeF0WGZ6bgvUvCn6g5KZ0mcJNy5Zzg2wVdtSVcIRYNkfF8kxInWbvEF9uLPDl7XJPfCf4cvOrx5uMQv/1hOkk88rhi7aYt0DTx9RoMHTRN5mvqbyOqzYdV0ouetV71ksYjF0LYBgXr1ai6aCxXvgAQ0x14IBPX1rVS8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744212656; c=relaxed/simple;
	bh=CyTg3znElmpC3zjKfLvS6Kh57LDVXfTIuFc3kLAuYgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0ybfmPgNryMS0DcLuVZc2VZbzgxGAG0t0oMiH8uihQ+coU1vkq7C/5O506Ia4LIOieftDsvVejiHfmZwb7c2g3LNSiM9GFd5xXNpkIoxbw3e85jgHGcsKXPEK7Jw4f4oYyuCJlnvLTE/BXP/rbzK2jHXl44CtL962TRU5b8XzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KurIPZRw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KurIPZRw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=GV+AjJjCeH45yYE+XZfxJSuGdUd00C2JgVdVtZLtr9U=; b=KurIPZRw1o+2X2+a5qNZlX8GB5
	keABdDc2isfIg/AfZrBIkBdO1duVbhnhs580Xq34iwy6eyvGQYkYJhM+kONutiVN5hLAdWjyvt/SG
	CogxHZW05HcCaExYZc4dTSJt2/YwZxKfn8ma1xPI3wwln9ud2SbBIXYUfIGPyAc4cSGKythK3rvxq
	rXDVCJKA7QwGvunRsjIrDrdWmCHIHoT6rwlpNFYIu21og8tQxz51nvwbothZNKsxYXBCI/vdeEJ1A
	lsBXwsQvMFjOhxfrkvWJcPox8tMySGddyVc1RC0QkbzSR5IhTtublpMXPvi22L1d50GyJlucdcXe9
	wPdOSJ2g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u2XNu-00000008dzu-3qtA;
	Wed, 09 Apr 2025 15:30:39 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 760BD30057A; Wed,  9 Apr 2025 17:30:38 +0200 (CEST)
Date: Wed, 9 Apr 2025 17:30:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vineethr@linux.ibm.com, tj@kernel.org,
	tim.c.chen@intel.com, shakeel.butt@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
	mingo@redhat.com, mhocko@kernel.org, mgorman@suse.de,
	kprateek.nayak@amd.com, hannes@cmpxchg.org, corbet@lwn.net,
	aubrey.li@intel.com, yu.c.chen@intel.com
Subject: Re: +
 sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch
 added to mm-new branch
Message-ID: <20250409153038.GM9833@noisy.programming.kicks-ass.net>
References: <20250409002907.39D1CC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250409002907.39D1CC4CEE5@smtp.kernel.org>

On Tue, Apr 08, 2025 at 05:29:06PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: sched/numa: add statistics of numa balance task migration and swap
> has been added to the -mm mm-new branch.  Its filename is
>      sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Chen Yu <yu.c.chen@intel.com>
> Subject: sched/numa: add statistics of numa balance task migration and swap
> Date: Tue, 8 Apr 2025 18:14:44 +0800
> 
> On systems with NUMA balancing enabled, it is found that tracking the task
> activities due to NUMA balancing is helpful.  NUMA balancing has two
> mechanisms for task migration: one is to migrate the task to an idle CPU
> in its preferred node, the other is to swap tasks on different nodes if
> they are on each other's preferred node.
> 
> The kernel already has NUMA page migration statistics in
> /sys/fs/cgroup/mytest/memory.stat and /proc/{PID}/sched, but does not have
> statistics for task migration/swap.  Add the task migration and swap count
> accordingly.
> 
> The following two new fields:
> 
> numa_task_migrated
> numa_task_swapped
> 
> will be displayed in both
> /sys/fs/cgroup/{GROUP}/memory.stat and /proc/{PID}/sched
> 
> Introducing both pertask and permemcg NUMA balancing statistics helps to
> quickly evaluate the performance and resource usage of the target
> workload.  For example, the user can first identify the container which
> has high NUMA balance activity and then narrow down to a specific task
> within that group, and tune the memory policy of that task.  In summary,
> it is plausible to iterate the /proc/$pid/sched to find the offending
> task, but the introduction of per memcg tasks' Numa balancing aggregated
> activity can further help users identify the task in a divide-and-conquer
> way.
> 
> Link: https://lkml.kernel.org/r/20250408101444.192519-1-yu.c.chen@intel.com
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Tested-by: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
> Cc: Aubrey Li <aubrey.li@intel.com>
> Cc: "Chen, Tim C" <tim.c.chen@intel.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Mel Gorman <mgorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutný <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
