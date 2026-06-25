Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1743A3E68;
	Thu, 25 Jun 2026 03:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356597; cv=none; b=ImMjkZJDUp3mmhWH/vjPUGdYKC2bkwvjwOMz0rr9KCuM0mTEPPfEdKTasphohaJ7kh4GPQY3caGJdUEiQMr2fzpYCd4YteMIVQmoRCz2O1ee7ldALamJWiEvWC82petSJ3QLh+yzGHzqFKafb+uawZ/YSG7+taMnPBbaXBlEEaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356597; c=relaxed/simple;
	bh=r25lLTtkZkQIBVUCix7ObyaQe0M+3zGQGVIwNH+nY2Q=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MJZLwcdNLUCu0k+4H+ilHGEcjLTvoqhWnUr4rQcN1R1IcIZ4qe1MwupCrHAAikHPOLB0YBzujqO+wdYVVzWSA2ghxGlZ+PAFIS8AHjEMWTtyQmHcwL/9gZXGEDexDPIvTALNqPizE80q6dAsXOTEmoPRt2Yibxa7WFj+GqP/D2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwT0i4yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwT0i4yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DFA1F000E9;
	Thu, 25 Jun 2026 03:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782356592;
	bh=2l97+gqVHxWXmN1wb4J7AzktLA0f6FsMbK2liSYk35E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YwT0i4ykZapISOEiO75K5jxPQLE9EVALw0o6hVeCyGe+JuXktqydh76WtDu24GGnH
	 xzGNexjJAU4fsUs3UDaDH/v2XFqS9v3p+ppy49Fhz9VPjhMSaUm0QZgvpMXcF//Hpe
	 IH0FuidUBeG1Ft2qERW0bzPI4V635I5hwNw/gs8U=
Date: Wed, 24 Jun 2026 20:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: mclapinski@google.com, mm-commits@vger.kernel.org, vbabka@kernel.org,
 stable@vger.kernel.org, osalvador@suse.de, kas@kernel.org, david@kernel.org
Subject: Re: + mm-hugetlb-init-tails-before-init_migratetype.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20260624200311.6da8a04dd323b336afe25673@linux-foundation.org>
In-Reply-To: <A6C55A66-5225-4C1C-9E4C-988EEAA960D0@linux.dev>
References: <20260625005458.9F75F1F000E9@smtp.kernel.org>
	<A6C55A66-5225-4C1C-9E4C-988EEAA960D0@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 25 Jun 2026 10:49:25 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> > VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> > 
> > This code looks inside the struct page which will be uninitialized
> > for hugetlb tail pages, which will cause a false positive.
> > 
> > So let's initialize the tail pages before this happens.
> > 
>
> ...
>
> 
> Hi Andrew,
> 
> Just a quick heads-up — this bug was actually already fixed in my patch #1 of
> patchset [1].

OK, thanks.  I work through backlog in reverse time order, so that's
still 800 emails away ;)

> Since both patches address the same issue, I'd suggest picking
> mine to avoid unnecessary merge conflicts when the rest of my series gets applied.
>
> Thanks to Michal for also taking a look at this — always good to have extra eyes
> on the same problem.
> 
> [1] https://lore.kernel.org/linux-mm/20260612035903.2468601-2-songmuchun@bytedance.com/

That's a very different change.

I expect I'll need to separate your [01/19] out of the series and make
it a hotfix.

Oh well, thanks, I'll leave a note against
mm-hugetlb-init-tails-before-init_migratetype.patch for now.
