Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4987A1E4BE
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408450; cv=none; b=lZTrAfWpSYAc9uxXFa0s5j7S9dbdvywzrbQ0P1xTFQaxmlcIASkU/E5IlIGDIDT2Wk/YqPGOi1zEP3J1SIHtFAc7Azw6h6oEWi2KuvCPCj7uyGNXFMMiC8Sm6rhY/otupcMiHiNrU0HggduodURZu8tMnCayzfl24Fvh1PCEtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408450; c=relaxed/simple;
	bh=QgLDFJdy7TMDaQrtsHnye0l8VgL3x8WxlVk8JpfVeqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qI61/oC5lnlaylv3/AbXjMy5JEfp2aJlN/HZ4rj/Ki4XY7gGmI8wWAWkr5qGYVMLFQMrmfiyHE3QX/OUfcAhhlcAgyZ+Yx/g7f6sFfItyZrP3cckH0saWDHHCUWFnc+/ml9utSO4wbXzJbNdiT24YpXdXpmlXs5BUv0NxN2toCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lO3RnGVj; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lO3RnGVj"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-61af74a010aso46008867b3.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 09:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714408448; x=1715013248; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kjHzsjc68dgK5/ua7wi8hd4abnOKjH/b67h5LoWBc6c=;
        b=lO3RnGVjbl0znZtXDSaGeQiEmJZQqZUeCp/Nb9VWZJ0gL8zOpRrobH499SWVG0RiIc
         au8aAj2r15p0q6BgwbQEVCel+WNS71oPMG/cmcog3zRbuoLHDB/3jHmTIlJ4sQTtOY+p
         kFp3pCRqqcFKLOsaoOQkiei7zHnDnhWB9vmBcyqdb0Kr5ljQ0KjxP0bXg4nwAsTe7DMg
         RH8YsCkhrgYJN++zRBC4KjAn0TELIJ3CEzguRdWzgkjPCFV4CNhU3BziFq80PeBQcwti
         N1ISErlbg8ZhW9JWR9KPT5pjqgGbypQCAfWtArKEQ2uzMvnwlelCK0BJQ24gqEKHPpyT
         CHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714408448; x=1715013248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjHzsjc68dgK5/ua7wi8hd4abnOKjH/b67h5LoWBc6c=;
        b=YzSwHA4GsDn4ccl6/Eg9u6Da61mJTLO7tICwkElu3bvyCa29lvsHrEIG9wiMxD363t
         oQA3oWINo29cP8Wh4Ds034ldeu4cjBQkT4rVHvagk+hv/8ylZ7Nx8xNkyLsBrpa4/kkh
         uJAVQVsCUTJuZXw2IgV1tfck7SV7WBbhD30uc2PuTM81CanfV+OSIrenvFhmeNXbMMec
         V0/6LI/Wph1HH4p6cbA91nsETUpIEwkpQrTjiQui4xC64lB2/VDBVTUFfluAlsEUk9eS
         ZOCypnn/TpiIpUOFyUlywcMKsjeTcs0dv1KG0hsOOR52PfXJQnjoaZNn/WF/odQICS75
         NrdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXz00TlyJmE67LO94gZRzucbxQvxEG2IpES0jq0ej359ManTp9XO4a15YF8lBgltqemyYVp9/AOyeRfnpwN0GQ8GWBcZZXQ8RxUnw==
X-Gm-Message-State: AOJu0YxcNyLHrgn+5IcvSdlBIqVIT7afJ6hQwZxhqUIs6XZrcCBhpwV1
	dBGrRTDN4bx/eacd0TZpMkZnWYMQ3csvzHES2ibGpNOSrRBLuc19gykL7w==
X-Google-Smtp-Source: AGHT+IFGNO+Xvu53bGngkAzitYYAEe8lPyxt7w+YeR58xh7pdfl08wGaD60zm+x9xoWmpZNGPIDphQ==
X-Received: by 2002:a05:690c:296:b0:61a:edf1:da55 with SMTP id bf22-20020a05690c029600b0061aedf1da55mr11289656ywb.47.1714408448130;
        Mon, 29 Apr 2024 09:34:08 -0700 (PDT)
Received: from localhost ([2601:344:8301:57f0:494:898b:2d2e:ed3f])
        by smtp.gmail.com with ESMTPSA id w63-20020a0dd442000000b0061ab76e5f4dsm5480558ywd.114.2024.04.29.09.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 09:34:07 -0700 (PDT)
Date: Mon, 29 Apr 2024 09:34:06 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, jserv@ccns.ncku.edu.tw,
	n26122115@gs.ncku.edu.tw
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
Message-ID: <Zi/L/hV47DJbtqqj@yury-ThinkPad>
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
 <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
 <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>
 <Zi50cAgR8nZvgLa3@yury-ThinkPad>
 <b14ef3d8-6b14-4078-b1dc-0df330948ebf@rasmusvillemoes.dk>
 <Zi+/cv66TtX3UkxM@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi+/cv66TtX3UkxM@visitorckw-System-Product-Name>

