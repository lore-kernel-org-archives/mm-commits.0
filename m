Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4C31B81B3
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725041260; cv=none; b=ZkkAWphWCnldtZc6vnqo5ZR/pcXylsetIB5rky3N3kDgliwSDKN7vQEIQ8fDd9xcOSqvp9jh8ppUioQdtUVgr0fM3DKmKMBeKgF9zsNbRRX4qUJOw29vIsx/rIhkjpf+wfN5hsE3zRArX1xf6PTcS+8nbcO6aX3PHVG8DwCZ0Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725041260; c=relaxed/simple;
	bh=f7iVRcsHAEDwatAT9Dn6Fx/eR1g5J6bug91MmasJevU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pqRmtMp5n63dHbhcULNwCaw/1ffBbrXv2pll59mlbhby8gaoMJF7KfX2F0UwrNQxCzfsCWa/ZgHayQEN9G0tV9sV0O3m8s3HVC0ZHCoImqGzFig7SsdU8H38JcADWKTVwJA90ob5VfQnpeDmEisFvDwCAiWMnc0LzgRfNauCwEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XG55tNBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XG55tNBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3969C4CEC2;
	Fri, 30 Aug 2024 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725041260;
	bh=f7iVRcsHAEDwatAT9Dn6Fx/eR1g5J6bug91MmasJevU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XG55tNBnL3MRp4XIhsPQ7XmYmMY19Rbr+6eN+6KTRWPKnug5dQwpRi2NQ38bNCwb4
	 D2Pyckmy+Thp6kSl5IvgskEk29+aAVjKn76op61uw/VWkhTI3dYbzgpravUHNkfS5h
	 QRM6Swu4gXxv163jPuKoJJSfZjtv10uI1LrXXzlA=
Date: Fri, 30 Aug 2024 11:07:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: mm-commits@vger.kernel.org, terrelln@fb.com, nphamcs@gmail.com,
 ngupta@vflare.org, minchan@kernel.org
Subject: Re: +
 documentation-zram-add-documentation-for-algorithm-parameters.patch added
 to mm-unstable branch
Message-Id: <20240830110739.73c067b432a5d28692b46a13@linux-foundation.org>
In-Reply-To: <20240829020150.GA9738@google.com>
References: <20240724192716.657C5C32781@smtp.kernel.org>
	<20240829020150.GA9738@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Aug 2024 11:01:50 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> Sorry to bother you, can you please drop this entire series?  I will
> send out a new version shortly.  There aren't any serious changes,
> I just don't like zram-extend-comp_algorithm-attr-write-handling
> patch anymore and instead of changing behavior of an existing
> device attribute I'd rather introduce a new one: algorithm_params.
> Other than that the series is exactly the same, so we should be
> fine landing it this coming merge window.

No probs, thanks, dropped.
