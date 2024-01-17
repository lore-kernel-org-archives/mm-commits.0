Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34694249F7
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 20:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705522850; cv=none; b=pRVOlnTODjkC+ckU4hBWUOi6S+kijeKLvfzINClhLOAsnmtDZJmegXRwhynaWWaNIYe8x7R4R0YL1EX8euTbekB5edy9ZBNOluKGOTQEqSAWsd4DKZJUBDzNkB1db1zVBimJ6Z0s2a6+twRbRHe6rIl4HACf+46BnYPQ/m4weGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705522850; c=relaxed/simple;
	bh=84B4iIt1hW/XKn/0X+PfICcbfcUZJG5XUZmMi6I2+hU=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding; b=adAWSgA8PnwSylakZye4feWCun2G+L+7WETTtwmh+X/nsXzhtulm6g86uL2jsc1cEpmhGSdkOcuTxlkUR3DvyThVULtaDC0v1IhmAe0+3qs8LkovBtYdVBIHvrbsv6/Cx1Jxq3g6ZCY5CR5OCXMG8H1P3dHaghCqcp6DD6Jue+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z3FSzG7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z3FSzG7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280A8C433C7;
	Wed, 17 Jan 2024 20:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705522849;
	bh=84B4iIt1hW/XKn/0X+PfICcbfcUZJG5XUZmMi6I2+hU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z3FSzG7sKIW72zh8swhKihDEmYjXvCB9KPQYk4vnDOVfZQWrkGwIMvDPZEQNfavsx
	 wFOCn9gd5nhDITmzQvnBMd6Vmfak78SCFdo8LQWOkOlZCgIzWdvwCrwE0l6DNYsPsb
	 yC4w1e6/V3R2NDwrZPA1GLGgRII/Mg6teuVEGWFA=
Date: Wed, 17 Jan 2024 12:20:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Yury Norov <yury.norov@gmail.com>, mm-commits@vger.kernel.org,
 tglx@linutronix.de, ming.lei@redhat.com, linux@rasmusvillemoes.dk,
 andriy.shevchenko@linux.intel.com
Subject: Re: + lib-group_cpus-rework-group_cpus_evenly.patch added to
 mm-nonmm-unstable branch
Message-Id: <20240117122044.ce5b24c38f62d1e36de715dc@linux-foundation.org>
In-Reply-To: <ZagEHj9v9n9M80YW@gmail.com>
References: <20240110160755.3E20BC433C7@smtp.kernel.org>
	<ZZ7e3xbIKfVa3yqd@yury-ThinkPad>
	<ZagEHj9v9n9M80YW@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 17 Jan 2024 08:45:18 -0800 Breno Leitao <leitao@debian.org> wrote:

> Hello Yury,
> 
> On Wed, Jan 10, 2024 at 10:15:59AM -0800, Yury Norov wrote:
> > diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> > index 3a0db0f51f09..c9c95b21e6c6 100644
> > --- a/lib/group_cpus.c
> > +++ b/lib/group_cpus.c
> > @@ -353,8 +353,8 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
> >  {
> >  	cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) = alloc_node_to_cpumask();
> >  	struct cpumask *masks __free(kfree) = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
> > -	cpumask_var_t npresmsk __free(free_cpumask_var);
> > -	unsigned int curgrp, nr_present, nr_others;
> > +	cpumask_var_t npresmsk __free(free_cpumask_var) = NULL;
> 
> I am testing the akpm's mm-everything branch, and I am seeing this
> compilation error when compiling with clang.
> 
> 	lib/group_cpus.c: In function ‘group_cpus_evenly’:
> 	./include/linux/stddef.h:8:14: error: invalid initializer
> 	 #define NULL ((void *)0)
> 		      ^
> 	lib/group_cpus.c:356:52: note: in expansion of macro ‘NULL’
> 	  cpumask_var_t npresmsk __free(free_cpumask_var) = NULL;

yes, there have been a few reports of this.  I'll drop the series and
shall await the next revision, thanks.

