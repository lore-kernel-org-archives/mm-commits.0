Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6108221475
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733418363; cv=none; b=Fa5YSMHKy0+Cv7oQdKu6LQBJ9BuRU0iAbNkFxQIHJ27qaNBglJ9IMVZxIL4T0Sb4eDricb+0JipOrL6zagGUWxnzazekXF0APXnnhcJhxUzXhPInwrr379w3sA3F6wJBqyCOfhUy9r5hAiHj4YhNKpMztGMPXngQxRKQQeQWyrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733418363; c=relaxed/simple;
	bh=wXl2G7az0GkK11pLls2yPEBoJLy9Lk9acvBaRXMShCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfJSiz8KVS/0uNELfnKIxNYdWGATO8q8NH15S+MMA10sH3V6vcYAWXkjg3Hv/dQht+o1h952WyxnT/ChiroCIQuriSUVFJa5ScSZtWpkvcZoW9jANrdsALUlnyBVoJ/s3BiWl4mP7tp/pA0Ck3h7nfXKLESZasRsQQ7XT2uPfUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DoSYK9XO; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DoSYK9XO"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21145812538so9537455ad.0
        for <mm-commits@vger.kernel.org>; Thu, 05 Dec 2024 09:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733418361; x=1734023161; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fugx12aU9xEHcCWPzUtpLt18+F3B0WR9u7RflIgXIwQ=;
        b=DoSYK9XORs0fd6xvmeJbffzmeMZNOOZLjx07w2B/rgeOtj29Lr/mBDpRZRUV8zLEqX
         35NSYi0FxMPd9wV1e8TlFkKhDz9LW7WNUBH8i02weYYV6ehRr1GLwRjViIkNdtRi93v+
         dOVCMbyjXsnFyVyiE0+HDWKX3x2HF+6fTRPKhfheygmQE4JggCxlY/ZtBUBKAtWyrr+v
         gwCI/fM+N36hHgyINROcmlab3EmFbPNi0plJuweKcR2UByJob8uCRlRbY9rYNEnPTVlQ
         5PCkn1LgsXVcWYbOtHqkWVRZoMjmbykNt7PAx8H0tnB/uDKYv5dQz0v1DMV4CFFrqy6/
         PkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733418361; x=1734023161;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fugx12aU9xEHcCWPzUtpLt18+F3B0WR9u7RflIgXIwQ=;
        b=fElvLqeJ9A7gzWgAz846iF5iLVpx3zGWClCVjS+Xc3eDy4FH/mzVB50h0ShdYSfgaX
         lIzfC31T3ehZPNhNGoZtiwP6ffO87nX4HBqWe6TKDADxJDe0YkyTxwC3PnvwItfbA0zK
         54TW21gOmLwAMRnOO7Qz4fu4odJZbBaYILQd4UsJhY1yevpx0R6OJV29waCPKC45L6ZN
         rWrX8V6rkYRsh5LGhIXylZ/wfBUzhAIN31YnpuazWRbb82KzopZiHqy8C4/OKUqx6E66
         8+IL82s8ncw5G1MwCp/MyTdhg0cpw9X07AEw4rAV/IPVVzEM8/7AW6z82kBEItgriuIL
         CsWw==
X-Gm-Message-State: AOJu0Yw/oUPSdCW25+5UmPBcfcyIf+GB7Qpt9MCVqBSG/IdzXbWoGAwm
	ODI4/DPPzK55Qn/3EUXQ8zPiC9sxpBvzpb7kAxqJPp37XWH39Nke
X-Gm-Gg: ASbGncsPqP2F4g1XXpZV5YdH/In3k1yrRYEyPOpCjjQ7DOFjp+c5CQD32/eTqCGYA8A
	QZM6KbYtTo2zdV0Fdl3S8eqlmORkKhe92MGfBL55YB17x3vVC9JeERxlryCUmmimTtJyR+t5Il9
	uFt/xgzQX9SfjT4xuZs/r4iltFPaoepfjxlula/XV834rYbT3SbwfnJLObqysWObFI6y7U3xPSj
	o36e0Vq5xTuh/oghKi8Kc4Sg021VnYdf8S3RrdB1ZcdHNO6x0VUS9xJcnt48SPpvJWg6J0jD8xe
	tg==
