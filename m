Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9A82D541B
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769459696; cv=none; b=Ne4I0a1n9nC2FlHnm5gsWT1sVSm1qcYUnblQ79tD9f5ryk6o0jZWtn0rcNqN5qWS2jIiw+nPUr3gPftbBlTdNZJ7wv/oRP+dpNIgDpypV2FkAXYJdCqYjxqIlQS489A2uJTkb/bc8iBNlDLQL0E3WCpFvcuYULM0x3VK7RJVNt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769459696; c=relaxed/simple;
	bh=xUQ3VsdiAvgy5vFpofdhieBZQPgaIRa5uVXZCV9yYVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlrsGhMLJQ+w31kJ8fOp0202alMbx2ZpFNCXUIWaU/GOxtLrVyZZGV27pSgxFKy+xDaAJ5/mHnotjyHm3DF84w9Rqfm18MGVuBejWLR7VFFAPf2JS0E0nKuK+tIHLhdqhpM2vMZGA4wdhoBj4S3gk+fvvGW1oOyAp0JwewYTo7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WDdCzkug; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WDdCzkug"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0ykR6/ThM34DSpcjEy84/WiY61uzOTeEBvprBlGr1TI=; b=WDdCzkug5Ad6SyZbPGPhib4ejv
	K8pMhh28E6ddczWOKSBqew5OwRvmzSiM58hToHJ/hznUnLRkDeCoDW+IUM+cyx40y2DjjJp7UvMdK
	EOexg3M9/SJpfBYU5aQpxO1iRT3QZsEKOmnukEd6dRtwPlVeBgOYQEWhj4nX7PPaFJ0+Cv0YxSBlq
	RYLPCHQzu32iDsdaE9U7rU+kNWwlEug3OMkXAWp2puPM2qD/01IV18hKnNTzPeE0FLMJYzAz3tRkS
	MyjINHTtc1/10aJNP6N7V/IoWWmeTprxzvOuYEveG8MtFgsv+WVk9eqhS3geWt9y07mw2D6CtK3pv
	4hD2nPCg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkTIO-00000006RIs-3w3M;
	Mon, 26 Jan 2026 20:34:48 +0000
Date: Mon, 26 Jan 2026 20:34:48 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tujinjiang@huawei.com, dev.jain@arm.com,
	david@kernel.org, shardul.b@mpiricsoftware.com
Subject: Re: + lib-xarray-free-unused-spare-node-in-xas_create_range.patch
 added to mm-new branch
Message-ID: <aXfP6Mr_86oVVN0E@casper.infradead.org>
References: <20260126200731.E28AEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126200731.E28AEC116C6@smtp.kernel.org>

On Mon, Jan 26, 2026 at 12:07:31PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: lib: xarray: free unused spare node in xas_create_range()
> has been added to the -mm mm-new branch.  Its filename is
>      lib-xarray-free-unused-spare-node-in-xas_create_range.patch

This has been superseded by my patch to call xa_destroy() in
clear_inode().
