Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101BA382
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 02:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733019725; cv=none; b=eKGo8NQJagMUtewFQo0LDXiCLdXJ1X6y/0WLu+REKmLaLqQIGmj/zSveEn+TGUir5oIupyc/Hw8uA+1er8PsUq1nZ8Nwh2TDWbftP9W1UF1KSB7i9bNzVhIvZYv/wBF67DiZm0R9AgCTU6PQQhP+ZsGAm2J0ZOC7v5z/kcIrCX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733019725; c=relaxed/simple;
	bh=0onZwjc9FKN9cKpIMctAdjmtHlXTr2tjV1b3gPxn29E=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=lrXFAXHKJ580IebWJ4FxXFeltB3ijeL67AGXZGTv1Zp6+8XiJEiWWQdjmttQMK27c4XMJBMaiFWD0WEjEMe4Iih9D/2WJnk3vJoxSD5m4r8NXPcjCTqiEEjsTGksH3odruRbM112NJg0CtAByZHPUC9Kc7ivUU7h9K9poEkslXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMNI2xag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMNI2xag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4359EC4CECC;
	Sun,  1 Dec 2024 02:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733019724;
	bh=0onZwjc9FKN9cKpIMctAdjmtHlXTr2tjV1b3gPxn29E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CMNI2xagXV0MXivWNzRGhR3U9S/eJSbnE6uRICHjQeizdPc0lGAx5PU4tZkZzPWLd
	 jf4kjoZw2mA70FzcISwKVXVNXiYMKuNQ5IEqgeNkgiYl4mOykjELegmf5Euj9UgIbz
	 5uuBwrLXFLr9qaQHjTOlyScDPqR+iEsKz6BJbzeA=
Date: Sat, 30 Nov 2024 18:22:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jakob Hauser <jahau@rocketmail.com>
Cc: David.Laight@ACULAB.COM, mm-commits@vger.kernel.org
Subject: Re: +
 drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch added
 to mm-nonmm-unstable branch
Message-Id: <20241130182203.29462d9d364eaf6d0e4a82be@linux-foundation.org>
In-Reply-To: <4f9c5ded-799c-44f7-8911-f8df85f18208@rocketmail.com>
References: <20241130064522.04220C4CED3@smtp.kernel.org>
	<4f9c5ded-799c-44f7-8911-f8df85f18208@rocketmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 30 Nov 2024 10:18:09 +0100 Jakob Hauser <jahau@rocketmail.com> wrote:

> > --- a/drivers/iio/magnetometer/yamaha-yas530.c~drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error
> > +++ a/drivers/iio/magnetometer/yamaha-yas530.c
> > @@ -411,8 +411,10 @@ static int yas537_measure(struct yas5xx
> >   		h[1] = (c->k * (c->a4 * s[0] + c->a5 * s[1] + c->a6 * s[2])) / BIT(13);
> >   		h[2] = (c->k * (c->a7 * s[0] + c->a8 * s[1] + c->a9 * s[2])) / BIT(13);
> >   		for (i = 0; i < 3; i++) {
> > -			clamp_val(h[i], -BIT(13), BIT(13) - 1);
> > -			xy1y2[i] = h[i] + BIT(13);
> > +			if (h[i] < (s32)-BIT(13))
> > +				h[i] = (s32)-BIT(13);
> > +			if (h[i] > (s32)BIT(13) - 1)
> > +				h[i] = (s32)BIT(13) - 1;
> >   		}
> >   	}
> 
> The line "xy1y2[i] = h[i] + BIT(13);" is missing now.

oops, fixed.

> 
> As this is just a temporary patch to avoid build errors, it might not 
> matter much. It's unlikely that the Yamaha YAS537 magnetometer comes in 
> use in that context. I assume the patch will disappear at some point.

Yep.
