Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C6A27EFE9
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 10:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783334523; cv=none; b=QoUm9Z615cwGlDBVDJFPl4W1mOCzkBnfh8zlH7CrXZFGruM0hWvmTjHVe0KV1EVFvC7F/FzONDepeM0smoEM0US8FKpqdnt3FJiVoqaWHGKhxG0Qx/O9Pv0qjw/OTwY2Cz45cve8BBLsMEpUbY0S/cfeL5XFECovrSEVdviBgX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783334523; c=relaxed/simple;
	bh=nglOawJyRmim/MQph0hhaMSFYSU4hKGespUIz60YJqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onEIWDJLsS0mykt0zEYb2ZtorHZe0A5Ty9vCzEr7ZjlE0oEF1g1BYI1NaBp8ITZSHbL45M/NW7UhPuuy0nufgYVlMNJe/ZwZc9Dlmn/FX/q/rKgKe3E91txxQMT2YcheZQ6yhvHFOyU9gviHNqy81BVp57dz5aoanY+YG9zHh2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=soqYQRzC; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="soqYQRzC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=nglOawJyRmim/MQph0hhaMSFYSU4hKGespUIz60YJqM=; b=soqYQRzCCH4yOiJJykzSCva4y5
	jtqPHTMjvso40bkSibuW7Ztis7ZYPSbRjBR0tHxC0pUy7luVt8mXxJeSoYEJKcocAyV6YDUMpPRUV
	mamrtF1qouJgkm3p1kL6xh/Lfgsd2iMeXdMUyPxp+UKhWoz/lgI4jg5lvKv2LHvi9W5rLqyEUKXPa
	XAtmzz1MutkqjzjjVoGi7LmlKwNovntYywg1Sm/I23bh9i0vopmMZe82umPmC7RW98Sfaf+/rzEKk
	u0S1BDKAWZaD4e5wIKHB8n/e6BwKlCgMzm7Ajj5VWnT0OfIBiWFHKEib5k1FciS8DgLO5uilXE2mx
	cWqE5nag==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wggly-001MEL-2n;
	Mon, 06 Jul 2026 10:41:59 +0000
Date: Mon, 6 Jul 2026 03:41:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	kent.overstreet@linux.dev, catalin.marinas@arm.com, bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <akuFSv7JaXo6M8gx@gmail.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ako1sMPVu4dfQR4K@casper.infradead.org>
X-Debian-User: leitao

Hello Willy,

On Sun, Jul 05, 2026 at 11:45:04AM +0100, Matthew Wilcox wrote:
> > Add a matching kmemleak_transient_leak() stub to the radix tree test
> > harness so the userspace lib/radix-tree.c build keeps building.
>
> Last time this was proposed, the suggestion was that kmemleak needed to
> be fixed.
>
> https://lore.kernel.org/all/aCyI8T2sWlPLEYZ_@arm.com/

My understanding from that thread is that kmemleak could be made more
reliable by explicitly waiting for a rescan before reporting (which it
is a great addition).

This patch explictly tell kmemleak that this object will be temporarily
unreferenced, which is more cooperative.

That said, I believe both approaches. This transient-leak annotation and
Catalin's earlier proposal—can coexist as complementary mechanisms to
reduce kmemleak false positives (which has been my goal, given I run
kmemleak-enabled kernel at some scale)
