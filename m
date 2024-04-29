Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F037E0F6
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714405240; cv=none; b=oYlT6aAzckfvAWReb19daQG3m5ziZhXdvT5oReOoqo5c/C681wOBXdkEwYyU4hi+JCXcU8kXXWi5IOtDS6KAwnSK6Kqm2o45wgHLA6g3q3ZyWFHbUHcUva+7MTVv4eXycjmG6IprJWYWKlmGlS0opUXDuLOjtjF20YNBra82GMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714405240; c=relaxed/simple;
	bh=YakN9SkLseg6J/UYEpYs126McZSsuNZS9ZKZnzU5aRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTcWYK+sRBzbnXcIhVduy18kFGFKbpzi7Uk+594QLyY48ZuhrqShCrpRIKCnK/qx1y8ZSN9GIi9dK/DubwYaa25x+eYBwUttqzMJ2vRg1c809pVrgi9MN8VdAazREYxRj76yqc6+xEbDnYdLOyhtTD5YWRF4v9kNEY6pEsZA1jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jaXmpbAY; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaXmpbAY"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2abae23d682so1233361a91.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 08:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714405238; x=1715010038; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yiOAu8NynUfn7+9lEM74YcgsHgS7lOVOAQkE9E1Ukn4=;
        b=jaXmpbAYL7I3T7wqjV1XRWo7mUxu74Wo07ESziloRr/Ww7xezXi6gSVP8MxPvimFQ3
         fon6ECDw178kl6LhT4l5tCdU1Vh5CZTPQ4Iy4CjIBbiA5ID4zpiksFaPex4Ql8b/kfIf
         8jiWLCc4hyMCKQG+USbdVx1lpJRHVmz5bwAim9/EsMJR9NbaYKcYgH7WVKEmNegLNfdO
         yz4u0halEJcQ+b7iOefFA5LDeRn1uhPk2AJrxjVZCiCr0kZftre5ojjDi4kgqcJ5h1iU
         1xRVg+AAHSYmG4uDGouvm5+lFu40axWQYbrp+WLL1hD9Rt3U8n/eDk6nznOqVSuP+kmT
         989g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714405238; x=1715010038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yiOAu8NynUfn7+9lEM74YcgsHgS7lOVOAQkE9E1Ukn4=;
        b=ltRUe6+qtXyqrQxA0K5dQ+aXDptbBAtNfmyfqBhhgPOdvYVRbQ2rirO4O4Y6OWiT1S
         i6CfOgGQX4B19fnsgRvn3R96onbMVIB/yI0xM3ktn/gmrijFkt+7vVJfOopsr85nDBpT
         oNzReaOUfJNQm8FhNs/+ECqmnGy4SOZruVMc6iJ+6JULTZCSGKDJ+FYIBXgjMNOPFN62
         R6v0rjovIjRzbJSVyb/4cCrDTRj7r+qUv1vzMgYNFKhlJOQLNo6lJWQ8HI6E+hPC5xGo
         63JprVwr5mui1DG1utMk5fEbIScoQwv4PN82HEWqOGP+oZgfC78EghZIZfIZud7qiUHS
         3fBw==
X-Forwarded-Encrypted: i=1; AJvYcCXqqpSMw67txwGdTPGY8a6/AWTLHpR9Vq5zbFpDRY4zPjrVQCLfo/ZhPDrndJKyjDlFitsXvF2rlTVHHKapSNYnx13Lrm9XSGXZYg==
X-Gm-Message-State: AOJu0Yyu0jkTXHfSkFGZlgpyjAav/bnBICPSwLDSbyRX79DqTTSZIQFq
	RZlfxhH0OmPhwUdh9+V+Y9YHiADz9FMmapsjZtOS/Yh2lfCkWByCKQ7l3wQI
X-Google-Smtp-Source: AGHT+IFWXcrIMFYScx0B7+8PfzK8por9kGnskQJag+Ep8BD7GH7Xtc7Lhms5JV1lEYjQyfNomzc6Xw==
X-Received: by 2002:aa7:91ca:0:b0:6ec:f406:ab17 with SMTP id z10-20020aa791ca000000b006ecf406ab17mr11905119pfa.0.1714405238085;
        Mon, 29 Apr 2024 08:40:38 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id z8-20020a056a00240800b006ecf6417a9bsm19355300pfh.29.2024.04.29.08.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 08:40:37 -0700 (PDT)
Date: Mon, 29 Apr 2024 23:40:34 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, jserv@ccns.ncku.edu.tw,
	n26122115@gs.ncku.edu.tw
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
Message-ID: <Zi+/cv66TtX3UkxM@visitorckw-System-Product-Name>
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
 <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
 <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>
 <Zi50cAgR8nZvgLa3@yury-ThinkPad>
 <b14ef3d8-6b14-4078-b1dc-0df330948ebf@rasmusvillemoes.dk>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b14ef3d8-6b14-4078-b1dc-0df330948ebf@rasmusvillemoes.dk>

