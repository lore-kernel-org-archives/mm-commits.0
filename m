Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B4FEDD
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 02:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708308712; cv=none; b=M3PJY4ULlIHHiKbOQUk6lQn9tKWHt1lABEew5v9xtNKwXpKGnVytu31IlI39c6DvznSvaeoqhtTM5kHvrTml7PHUM0vNqD0BXIBf7XKQuyDJCGmFnFLXUMFK5PyemIk8tv2+TruDL++Co8n0SCd8h/r5LUM4GOSYyjNCt75hDZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708308712; c=relaxed/simple;
	bh=0GYFG5zmxbQmJUgiUOhC4YOLL2LESOomNPOqNQeliU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNdfq1rxeztyeptkmHoetp8B2gKEo0ieSkJA41/os+536UgtGSQFB6ac4XHEsQCGzImWWJOEfFw1ulAfNEVFCyEuzjNWzi7/ud57cnKkunumCRJn0CC90Tp5TnZJXU6hLnuHEU36sfvvb1R22yo+Hfp2txiW2xmmbBHMh4ai2TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rbt8D-00F6kk-Pp; Mon, 19 Feb 2024 10:11:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 Feb 2024 10:12:00 +0800
Date: Mon, 19 Feb 2024 10:12:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
	yosryahmed@google.com, vitaly.wool@konsulko.com,
	sjenning@redhat.com, nphamcs@gmail.com, hannes@cmpxchg.org,
	ddstreet@ieee.org, davem@davemloft.net, chrisl@kernel.org,
	v-songbaohua@oppo.com
Subject: Re: + crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch added to
 mm-unstable branch
Message-ID: <ZdK48DtKboXF0uTi@gondor.apana.org.au>
References: <20240218230445.B1233C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240218230445.B1233C433F1@smtp.kernel.org>

On Sun, Feb 18, 2024 at 03:04:45PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: crypto: scompress: remove memcpy if sg_nents is 1
> has been added to the -mm mm-unstable branch.  Its filename is
>      crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

> ------------------------------------------------------
> From: Barry Song <v-songbaohua@oppo.com>
> Subject: crypto: scompress: remove memcpy if sg_nents is 1
> Date: Sat, 17 Feb 2024 17:51:02 +1300

Hi Andrew:

Please drop this patch as it should go through the crypto tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
