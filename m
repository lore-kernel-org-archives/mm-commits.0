Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1AC1D689
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 04:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709094941; cv=none; b=HIUNwm9BCf87bPJi0ZFqQv0L2yyo5tpMhn4pkCxlLjtjdrd3+VlMX9lheH0i8ystNNbhwYgENRnV9U4+E4b14coDWDeOuuz+bjXstAiO5+0cOSD81eczzEicY9wTdCg101xCYpn3TPCO6jZYzNMviQvNLaMueR9uZHr9QHTPZd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709094941; c=relaxed/simple;
	bh=Z9/KJjieSdZ2Hl5Emopz32t8ZdcW49dsiiPJNVAcwas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDBW6jH9rHDtO2lredMi/6c/QqQijfnLsyYk5vgeyOVm0BLmkRgBnapFGijLem4Qf5qEtgvmGu9m1NxZt0m+nE1Yzp8Ru3iLKzEmS4a6whaVemq7XqET7nUL9Yx63A/flKMF6ZCkyu0v/Ubp+k65V6/T5kJYXxLMzl5tnCs5dak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MilYfKkS; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MilYfKkS"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dc6d8bd618eso5294330276.3
        for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 20:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709094938; x=1709699738; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jjFJ2ObDpftsd4P/6H4aD/JLuBKF3FXmT54KTHBac7E=;
        b=MilYfKkSYvwVAVW3sdW1CxjelaHt7TqwKvk/9ClINzd+U/ibXrczD5SDwGl5RF0a0Y
         BIpTVKaietRR/pLrCHaeDe1fWaJwZwnuDDTzZhTGnUhZvXvJGhmCWtORYUSfw8YhEDvM
         hCPK3hty/5Q6Px2EB+wBJSyDm0ql+YL3Ic7B4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709094938; x=1709699738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjFJ2ObDpftsd4P/6H4aD/JLuBKF3FXmT54KTHBac7E=;
        b=Xqozu6hNEIyqdzNXu3BARW/LQo1+HsWOcI4qf/4ERyafJz0AR+ABVdxwlFgEMpeQsr
         hTo0gTjK/jtlkdmacFmU7+yBlKvZ8JkqkOzzuH5Q9dLneq2CCBujg/M63etFASOH+AJm
         p8pda7hEfkcn25j1RLP49rVZdQxZvggFuKLPwyOknb8NoyYKN6mewIv+rSdwYZZvR+rX
         5EO12IP///z08q/PiMKn99UTWVPqCkny1UVzhdEyQv4+xGP4rh9ZULppRzYe3ac6j66z
         3CnYuYibt7SCDvoFpqkTEowxZXLmGlSPHeW9mYuldWYJp+n/AmAGJlJGWHJw5Kkri/io
         WBbA==
X-Gm-Message-State: AOJu0YxXx7v5njl6gvZa4Uh6VVV6XOFMXCdWECavpJ65UYUvkJCxaC0Q
	a/6CLz9uDMO+FHKviD1nlvjdQFaFCQNIiQpMH71dqz78lkGBo6bDE0Fx9nAiLw==
X-Google-Smtp-Source: AGHT+IGygoEtbIGEWTgtFMaIoHledt09TYV/hm0dCPXtHB9vhSuD9ACjmPxg34TADmVYRahkQOJszA==
X-Received: by 2002:a05:6902:2846:b0:dc6:2e29:4262 with SMTP id ee6-20020a056902284600b00dc62e294262mr1588939ybb.58.1709094938623;
        Tue, 27 Feb 2024 20:35:38 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:50c1:1ad2:3268:cacd])
        by smtp.gmail.com with ESMTPSA id f26-20020aa79d9a000000b006e4f0e2cc52sm6743198pfq.168.2024.02.27.20.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 20:35:38 -0800 (PST)
Date: Wed, 28 Feb 2024 13:35:34 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com,
	senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
	hannes@cmpxchg.org, zhouchengming@bytedance.com
Subject: Re: +
 mm-zsmalloc-dont-hold-locks-of-all-pages-when-free_zspage.patch added to
 mm-unstable branch
Message-ID: <20240228043534.GG11972@google.com>
References: <20240227180415.6E4BBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227180415.6E4BBC433F1@smtp.kernel.org>

On (24/02/27 10:04), Andrew Morton wrote:
> The patch titled
>      Subject: mm/zsmalloc: don't hold locks of all pages when free_zspage()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-zsmalloc-dont-hold-locks-of-all-pages-when-free_zspage.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-dont-hold-locks-of-all-pages-when-free_zspage.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Chengming Zhou <zhouchengming@bytedance.com>
> Subject: mm/zsmalloc: don't hold locks of all pages when free_zspage()
> Date: Tue, 27 Feb 2024 03:02:54 +0000
> 
> Patch series "mm/zsmalloc: simplify synchronization between
> zs_page_migrate() and free_zspage()".
> 
> free_zspage() has to hold locks of all pages, since zs_page_migrate() path
> rely on this page lock to protect the race between zs_free() and it, so it
> can safely get zspage from page->private.
> 
> But this way is not good and simple enough:
> 
> 1. Since zs_free() couldn't be sleepable, it can only trylock pages,
>    or has to kick_deferred_free() to defer that to a work.
> 
> 2. Even in the worker context, async_free_zspage() can't simply
>    lock all pages in lock_zspage(), it's still trylock because of
>    the race between zs_free() and zs_page_migrate(). Please see
>    the commit 2505a981114d ("zsmalloc: fix races between asynchronous
>    zspage free and page migration") for details.
> 
> Actually, all free_zspage() needs is to get zspage from page safely, we
> can use RCU to achieve it easily.  Then free_zspage() don't need to hold
> locks of all pages, so don't need the deferred free mechanism at all. 
> This patchset implements it and remove all of deferred free related code.
> 
> 
> This patch (of 2):
> 
> free_zspage() has to hold locks of all pages, since zs_page_migrate() path
> rely on this page lock to protect the race between zs_free() and it, so it
> can safely get zspage from page->private.

Andrew, please drop this series as it's NULL-deref crashing zsmalloc
(as far as I can tell).
