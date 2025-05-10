Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CA2158DAC;
	Sat, 10 May 2025 10:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746872271; cv=none; b=EaBI4XLq4EkBRNDL+zAnuALqakCRCdxkwS056oR5oIP/2oIz/5F9ISUh+4vjq00D2gEzETZWdvsY9GK5t8Vomog8V8VbBQU7FiLLSQejCfriIx9+QPmUCMv/C8KzT++bek49iyzNjBxEkaSuESUX/9xcr3nNniQpvOKCt3/Lizw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746872271; c=relaxed/simple;
	bh=mudcIF5oRv2KV/py0dwn2w0kQkwlJwCI4ZZ0ZTg4EFE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HZF53Kdk8UceXLX3W2aT5nmg02/Gvqv5/iYzPHa/IMzoy5R2cZ9+j57dfXjAbgnTxLFdKW5k6FmnddvlWYzzNjc/KEeYYeRbIJhF4Ju0pXHrmaUeZ+vSvzbs71dUJMakIzuHiV1Y4NfBRL8XuiHZECAf9rc65ZVkE0pHAkRGCIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jwkKircO; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwkKircO"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43d0782d787so19110045e9.0;
        Sat, 10 May 2025 03:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746872268; x=1747477068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OP6oIyX3y0jnZ6iUWZ7/pJgSz9RgalovuY3vppfrvg=;
        b=jwkKircOVgpIdNhqS85wO0N/o2JZTgTVlI4qWvyE3No6TU9maUFauthkiwierfRhiv
         Qux6NdY71UkbkZQlFi4CFEjjHoY6+kP6ZdIapYC9mQGKhwY3EvCa4n6QWOXu60BedBuD
         7yohTS5fLFOjpnXnGEe1UPhJ0WxcntXMW5le8dtIK6xq7OV/hJRNagXCraI8n1pwzXWg
         o8GL3s6FKbUVt6HLXc3FumAURNjPDHo8Bf9g1hK/67jKG5JQVjqbMVSrtxFG3/4vKBKJ
         o0yx12ou0LlHitU2DU/F/+NJsN1//5W3qS25KoTO7ea9Bi1TrRU75wk8Ip5QWfkAbJyA
         VaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746872268; x=1747477068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OP6oIyX3y0jnZ6iUWZ7/pJgSz9RgalovuY3vppfrvg=;
        b=FzXkjwUiTHFz/lCqIWSa+jb+XL7SRj+a7twyYdH5Wg3+96lOA/eYD26W3w316FvMf7
         zvVYaFb3hq9XOdyK1ONWCadJROL3HVKIPOeBDKyWgUpSjq9wpFsM4kZTb1aEDLLNC2lj
         2zEm6eY9ZED4AwKx7r0bZqKYLz4HUMClDxLEbQCg9xlAaQGkiTqEmx3yTN6ITQVgV92B
         zllNVfzvgYrlW5FXvhpMj1Z1GAMhBSNyomQbpjBsCeohloxGw6oFtavqCUaVxRE24M6m
         0ATQbsR3IeM97V+MwJqfug3ssg8H1lrWlL2CG6bPiLmuxDirYHirdOVfrWcemusQHMBM
         BzDA==
X-Forwarded-Encrypted: i=1; AJvYcCX3VUDUpgPuWYPbRzfO1ivY3WHuj3vdvYadNL+ZNS/8y2k+/CegsIkFaPpOpujD6enDVzsXvsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO6TMfgtpextIMeK9yfy24/71+b6JaPrB982u7qK+8xY8fX/bI
	6csz8io9Y0howPytBvetqR2jjsrKfnWa6dH+JIC+4WDOuVGRsQKKUYAp/Q==
X-Gm-Gg: ASbGncuBSKsNStkvCO/UHbnV4QfeN26D6U5klASC/7BdqmGH/4xq8Kz4mlOCS/tO583
	+hzc5I1hxeQg4Fis4e6aTS4O6vq1swbr62WewHnHb/lUWYxZ4Ey7kEF5A36oTdSZKM2FiRGbxuI
	VWfIZDWg89RtavWf9MK3QBm2DUQK55WI7CPvbQldnpCd2oDefWyWCRSf79bbWdkLJyTvQrZDCEV
	4ryY3Y8dZ/maqZs9D1INA1kwC5Qnwg8p4uzkcB8D6DWtTyF2yIEdsxSpb9qsrmz9UKwHJI+7e1S
	tbG2IFRrH9SLmPt1y7wEZbEEYjhTY2ghFMNvyTbZo8U7gTnP4oDwyx5lDjz90v9xVjZGmK2jQuR
	T+59TF/0APNP5PA==
