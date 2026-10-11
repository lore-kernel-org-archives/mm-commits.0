Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C785FB640
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791731754; cv=none; b=hQAtQNc51SmAimeCKKr1VWO8D6hmfqYGmFvwqIx1YH11I3oaRZ5prTRYzTjAgAjzkorT9y3qQT6lm9Kw0d9Q+2pU+QfTaqYI94fNytx1jQxoCJMMkHe1/6nPVTYwQRpY4/R66Ghtv2HSf0kJnWniHkdKAolZod5S1haxk/t+4mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791731754; c=relaxed/simple;
	bh=8EHNJti9fn6N6uKT7yLSrTDqcL+pQgfRY9lzy9h+R74=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=E1UZpa9XUITK7D7C+JvD/StmmuySrT//xQd//J6sNd+9Hl/NdGYdi7ANhAqFVIPmsl4JtQV6Jn93M61Ddanxh/hvpShduLQNOttEpUe18lzBnzmfjxu21zvVH6kP0/HzOXOAK4dwQ19788DKJNIcpZYbAHT5cFt/U626g+ENtg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQ50hfat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQ50hfat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70FE1F0089B;
	Sun, 11 Oct 2026 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791731753;
	bh=CYplqZKX2eYr/YQhjegbIAa0rx80nEhDJ74vMKR8q4E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nQ50hfat5KZ/0TsT14bBjlI0rgWGUTCUIKYVffnlbz4iUE7x5WJfd6hQXt/IRjjRV
	 Skah0s+i2t+/qp48IQOzUvAVngVrkkNdS2Sw/PcrRkF8tCaQUXSuZt5o0yVW7E5WbL
	 rtEftDujZuFmixI6fO9N/4H4LevOOHeh1LLuf3rY=
Date: Sun, 11 Oct 2026 08:15:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
 thomas.weissschuh@linutronix.de, rostedt@goodmis.org, pmladek@suse.com,
 olsajiri@gmail.com, nsc@kernel.org, nathan@kernel.org, mcgrof@kernel.org,
 masahiroy@kernel.org, ljs@kernel.org, kees@kernel.org,
 geert@linux-m68k.org, denis.benato@linux.dev, chewi@gentoo.org,
 andrey.grodzovsky@crowdstrike.com, abelvesa@kernel.org,
 jim.cromie@gmail.com
Subject: Re: +
 kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
 added to mm-nonmm-unstable branch
Message-Id: <20261011081552.e6f08178e6fc8b865e2715d3@linux-foundation.org>
In-Reply-To: <20261011154401.479c51b6@pumpkin>
References: <20261011002340.E44771F000FF@smtp.kernel.org>
	<20261011154401.479c51b6@pumpkin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 15:44:01 +0100 David Laight <david.laight.linux@gmail.com> wrote:

> On Sat, 10 Oct 2026 17:23:40 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > The patch titled
> >      Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclusion
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
> 
> There is a problem with the way this change in implemented.
> Basically the kernel Makefile (etc) only builds scripts/kallsyms if it doesn't exist.
> This means that if the header file is changed you can easily end up with a kernel
> that expects a different marker density from that in the data file.
> That will lead to all sorts of strange/confusing issues.
> 
> It would be better to put the 'shift' value into the .S file.
> It isn't used anywhere where that will make a performance difference.

OK, thanks.  I'll remove the v7 series from the 7.3-rcX queue - let's
revisit for the next -rc cycle.