On Mon, Apr 29, 2024 at 10:05:12AM +0200, Rasmus Villemoes wrote:
> On 28/04/2024 18.08, Yury Norov wrote:
> > + Rasmus
> > 
> > On Sat, Apr 27, 2024 at 01:33:55PM +0800, Kuan-Wei Chiu wrote:
> >> Before:
> >>                Start testing find_bit() with random-filled bitmap
> >> [    0.299085] fbcon: Taking over console
> >> [    0.299820] find_next_bit:                  606286 ns, 164169 iterations
> >> [    0.300463] find_next_zero_bit:             641072 ns, 163512 iterations
> >> [    0.300996] find_last_bit:                  531027 ns, 164169 iterations
> >> [    0.305233] find_nth_bit:                  4235859 ns,  16454 iterations
> >> [    0.306434] find_first_bit:                1199357 ns,  16455 iterations
> >> [    0.321616] find_first_and_bit:           15179667 ns,  32869 iterations
> >> [    0.321917] find_next_and_bit:              298836 ns,  73875 iterations
> >> [    0.321918] 
> >>                Start testing find_bit() with sparse bitmap
> >> [    0.321953] find_next_bit:                    7931 ns,    656 iterations
> >> [    0.323201] find_next_zero_bit:            1246980 ns, 327025 iterations
> >> [    0.323210] find_last_bit:                    8000 ns,    656 iterations
> >> [    0.324427] find_nth_bit:                  1213161 ns,    655 iterations
> >> [    0.324813] find_first_bit:                 384747 ns,    656 iterations
> >> [    0.324817] find_first_and_bit:               2220 ns,      1 iterations
> >> [    0.324820] find_next_and_bit:                1831 ns,      1 iterations
> >>
> >> After:
> >>                Start testing find_bit() with random-filled bitmap
> >> [    0.305081] fbcon: Taking over console
> >> [    0.306126] find_next_bit:                  854517 ns, 163960 iterations
> >> [    0.307041] find_next_zero_bit:             911725 ns, 163721 iterations
> >> [    0.307711] find_last_bit:                  668261 ns, 163960 iterations
> >> [    0.311160] find_nth_bit:                  3447530 ns,  16372 iterations
> >> [    0.312358] find_first_bit:                1196633 ns,  16373 iterations
> >> [    0.327191] find_first_and_bit:           14830129 ns,  32951 iterations
> >> [    0.327503] find_next_and_bit:              310560 ns,  73719 iterations
> >> [    0.327504] 
> >>                Start testing find_bit() with sparse bitmap
> >> [    0.327539] find_next_bit:                    7633 ns,    656 iterations
> >> [    0.328787] find_next_zero_bit:            1247398 ns, 327025 iterations
> >> [    0.328797] find_last_bit:                    8425 ns,    656 iterations
> >> [    0.330034] find_nth_bit:                  1234044 ns,    655 iterations
> >> [    0.330428] find_first_bit:                 392086 ns,    656 iterations
> >> [    0.330431] find_first_and_bit:               1980 ns,      1 iterations
> >> [    0.330434] find_next_and_bit:                1831 ns,      1 iterations
> >>
> >> Some benchmarks seem to have worsened after applying this patch.
> >> However, unless I'm mistaken, the fns() changes should only affect the
> >> results of find_nth_bit, while the others are just random fluctuations.
> > 
> > So...
> > 
> > The patch itself looks good, 
> 
> Well, I think it could be even better. While I agree that bit=ffs();
> clear_bit(bit, ) is probably a bad way of doing it, I think the basic
> structure of the function is good. Introducing a "count from 0 up to n"
> loop is rarely a good thing, keeping the n counting down to 0 is likely
> better.
> 
> So I'd instead just change the function to
> 
> static inline unsigned long fns(unsigned long word, unsigned int n)
> {
> 	while (word) {
> 		if (n-- == 0)
> 			return __ffs(word);
> 		word &= word - 1;
> 	}
> 
> 	return BITS_PER_LONG;
> }
>
How about rewriting it as follows:

static inline unsigned long fns(unsigned long word, unsigned int n)
{
    while (word && n--)
        word &= word - 1;

    return word ? __ffs(word) : BITS_PER_LONG;
}

IMHO, this way the code can be shorter and more elegant.

Regards,
Kuan-Wei

> 
> Now that I look closer, I think the
> 
>  * Returns the bit number of the N'th set bit.
>  * If no such, returns @size.
> 
> in the find_nth_bit and friends' docs is wrong. Tell me what happens here:
> 
> 
>   DECLARE_BITMAP(x, 12);
>   int i;
> 
>   x[0] = 3;
>   i = find_nth_bit(&x, 12, 7);
> 
> So I'm asking for the seventh (counting from 0) bit set in a bitmap of
> 12 bits, but only two bits are set. So i should be 12? No, i will be
> BITS_PER_LONG, because fns() doesn't know anything about the limit of
> 12. Do we really not have any tests covering that? Or indeed covering
> any of the small_const_nbits optimizations?
> 
> I've said this before, and I repeat. It was a mistake for the bitmap
> functions to promise a return of exactly @size when stuff is not found,
> they should always have just promised to return something >= @size. The
> checking in the callers would be just as easy (and some indeed do >=
> instead of ==), but the implementation can be somewhat cheaper. I'm
> afraid that ship has sailed, but it annoys me every time I stumble on this.
> 
> Rasmus
> 
