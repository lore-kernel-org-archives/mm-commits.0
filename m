Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A056267B7D
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 12:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740486937; cv=none; b=fcIKsCK4b9yfoukKEm72ZzZpjYrLQGl+IEKkn8oqgl2bPwyryfXeb9QiSXQFbcCo+j5XXS5m+3+PehOvBPMuvtaxQUWnkNzVwO5Z+L0T3/BHtS/TCwByZ+NwoPVH/kmFRG+3nSxlKR2aIbL2AClGu+c4Bkt8zK5dl8adn9nI1/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740486937; c=relaxed/simple;
	bh=UPWgVPKNOkYR938F7FZNuyWaC7o67z8aAluR7Y+qI4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UucVnwALEEdGCiEa0ALuLxl+tw2g8JFehgOcuE87OHFYz2UY2jJ1tF/lEyjERwdAyBs36HqgZsFTTwXz9xpStoh4yTuccQKUSAQktEAxPuJxcrL/vYOAh+5x5nczk0FMAolcMoxuc5nIU+bnh4vJbHIGNzQNQYHXUnGXviUqCII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HLz9Um2Q; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HLz9Um2Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nPp8mnAwwzCrqdZ4xggbDPiuik9U6pTV3NpWuLxIvHk=; b=HLz9Um2Q50p9DIcnPAKOY8nN4x
	Ld1DlGHeNQ6dhiv9XwxpYf4Ot103y7REGDKAtBTQaLysXwHEu35a0hoMo/HBGjD2thG8vG9oAmTJ1
	+GMy248KFG8LDX221nclGiuF55Ou1HEQZuoTw5lk8CLgAejje4uEobHAvsvQVEuv7IuMGZDt3uadl
	Drn9ZL/dt0f1efj+dbver5eNRV7/o579d9Fnfr0thFRmwd/2nS+6i1nEGZk19cLdwTtcGT5PoacBd
	51eY4cpIhIfWCQ5ZWAFmZpVkRmXQosFXwhGnEyeC8Kxl2AKbR632sHCtaTUE+kxWTlYY8dzk9c96e
	qJxVhpnw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tmu9p-0000000BGFh-0pOC;
	Tue, 25 Feb 2025 12:35:29 +0000
Date: Tue, 25 Feb 2025 12:35:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, michel@lespinasse.org,
	richard.weiyang@gmail.com
Subject: Re: +
 lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added
 to mm-nonmm-unstable branch
Message-ID: <Z725ERN5KDAANgD6@casper.infradead.org>
References: <20250225042234.AC256C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225042234.AC256C4CEDD@smtp.kernel.org>

On Mon, Feb 24, 2025 at 08:22:34PM -0800, Andrew Morton wrote:
> The patch titled
>      Subject: lib/interval_tree: skip the check before go to the right subtree
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch

I don't think this patch should be added.  There's no claim of any
performance win.  Wei has a long history of tweaky little patches that
may or may not be buggy.  The interval tree has been around a long time
and doesn't have a test suite.  This feels like unnecessary risk.
