Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E06CB67B
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 04:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708316378; cv=none; b=kTBHE3jzafVS3bPD1DGS4wTHPnM3YnfbnxH8MrGVrqGHiqLpgcRgEeQUPpN6fFV53tIXeXLZYzIfmGih74in23ZDVbValSt1skBPVgP5mMpwrHJtgDzR4gc9suPi6qA6z6EFFTgzvMt99CRprkK5dGGBMY4vcraC+up8yKDHSJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708316378; c=relaxed/simple;
	bh=bCm2IJR54YQpptKgenO5j6QaOTT9fNHrxqhQoaS1D6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fabJembKbvPr5cdt+S9u6PB3HjVVehmfyY1ROV1C4EB7wO5LHM0wgv0GuYIgYXqjVoWhcNgPDfmqe6koHje+g8t12c2Bg2mFAkQ992Chu/0EqwagKOYG8Q6m7yLiHLChxgUEY5d1jUwOKW3vhq/Bt549+93rL7P/xAscA008InM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rbv7d-00F8Bx-EJ; Mon, 19 Feb 2024 12:19:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 Feb 2024 12:19:31 +0800
Date: Mon, 19 Feb 2024 12:19:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, davem@davemloft.net,
	ddstreet@ieee.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org,
	nphamcs@gmail.com, sjenning@redhat.com, v-songbaohua@oppo.com,
	vitaly.wool@konsulko.com, yosryahmed@google.com,
	zhouchengming@bytedance.com, wangzhou1@hisilicon.com
Subject: Re: +
 crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch
 added to mm-unstable branch
Message-ID: <ZdLW0/cLS0YT6P9E@gondor.apana.org.au>
References: <ZdK4x9J/hhReO6wg@gondor.apana.org.au>
 <20240219040317.5184-1-v-songbaohua@oppo.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219040317.5184-1-v-songbaohua@oppo.com>

On Mon, Feb 19, 2024 at 05:03:17PM +1300, Barry Song wrote:
> 
> Not Andrew, i wrote a note in cover-letter and said zswap was
> the direct user for this patch, so it is good to go through
> mm. but it's also fine to go through crypto.

Even if we decided to export whether an algorithm is sync or not,
the approach taken in the patch is not the right way to do it.

You're exporting an internal data structure and making it available
to everyone.

> But the problem of directly using scomp is that we are losing
> the chance to use hardware like intel/qat/qat_common/ and
> hisilicon/zip/zip_crypto.c to offload the overhead of
> compression/decompression as those drivers have no scomp.
> On the other hand, acomp with acomp backend can sometimes
> decrease cpu usage especially when PAGE_SIZE is big such
> as 64KiB while providing higher performance.

No I'm talking about using scomp only in the specific case of
an unsleepable context.  If you think acomp offload still
provides a sufficient benefit in that corner case, please
provide the data to back it up.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
