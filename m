Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5A25949D
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736346396; cv=none; b=Dp+/JJ6TFs/adK3fo2NBbu7WjkAVOgeHAwF7f09KA7HjPWPLmZSXps+bbOEpt2VyRosXpZ8R7VE7MrSchnRV+EOIQITnQRO5mWXKi60vS6XTdiYjSILdzFv8LsxEKwn7JvWxvQHESofWA3r4pn5zNw3yu2LqdrFPdkWvpYRXX/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736346396; c=relaxed/simple;
	bh=4Guo9WMPj08tFFttu3DV2i9ayFwUIdAsWMCmQduMgcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhAYDOEH5uqW18PPK+gbDZ7MBUIBCCQ9boTt24d5NYhv7ehowvNaltMUrZwwjpSQRwIni4WHWm7yv32ELdrBxogdgWz6GJJI7j+OxfvSeTz+K9ijY+tC9W2Z/ECtP6jblE91lylpRMhcbRelQIP8PBTvD4/48TWTmEjsPy+oJ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ugAsBH2V; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ugAsBH2V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KbzYpKqp+U/Fs0ZESAzc2ilAysai1xUJRwxGEjKOCok=; b=ugAsBH2VMYx3ie5PEkol6YrB8w
	SiGogN2odOcRC1fXUlkQTecR3LC5waYJTEUXk91ftjwyEm9fwFtJ8enQ4hb7WAXSwZLPk/HY5iWNn
	8ulkuRaPwNrBdOJjFAlj7j6MybqF1Tyx3NXF7PGe02g6wTeSXJllAso+fyQImfRF3K9h+nSrVfKhy
	Y5aunJX+Wy1ct6bZRm+OcyY+2662UPvN1HtSIIm3ZMCiC6ChjW3bwFeihUy19GqnE3LvEv49xEBI8
	SPHBLU5Rj1x3V1zTT9zsgIGwZN2IbcYQsgODNsJ6xh4C4JCi5VqjCXsO+nYm9fkYBF2zeyLkjLsoE
	W1BfloVg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVX0v-00000000hLr-2efd;
	Wed, 08 Jan 2025 14:26:29 +0000
Date: Wed, 8 Jan 2025 14:26:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, hch@lst.de,
	hannes@cmpxchg.org, clm@meta.com, bfoster@redhat.com,
	axboe@kernel.dk
Subject: Re: + mm-add-pg_dropbehind-folio-flag.patch added to mm-unstable
 branch
Message-ID: <Z36LFTqnHM-jywV5@casper.infradead.org>
References: <20250108033555.926E6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108033555.926E6C4CED0@smtp.kernel.org>

On Tue, Jan 07, 2025 at 07:35:55PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: add PG_dropbehind folio flag
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-add-pg_dropbehind-folio-flag.patch

I was hoping we'd get some response to Kirill's suggestion that we not
do this.

https://lore.kernel.org/linux-mm/Z2WRJdKnTD5eSfBS@casper.infradead.org/
