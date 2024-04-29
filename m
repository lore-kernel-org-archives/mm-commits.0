Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C125C824AA
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714407983; cv=none; b=arEo29uSoSSMfMY2XOT78KmTYBRMd6BR+iNhKOghPRfaLOROrrsp0fst1H8PoQQkmAF9WOpvtLg8r+YedOufBZX++UJ7z7eXEk83ISz0Oc6pS5CoGuQ3ZiGuGc2UXNjG0LODj5/7AYUFM2iLhj/ccMbHsc+akx+fFqVwedg4DHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714407983; c=relaxed/simple;
	bh=yI7Rl2zjgs+w2iMIyRPlh47eBnIramIWL1E0NfDeUEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgrUu47zO7ehHJXTkG9ZMGcVBQ0KDrpvQFDfCjp+OP0Ah9RHO+Tt8DkHUGsiIEnjcxxI8KgbWNIgCKwMcGM5Gcuxlco7lgsdNq9Uw5He635Kf0b21nqLXnAxVpA5eQONE5fC3+LLiKaq0M+al5iLGmeZ2/31Xr9zH740igfm1V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3HIUU7Q; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3HIUU7Q"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-61ac45807cbso50910587b3.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 09:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714407981; x=1715012781; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MTzUP00Nwwpu3K0JwMO/wk9Dq0x4zzzL3CwrC1kI6mc=;
        b=b3HIUU7Q4wywAgU+pJqYzW4YKAAZEGDQuw9XxsMj7DBbtOzhAtGpVpBhcd1FtCuzaz
         abdYAervtF0MCtCvSztCRvfJYZEjvPyyftZiR4/AYwIye0nS/3o+wcflX2cIDciRKMeF
         s8eZn141etNhJp9zJpUuxqAZORrbRB1Q+8WS9Ez8iO/krQuAR5zjaeBonexTr5OuLBzV
         SM0qmS7VBZkV3qdwMSVOe2y/P9stRSk31e6IPw6OE9XbzJp+p26t7W7+I1/3l/14qZG3
         w4iwUywSrrOkoOLJTykiHctXs/SgrZ6D8opUoC5kz5p1QbKQCc+pPV1PKOs4nwEWuXDl
         +i+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714407981; x=1715012781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTzUP00Nwwpu3K0JwMO/wk9Dq0x4zzzL3CwrC1kI6mc=;
        b=gBLUmCH7IgngmJCvmfFohg8s/qK3hqUNbZuT59uitagZwttqAuuG3aeuU5Xm4Iwq2O
         qCFyfQZprF1/XdR1Be24RTPCbvIDLoyl5zUGcwPRZwgPQTKKPhENbIelqsif7l5yYAFC
         GotuRMdQ9ohTiHEWXNh8sh0uDt+aQlZX6CCD3JB+FuTsnV6JoKf4FOY7sEuui8DZamI4
         1TDaLW8uOlQ9efmlT3iYlcofoFo3RE1ausURyuk7f7EN9qmjoTdHOvR95luEpdruMRQ8
         czP7pNtBxUg+QJLHObEYKLwvaIsLpI5BKrqsytZA3O0CJYWgRvIhvWl2i2qjd945ZOq1
         sOYw==
X-Forwarded-Encrypted: i=1; AJvYcCUfgCPBJNG26FO3ThYq8+H7vinJwpPOsjeFVTiHI9rK8iTx+mD0uhlxxkiQHIHXRJj6kf803B/hvTFNl6XWVYBkTHw7tpjfnYe9vQ==
X-Gm-Message-State: AOJu0YwH8/BOLSZRGkXJ/t7+8OnfhiMgsPw96A+c8sBvrOkssueRz3US
	VAyrpzSKGHyljs7FuJnGMPuxaLjn5lmEJxpdsF25Bt01ltRvhuMJ
X-Google-Smtp-Source: AGHT+IGui0TsiOalC7cMqaLZrmh6kVb7S6fgXDttSGND1ijeSBO5Q5xdH8KjWAQp/uJY0JmmW/gE6A==
X-Received: by 2002:a05:690c:640b:b0:61b:9369:ef36 with SMTP id hr11-20020a05690c640b00b0061b9369ef36mr365111ywb.37.1714407980565;
        Mon, 29 Apr 2024 09:26:20 -0700 (PDT)
Received: from localhost ([2601:344:8301:57f0:494:898b:2d2e:ed3f])
        by smtp.gmail.com with ESMTPSA id o19-20020a0dcc13000000b00617e3c07229sm5399486ywd.20.2024.04.29.09.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 09:26:20 -0700 (PDT)
Date: Mon, 29 Apr 2024 09:26:19 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, jserv@ccns.ncku.edu.tw,
	n26122115@gs.ncku.edu.tw
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
Message-ID: <Zi/KK1jh4ogYEPkj@yury-ThinkPad>
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
 
Agree. Even better.
 
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

We test non-small_const_nbits() case in  test_find_nth_bit() tests at
line 257:

        expect_eq_uint(64 * 3 - 1, find_nth_bit(bmap, 64 * 3 - 1, 8));

And this is enforced in FIND_NTH_BIT() like this:

        sz = min(idx * BITS_PER_LONG + fns(tmp, nr), sz);
        
We don't test small_const_nbits() case, and it seems violating that
rule.

> I've said this before, and I repeat. It was a mistake for the bitmap
> functions to promise a return of exactly @size when stuff is not found,
> they should always have just promised to return something >= @size. The
> checking in the callers would be just as easy (and some indeed do >=
> instead of ==), but the implementation can be somewhat cheaper. I'm
> afraid that ship has sailed, but it annoys me every time I stumble on this.

The ship has sailed for an old API. For the new one we can make new
rules. Moreover, almost all kernel users of the function use it as
cpumask_nth(), and in cpumask API we always claim to return >= @size
if nothing is found.

So, we need to either fix small_const_bit() branch, or relax the
'== @size' requirement in FIND_NTH_BIT() and in the comment. I'd
rather do 2nd despite it breaks consistency...

Can you send a patch?  Or I can do it myself if you prefer.

Thanks,
Yury
