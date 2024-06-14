Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CB917BCC
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718387761; cv=none; b=aJxk4Ymx70L2FNv3WoaQoZ0M6YaWIaB/A+nMUHiL7p+EVAN2zIP19IVzxD713ZS43hoaCLTrQrGYG5d+OEbZLaTCLYZpnnUKH9h6C1B1xnH4B9uHEYjrVWobNw4s7Uf+OibuOBT4qfa97pcIgCBOpqoZx50cGbkcnyM4fgCJVJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718387761; c=relaxed/simple;
	bh=7Ydp4B0cYfEXk4c0tX0jccxxXZY2nsBR8s/Hgzd9xP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2ZIf8PZPpftM9wJ7y+KiKpdXK1wokCbwYkEmj3K3JgHjFAwOQPDpfKRNRQ74/SGYmmWiZUqCJwlzcjujHycf38SS6jhx0EuwcGym8wxyWh8U1gX9DpiKNLG6nC7t8ZMmctj8eyIGC+i+nnQr1f+TIPJDtUez9P77lDy9TyPerI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyEHSfUO; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyEHSfUO"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-704189f1225so2261622b3a.0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 10:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718387759; x=1718992559; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aAuQXIIaPSpbCyI5jahb+0TjZo/R99GEgqroDTwrpk4=;
        b=TyEHSfUO+GKvIg3euu1SV8pW6YG0fcNVJgNcbD2vjS3ZK5uV1UNgBS6ncCy6lDAc7m
         16RpJLtP/bInNLJCoEcskGnv+fnXKK+Jv6ix6B9dzYhrtBBFTvF7+jFZTt15SYCY9H8V
         iVyZZShiCxobbFrB7xvhFqdpZsS/fCYCyEZiZzb+0h7zMbg2R8y/IsN7oKbikAi4VdD0
         CrAP/V/XO0pGRh0q4rkeJTPNJFmNWqI0/CA+SUWJws65U5IW3rJ9ySU3sA0Oo/Giy5PM
         iLD4dIuoWXJlkYiXtywuXm4wOwlx6BQ4YHj7rhlSsyCMXhImbrPL3/SFBwbFwWhNUgB3
         CKXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718387759; x=1718992559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAuQXIIaPSpbCyI5jahb+0TjZo/R99GEgqroDTwrpk4=;
        b=pczefUoN9QqbfWPCWG89LweLBY0y3RvzfEPe3VpC2gK25JmXJPqisXRSg2SltIsgm2
         rrNUHgsy0qAhr+BbX7aPI8d6qsZkrhmC4pa6EX+nERFLIczBMk3PFRT3ZEkAThmRJlz8
         +0vQX/UjzRO4uOwxW7p0ZVsoyXNvKnMfQvbcGaJ0Qa6VNT+EpWkn9IHP5m31cr4R9qme
         PlyZSqeEOfSzUPM3ZRwlx91DRXCfhYLHcT/XGcGjVx+J6FIWrGsSvkHU24N8yDxfVwRo
         cDbi8DDrh/aNwchWt0yIOiBs98gaornaYJk3YtaPlG9g1yQhFU4Pa49+wQLm07eSDwgl
         MtPg==
X-Gm-Message-State: AOJu0YzbXupGSNKXW8Od4RLolLboh2slpKOOsHtt+y+lvX+ts/A2NuBG
	BimKHABK5ES++oEyIav3xucLAUWMaL2NN02QWhHablppNnpQP+UN
X-Google-Smtp-Source: AGHT+IEH52jUMU4cas5RAoqDGN3jCCuDfL2gwjaiLXXdGvrQDh9D9LvYpTlQYRFW7i/rv93sjFc38Q==
X-Received: by 2002:a05:6a00:2b9:b0:705:d805:5bf5 with SMTP id d2e1a72fcca58-705d8055c71mr3064265b3a.2.1718387759105;
        Fri, 14 Jun 2024 10:55:59 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc92560esm3425990b3a.12.2024.06.14.10.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 10:55:58 -0700 (PDT)
Date: Fri, 14 Jun 2024 10:55:56 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yoann.congal@smile.fr,
	vincent.guittot@linaro.org, rdunlap@infradead.org, pmladek@suse.com,
	nphamcs@gmail.com, masahiroy@kernel.org, gustavoars@kernel.org,
	davem@davemloft.net, arnd@arndb.de, aleksander.lobakin@intel.com
Subject: Re: + gcc-disable-warray-bounds-for-gcc-9.patch added to
 mm-hotfixes-unstable branch
Message-ID: <ZmyELH6WkltS9SWw@yury-ThinkPad>
References: <20240524030008.78A1AC2BD10@smtp.kernel.org>
 <Zmx60snJwvBsgUNX@yury-ThinkPad>
 <20240614104052.f4c597e9f4239247f9058b4a@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614104052.f4c597e9f4239247f9058b4a@linux-foundation.org>

On Fri, Jun 14, 2024 at 10:40:52AM -0700, Andrew Morton wrote:
> On Fri, 14 Jun 2024 10:16:02 -0700 Yury Norov <yury.norov@gmail.com> wrote:
> 
> > On Thu, May 23, 2024 at 08:00:07PM -0700, Andrew Morton wrote:
> > > 
> > > The patch titled
> > >      Subject: gcc: disable '-Warray-bounds' for gcc-9
> > > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> > >      gcc-disable-warray-bounds-for-gcc-9.patch
> > 
> > Hi Andrew,
> > 
> > The script said you've applied it to mm-hotfixes, but the patch is
> > still not in mainline. Are you going to move it in this cycle, or
> > what are your plans on it?
> 
> I was thinking it would go via the net tree but it seems that
> b44759705f7d is in mainline so I can send this into Linus soon.
> 
> Did we agree that
> 
> 	Fixes: b44759705f7d ("bitmap: make bitmap_{get,set}_value8() use bitmap_{read,write}()")
> 
> is the appropriate target?

Not that b44759705f7d introduced a bug, it reveals GCC bug.
But I think it's worth to mention the b44759705f7d somehow.

Please put it at your discretion.

Thanks,
Yury
