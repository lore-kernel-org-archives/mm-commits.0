Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC68230987;
	Fri, 22 Nov 2024 05:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732254155; cv=none; b=kwUY87rECw4HV9erTsslwuLsoKB+wX8hrDIi9nEIJipo/A/14R3I1tVvX4PYLwtdYU1lKkwnQ9H2cgkEwDhKFLbm3xqDCelJES0/76o0NflsfI5yX4VooCm9L0vZqtQQ5pbqSEAEejeKbz2rH6Bq9aUNXA6rmKG43l/uvNwE8U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732254155; c=relaxed/simple;
	bh=NWopFJbUd56WuHEPeK22+c6oGsR2DCkaOH6RGADlLcA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=BrikjoWxn/wFVdm9knf5nUuYYjGoNbwikgVcmxa5TlvPKEka4EvVx7tyQFOqV+DbUV5Cs9xecBhLtddJwS9DUuuRyGdOIXtQLrdvlONVnhxt22URPZLEXEr3FHDQFebH6HMbBJG1RyHiRJ4B/XHngDRphFUub8C1/RlODyCz9sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jpMFcOGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jpMFcOGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFE5C4CECE;
	Fri, 22 Nov 2024 05:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732254155;
	bh=NWopFJbUd56WuHEPeK22+c6oGsR2DCkaOH6RGADlLcA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jpMFcOGV2Xxj5FeCYuQc8wblX63XQFm8f5ScmcNMYhyFCQ8RKRRGIUmaPiYGf0caU
	 Uuo+uFDu+gnhAPBh+ftWjk7yOXWoJ9dG8vtqYz9nvZUyq6sLIyCy3DbjnOEaHKuFjc
	 pafWiWkW564hP4cMIIOBO4tEuiW8z+O7jo/wjMk0=
Date: Thu, 21 Nov 2024 21:42:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.13-rc1
Message-Id: <20241121214229.8fe091954f9bf0d26f54ed88@linux-foundation.org>
In-Reply-To: <ZzwVo0ZbuG37pHdR@casper.infradead.org>
References: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
	<ZzwVo0ZbuG37pHdR@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Nov 2024 04:35:47 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Nov 18, 2024 at 07:30:01PM -0800, Andrew Morton wrote:
> > Matthew Wilcox (Oracle) (13):
> >       ksm: use a folio in try_to_merge_one_page()
> >       ksm: convert cmp_and_merge_page() to use a folio
> 
> Unfortunately you left the crap patch in from Gaosheng.  Linus, can you
> apply this fixup?
> 
> >From 3d7e7319bbb3ced1dfb9c82bb7e8c7386380799b Mon Sep 17 00:00:00 2001
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Mon, 18 Nov 2024 23:32:25 -0500
> Subject: [PATCH] mm: Revert IS_ERR_OR_NULL check
> 
> &foo->bar is address arithmetic, not a dereference of foo.
> Huawei engineers seem particularly prone to not knowing this.

It isn't only Huawai people.  David acked Gaosheng's patch and it snuck
past me (again).  People keep on getting tricked by this idiom and I
think we'd be better off with some nicely named wrapper to help
readers understand what's going on.

> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2261,8 +2261,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>  
>  	/* Start by searching for the folio in the stable tree */
>  	kfolio = stable_tree_search(page);
> -	if (!IS_ERR_OR_NULL(kfolio) && &kfolio->page == page &&
> -	    rmap_item->head == stable_node) {
> +	if (&kfolio->page == page && rmap_item->head == stable_node) {
>  		folio_put(kfolio);
>  		return;
>  	}

Linus has already asked us to avoid this "funky sh*t":

https://lkml.kernel.org/r/CAHk-=wicaWSn3JLwpexH=gu1HoHWpecyWoLYBwD3qPd0-t9aJA@mail.gmail.com
