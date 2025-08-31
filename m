Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB3F79CD;
	Sun, 31 Aug 2025 23:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756682970; cv=none; b=KwmGQrUwl89D2ZepFG64IkkfX3OT60dA33xBNkF85GUoKr664RIDz4ND36U+gfoRE3dNuLX+y8L2Ba5j7g96f3KJnvpouaRbeHR+1eR5HG+Bu3RJI22IgRUdFYEIuVEBSyskMw8aAd6F5XxODW3oNYiH2KiHEy85lg273E1nhUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756682970; c=relaxed/simple;
	bh=EZBFEyS4HxmV71x9Ua5+mUF9HJBJSHv+wrduh9/94Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqgTsBSft2kX256yEkMBmn0Lx3g9ArLCYgiPi6LQd66EiTSluKshmPLtYFc3brEnAf/jSfkPL1kD/MpD8gUZN1ieqyJjE1Wa6sb6SvaP9ZML+vsVYMQoKbaY6F9BjZ39kHMV9ZDFtJ9M3BD4qonygssk6Uh5SG5+TeWoaOjLcZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mrkrzg6Z; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mrkrzg6Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GlJZyU2iMVQPpa9EdFBUUeOTbxDJebxwLjr10Yw03Lg=; b=Mrkrzg6Z8HCtRGY/E/z135F7Hg
	tZe3rZKgm3C4ce8chS8if7k51HdJ7OOFH+nZzZXWucCGB2iGxcDtyHfD/fnp0rfIf/RXd1i9/bncs
	cFcyKHZ6n29O6LTrBOOEIU39X/rHGbtHHYUax6t3fYjmQ9pmWrYh6Tr/wqd4OKcIvdy9GlfHkLGVb
	TJD4zizmTKlIlO/qMvBr+kgIDy+jWUfP0G02JOIM5zXRiQ+r4mRe5T9CC0d/N1INRkuGxipSD2ZjL
	192HjO249X/X3jdcmn3NR9eqs7ylLWvc+Mm9oYEnH1JNBpIvHXgOQHcbT3bP6QU+0WpTIwXTozQ7h
	yquRNp8Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1usrU1-0000000GrLf-3iWo;
	Sun, 31 Aug 2025 23:29:13 +0000
Date: Mon, 1 Sep 2025 00:29:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
	yangge1116@126.com, will@kernel.org, weixugc@google.com,
	vbabka@suse.cz, stable@vger.kernel.org, shivankg@amd.com,
	peterx@redhat.com, lizhe.67@bytedance.com, koct9i@gmail.com,
	keirf@google.com, jhubbard@nvidia.com, jgg@ziepe.ca,
	hch@infradead.org, hannes@cmpxchg.org, david@redhat.com,
	chrisl@kernel.org, axelrasmussen@google.com,
	aneesh.kumar@kernel.org, hughd@google.com
Subject: Re: + mm-fix-folio_expected_ref_count-when-pg_private_2.patch added
 to mm-new branch
Message-ID: <aLTayWpbkN3g1Q15@casper.infradead.org>
References: <20250831194300.081C3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250831194300.081C3C4CEED@smtp.kernel.org>

On Sun, Aug 31, 2025 at 12:42:59PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: fix folio_expected_ref_count() when PG_private_2
> has been added to the -mm mm-new branch.  Its filename is
>      mm-fix-folio_expected_ref_count-when-pg_private_2.patch

NAK.  I'm about to respond properly, but this one is dangerously wrong.
