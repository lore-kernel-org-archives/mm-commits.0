Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185833909B9
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 00:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496382; cv=none; b=pyL1+USp/4n9dFIe2BdrLPCqRBMuakB7JP0jnYavmlKBatv+6+7Xnx9TH9XpY0OxOmzrTs6Dn1R8FCY9ldABTqoqoszxeRyq8ZbGTf104yDE9QOSjJe7lA5bUqN3KpKZWg76E0GBMcO8YQIorW14MwHwo51zX0tuFJcoj7fvxgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496382; c=relaxed/simple;
	bh=5hNTfP2q2AupyLOGVTRvV9AL3V2FKImoGVB7+MjGdpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrVSX6yNtO0TqB25h1Qb9xwx/4tdkGIGHOnK2DuGGVr3EhrubqUASTElXMwoY67mzLh5YRXelPcbMujuhc6xYoyIxk+HbtGeqrEKmjyE+K5imLQLFTP1a/c3wXa29GkHv5MczZJ0FjlHzJafeul3S2MBvv/KCrn01KSLJX0mJBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tB3Oa36F; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tB3Oa36F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6I78Tlssza6F3d8qyuXHFMvhA8AGLYye5JIn8EnXEVw=; b=tB3Oa36FcAzKo0M9YYir5YuRcS
	9Icp7iv66d3DOlSmFpMAztDd1HghFAIePPbvN7T9NKzupH17M+OXvCQgYgg/wEWA53pwZhvChDWlC
	urPvm6bsvATKqxOD7Gc76KdSGwD3xsUPxnvU83FEAw95adejcgkE85BSgnk5jQi8zVl6O3L3hykw6
	nRPkZDkarSYlkTbu384SPmsMNTWTgV1ndzL5mqaGZHIALMmrHis9q1mp0J1jxOYCQ/mkWXNW1eLTS
	Mgmiy3j9cu8XennZYRQrZgwTgGtN+f1URdx9z/R6Hu6KEvy3GDbPVYFP8XlUSGL7lvGqIYGLvs22Q
	oD3zB5WQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxDHD-0000000ATPz-2P9a;
	Tue, 03 Mar 2026 00:06:15 +0000
Date: Tue, 3 Mar 2026 00:06:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, peterx@redhat.com, joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com, jgg@ziepe.ca, dywoq.contact@gmail.com,
	david@kernel.org, aleks.koyf@gmail.com
Subject: Re: +
 mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch
 added to mm-new branch
Message-ID: <aaYl99AXj-mKHDbO@casper.infradead.org>
References: <20260302204309.E824DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302204309.E824DC19423@smtp.kernel.org>

On Mon, Mar 02, 2026 at 12:43:09PM -0800, Andrew Morton wrote:
> The patch titled
>      Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
> has been added to the -mm mm-new branch.  Its filename is
>      mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch

This was a W=2 warning.  We don't usually fix those.
