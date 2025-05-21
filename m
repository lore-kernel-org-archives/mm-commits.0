Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613011428E7
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747861136; cv=none; b=fz8JKWyLagsv4k8yn8hQ7uhNO4D1RwVyWgktGdJh+WSAbW/T1LUuMMLHrFYp0oCyoqWF2E2+kC40XpK0zl10nD3VyiRkMbTGWcJhfHBIHEYN1sQ0bB5BvIoS6jbASTpOR1LHdiv/Hc82/Aq8oBN0GZYa8lG0UwALXem61v/ozSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747861136; c=relaxed/simple;
	bh=XHYCWQ2zeje0N8SfE49KnPFjaG0/xwjnaPlKT2v277c=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fTGWCowAqgs+fqGYXgEfMRwTcSAvdNBHNLljQFPSQF89kJhz+ialXpRvvdDxnPrsGEgWsB4yT8o/GjvRhJRPc72UpVcHwq/VG+ANG/P66bSHWTG8eKTp407jRbDq4TnMA6GxuDKHWLVv47NjdRWMHp0nDPHKaeDomTCZEBtkR44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUqMDawO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUqMDawO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E955C4CEE4;
	Wed, 21 May 2025 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747861135;
	bh=XHYCWQ2zeje0N8SfE49KnPFjaG0/xwjnaPlKT2v277c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nUqMDawOCyLJnpgJUMfCLoMqOFa5wSP3x1LIndrkdQHO0E+qNGV9fa8FzX+ixelX5
	 JO4Yb2+9jZAzYPgSsGfjurkNW/u4bVR/GzOIk5siXIwnKez29ElBvb/aR5lTY7Uc9Y
	 M5sJ7z6vuJPSXyPfF32jdMQdW92l2PI/8B9BRAxA=
Date: Wed, 21 May 2025 13:58:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mm-commits@vger.kernel.org, yu.c.chen@intel.com, vineethr@linux.ibm.com,
 venkat88@linux.ibm.com, tj@kernel.org, tim.c.chen@intel.com,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 mkoutny@suse.com, mingo@redhat.com, mhocko@kernel.org, mgorman@suse.de,
 kprateek.nayak@amd.com, hannes@cmpxchg.org, corbet@lwn.net,
 Ayush.jain3@amd.com, aubrey.li@intel.com, libo.chen@oracle.com
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
Message-Id: <20250521135854.3ba2d1f61bd2c6a4af36ac13@linux-foundation.org>
In-Reply-To: <20250521191114.GE24938@noisy.programming.kicks-ass.net>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
	<20250521191114.GE24938@noisy.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 21 May 2025 21:11:14 +0200 Peter Zijlstra <peterz@infradead.org> wr=
ote:

> On Wed, May 21, 2025 at 09:56:52AM -0700, Andrew Morton wrote:
>=20
> > Fix this by not considering kernel threads as swap targets in
> > task_numa_compare().  This can be extended beyond kernel threads in the
> > future by checking if a swap candidate has a valid NUMA preference thro=
ugh
> > checking the candidate's numa_preferred_nid and numa_faults.  For now,
> > keep the code simple.
>=20
> > --- a/kernel/sched/fair.c~sched-numa-fix-task-swap-by-skipping-kernel-t=
hreads
> > +++ a/kernel/sched/fair.c
> > @@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
> > =20
> >  	rcu_read_lock();
> >  	cur =3D rcu_dereference(dst_rq->curr);
> > -	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
> > +	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
> > +		    !cur->mm))
>=20
> !->mm is not the right way to determine a kernel thread, PF_KTHREAD is.
> Notably, there are kernel threads that have ->mm.

Thanks, I'll queue this:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: task_numa_compare: fix check for kernel thread
Date: Wed May 21 01:54:00 PM PDT 2025

Peter points out "!cur->mm is not the right way to determine a kernel
thread, PF_KTHREAD is.  Notably, there are kernel threads that have ->mm".

Link: https://lkml.kernel.org/r/20250521191114.GE24938@noisy.programming.ki=
cks-ass.net
Fixes: 69cebdfa253b sched/numa: fix task swap by skipping kernel threads
Cc: Aubrey Li <aubrey.li@intel.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Chen, Yu C <yu.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Libo Chen <libo.chen@oracle.com>
Cc: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutn=FD <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c~task_numa_compare-correct-check-for-kernel-thread
+++ a/kernel/sched/fair.c
@@ -2274,7 +2274,7 @@ static bool task_numa_compare(struct tas
 	rcu_read_lock();
 	cur =3D rcu_dereference(dst_rq->curr);
 	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
-		    !cur->mm))
+		    !(cur->flags & PF_KTHREAD)))
 		cur =3D NULL;
=20
 	/*
_

