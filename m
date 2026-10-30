Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793370073;
	b=v3ZEAx79yd4vBQGrUxJqqTXBiKo4KLTRUgf0N+JKo8cft0xZWRn5+ydQuTqdACeUCVus
	 NtnMuZHHHFuW51mhWgCE8UixTZ+yYlaEww3HfBGM/UYZMVYH0Hc8pkXssq1P0dirJda2R
	 4N3Ql//pEkXI4b+PcTgqzzhT0AUnynn/xa1faTQEo7tNh3p+U1iUWLhCpSe4b7c7RC0Gn
	 mMRn5KHiq6vB7DzHoK7y6ST+tgIA0zvYNfUAXpgIoKWa3VTfXt/BBGNwsjdsZTtR/9zfX
	 R5neLePQEaPciUelXUSKu4AQ5CRPozhVJPcge/Pdhg2lBgiqqqQDqdPsbAmmnnxxJ4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793370073;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Hsh9NuPhAGEXDJ+GSWmxS0u5rrfT2dr0uAmm/IOvLj8=;
	b=W8vp3vW3tIO6CqjjAUvfn1bOAhFyZMOHBsmVviCaGqp8SoR7wNp3mkUZ0r4gJzpme8X2
	 RhND38S1UMtGlQZk41BLdXjdHBmQ7AsO64dl8rbtYpnRcXKYh5CFt2XHRrKeYEXQ7/J9a
	 +blVsdgiyTcptWRZj8gdShllbNPbn+/WKJ09wjU4jjBYSTfSwZpHWSdcjuSLFzCaGf0AQ
	 4FxsSlb6oPSQwH9LyFnz/T+S64xHazhMkkWJLeiAp/Vl7DCBvIbTqG84NaSme3kwI/hfw
	 kuh96vGshXZ9E9oV0Ned76AjhBkbydWSOSHoPeGOgyJByGpfJw6rl+S55WExkLKz0Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e9P2zDBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D8B606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 14:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e9P2zDBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A361F000C1;
	Fri, 30 Oct 2026 14:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793370072;
	bh=Hsh9NuPhAGEXDJ+GSWmxS0u5rrfT2dr0uAmm/IOvLj8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=e9P2zDBIihmICNpOetxAXVSheJa5C7fU1eNuOrbWZNpevSs22c8YZYdAVWJU/zupB
	 MGhXvuHbpFixEZ6/ONo5z5K+nyV4GIAtV7Mw1k83xo6dEB7ogD/NASXKHIhROZ+8p9
	 emQ8kQ943pB7s3pMC/ercJTVif4AughiFbHn2nog=
Date: Fri, 30 Oct 2026 07:21:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: mm-commits@vger.kernel.org, urezki@gmail.com, baoquan.he@linux.dev,
 nickolai@csail.mit.edu
Subject: Re: +
 mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
 added to mm-unstable branch
Message-Id: <20261030072111.35bda475c93699d32c68202c@linux-foundation.org>
In-Reply-To: <auR3EGwXrn8-3gcC@gremlin>
References: <20261018001257.B247E1F000C4@smtp.kernel.org>
	<auR3EGwXrn8-3gcC@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 30 Oct 2026 10:58:08 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Hi Andrew,
> 
> Please drop this until a respin is sent.

Sure.

> On Sat, Oct 17, 2026 at 05:12:57PM -0700, Andrew Morton wrote:
> >
> > The patch titled
> >      Subject: mm/vmalloc: read vm_map_ram block regions from the requested offset
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
> 
> Little unsure what mm-unstable is for during the merge window (I thought we
> were leaving that alone now?) btw?

It's supposed to empty until -rc1 release (linux-next rules).  It has a
few leftovers in it at present - things which didn't get included in
the merge window.  Probably good patches but they have unresolved red
marks which I need to circle back on and figure out.

#mm-zswap-validate-dlen-and-normalize-comp_ret-on-compression-success.patch: TBU? (changelog).  -stable?
mm-zswap-validate-dlen-and-normalize-comp_ret-on-compression-success.patch
#
#mm-nommu-set-mmf_oom_skip-in-exit_mmap.patch: https://lore.kernel.org/as80Rpm-VHhP14aK@tiehlicka acks? bogus: https://lore.kernel.org/atB63fzpLyfWpzPn@tiehlicka TBU (changelog)
mm-nommu-set-mmf_oom_skip-in-exit_mmap.patch
#
#fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch: TBU (changelog): https://lore.kernel.org/as5M1BSWcPDHjEWt@gremlin.  Suren?
fs-proc-task_mmu-fix-lost-maps-entries-above-263.patch
#
#mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch: acks? https://lore.kernel.org/atSM69faDNgmLNVJ@milan TBU
mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

Apart from the vmalloc one, they're good patches which just need
changelog tweaks and maintainer pokes to get them over the line.

> Anyway, this patch has had negative feedback from the vmalloc maintainer
> [0], so should not be taken in this form, please - Ulad is vmalloc
> maintainer so has final say over what lands there.
> 
> Sashiko also found an off-by-one error that you highlighted yourself [1].

oops, forgot about that, thanks.

> I assume this isn't heading for any fixes branch?

Nothing goes anywhere until the little red marks get rubbed out.

The patches which need changelog updates I'll probably do myself.

