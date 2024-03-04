Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D8879946
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 19:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709580585; cv=none; b=rBI1LCDbXnH0fFBOBOVuRGUetnEkH26gLn6nCHILTuYsNsAGY9jLIaVBQVFYpIKl7S1A6IPP42g664h/o8VE1EaQVuxqUKty3ViHiQCh0r/807lyMnpvmlYV3OL7qBhibIOuSiHMZXMa5gHFcwxhoirVtuR49f7wkP/sSqKyuBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709580585; c=relaxed/simple;
	bh=gIVlMmMwarjyqg3hd3tdCgSB2v4HonmvTfe0ra/elK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gl7sSDYV9o8bSm/D9xol6gfXseu4uF4ASDsaDCMYHj2h5F2jsDMZkg7A2TL6l/5HkWT+pKQMo0+E+r/GEqXh72Hh5viRwX4ba0mwYXH236Yzjn6GGhCWwvzkqG2NqNXADOFXMGLLs3YesCiLCPufZRI7ibxjjV8ZaVnZBSaFaog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VdqhKx7H; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VdqhKx7H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+HFlqTotS0p870CLpOp500ESOzFNIL3qnvYu3t4Q58k=; b=VdqhKx7H5GWSJiNR/tcVBt6Y84
	kC1Vl4i5ax1q48u4cesCYw4zY8Oc/NW6orZf/XZUpGGiNLz3B7PeinZC1uoucJGqDOg1Za1lUjkEQ
	olTAZlmSuB+QXNdy3fVuMLs61WkFiKnq6fzxbBliiT1E40GNOkQaP49JCl6CnTWi4VoDVrrng2B5N
	p2O8ZAdgqZC0RqSvK5mkeoRpJpicGqTjsE08g0+hGk1mQUNRaD+D1BAM9O/SDgJ9NDjt6IEY5tu7l
	9LkQkAXtmBJPdgesGKCE1uZnGmuWrgqzD0LEJJAXy3jqjZwBISmTNNMnFInRAfHk9jKzck45YI8hi
	4fJcApWA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhE0J-00000002EqZ-1D8i;
	Mon, 04 Mar 2024 19:29:39 +0000
Date: Mon, 4 Mar 2024 19:29:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ryan.roberts@arm.com, broonie@kernel.org,
	ardb@kernel.org, aishwarya.tcv@arm.com
Subject: Re: + mm-add-__dump_folio-fix-3.patch added to mm-unstable branch
Message-ID: <ZeYhIwWBfYcAOiWU@casper.infradead.org>
References: <20240304191128.CBF45C433F1@smtp.kernel.org>
 <20240304111722.49e949bc5367e99a5624bbcd@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240304111722.49e949bc5367e99a5624bbcd@linux-foundation.org>

On Mon, Mar 04, 2024 at 11:17:22AM -0800, Andrew Morton wrote:
> On Mon, 04 Mar 2024 11:11:28 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> > +	if (idx > nr_pages) {
> > +		if (loops-- > 0)
> > +			goto again;
> > +		printk("page does not match folio\n");
> 
> We shouldn't use a bare printk().  I'll make it pr_warn(), but should
> we be using WARN() here to get a backtrace?

I'm wary of doing that.  We're in dump_page(), so we might well be in
the middle of something else going wrong.  A backtrace will cause more
confusion than good.  pr_warn() is fine; matches
                pr_warn("page dumped because: %s\n", reason);