X-Google-Smtp-Source: AGHT+IH6xz/PsgXehrvdxQIBRsiRUM80kZBH6m+XpLfOJnOY6eoIyygA6JfIRmNmmphtYQl1vJAxZA==
X-Received: by 2002:a17:902:fc4d:b0:215:3a42:dc17 with SMTP id d9443c01a7336-215bcfc4b25mr137744335ad.7.1733418361038;
        Thu, 05 Dec 2024 09:06:01 -0800 (PST)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2161063875esm379585ad.238.2024.12.05.09.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 09:06:00 -0800 (PST)
Date: Fri, 6 Dec 2024 01:05:56 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yuehongwu@tencent.com, linux@weissschuh.net,
	joel.granados@kernel.org, avagin@google.com, mengensun@tencent.com
Subject: Re: +
 ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch
 added to mm-nonmm-unstable branch
Message-ID: <Z1HddMxvQkNIrNMx@visitorckw-System-Product-Name>
References: <20241205043541.1078BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241205043541.1078BC4CED6@smtp.kernel.org>

Hi Andrew,

On Wed, Dec 04, 2024 at 08:35:40PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: ucounts: move kfree() out of critical zone protected by ucounts_lock
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
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
> From: MengEn Sun <mengensun@tencent.com>
> Subject: ucounts: move kfree() out of critical zone protected by ucounts_lock
> Date: Mon, 2 Dec 2024 22:32:45 +0800
> 
> Although kfree is a non-sleep function, it is possible to enter a long
> chain of calls probabilistically, so it looks better to move kfree from
> alloc_ucounts() out of the critical zone of ucounts_lock.
> 
> Link: https://lkml.kernel.org/r/1733149965-749-1-git-send-email-mengensun@tencent.com

Clicking the link returns:

Message-ID <1733149965-749-1-git-send-email-mengensun@tencent.com>
not found

From a quick search on lore, I couldn't find the original email for
this patch on any mailing list. This might be because the original
patch wasn't Cc'd to the correct mailing list, and the link was
generated by a tool without checking if it points to an existing email.

Regards,
Kuan-Wei

> Signed-off-by: MengEn Sun <mengensun@tencent.com>
> Reviewed-by: YueHong Wu <yuehongwu@tencent.com>
> Cc: Andrei Vagin <avagin@google.com>
> Cc: Joel Granados <joel.granados@kernel.org>
> Cc: Thomas WeiÃŸschuh <linux@weissschuh.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/ucount.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/kernel/ucount.c~ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock
> +++ a/kernel/ucount.c
> @@ -164,8 +164,8 @@ struct ucounts *get_ucounts(struct ucoun
>  struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
>  {
>  	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
> -	struct ucounts *ucounts, *new;
>  	bool wrapped;
> +	struct ucounts *ucounts, *new = NULL;
>  
>  	spin_lock_irq(&ucounts_lock);
>  	ucounts = find_ucounts(ns, uid, hashent);
> @@ -182,17 +182,17 @@ struct ucounts *alloc_ucounts(struct use
>  
>  		spin_lock_irq(&ucounts_lock);
>  		ucounts = find_ucounts(ns, uid, hashent);
> -		if (ucounts) {
> -			kfree(new);
> -		} else {
> +		if (!ucounts) {
>  			hlist_add_head(&new->node, hashent);
>  			get_user_ns(new->ns);
>  			spin_unlock_irq(&ucounts_lock);
>  			return new;
>  		}
>  	}
> +
>  	wrapped = !get_ucounts_or_wrap(ucounts);
>  	spin_unlock_irq(&ucounts_lock);
> +	kfree(new);
>  	if (wrapped) {
>  		put_ucounts(ucounts);
>  		return NULL;
> _
> 
> Patches currently in -mm which might be from mengensun@tencent.com are
> 
> ucounts-move-kfree-out-of-critical-zone-protected-by-ucounts_lock.patch
> 
> 
