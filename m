Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151D37EF02
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410380; cv=none; b=pDsw3ASePE/rFsV3g2fe4qZ3leiS/TuRgU+0Ai8isVQu1v6gB+I5Kv1wOqGdNv6jsCCcw43erbwtaSZvW/0xrj4dEcUo2lKNxa1MCkfdNqoLFMquoXSZ/4SDXPervoKdj6b2M8yjagvquIAMr7yfgklcsk8YZV5GcZV1wTBvRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410380; c=relaxed/simple;
	bh=H+UXi9QvrM2rEgjHPawckzrLFiJyy31HlemZgzzWzzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXYufAm4qpMza3UuL5k8ICrBIZVpZfiOjc900FK6UoTDrpN6oGIwC8W4Wy9matPB3rG7EXV1tEUydMNwfukSoCUiel5Onm3dw9VmI3qrMwc8RsrNSvrzbbkC4rX1yMjkjqPd6na7/W5ax15CV9poa5uqdaRD51BU2VdP6+/ULbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UsKLEJCh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsKLEJCh"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f055602a7bso169558b3a.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 10:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410378; x=1715015178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c2wBp5U9m4f5aHBzvz5UlXO+VXznghx7NQKhDrkcqbs=;
        b=UsKLEJChSRL9ATfgZ7e3XeR5nNz3vm7d+cbwPEoF1iIvI/nPtadM/TDGogebMIf97x
         JSQDr0tt1BSV5VDvrTiei6ntVFa3YiiAva3sEWSj2lhBAhHU7sB3gvrOv9Vu6Ie6CUpm
         4Lzv/o8bTfNyIMrJ1ugZHdLWAuVTF6029Eu8CjOsrYJ5kte+DJGF9XcUpRNcmxvgMx5a
         0aAlwdPEGf36NWQ29kSSR8gf5IbjualjVXlbz7X+ip6C+KPHEEhIVnQn2i1pYT5JL/bh
         0Xjr2dbAHOJ9GqIJgc8kMDmqIE0ypH1m50Yc8/Qoogc6u3zOV3l3/u4Pb55ZrNS1/aL1
         46EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410378; x=1715015178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2wBp5U9m4f5aHBzvz5UlXO+VXznghx7NQKhDrkcqbs=;
        b=onirg3ITye6egP93dDsExYZ/b/sRq9bVzibJmuwHzN5S54lfkcfefpedKdczyrAaLK
         l3miCAFRsaVf3ny73pi/xekGvMVuThGf5wK8O64kFwH34tSYaCofZd7k4aVWaVKj1ZKz
         rJKjNFVjf3xtnZ/Zk1yaFfFXay/Dy/VOt2/36IU/cIRztGC3IdV/nePRetHb4D9a/Op0
         laAd5g9XGlLQNTBnFLN+2g5vL7pJWea8vAYQfZWCBo5e/z1FiQVZwPOrV7oXdzvc8dw/
         121UtC4i6IoV+wPMCeZFozbMngTDP7s02oYqYUGQZdJPB1I1SWrNA/yIo0DqmCbVc6jd
         HHcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXrLfO0AjLCBk7HIJDWUjK5gRfXkcB48UEP80mnRvXDt7eSB8XxlZY2uvRG/xx4buuB1X3cK20C0TOttSlb2g3xeujkxy3YKc9jw==
X-Gm-Message-State: AOJu0Yx8Vh/QQkKbEFH2wI3non9D0yU7ABAIRX1vY5idRcxAlxEKuhw3
	83OTTkCIaRpIEKOnDRHcHtyChWVhdbRu/544siKKoT35PbqHeN33
X-Google-Smtp-Source: AGHT+IElo9Sf1xhDZs5/0w57T1sc+5RahtL61wQlx25g70YeHO2VY1PJr+BSMsUUvk/sj4d9pcRwLQ==
X-Received: by 2002:a05:6a21:18d:b0:1ae:42aa:7f1 with SMTP id le13-20020a056a21018d00b001ae42aa07f1mr12409822pzb.2.1714410378331;
        Mon, 29 Apr 2024 10:06:18 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id i6-20020aa787c6000000b006e6b52eb59asm19456961pfo.126.2024.04.29.10.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 10:06:17 -0700 (PDT)
Date: Tue, 30 Apr 2024 01:06:14 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, jserv@ccns.ncku.edu.tw,
	n26122115@gs.ncku.edu.tw
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
Message-ID: <Zi/ThiPs6tCflxUo@visitorckw-System-Product-Name>
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
 <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
 <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>
 <Zi50cAgR8nZvgLa3@yury-ThinkPad>
 <b14ef3d8-6b14-4078-b1dc-0df330948ebf@rasmusvillemoes.dk>
 <Zi+/cv66TtX3UkxM@visitorckw-System-Product-Name>
 <Zi/L/hV47DJbtqqj@yury-ThinkPad>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi/L/hV47DJbtqqj@yury-ThinkPad>

