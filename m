Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898F5EDD
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 02:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708308681; cv=none; b=cYTXATaHSHOVBLHcO3whj/MZ5e/tOPBKqHvg0KiKf2HKxDm145k0ZrTuC4Yff5g7TJ2kHiDVc4UQbk3/PPm18+2Wz/V3nlU7VeooAZhxyGUrA3cwWG7EMgin37fR0ggFBsaYt57rzl6ucNH5WKnUFFXMpamB8t+Sjca0BwtmNwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708308681; c=relaxed/simple;
	bh=vJW8ekLRmKaK7u0Rqa8ttaCbjaU3IdYLavhw/wTFz8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmzNQXYfvjV3ERcfZJ0rsdO0W4q935TTiEI4Qayt3DK6gP4QqkGds2Ipbbbu/PFNP1KEShXF1nIVCa749SwE/bUE0x/HWZK993Da8tyEZIIkY/JWYTA2gZO7l/gUoc1/3RaNxnvXzY9vtvlfThnrH2+ri8YZLqbDJ9XyHaWfhkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rbt7Z-00F6k5-K7; Mon, 19 Feb 2024 10:11:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 Feb 2024 10:11:19 +0800
Date: Mon, 19 Feb 2024 10:11:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
	yosryahmed@google.com, vitaly.wool@konsulko.com,
	sjenning@redhat.com, nphamcs@gmail.com, hannes@cmpxchg.org,
	ddstreet@ieee.org, davem@davemloft.net, chrisl@kernel.org,
	v-songbaohua@oppo.com
Subject: Re: +
 crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch
 added to mm-unstable branch
Message-ID: <ZdK4x9J/hhReO6wg@gondor.apana.org.au>
References: <20240218230441.7D7E3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240218230441.7D7E3C433C7@smtp.kernel.org>

On Sun, Feb 18, 2024 at 03:04:40PM -0800, Andrew Morton wrote:
>
> ------------------------------------------------------
> From: Barry Song <v-songbaohua@oppo.com>
> Subject: crypto: introduce acomp_is_sleepable to expose if comp drivers might sleep
> Date: Sat, 17 Feb 2024 17:51:00 +1300

Hi Andrew:

Please drop this patch as it should've gone through the crypto
tree.

Also per previous discussion, it needs to demonstrate that this
actually makes a difference in the right direction vs. using the
scomp interface directly (as opposed to comparing against the
code-base without this patch as it does right now).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
