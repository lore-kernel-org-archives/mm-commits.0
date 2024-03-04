Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9357278B68
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579843; cv=none; b=pL6UOuqgltDcGxiC3Xibj2QgWe2J6DdLqgzpxuuXvLHyZlaJrVUUToFYSjphJYRCNjXFRhyeFxJgxNvSvYfYPi4Ah8F4tO80VoKaGW7nkZgEzrnMoWvi7d2lS7TezrT5RMX/pOykFb0ufdOfGfL3Gk90Ms091hm8gxf2x5LUSI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579843; c=relaxed/simple;
	bh=Zb6uPjRgPVLdYLNEm+V4Q/ZY4oJa0TDA9BmNSuObjiQ=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=aFOfbSsC35asnp3+IL0QogyqYKv/uTEucdYKMIwUQ39tlEmfWdA3tEzFBRl13JTUxV4cuoEMSm/v3NZazsEL0hW1BKWXq2lAuONkCAJqi5+6ilyRLNwaMXGsT+6rmjHDMZRQvF4TH9yqtpZXK0jjxVHIzKNvr5QKskvh3Vrgg5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AC+Lgs01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AC+Lgs01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACA6C433C7;
	Mon,  4 Mar 2024 19:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709579843;
	bh=Zb6uPjRgPVLdYLNEm+V4Q/ZY4oJa0TDA9BmNSuObjiQ=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=AC+Lgs01vBtXlAOyAj4njw7WCo7+vB1hAuYMnBqqzbzLeE3ri36o3nX+3fq493zEV
	 3OViyM4wCN3HzCXvZ6XHXxj32bqkgJC44RSS74r/cF24MYyNVUWLJB0SDQhs7tU2qf
	 aGlF9KVZabGcQcR2cOCsBd1s5afb8Sm6g8oFjOAs=
Date: Mon, 4 Mar 2024 11:17:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mm-commits@vger.kernel.org, ryan.roberts@arm.com, broonie@kernel.org,
 ardb@kernel.org, aishwarya.tcv@arm.com, willy@infradead.org
Subject: Re: + mm-add-__dump_folio-fix-3.patch added to mm-unstable branch
Message-Id: <20240304111722.49e949bc5367e99a5624bbcd@linux-foundation.org>
In-Reply-To: <20240304191128.CBF45C433F1@smtp.kernel.org>
References: <20240304191128.CBF45C433F1@smtp.kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 04 Mar 2024 11:11:28 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> --- a/mm/debug.c~mm-add-__dump_folio-fix-3
> +++ a/mm/debug.c
> @@ -121,23 +121,31 @@ static void __dump_page(const struct pag
>  again:
>  	memcpy(&precise, page, sizeof(*page));
>  	foliop = page_folio(&precise);
> -	idx = folio_page_idx(foliop, page);
> -	if (idx != 0) {
> -		if (idx < MAX_FOLIO_NR_PAGES) {
> -			memcpy(&folio, foliop, 2 * sizeof(struct page));
> -			nr_pages = folio_nr_pages(&folio);
> -		}
> +	if (foliop == (struct folio *)&precise) {
> +		idx = 0;
> +		if (!folio_test_large(foliop))
> +			goto dump;
> +		foliop = (struct folio *)page;
> +	} else {
> +		idx = folio_page_idx(foliop, page);
> +	}
> +
> +	if (idx < MAX_FOLIO_NR_PAGES) {
> +		memcpy(&folio, foliop, 2 * sizeof(struct page));
> +		nr_pages = folio_nr_pages(&folio);
> +		foliop = &folio;
> +	}
>  
> -		if (idx > nr_pages) {
> -			if (loops-- > 0)
> -				goto again;
> -			printk("page does not match folio\n");
> -			precise.compound_head &= ~1UL;
> -			foliop = (struct folio *)&precise;
> -			idx = 0;
> -		}
> +	if (idx > nr_pages) {
> +		if (loops-- > 0)
> +			goto again;
> +		printk("page does not match folio\n");

We shouldn't use a bare printk().  I'll make it pr_warn(), but should
we be using WARN() here to get a backtrace?

> +		precise.compound_head &= ~1UL;
> +		foliop = (struct folio *)&precise;
> +		idx = 0;
>  	}

