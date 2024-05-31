Received: from wfout2-smtp.messagingengine.com (wfout2-smtp.messagingengine.com [64.147.123.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531AE158D7A
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717162195; cv=none; b=Dk87Rgaq9AB8xNOK7PuJN/FL0/6vSt7eMk/CW0lDBKvboFUkTgB6VMyQsdblsf6IV9AojJOiBD8CJ3FczJiTWs+DuHeuTvCQityHuoHKj9ydkTEzY5Ts7x2g6VTw8aP2igUuviW/3q94FIn+7nKeKQBHn6L0wagpWMzUX6YjGN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717162195; c=relaxed/simple;
	bh=KGTfj8wKa8EAVwvOZPLtJkLyAiC6G3sn9/QQvSXOw10=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=t0OWpBAUiOstg8pYZjAU2BcxWxSuzwlUcSt0E2wmeX8iMqh5q+vUMx5uRPF7EdxdJLf5J8nwxN//I1bZOatYSpl6z6D6QyuEzVubfB0xoxQZGTX4TW5a/IkJrGLE5h8ojDL9W0iluyhq+Jwfa+GytVv9+NJ4jg24tv9mBHZlD3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=QEVykN4p; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XjxXxMEi; arc=none smtp.client-ip=64.147.123.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="QEVykN4p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XjxXxMEi"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.west.internal (Postfix) with ESMTP id D181B1C0013B;
	Fri, 31 May 2024 09:29:51 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Fri, 31 May 2024 09:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1717162191; x=1717248591; bh=WokSrIj5Ri
	JkzB+Zyft7cI5GFC/vWHaeKG+YgK3iAXw=; b=QEVykN4pt857L5t+81Ualh9YJa
	/UISAKtQmg5aTPJTXVKA26vAXdEZ7gmpavSpsjHXqUKonggpv7xgqz8MvuGkfg4+
	tJ0RQpEiglp+KpcPUAcWpiHvQIbzAsy1z+FPu8pR5H9d2xtBDbrGPiDD5OrTo/zv
	+Tq289rqmmNNxtUm6O5WlYeqnrBmjHr1aq0OZJ/J/ggnJKPCFbpiIIRQhpmledpc
	0z2VV62UkqM53BtRHbXobi+ir/GRzq3RS5cOlvIPtpemR0F2bs4LIWjqMfC93aoX
	cHGKqfZ8w7OVzjaba36zWmnH4hw5bYbMnN06iY2tom3j2oPEIKKDG/GpcOMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1717162191; x=1717248591; bh=WokSrIj5RiJkzB+Zyft7cI5GFC/v
	WHaeKG+YgK3iAXw=; b=XjxXxMEirZYrn/Rc6tVC31774v4WtPJSpBqQoXH6i6io
	edRFMUlJ0+1Wg++rz0JhxAFnvEHqsKDpp34tcIliiFusd5Ku3jZCqOlDPfvun5g2
	gH4t1vAOtL9pdjLjMFzPRoNpQrlLaBGmXyiWdaryggSYrK/1D76wgKTNbcoZ7Aol
	AwFSpAsoeiagMgHAW735qyndEMXQRAxcmmsBCW1xlf40FOM8yXkv0D4n7jXe/Mrh
	bYNEWPlmzb550ycnKXPkzwoKny5LCzPf8i/a8fVOK8FraZVnQslyVwyQmXIG+Int
	1b2dpUMiilvkOotTgFozC85sNaR3dYSqJdhPYi+gNg==
X-ME-Sender: <xms:ztBZZtCVCoUdGXeFT88DP788EsXHZAJtj6PiTRkXOIDXiLqzPqVOFw>
    <xme:ztBZZrjF0Os4jpcp75TTuqjhlJnhLliMq4d-SMUjaNXjahBqWZcqgftKGpI5XPdn0
    E6HcMhpdBqXk7nOc4I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdekiedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:ztBZZonXh8YOpbqPy_36WVLjVVtBLTPh2P5-KSc9EhfWXgiqR8Ctaw>
    <xmx:ztBZZnxHq1gDjQOx-R5HA8uqY2UAFxZ9tIM7rmUtJ531bfa5AaYSCQ>
    <xmx:ztBZZiScuk142EFcllyItnEKL9boIzkbskOP8kR9sSIfpJAT85mdTw>
    <xmx:ztBZZqZv02ojx4eNluQWMFduhLn1jjyDo03WpIGw_zYYNkDXNIEPbA>
    <xmx:z9BZZua3XNzQYaQvNbx6RlJ-59yr-q5Hh1oyNcLA0v2Q7gjZQgXHtXBv>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 9CA9CB6008D; Fri, 31 May 2024 09:29:50 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-491-g033e30d24-fm-20240520.001-g033e30d2
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <01d0db40-e02c-4204-abd3-62e6348e4bbd@app.fastmail.com>
In-Reply-To: <ZlklY6LkIhn98S6Q@yury-ThinkPad>
References: <20240524030008.78A1AC2BD10@smtp.kernel.org>
 <0ab2702f-8245-4f02-beb7-dcc7d79d5416@app.fastmail.com>
 <ZlklY6LkIhn98S6Q@yury-ThinkPad>
Date: Fri, 31 May 2024 15:29:28 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Yury Norov" <yury.norov@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 yoann.congal@smile.fr, "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Randy Dunlap" <rdunlap@infradead.org>, "Petr Mladek" <pmladek@suse.com>,
 "Nhat Pham" <nphamcs@gmail.com>, "Masahiro Yamada" <masahiroy@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Alexander Lobakin" <aleksander.lobakin@intel.com>
Subject: Re: + gcc-disable-warray-bounds-for-gcc-9.patch added to mm-hotfixes-unstable
 branch
Content-Type: text/plain

On Fri, May 31, 2024, at 03:18, Yury Norov wrote:
> On Wed, May 29, 2024 at 04:39:45PM +0200, Arnd Bergmann wrote:
>> On Fri, May 24, 2024, at 05:00, Andrew Morton wrote:
>
>> I think this is mixing up
>> a couple of independent issues, and makes it harder to
>> ever enable the warning again.
>> 
>> The bitmap.h code looks suspicious to me, and if gcc is
>> unable to analyze this as a false positive, it probably
>> also can't optimize it correctly,
>
> In the b44759705f7d Alexander says:
>
>   bloat-o-meter shows no difference in vmlinux and -2 bytes for
>   gpio-pca953x.ko, which says the optimization didn't suffer due to
>   that change. The converted helpers have the value width embedded
>   and always compile-time constant and that helps a lot.
>
> Bloat-o-meter itself is not a measure of how effective the code is,
> but it's a good hit that code generation before/after is at least
> on par. Have you an evidence that the patch makes code generation
> worse?

So far, it's only a suspicion based on the gcc warning:
this is in the same category as some other warnings that
depend on gcc analyzing code across function boundaries.
Another example is -Wmaybe-uninitialized.

It's usually good at this, but if the code gets too
complex it fails to track the state correctly, resulting
both in missed optimizations and false-postiive warnings.

This often happens in combination with sanitizers, as they
add more complexity and turn off some optimization steps
that are required here.

>> so it may be better
>> to either not have this as an inline function at all,
>> or find an implementation that gcc can optimize better.
>
> The functions look bulky but it boild to one or at max two words fetch
> plus shifts. Inlining helps to generate better code, particularly in
> the bitmap_get/set_value8 case because masks and offsets generation is
> done at compile time.
>
> We had quite a few cycles back then... Alexander, can you please
> share on code generation, particularly inline vs outline versions?

Right, maybe all we need here is marking it __always_inline
then. Something I've seen before is functions that
are meant to become trivial after inlining, but that
(before inlining) appear to have too many statements for
gcc to consider them candidates. It may then try to generate
a specialized version of the function that optimizes for
certain constant arguments, but is then confused about which
arguments are constant or not.

Do you still see gcc-9 false-positive warnings with the
trivial patch below?

     Arnd

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 8c4768c44a01..08df806df3d2 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -737,7 +737,7 @@ static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
  * @map memory region. For @nbits = 0 and @nbits > BITS_PER_LONG the return
  * value is undefined.
  */
-static inline unsigned long bitmap_read(const unsigned long *map,
+static __always_inline unsigned long bitmap_read(const unsigned long *map,
                                        unsigned long start,
                                        unsigned long nbits)
 {
@@ -772,7 +772,7 @@ static inline unsigned long bitmap_read(const unsigned long *map,
  *
  * For @nbits == 0 and @nbits > BITS_PER_LONG no writes are performed.
  */
-static inline void bitmap_write(unsigned long *map, unsigned long value,
+static __always_inline void bitmap_write(unsigned long *map, unsigned long value,
                                unsigned long start, unsigned long nbits)
 {
        size_t index;