X-Google-Smtp-Source: AGHT+IFaymRQcUWLsOn2NT/IjehNWYp15HaOQKtG1UQDabP0s0HS/x4hw899KHOG5Gia403qH8OEXg==
X-Received: by 2002:a05:600c:190d:b0:441:b698:3431 with SMTP id 5b1f17b1804b1-442d6dde8e8mr43362805e9.28.1746872267772;
        Sat, 10 May 2025 03:17:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3b7f18sm103722365e9.40.2025.05.10.03.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 03:17:47 -0700 (PDT)
Date: Sat, 10 May 2025 11:17:46 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, stable@vger.kernel.org,
 wangyuli@uniontech.com
Subject: Re: + mm-vmscan-avoid-signedness-error-for-gcc-54.patch added to
 mm-hotfixes-unstable branch
Message-ID: <20250510111746.70313120@pumpkin>
In-Reply-To: <20250507180817.C7E7FC4CEE9@smtp.kernel.org>
References: <20250507180817.C7E7FC4CEE9@smtp.kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 07 May 2025 11:08:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch titled
>      Subject: mm: vmscan: avoid signedness error for GCC 5.4
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-vmscan-avoid-signedness-error-for-gcc-54.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-signedness-error-for-gcc-54.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: WangYuli <wangyuli@uniontech.com>
> Subject: mm: vmscan: avoid signedness error for GCC 5.4
> Date: Wed, 7 May 2025 12:08:27 +0800
> 
> To the GCC 5.4 compiler, (MAX_NR_TIERS - 1) (i.e., (4U - 1)) is unsigned,
> whereas tier is a signed integer.

As I've said before this is independent of the compiler.

> Then, the __types_ok check within the __careful_cmp_once macro failed,
> triggered BUILD_BUG_ON.

The test passes when the function is inlined because the compiler knows
that 'tier' is always positive - even though it is a signed type.
Most likely the compilation with GCC 5.4 isn't inlining the function.

I rather hope this isn't a common code path - the generated code
for the function will be pretty horrid even when inlined.

> Use min_t instead of min to circumvent this compiler error.

It is a compilation error not a compiler error.

If every complain about min() reporting a signedness error is fixed
by using min_t() we might as remove the check.
The fixes should change the types of the variables so the error isn't
reported.

In this case just changing 'tier' to unsigned int is enough.
(Although the code is still horrid.)

	David

> 
> Fix follow error with gcc 5.4:
>   mm/vmscan.c: In function `read_ctrl_pos':
>   mm/vmscan.c:3166:728: error: call to `__compiletime_assert_887' declared with attribute error: min(tier, 4U - 1) signedness error
> 
> Link: https://lkml.kernel.org/r/62726950F697595A+20250507040827.1147510-1-wangyuli@uniontech.com
> Fixes: 37a260870f2c ("mm/mglru: rework type selection")
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/vmscan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/vmscan.c~mm-vmscan-avoid-signedness-error-for-gcc-54
> +++ a/mm/vmscan.c
> @@ -3163,7 +3163,7 @@ static void read_ctrl_pos(struct lruvec
>  	pos->gain = gain;
>  	pos->refaulted = pos->total = 0;
>  
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier % MAX_NR_TIERS; i <= min_t(int, tier, MAX_NR_TIERS - 1); i++) {
>  		pos->refaulted += lrugen->avg_refaulted[type][i] +
>  				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>  		pos->total += lrugen->avg_total[type][i] +
> _
> 
> Patches currently in -mm which might be from wangyuli@uniontech.com are
> 
> mm-vmscan-avoid-signedness-error-for-gcc-54.patch
> ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch
> treewide-fix-typo-previlege.patch
> 
> 

