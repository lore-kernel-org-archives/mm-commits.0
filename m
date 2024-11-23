Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41EE1862A;
	Sat, 23 Nov 2024 22:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732399297; cv=none; b=rsbCbUsJBlVg2cFzSapeEF2xaaCBjBCQ8J5C8kRIBSM6XnLy2t3uns0K1xoE8AbRaqotSfVa5KAi/32ai2UPp0wuQHmcH/QmFvWvDgLkgkcLF91T1DwlYp0CGc6iaektdPFeKvbC4UEk6mTi/w5iX6VtNK4RmpergijQoGGXtxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732399297; c=relaxed/simple;
	bh=R4TjGylb16jpWTG10E9GSwqmuPW5xKtP3F2bKF+4fZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=st3sSor10AuwbWoob27s0JDDV/hTFsI9ZqLneWUO9SqKsN8M/Dagbvv+3SdIn/YJGgon9iuwi5yYAfZQXBRlhYlbNwe6JK6HY5moPEva7i4xScbkv172MHK5Z7fhwDJJuPsth4jrLnJof/WA/01i4hpRcRzFnOkGV2KESoV8RQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=miJvszto; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="miJvszto"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VQAlmEJeN3UupymFJIVdz7z6mlrCIkMM22mcn6/6TAo=; b=miJvsztoQZsdcENufr3Tb8L/Ag
	R9Vv8WYiqSaonaV/loGtNzqRkrzer8ucNVzz+E8Xd2+cLL3CIhfoRkjts4WayX3tbplkB4OnywcAi
	4PuSchLjfusLFGPu+eJR40hZahvPx47eWDOqezcBUTbVcZ/Zofx+sIb3MNP+SqwA6iqd3jBtC8gSg
	6/DNdXyBVbZAJ2lERRmI1p2ripKAOoqFRhfo2a/BehYySw0SRAl3HtOSah4D3s6gRJFK9I2SZsj+N
	YFbQ1WHZXp0+l7BhNNGvnBdo86t9/2PW1TTntU5dewsjZUkH0vgfZw4gcE5Fz5hZyBIoYj5xXWUqB
	yP8znscQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tEyC5-00000009gaW-0Dk9;
	Sat, 23 Nov 2024 22:01:33 +0000
Date: Sat, 23 Nov 2024 22:01:32 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.13-rc1
Message-ID: <Z0JQvEK5jcOSaKsB@casper.infradead.org>
References: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
 <ZzwVo0ZbuG37pHdR@casper.infradead.org>
 <20241121214229.8fe091954f9bf0d26f54ed88@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121214229.8fe091954f9bf0d26f54ed88@linux-foundation.org>

On Thu, Nov 21, 2024 at 09:42:29PM -0800, Andrew Morton wrote:
> It isn't only Huawai people.  David acked Gaosheng's patch and it snuck
> past me (again).  People keep on getting tricked by this idiom and I
> think we'd be better off with some nicely named wrapper to help
> readers understand what's going on.

This whole discussion has got out of hand.  The solution is to divorce
page and folio, and I think we can get there in 3-4 more merge windows,
at least with a CONFIG option.

And this is where &folio->page is USEFUL because it clearly marks all
the places that need to be fixed.  As I've been saying to people all
along, while folio_page(folio, 0) and &folio->page are the same today,
they have completely different semantics.  That hasn't stopped people
from getting it wrong, but some people can't be helped.

Don't bother coming up with clever new ways for people to get this
wrong.  Let's get this project over the finish line.
