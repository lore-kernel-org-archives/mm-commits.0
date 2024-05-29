Received: from wfhigh7-smtp.messagingengine.com (wfhigh7-smtp.messagingengine.com [64.147.123.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5C6158201
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716993611; cv=none; b=jT0JmOTTRkjTZsdp6B/FgbuB/UtHx03s/Lc1DqQjDP5xYYHOhXbXtZRNrsxq+0CXRUzlMbsst5WpmjuPkgH2ksN3pHdGy8Ip3eH5MhesqikfdrxWc1FK4dbzcreAidQTx+D3nodos1eJx51xlfQimGFL4gWCPoL073GU3tqdeu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716993611; c=relaxed/simple;
	bh=x/JphizHAXbgnVrvfRPjd4PmBANp0hhNU6My3qBsDdU=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:
	 Subject:Content-Type; b=SrQxkA7gkvDwnB2KUAwjDWNBGsTcD0F1PVWVDzdh+RW84wyjozh/+aWxQ+schfQ8C3i90ioBZEISAGqu9mu9IPj2qcrFARNipojNOX1NlIzDLHgyXC8cQA58yglIJNHdETSGm4TEldpa/hKO57Xq75Nt6fJGD4Lz5DfolRkJxII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=ZrxPDIyP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Rmzub/m7; arc=none smtp.client-ip=64.147.123.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="ZrxPDIyP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Rmzub/m7"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id 0F696180007F;
	Wed, 29 May 2024 10:40:07 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 29 May 2024 10:40:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1716993607; x=1717080007; bh=a7WM3Si7R3
	4BnctYs/0szML93FwTOqdMal+ftLQiihY=; b=ZrxPDIyPnwoOCl9vW402EmiCa0
	hujSqH3sWdpCsGzMu8SNVkFfImVw7GfvdJDL7U9CTbzUVTBS4me0bvZm0Kvn7Bec
	n9uhFvLGKeAfJRYCJ5PmIWTPTG5FZ/0+Dh5ZyGT6s0r+oSL4+tZNcUAw+kR5VaM8
	fVG6bsgtvUjEmgZWJ/zecS+3s/vjcCTVj80hhc5MJd3XEIHo9fXpziVCC0PRQabf
	NIKnXIG8qJW4DZhVfqzdVSf+MkT5SrF/keVHitW/4dgqSYyKU4cqqoz32dgcb/J+
	wT9VYklphLTlA8OxmEbKOSfCmBOApSpPh3Pbbqrv9gugoRE7xTVUPcavBqdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1716993607; x=1717080007; bh=a7WM3Si7R34BnctYs/0szML93FwT
	OqdMal+ftLQiihY=; b=Rmzub/m7AKCxBN1tu7c6rqMKCWGiTzX5/uMwt27zbDbJ
	f4iHraRezJD1NZS4UZvr9RgM45kFm+EjISaCts8Wfe1MmWMd3izdCJgsfhaalHnO
	n3Sss50po+jv6BRPqixDCOTM8rvM5iL1/aB+cDdBEMZ+p3yhXVIvLomrgtTUJnqE
	LxXAbSpJLWotXpEdzksuopI1FC4yl4SIRcLctYF5gjREJKA+RvL3pr/MwLcs0zA8
	ybWVUUcFXEUKhGe2k1wDN9o4KDQnBeQaOvRUf/fa82iWEM4t4XaEXqlEWV2TqV2A
	3FPDctzm81d962qEJcmNCkSRdZV1k4xJ/MHjWHekrw==
X-ME-Sender: <xms:Rz5XZmWeqR7TTTZBjsczXnn_az9Fd_AyYY7dI4cnA7hAZsVc_U1y3g>
    <xme:Rz5XZilLmVXTDMZfobniSrQLxR5XFE9GD0YA-tJcvuOQirbt9fyPgyAq8MHBFQRdz
    _xbStxJSQvq3w4SBFc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdekuddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffgeffuddtvdehffefleethfejjeegvdelffejieegueetledvtedtudelgfdu
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:Rz5XZqYu-PoFQz03qCBdMIxUA3T1nBcYk5O_ime_wzTBTZC5XLC5Tw>
    <xmx:Rz5XZtVsgA8WgMoSBvvD0BKU1TOkzRGk95WUB2MEkyQnW2EDKlzqIQ>
    <xmx:Rz5XZgl5FUKIBHPEQM1sOu10BAVo2o8njGIwIVQX9faiBnZJW81Pbw>
    <xmx:Rz5XZic7FVH-Lxbi0Y57-DSpZ0EMzBzyQdf8M4NZXjhhPNdsv8kBhQ>
    <xmx:Rz5XZqdlHG05JWV2qv2iEe6Loo0Z3DQWqfs1OH2uIYigXqTtK7DAuw73>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 1988EB6008D; Wed, 29 May 2024 10:40:06 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-491-g033e30d24-fm-20240520.001-g033e30d2
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <0ab2702f-8245-4f02-beb7-dcc7d79d5416@app.fastmail.com>
In-Reply-To: <20240524030008.78A1AC2BD10@smtp.kernel.org>
References: <20240524030008.78A1AC2BD10@smtp.kernel.org>
Date: Wed, 29 May 2024 16:39:45 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 yoann.congal@smile.fr, "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Randy Dunlap" <rdunlap@infradead.org>, "Petr Mladek" <pmladek@suse.com>,
 "Nhat Pham" <nphamcs@gmail.com>, "Masahiro Yamada" <masahiroy@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Alexander Lobakin" <aleksander.lobakin@intel.com>,
 "Yury Norov" <yury.norov@gmail.com>
Subject: Re: + gcc-disable-warray-bounds-for-gcc-9.patch added to mm-hotfixes-unstable
 branch
Content-Type: text/plain

On Fri, May 24, 2024, at 05:00, Andrew Morton wrote:
> ------------------------------------------------------
> From: Yury Norov <yury.norov@gmail.com>
> Subject: gcc: disable '-Warray-bounds' for gcc-9
> Date: Wed, 22 May 2024 15:58:30 -0700
>
> '-Warray-bounds' is already disabled for gcc-10+.  Now that we've merged
> bitmap_{read,write), I see the following error when building the kernel
> with gcc-9.4 (Ubuntu 20.04.4 LTS) for x86_64 allmodconfig:
>
> drivers/pinctrl/pinctrl-cy8c95x0.c: In function 
> `cy8c95x0_read_regs_mask.isra.0':
> include/linux/bitmap.h:756:18: error: array subscript [1, 
> 288230376151711744] is outside array bounds of `long unsigned int[1]' 
> [-Werror=array-bounds]
>   756 |  value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + 
> nbits);
>       |               ~~~^~~~~~~~~~~
>
> The immediate reason is that the commit b44759705f7d ("bitmap: make
> bitmap_{get,set}_value8() use bitmap_{read,write}()") switched the
> bitmap_get_value8() to an alias of bitmap_read(); the same for 'set'.
>
> Now; the code that triggers Warray-bounds, calls the function like this:
>
>   #define MAX_BANK 8
>   #define BANK_SZ 8
>   #define MAX_LINE        (MAX_BANK * BANK_SZ)
>   DECLARE_BITMAP(tval, MAX_LINE); // 64-bit map: unsigned long tval[1]
>
>   read_val |= bitmap_get_value8(tval, i * BANK_SZ) & ~bits;
>
> bitmap_read() is implemented such that it may conditionally dereference a
> pointer beyond the boundary like this:
>
> 	unsigned long offset = start % BITS_PER_LONG;
>         unsigned long space = BITS_PER_LONG - offset;
>
>         if (space >= nbits)
>                 return (map[index] >> offset) & BITMAP_LAST_WORD_MASK(nbits);
>
>         value_low = map[index] & BITMAP_FIRST_WORD_MASK(start);
>         value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + nbits);
>         return (value_low >> offset) | (value_high << space);
>
> In case of bitmap_get_value8(), it's impossible to violate the boundary
> because 'space >= nbits' is never the true for byte-aligned 8-bit access. 
> So, this is clearly a false-positive.
>
> The same type of false-positives break my allmodconfig build in many
> places.  gcc-8, is clear, however.

I'm not too happy about this one, I think this is mixing up
a couple of independent issues, and makes it harder to
ever enable the warning again.

The bitmap.h code looks suspicious to me, and if gcc is
unable to analyze this as a false positive, it probably
also can't optimize it correctly, so it may be better
to either not have this as an inline function at all,
or find an implementation that gcc can optimize better.

In the meantime, I would suggest reverting b44759705f7d
("bitmap: make bitmap_{get,set}_value8() use
bitmap_{read,write}()"), until the implementation is
improved to work without a warning.

The other problem I see is that the warning is
disabled globally even when building with W=123,
and I think we should change it to always warn at
least with W=1 regardless of the compiler version.
It's also likely that the other false-positive
warnings only happen when sanitizers are enabled,
so we could turn it on by default without sanitizers
and move it to W=1 with sanitizers.

       Arnd
