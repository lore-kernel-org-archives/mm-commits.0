Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25DF16F288
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 19:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747854697; cv=none; b=iD4KxX0TRKkBJH5GYWp8d5n7WRvfXhZQBqH4ZyMX4sY+dH9HhwrXsx5ctA+dSoLO+Hq74ECn0tLAkpVfAnTqO2cnXJpFc0R+FzO4xx8hxCpFqfG0aM8/16jXrIr/7Epj36a5q2qtiPgY0HAKkY+YQ/fgvAGhiJ8GI22d61MQdLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747854697; c=relaxed/simple;
	bh=MAJhH0mMClmDjnNql+2k06MM7eDlQcPnDG7K2Iz2AFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmqeLXIgUX+4SHD+LXzF356Oqdk0bFFug9xoEUOqMToAg0AXQqd0kX6rcvj/HebiJd4QlgJl8+2WTb38TT9UqBsuaPhuuPWsYz+cH/8XpNgIsGYEerLGyfpv2f/zJxd2mEYLY8UqDQWEy/97dhHSUvdzO0SZH1z/hfgQug6VInI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IF1g0qOD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IF1g0qOD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LpsijoqO5OysF73du0n6eZ1Ld5MwPRq3CEtfsEsFr7k=; b=IF1g0qODOXs1B8Ffi5/XSutXOx
	cF/WRHHNIXCe6clpXPtQmDBJ0AANwOonHWT5TODRdowKQAwyiTRa0gbRteqPzphc2xmyEdCFL3Y4n
	nTIJw7v+UYmL3gmYdPmkJqxEyEPJXpf1jIhatXF32p/LIOZ/zVrN+aEmRRn6ARyq0IfmucatiRmkl
	rmEGjltjHomvj6tDPnvk9BdasPeh/CD6aub2oIU37K37wUAHJ34FaQLM1l/j+kfnREQezIE05Fr9Y
	qR6IPwOLTFq0DdWacHfgXSQEpezQA8WdJ66HQxekJr7lfwfGmnDaLmDKoIvL1+kildc2cUO43rtAE
	AU9SrICw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uHoqQ-000000052xg-3VJv;
	Wed, 21 May 2025 19:11:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4AED5300583; Wed, 21 May 2025 21:11:14 +0200 (CEST)
Date: Wed, 21 May 2025 21:11:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yu.c.chen@intel.com, vineethr@linux.ibm.com,
	venkat88@linux.ibm.com, tj@kernel.org, tim.c.chen@intel.com,
	shakeel.butt@linux.dev, roman.gushchin@linux.dev,
	muchun.song@linux.dev, mkoutny@suse.com, mingo@redhat.com,
	mhocko@kernel.org, mgorman@suse.de, kprateek.nayak@amd.com,
	hannes@cmpxchg.org, corbet@lwn.net, Ayush.jain3@amd.com,
	aubrey.li@intel.com, libo.chen@oracle.com
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
Message-ID: <20250521191114.GE24938@noisy.programming.kicks-ass.net>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250521165653.4CFACC4CEE4@smtp.kernel.org>

On Wed, May 21, 2025 at 09:56:52AM -0700, Andrew Morton wrote:

> Fix this by not considering kernel threads as swap targets in
> task_numa_compare().  This can be extended beyond kernel threads in the
> future by checking if a swap candidate has a valid NUMA preference through
> checking the candidate's numa_preferred_nid and numa_faults.  For now,
> keep the code simple.

> --- a/kernel/sched/fair.c~sched-numa-fix-task-swap-by-skipping-kernel-threads
> +++ a/kernel/sched/fair.c
> @@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
>  
>  	rcu_read_lock();
>  	cur = rcu_dereference(dst_rq->curr);
> -	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
> +	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
> +		    !cur->mm))

!->mm is not the right way to determine a kernel thread, PF_KTHREAD is.
Notably, there are kernel threads that have ->mm.
