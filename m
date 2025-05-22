Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10806257AED
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 21:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747951021; cv=none; b=r/SwYaO+eS5nhKs3zz96MlwRJFoNx/GyaqVxTu0GWUpAt3BrJuJesr90Hwo06gtWVzoELEefNKXlP3QFKi6HOVxVE3nmcoBGShrZ4MoYL7oI8voZEsmvVlR7SjHUpi/+GFmXSgzWKQCsi4cATmnowExpIquZ2ZqGAvARkGHNJCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747951021; c=relaxed/simple;
	bh=KJYdFpTaz/VAkFhMbJcNWttb+2c/Qb9pfXf8d5otVg8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=HJP+h8OEEpCOOTVGnw+vY3/i/iuteF2zDjBgBFUoRykBfTA7G/V8R1aJNiUig+N0i++edf0njiizv8fbJHP4cTC1Y97IAYW6YbYfGVqFkD1M0KAEfcYuMmms0rN4mzeftOkzVWnTbdePXORiDPpCD2n7BkDYcutTI3JsxSdLG7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bzsdCymW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bzsdCymW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22356C4CEE4;
	Thu, 22 May 2025 21:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747951020;
	bh=KJYdFpTaz/VAkFhMbJcNWttb+2c/Qb9pfXf8d5otVg8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bzsdCymWBUUMqMjJLugG1vkvZhT6bZy4fKMhEfHZ+oqT2aa3FdkkWLOifZRC9731X
	 SDeGvr3Zl0HeSPTsAqIY6nF3Yj0T2C6ETFRsB1ESUEK4NxJkaLL/Dc7yjPgMjTkgfh
	 kRMmp7i/f+eZEezV2XK471iUJGLiKVrSJfpBYbO0=
Date: Thu, 22 May 2025 14:56:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Libo Chen <libo.chen@oracle.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, Peter Zijlstra
 <peterz@infradead.org>, mm-commits@vger.kernel.org, yu.c.chen@intel.com,
 vineethr@linux.ibm.com, venkat88@linux.ibm.com, tj@kernel.org,
 tim.c.chen@intel.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev,
 muchun.song@linux.dev, mkoutny@suse.com, mingo@redhat.com,
 mhocko@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, corbet@lwn.net,
 Ayush.jain3@amd.com, aubrey.li@intel.com
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
Message-Id: <20250522145659.91bb0bc4c8affc8e62306e0d@linux-foundation.org>
In-Reply-To: <27831b60-53f1-4348-b33e-1f30900e29a6@oracle.com>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
	<20250521191114.GE24938@noisy.programming.kicks-ass.net>
	<20250521135854.3ba2d1f61bd2c6a4af36ac13@linux-foundation.org>
	<021d2962-2fba-4c27-ae9f-4ded2df44903@amd.com>
	<27831b60-53f1-4348-b33e-1f30900e29a6@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 22 May 2025 03:01:34 -0700 Libo Chen <libo.chen@oracle.com> wrote:

> On 5/21/25 23:31, K Prateek Nayak wrote:
> > On 5/22/2025 2:28 AM, Andrew Morton wrote:
> >> --- a/kernel/sched/fair.c~task_numa_compare-correct-check-for-kernel-t=
hread
> >> +++ a/kernel/sched/fair.c
> >> @@ -2274,7 +2274,7 @@ static bool task_numa_compare(struct tas
> >> =A0=A0=A0=A0=A0 rcu_read_lock();
> >> =A0=A0=A0=A0=A0 cur =3D rcu_dereference(dst_rq->curr);
> >> =A0=A0=A0=A0=A0 if (cur && ((cur->flags & PF_EXITING) || is_idle_task(=
cur) ||
> >=20
> > Question: Shouldn't ...
> >=20
> > =A0=A0=A0=A0if (cur->flags & (PF_EXITING | PF_KTHREAD))
> > =A0=A0=A0=A0=A0=A0=A0 curr =3D NULL
> >=20
> > ... be enough?
>=20
>=20
> Good point, idle thread is always a kernel thread. I think we can
> remove is_idle_task() in that case

I'll drop the v4 series from mm.git.  Let's have a v5, please.
