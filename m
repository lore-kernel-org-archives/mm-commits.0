Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E332D1DC721;
	Tue,  3 Sep 2024 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725393212; cv=none; b=Pn9jRgGgMiITkUqCHqFVUOlrMh90GR5ZQurxikdjRElRZoE579Tm0h9TL2nOKsrzAZWmX76q5ZkZkEJiGi6793Zn2JwjOZ4JfKADBSmlGX+ete3/vD5+NVYq6X/TcGvi+EYAJ2dhj5fFT3k85FyDWR4F+nWi33p+wBIPkiYVxbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725393212; c=relaxed/simple;
	bh=JVr7ZhQw9skBlpl6w2K3nBJ1GT+IIu9VMRsT6hW9sdA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kq9hNoqEXH1jrmqFppgrIRi/MUq4ZyZq1MJ0CGCB9/6M4Six1/z8aLRi9SjPF7I9U1to8b+ek/KUwYjwNaLhMVg9PxiphWQnsstr0vaIuOiQuCw7txESZfB7bH66V3LLHPGx6atxNi4Q7ApAv908EivuKp7U211aOJ7KXTvrhOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K7sLbrql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K7sLbrql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8721AC4CEC4;
	Tue,  3 Sep 2024 19:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725393210;
	bh=JVr7ZhQw9skBlpl6w2K3nBJ1GT+IIu9VMRsT6hW9sdA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K7sLbrqlGxgl0hpUbdTV7ATPNZQkReT8MNwLp8zN4HIcC9E275/Gg3xzHZisFFjl0
	 4A/+5/St/MqfXZoLovAVZBcUtBMIC/xCzoaxawfN1+oewYNqQdtssjLpBbGWUAVHYt
	 l6AyJ35WpbWlMKDHNIW1DJFxA0u4AtdOdM6VR75g=
Date: Tue, 3 Sep 2024 12:53:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, nphamcs@gmail.com,
 muchun.song@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
 hannes@cmpxchg.org, me@yhndnzj.com
Subject: Re: [merged mm-hotfixes-stable]
 mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch
 removed from -mm tree
Message-Id: <20240903125329.726489169d81399a954f7787@linux-foundation.org>
In-Reply-To: <CAJD7tkYtM8gQDX8RrT1cnkfDQ0dRv4woNY4jrwjc1oUuavbuTg@mail.gmail.com>
References: <20240902005945.34B0FC4CEC3@smtp.kernel.org>
	<CAJD7tkYtM8gQDX8RrT1cnkfDQ0dRv4woNY4jrwjc1oUuavbuTg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Sep 2024 10:53:21 -0700 Yosry Ahmed <yosryahmed@google.com> wrote:

> > The inconsistency became more noticeable after I introduced the
> > MemoryZSwapWriteback=3D systemd unit setting [2] for controlling the kn=
ob.
> > The patch assumed that the kernel would enforce the value of parent
> > cgroups.  It could probably be workarounded from systemd's side, by goi=
ng
> > up the slice unit tree and inheriting the value.  Yet I think it's more
> > sensible to make it behave consistently with zswap.max and friends.
> >
> > [1] https://wiki.archlinux.org/title/Power_management/Suspend_and_hiber=
nate#Disable_zswap_writeback_to_use_the_swap_space_only_for_hibernation
> > [2] https://github.com/systemd/systemd/pull/31734
> >
> > Link: https://lkml.kernel.org/r/20240823162506.12117-1-me@yhndnzj.com
> > Fixes: 501a06fe8e4c ("zswap: memcontrol: implement zswap writeback disa=
bling")
> > Signed-off-by: Mike Yuan <me@yhndnzj.com>
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Acked-by: Yosry Ahmed <yosryahmed@google.com>
>=20
> We wanted to CC stable here, it's too late at this point, right?

It has cc:stable?

> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Michal Koutn=FD <mkoutny@suse.com>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: <stable@vger.kernel.org>

^^ here
