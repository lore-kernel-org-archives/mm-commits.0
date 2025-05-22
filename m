Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC64C221729
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747902230; cv=none; b=iO3fR3jS8kkgF+fj2JWw/JLg+LkqGfcn4E65Wy9TLFwtCnOvrwZ7QhtE/G8kzH87s3XP37c20h3vbdH9UpmpETeKWor/HoomHzmQ9tgek29YDXKt8srD6qQgALwxidAwIMWv2IfBZCCpIztCZVGY+lMsgyMwy8vSS5W6D748ibk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747902230; c=relaxed/simple;
	bh=ZeG5Y1CIJ8nic5u5aRLu+7aGgFLFcWo4dnoudcto4Pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvfctw4tHCU6G6juvfkCqndHn5rV27tQC6aioNaXRg9tssoJTjP1WPD8LPaJ95VSnEw5PGnbZw4+66QiDwEN1Arsoez9W4nCYAzLt3r11ZfTnsKaMuw5q/dk7K8E7tTnepf69Ig62WzsbluOaI5aesmYUeEs+ukOCtswOqdKpXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D8FK4W3Q; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D8FK4W3Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=OqD9N1O7BPseED8FnvsSePnUzW0AElyuGLZGaDdqPPw=; b=D8FK4W3QDzYYKHKluggK3bpo9t
	NoomHVXnX0xv+BTlfj7y+cICO7HgdF+e6MzQisxSBdqp/Vdfa8k/WYPl3ACRiGQordkonLelEoC4G
	/90GXrnbzY0xmjSpEV8Yb9bcsAt+cf48gceAhvxiyxhu2/w0h2aFROYdL7jawpkl7xdhfhcs401ji
	mncw6exFDAi9bNynDPp/EwN1Uv6Ehovup64uX1ulfqNEcOo6w6VsoRMJfPS8Zvke0RL4i8ByWO2IP
	tWKSYjlcQfE6JKJ2LK8L9/8dfsF7llDkN32+nfFJQHmkaTunKo8gq7bQ3N/C1mFXe0Y6Famxm9vTn
	FwOe14Lg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uI1DB-000000010uW-0dbx;
	Thu, 22 May 2025 08:23:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9E293300677; Thu, 22 May 2025 10:23:32 +0200 (CEST)
Date: Thu, 22 May 2025 10:23:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	yu.c.chen@intel.com, vineethr@linux.ibm.com, venkat88@linux.ibm.com,
	tj@kernel.org, tim.c.chen@intel.com, shakeel.butt@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, mingo@redhat.com,
	mhocko@kernel.org, mgorman@suse.de, kprateek.nayak@amd.com,
	hannes@cmpxchg.org, corbet@lwn.net, Ayush.jain3@amd.com,
	aubrey.li@intel.com, libo.chen@oracle.com
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
Message-ID: <20250522082332.GH24938@noisy.programming.kicks-ass.net>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
 <yf637jkmcdunhgs6qjbnprygpkifnphdcqofp546dd6ti6s6i4@b2geqedevt42>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <yf637jkmcdunhgs6qjbnprygpkifnphdcqofp546dd6ti6s6i4@b2geqedevt42>

On Thu, May 22, 2025 at 10:19:29AM +0200, Michal Koutn=FD wrote:
> On Wed, May 21, 2025 at 09:11:14PM +0200, Peter Zijlstra <peterz@infradea=
d.org> wrote:
> > > @@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
> > > =20
> > >  	rcu_read_lock();
> > >  	cur =3D rcu_dereference(dst_rq->curr);
> > > -	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
> > > +	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
> > > +		    !cur->mm))
> >=20
> > !->mm is not the right way to determine a kernel thread, PF_KTHREAD is.
> > Notably, there are kernel threads that have ->mm.
>=20
> How does this compose with the NUMA balancing? Should kernel threads
> with ->mm be considered here? (I don't know thus asking.)

I don't know either -- I've not thought about it, I just reacted to the
difference in changelog/comment and code.

Typically the kthreads with mm are io-uring threads. And I just don't
know enough about those.
