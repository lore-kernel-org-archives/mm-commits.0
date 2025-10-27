Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D102F5B;
	Mon, 27 Oct 2025 07:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548601; cv=none; b=KIAzpvCSmV7QmDr95TwyyySMQ01Ht9htL/EwPkb3B6vgizljGqef8IDOQParI2UDg3eUyMjhg94DM+YGhxg4bULGSgSNbUErtT2L23wAiT9LzjNfsgpshomPL6FJKSCUoVsjCSmqEPq0c5N5ihgsnVq2f/f9abTwRj5oavSvDoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548601; c=relaxed/simple;
	bh=ZFi3PiJUz4T9a0j8bsBUFz9ZoQQLLy+GZe69LdVi5dk=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=JuvT2m3U93ONlRcI4jhHIT33uuu4vdT9WKOlnLXNpdUB/hh9iqGTV22cn4QA8/hc7EuG0f9UZOqFtp8ZH2cJpN3IvxEtExJmO+UMiLbUH31JNYcZCJFtHJe3nlhtzyEqT+JD41bWl40iNxwnkkzuaHJBOA5tCAEIRnki89J0Dn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=sOalyLYI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dJjhGg4x; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="sOalyLYI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dJjhGg4x"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B85EA7A01FB;
	Mon, 27 Oct 2025 03:03:18 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 27 Oct 2025 03:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761548598;
	 x=1761634998; bh=adaMRzF6ds8teu7leuvNSwnScW38m8MWre0/lgf0omk=; b=
	sOalyLYIVSjqIejTzQg+lH4kM7mlvRS4ECGsvGt8/1NLYGKxIRnzMoj6NmCTzrYm
	OzAMaAZH4XYPdvMttQKHS8CouoLAq2xi8LYnyVH/nognFVGbsEeLBcFVR1V3dCry
	6G+JEyFmfxn+XsS+3s9xpZyhuf4aBYatvYSpfNJ/hUUZOOZLaJRF+bzDAoK2Ra+I
	k2awfow2TB61ghakYDxWpSNu7O1s7rRHTfn5uUwiAmNXuQ/nihAKg9AEIt6Vq0Rn
	lOBTrmxFb8B8Y+s7t+YIkJsPxhaJ3rafVQMogGiew4BNpLlbPVO06LC+LRTty8aa
	P3SiweQ0gDR0OgpM5kOdrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1761548598; x=1761634998; bh=a
	daMRzF6ds8teu7leuvNSwnScW38m8MWre0/lgf0omk=; b=dJjhGg4x22kfvEVln
	tDe2aHgEk8X7P/14dGGVWLxG5NtsY03m1YRA04FlZy8pbPWWa5Xs+tLs6BYryyS5
	MLOenns7yYIibFw6yRo/aQhEKJsROYmpzxVGNHZ+sGeEjOy66gjo8w0UpenigMdg
	GdPbo1alfxZ5Hu05pv1kG60cgv/VyvryeLJtbhXtBl6TeLhfwoEbSEoY4bAksIjM
	SSGimXVkMYcx2xh7C4KKhDpEfx+soUt1eHwmbQjLSDGChcHal5olYoq/WMaW8n03
	+D3ImRQXFgQJREYbOlEL+THgzko7ZLnYqxqp1NyGTqwnEsfKZkbw/ZiIL4D6j27a
	0SADA==
X-ME-Sender: <xms:Nhn_aJN5BJp4_4cZygUT8du4Qv9LnrI0Q2Q-SNwr2S8V9qWrH_7QrA>
    <xme:Nhn_aGypNAKC9K_5M4AqI79pk1Ed_XD3ypj1VLbiGCg3rk2T9SpHLPN3Uh8toJoN-
    -TTLhVg-NSQGn6Cqe3u6565d4g4QXropKugMmn1EPI2-htLL56jf1Y4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheejfedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvffkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhfeduveehheejgfeileelheduieffleevudelvdejtdektedtgfeggffffefgvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopegurghvihgurdhhuhhnthgvrhdrlhhinhhugiesghhmrghilhdrtghomh
    dprhgtphhtthhopehhrghnnhgvlhhothhtrgesghhmrghilhdrtghomhdprhgtphhtthho
    pehguhhsthgrvhhorghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvvghsse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggr
    thhiohhnrdhorhhgpdhrtghpthhtohepmhhmqdgtohhmmhhithhssehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:Nhn_aC1sZcjdwZyDGVsMI_8YhmvDJqv7LIfZ5FEYVcjzE0pyJYgfEQ>
    <xmx:Nhn_aPLcKIQrwoA7fCU6kESbycp55Lasdd6BQc452_My6Poo476Iqw>
    <xmx:Nhn_aKza2fpiCMo-JwbRNg9btuqxkKdzfAQZ-WDvtxYdyWl0QAE74g>
    <xmx:Nhn_aFWeMdaccpEC6n5Cb-kF7CrHINWmd0iDquSnCyvsbutUrSCftw>
    <xmx:Nhn_aB2YNSVO8NpiEOR5xcnAfGD4d1-HZ5PBE0JGpXVdo6ErnEL3PRcz>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 13E4B700054; Mon, 27 Oct 2025 03:03:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A-keNruaM7oc
Date: Mon, 27 Oct 2025 08:02:57 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Kees Cook" <kees@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stable@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 david.hunter.linux@gmail.com, hannelotta@gmail.com
Message-Id: <b47b1167-28b0-445f-947b-55f7a07c1bf8@app.fastmail.com>
In-Reply-To: <4FFB0358-0312-45AA-84BD-9249D8CE9C41@kernel.org>
References: <20251026235632.6E245C4CEE7@smtp.kernel.org>
 <4FFB0358-0312-45AA-84BD-9249D8CE9C41@kernel.org>
Subject: Re: + headers-add-check-for-c-standard-version.patch added to
 mm-hotfixes-unstable branch
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025, at 03:31, Kees Cook wrote:
> On October 26, 2025 4:56:30 PM PDT, Andrew Morton=20
> <akpm@linux-foundation.org> wrote:

>>------------------------------------------------------
>>From: Hanne-Lotta M=EF=BF=BD=EF=BF=BDenp=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD <hannelotta@gmail.com>
>>Subject: headers: add check for C standard version
>>Date: Sun, 26 Oct 2025 21:58:46 +0200
>>
>>Compiling the kernel with GCC 15 results in errors, as with GCC 15 the
>>default language version for C compilation has been changed from
>>-std=3Dgnu17 to -std=3Dgnu23 - unless the language version has been ch=
anged
>>using
>>
>>    KBUILD_CFLAGS +=3D -std=3Dgnu17
>>
>>or earlier.
>>
>>C23 includes new keywords 'bool', 'true' and 'false', which cause
>>compilation errors in Linux headers:
>>
>>    ./include/linux/types.h:30:33: error: `bool' cannot be defined
>>        via `typedef'
>>
>>    ./include/linux/stddef.h:11:9: error: cannot use keyword `false'
>>        as enumeration constant
>>
>>Add check for C Standard's version in the header files to be able to
>>compile the kernel with C23.
>
> What? These are internal headers, not UAPI. We build Linux with=20
> -std=3Dgnu11. Let's not add meaningless version checks.

I have a similar patch in my own testing tree but in the end
decided not to send it because supporting std=3Dgnu23 doesn't actually
add any features we want.

The next time we raise the compiler version from gcc-8 to anything
newer, we can change the version selection to use --std=3Dgnu2x
unconditionally.

      Arnd
