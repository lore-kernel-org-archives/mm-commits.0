Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E6D52A
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718386854; cv=none; b=ouOHXyTNqCQ3P91PL9zAQ0yCZpoZsczVnx9DQTNr8MJaWSAtmz+k5s6dxpzhHng9qEo50XuwJ5edDGqqndDMD3H/gsHmq+AZSZKLnD5ORijhiHDKa/Qb57oAYKv9Q4kcR28v8lFetdjadte+gHCrOKVv7ptGP7rYKBjM9bU3ezc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718386854; c=relaxed/simple;
	bh=Dc+5Ya2Ds1m515luEQsoBUgFhfyxNZVG6nriwiC1z5w=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=M34MV5AO56FznR1Ds+QFl41lWj1mVH7DltGopD2+rEo/L5s6AC748EhUK8GgU0wRkH/USD2qCwPrtNv4huWbtoe76YhNjtGy4I7Rk4F7y4+xLLU9MkfvFgbEL7MQ8lw2UvD4BHGRxIvEMfdaqgBNeS3RlNsgBsV5daLydK8sCwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mNL7NSPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mNL7NSPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB8DC2BD10;
	Fri, 14 Jun 2024 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718386853;
	bh=Dc+5Ya2Ds1m515luEQsoBUgFhfyxNZVG6nriwiC1z5w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mNL7NSPx+fmZ8epM2gENDxUEA/TMjBZobMh1s+WVe2Prcs/GGQzXGYBwPJClX5HRS
	 n9HItr1PxcYkHklTyin1BiDiaR9lmzfFi5GIYe3hdLRfQjtHD2MSyYlwqYd14GP3hI
	 UEImCLSpmu+SOPODjnJ4VakN149eQ6o5+sobJl+k=
Date: Fri, 14 Jun 2024 10:40:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: mm-commits@vger.kernel.org, yoann.congal@smile.fr,
 vincent.guittot@linaro.org, rdunlap@infradead.org, pmladek@suse.com,
 nphamcs@gmail.com, masahiroy@kernel.org, gustavoars@kernel.org,
 davem@davemloft.net, arnd@arndb.de, aleksander.lobakin@intel.com
Subject: Re: + gcc-disable-warray-bounds-for-gcc-9.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20240614104052.f4c597e9f4239247f9058b4a@linux-foundation.org>
In-Reply-To: <Zmx60snJwvBsgUNX@yury-ThinkPad>
References: <20240524030008.78A1AC2BD10@smtp.kernel.org>
	<Zmx60snJwvBsgUNX@yury-ThinkPad>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Jun 2024 10:16:02 -0700 Yury Norov <yury.norov@gmail.com> wrote:

> On Thu, May 23, 2024 at 08:00:07PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: gcc: disable '-Warray-bounds' for gcc-9
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      gcc-disable-warray-bounds-for-gcc-9.patch
> 
> Hi Andrew,
> 
> The script said you've applied it to mm-hotfixes, but the patch is
> still not in mainline. Are you going to move it in this cycle, or
> what are your plans on it?

I was thinking it would go via the net tree but it seems that
b44759705f7d is in mainline so I can send this into Linus soon.

Did we agree that

	Fixes: b44759705f7d ("bitmap: make bitmap_{get,set}_value8() use bitmap_{read,write}()")

is the appropriate target?
