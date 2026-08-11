Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DB4426EB6
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 09:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786439993; cv=none; b=fvel8Tes1c2u7aFoVRZwMcK1T0DCMBFGYwS65RyoaTa9LvWJpyLw8Fi2W2fkZRDCT+gtf9OVr45LrTzfeMhKVOQq7PyGJMJlnLi7PECgqvVmU/sNKhTu9bVQ5vR15NLTy1zIrcWsKd4bjwuATUWqyr2WR2NTmguw+rl5GLc7Ogk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786439993; c=relaxed/simple;
	bh=HZR6/idUylE6q2WNQwgcRhEx/zeBrNJyZra20RAEvzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K155GAdnVCS8rX6ItACc4qfYznyeR/McPXwE7XFJfVjZoybv6Prc4b8Tv38Z3CmzI/QOdRPJFiTPaLH9UgtUcFo1KgEkkXS68ArBavoB18k4h5BnSk8RltL84/1JO2CvnbCMemcUiDfTyeE1Jtv/J4+jCVRo5ECL3hX7lc1DjxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=qUCZAY7O; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="qUCZAY7O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c2tnKOC8qXuU3QGuy3HGRA/ftw/21AmtGXs04tfXLLA=; b=qUCZAY7OqSZ5Joi1/nYlKKjVg+
	x956ZEK9kApVdOOBbuVTNWdMjU612KVLIStuKhif8m4OqMikjY2wbJAQ0V6fCMtR9ZWuM289aOnmU
	J4tQJHWZwuF2/Nyfgd6J3MBEcteEZn+hEzvXUljZ45nrnL9exmGpwO0LfOYthynzVWDycfVQITB/i
	58R33zUE/g0ll3ekVw+wO+tWFm3wextAuvhstj1hpajckKGLV0n45YSfGA8F8vSRHRUnCidozYzzP
	kHxZ/tS2yoYYQkrs2zHxXGbIlMHBd1KZtJNlGJ18OpPaa3ZXVH8pmAd3cawV5Oe8sbh8YIstnMD97
	v6G9/WMQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtie4-003SbZ-0t;
	Tue, 11 Aug 2026 09:19:40 +0000
Date: Tue, 11 Aug 2026 02:19:36 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, mm-commits@vger.kernel.org, kent.overstreet@linux.dev, 
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <anrnoSQUwz9um0SF@gmail.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
 <akuT8pEjBKvByPlA@arm.com>
 <akuzsny_3EpxaPww@gmail.com>
 <akvW9RwjVmRnNzHM@arm.com>
 <akw4FspAoT60tQeu@arm.com>
 <akzZSIN5ALd8iH52@gmail.com>
 <20260810201814.52d1353d5c3f1ce27ba10186@linux-foundation.org>
 <anri2rKW2gG28tXC@arm.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anri2rKW2gG28tXC@arm.com>
X-Debian-User: leitao

On Tue, Aug 11, 2026 at 09:52:42AM +0100, Catalin Marinas wrote:
> On Mon, Aug 10, 2026 at 08:18:14PM -0700, Andrew Morton wrote:
> > On Tue, 7 Jul 2026 04:26:43 -0700 Breno Leitao <leitao@debian.org> wrote:
> >
> > > > Anyway, a better diff for the first idea below. I need to do more
> > > > testing and can turn it into a proper commit (if we don't deem it
> > > > redundant because of the other min_unref_count).
> > >
> > > Thanks for it. I've reviewed it and it looks sane.
> > >
> > > I am also testing it on my side.
> >
> > This went quiet.  I take it that we won't be proceeding with this
> > patch, "radix-tree: fix kmemleak false positives on tree head
> > reassignment", v2?
>
> Yeah, I think the recent heuristics additions make this annotation
> unnecessary. Well, Breno to confirm.

Agreed. I've pulled all the latest kmemleak patches into Meta's kernel
(including this one), and the false positive rate is now much lower
than before (althought I still don't have much bake time).

I'd suggest dropping this one and instead continuing to improve
kmemleak itself to avoid these false positives where possible.

That said, I'll let Meta's kernel bake a bit longer, and if more false
positives turn up I'll report back so we can decide how to proceed.

Thanks,
--breno