On Mon, Apr 29, 2024 at 09:34:06AM -0700, Yury Norov wrote:
> On Mon, Apr 29, 2024 at 11:40:34PM +0800, Kuan-Wei Chiu wrote:
> > On Mon, Apr 29, 2024 at 10:05:12AM +0200, Rasmus Villemoes wrote:
> > > On 28/04/2024 18.08, Yury Norov wrote:
> > > > + Rasmus
> > > > 
> > > > On Sat, Apr 27, 2024 at 01:33:55PM +0800, Kuan-Wei Chiu wrote:
> > > >> Before:
> > > >>                Start testing find_bit() with random-filled bitmap
> > > >> [    0.299085] fbcon: Taking over console
> > > >> [    0.299820] find_next_bit:                  606286 ns, 164169 iterations
> > > >> [    0.300463] find_next_zero_bit:             641072 ns, 163512 iterations
> > > >> [    0.300996] find_last_bit:                  531027 ns, 164169 iterations
> > > >> [    0.305233] find_nth_bit:                  4235859 ns,  16454 iterations
> > > >> [    0.306434] find_first_bit:                1199357 ns,  16455 iterations
> > > >> [    0.321616] find_first_and_bit:           15179667 ns,  32869 iterations
> > > >> [    0.321917] find_next_and_bit:              298836 ns,  73875 iterations
> > > >> [    0.321918] 
> > > >>                Start testing find_bit() with sparse bitmap
> > > >> [    0.321953] find_next_bit:                    7931 ns,    656 iterations
> > > >> [    0.323201] find_next_zero_bit:            1246980 ns, 327025 iterations
> > > >> [    0.323210] find_last_bit:                    8000 ns,    656 iterations
> > > >> [    0.324427] find_nth_bit:                  1213161 ns,    655 iterations
> > > >> [    0.324813] find_first_bit:                 384747 ns,    656 iterations
> > > >> [    0.324817] find_first_and_bit:               2220 ns,      1 iterations
> > > >> [    0.324820] find_next_and_bit:                1831 ns,      1 iterations
> > > >>
> > > >> After:
> > > >>                Start testing find_bit() with random-filled bitmap
> > > >> [    0.305081] fbcon: Taking over console
> > > >> [    0.306126] find_next_bit:                  854517 ns, 163960 iterations
> > > >> [    0.307041] find_next_zero_bit:             911725 ns, 163721 iterations
> > > >> [    0.307711] find_last_bit:                  668261 ns, 163960 iterations
> > > >> [    0.311160] find_nth_bit:                  3447530 ns,  16372 iterations
> > > >> [    0.312358] find_first_bit:                1196633 ns,  16373 iterations
> > > >> [    0.327191] find_first_and_bit:           14830129 ns,  32951 iterations
> > > >> [    0.327503] find_next_and_bit:              310560 ns,  73719 iterations
> > > >> [    0.327504] 
> > > >>                Start testing find_bit() with sparse bitmap
> > > >> [    0.327539] find_next_bit:                    7633 ns,    656 iterations
> > > >> [    0.328787] find_next_zero_bit:            1247398 ns, 327025 iterations
> > > >> [    0.328797] find_last_bit:                    8425 ns,    656 iterations
> > > >> [    0.330034] find_nth_bit:                  1234044 ns,    655 iterations
> > > >> [    0.330428] find_first_bit:                 392086 ns,    656 iterations
> > > >> [    0.330431] find_first_and_bit:               1980 ns,      1 iterations
> > > >> [    0.330434] find_next_and_bit:                1831 ns,      1 iterations
> > > >>
> > > >> Some benchmarks seem to have worsened after applying this patch.
> > > >> However, unless I'm mistaken, the fns() changes should only affect the
> > > >> results of find_nth_bit, while the others are just random fluctuations.
> > > > 
> > > > So...
> > > > 
> > > > The patch itself looks good, 
> > > 
> > > Well, I think it could be even better. While I agree that bit=ffs();
> > > clear_bit(bit, ) is probably a bad way of doing it, I think the basic
> > > structure of the function is good. Introducing a "count from 0 up to n"
> > > loop is rarely a good thing, keeping the n counting down to 0 is likely
> > > better.
> > > 
> > > So I'd instead just change the function to
> > > 
> > > static inline unsigned long fns(unsigned long word, unsigned int n)
> > > {
> > > 	while (word) {
> > > 		if (n-- == 0)
> > > 			return __ffs(word);
> > > 		word &= word - 1;
> > > 	}
> > > 
> > > 	return BITS_PER_LONG;
> > > }
> > >
> > How about rewriting it as follows:
> > 
> > static inline unsigned long fns(unsigned long word, unsigned int n)
> > {
> >     while (word && n--)
> >         word &= word - 1;
> > 
> >     return word ? __ffs(word) : BITS_PER_LONG;
> > }
> > 
> > IMHO, this way the code can be shorter and more elegant.
> 
> Rasmus' code looks shorter because it tests the 'word != 0' only once
> when n == 0, for example. But we never sure how the compiler would
> optimize it. Can you show a disassembly of both and pick the best?
> 
> Thanks,
> Yury

It appears that gcc with the O2 flag is smart enough to generate the
same code. The only difference in my disassembly results is the
generated label names. Tested with gcc 11.4.0.

Regards,
Kuan-Wei
