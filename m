Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A211BC58
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 03:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870913; cv=none; b=XnJYpAoYThC5CzcNaV0pVjpK3BmF1ojhznIG+64qibUxy87KPr4BI7d6RUpXue4aTLB9cdKzYiBo3zIVum59UaEkY4W/tVci6qB8uJJGQJztLec2dJ6hirhU4x54lI2gg91e+oo4B61wnMmOmB0gMZZ+TWm8F0caVyAqqQ1psnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870913; c=relaxed/simple;
	bh=354kjhF+8yoK7x9xuTybv4sHLzmsIuWtcI68yb/CHUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeQYDQTy0zpD2HDs+Bo/UZMGIuGoeu5qUD49dQGuroh1GMWSnYNkmEy+ObJ83ZXdiHEV8NDgMkGLsmsdKnluWmOdh53fmX8dGXi6OPXo6MxpfYz9DfucUJbmm9P1WHsZ1id8j5LlBqq59WxQfW8x1oOnBL5VXXZlyYJOHTVtLkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eseRQUFb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eseRQUFb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6QqDPPj5kA08hqI1+JrrFKUZoT3B+o1aKNs5M+nN5FE=; b=eseRQUFbWADTpNPGDc7zdyaZ8j
	P4g/zRsd/FZ2WPiCde1pPXMRWVo9C5kohB55RkhOUMDomlmfBYGqrnma8r7CM5tx0mhpL8LMUYHmc
	BVd+L0ujDlE0Bl7zK1xC0EETJUK4Jnf6WIxIJPSopMuN4MFtiUFz807NUn6/Ko/+xsSzqbfo8so2i
	TqLdBKvhX+0OxPolXEELOKFr2TsnpdcMh5p1Ca/nH+jPotV6tRbUonOTqUprEfLRBS1+52f1LTgqG
	I0xT8KFlNYXddEoPrdygSKVl4XXlHst5/+QwED+pY4ure3QO5w/eHHQkLDagaUrzRSOVmstbj2QSP
	qY2uklCw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uteNX-0000000Ehes-1Ot6;
	Wed, 03 Sep 2025 03:41:47 +0000
Date: Wed, 3 Sep 2025 04:41:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
	fengwei.yin@intel.com, david@redhat.com, tujinjiang@huawei.com
Subject: Re: + filemap-optimize-order0-folio-in-filemap_map_pages.patch added
 to mm-new branch
Message-ID: <aLe4-6UEhiGKlXt8@casper.infradead.org>
References: <20250902231041.96D8FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902231041.96D8FC4CEED@smtp.kernel.org>

On Tue, Sep 02, 2025 at 04:10:40PM -0700, Andrew Morton wrote:
>  	set_pte_range(vmf, folio, page, 1, addr);
>  	(*rss)++;
> -	folio_ref_inc(folio);
> +	folio_unlock(folio);
> +	return ret;

No, this is the wrong version.  The folio_unlock() should not be moved.