On Mon, Apr 29, 2024 at 11:40:34PM +0800, Kuan-Wei Chiu wrote:
> On Mon, Apr 29, 2024 at 10:05:12AM +0200, Rasmus Villemoes wrote:
> > On 28/04/2024 18.08, Yury Norov wrote:
> > > + Rasmus
> > > 
> > > On Sat, Apr 27, 2024 at 01:33:55PM +0800, Kuan-Wei Chiu wrote:
> > >> Before:
> > >>                Start testing find_bit() with random-filled bitmap
> > >> [    0.299085] fbcon: Taking over console
> > >> [    0.299820] find_next_bit:                  606286 ns, 164169 iterations
> > >> [    0.300463] find_next_zero_bit:             641072 ns, 163512 iterations
> > >> [    0.300996] find_last_bit:                  531027 ns, 164169 iterations
> > >> [    0.305233] find_nth_bit:                  4235859 ns,  16454 iterations
> > >> [    0.306434] find_first_bit:                1199357 ns,  16455 iterations
> > >> [    0.321616] find_first_and_bit:           15179667 ns,  32869 iterations
> > >> [    0.321917] find_next_and_bit:              298836 ns,  73875 iterations
> > >> [    0.321918] 
> > >>                Start testing find_bit() with sparse bitmap
> > >> [    0.321953] find_next_bit:                    7931 ns,    656 iterations
> > >> [    0.323201] find_next_zero_bit:            1246980 ns, 327025 iterations
> > >> [    0.323210] find_last_bit:                    8000 ns,    656 iterations
> > >> [    0.324427] find_nth_bit:                  1213161 ns,    655 iterations
> > >> [    0.324813] find_first_bit:                 384747 ns,    656 iterations
> > >> [    0.324817] find_first_and_bit:               2220 ns,      1 iterations
> > >> [    0.324820] find_next_and_bit:                1831 ns,      1 iterations
> > >>
> > >> After:
> > >>                Start testing find_bit() with random-filled bitmap
> > >> [    0.305081] fbcon: Taking over console
> > >> [    0.306126] find_next_bit:                  854517 ns, 163960 iterations
> > >> [    0.307041] find_next_zero_bit:             911725 ns, 163721 iterations
> > >> [    0.307711] find_last_bit:                  668261 ns, 163960 iterations
> > >> [    0.311160] find_nth_bit:                  3447530 ns,  16372 iterations
> > >> [    0.312358] find_first_bit:                1196633 ns,  16373 iterations
> > >> [    0.327191] find_first_and_bit:           14830129 ns,  32951 iterations
> > >> [    0.327503] find_next_and_bit:              310560 ns,  73719 iterations
> > >> [    0.327504] 
> > >>                Start testing find_bit() with sparse bitmap
> > >> [    0.327539] find_next_bit:                    7633 ns,    656 iterations
> > >> [    0.328787] find_next_zero_bit:            1247398 ns, 327025 iterations
> > >> [    0.328797] find_last_bit:                    8425 ns,    656 iterations
> > >> [    0.330034] find_nth_bit:                  1234044 ns,    655 iterations
> > >> [    0.330428] find_first_bit:                 392086 ns,    656 iterations
> > >> [    0.330431] find_first_and_bit:               1980 ns,      1 iterations
> > >> [    0.330434] find_next_and_bit:                1831 ns,      1 iterations
> > >>
> > >> Some benchmarks seem to have worsened after applying this patch.
> > >> However, unless I'm mistaken, the fns() changes should only affect the
> > >> results of find_nth_bit, while the others are just random fluctuations.
> > > 
> > > So...
> > > 
> > > The patch itself looks good, 
> > 
> > Well, I think it could be even better. While I agree that bit=ffs();
> > clear_bit(bit, ) is probably a bad way of doing it, I think the basic
> > structure of the function is good. Introducing a "count from 0 up to n"
> > loop is rarely a good thing, keeping the n counting down to 0 is likely
> > better.
> > 
> > So I'd instead just change the function to
> > 
> > static inline unsigned long fns(unsigned long word, unsigned int n)
> > {
> > 	while (word) {
> > 		if (n-- == 0)
> > 			return __ffs(word);
> > 		word &= word - 1;
> > 	}
> > 
> > 	return BITS_PER_LONG;
> > }
> >
> How about rewriting it as follows:
> 
> static inline unsigned long fns(unsigned long word, unsigned int n)
> {
>     while (word && n--)
>         word &= word - 1;
> 
>     return word ? __ffs(word) : BITS_PER_LONG;
> }
> 
> IMHO, this way the code can be shorter and more elegant.

Rasmus' code looks shorter because it tests the 'word != 0' only once
when n == 0, for example. But we never sure how the compiler would
optimize it. Can you show a disassembly of both and pick the best?

Thanks,
Yury
