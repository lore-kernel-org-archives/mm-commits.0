Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215E7283141
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752234573; cv=none; b=UoJR5ukKesQjDikcfkxPI0MsUNJFcKnGDhZuUILCrtGWJ268ldMGK9CDEVEK9XvAjxvDWrvdV+K/R8Y+LgcYRSEMeAdMcubqXi22nm98o1+kGxTJA2EzMErS4b8mTtcFFKJQfb0ZgXDaXt0XYWuNudTAnPLo1/lNMElGFJP7n3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752234573; c=relaxed/simple;
	bh=xFPa56jhQ4z1s5zRJ+Eggr2UgI8sdSJ1nyDvFj9/WaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dU+Veh6epn/6n69lWng81oF/ErV6/O4fZax68L2+uF4MsBnh1zHW1frEx0p22Xdolvdg+EwaSA03Ke0XiAKhstlPA1uacjSPw0TgtBS9yiXrrXTQhuHaeWvjgkV+73o3X3zGZbkci6VKNHt9/UB7OwbVStkZAi9O6gjEp/Cou9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSYzeK6F; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSYzeK6F"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5561c20e2d5so2536642e87.0
        for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 04:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752234569; x=1752839369; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTWki9xJRErABuwj33rF8JLlcpPWAaWPxlddZULAyLc=;
        b=FSYzeK6FWx4Vh+FXuec5c9vozqsQtPf/wXpNC5noU4dAb9BV10AO5ApO8xHDSscg3S
         vyki1L8gH9NbIJPki9C2XMVfQVWBS5/iy5PKBZT1H5/Iwz/YBD1ReW1eI5R7C8UCemLn
         dEWuh0v9eWt1QtdvL6btAiJW5gSfLVEsGPQf4c4OG5n5919DdYK91JM+kuggzYsroi7W
         l7eN4AFmgOlRwxpaYY9bdXoLQ0HBr9UrCTPurQ+vnhjMpIhDNH19VEOJxDbliEzMuke9
         mWspacmA3drwL8NdYDQrt7Y8iFafnQ1tlnUvHjnIqPDnODPmDbRMN8Oes8FtcJOD7Vdu
         YJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752234569; x=1752839369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTWki9xJRErABuwj33rF8JLlcpPWAaWPxlddZULAyLc=;
        b=CbGkhStEnpo0i28QBxFCHHcZGsgJV+jgVC69kvJ1IfIYIVg9EgUTiCLdmTVtn9tzBx
         bGYcSUr0XgBEq0KBnqE/YTQiO9h/R16XN5bFUgqf448FVfUBl/twTL7ty+P6oc/0PcHo
         hHuv32iyvdM/p4sAjXZsQhxtFuZPJm0zRPhadafWcisf4LysGuM1evmjZXokCllly1gB
         nUO/Q+Mts1sOgEq1LOqEAdqbdOtWCQFUiIW1fUh/aN2Q6BXPqun/XHAvHI5SbhWGPN9y
         ax2BtOA1tLye2/AnAOfHrwRO3JDB0Nkvdy22Sz7eRRjZZJx+V3UAYvadtXzQnjdx5XvN
         OMfw==
X-Gm-Message-State: AOJu0YzpxlZvGnbW7QNVdUboqHaftLql+k/VO5qY1jvCZMaPwUJIxwds
	FcksHSLJN0P5Pr8450/jmicCAANANUycQogV9Kyh0f4/HxPJ/M1nxMaF
X-Gm-Gg: ASbGncuQQT7D+GksXBtwS9cSCt/3M8jWxoNXC5R3nxtdFFgZ3dJC0vaq4pOYwHlAD6N
	9LvTQ2qKjmIIUaeeUFa7kH3m0ykpotrgfNEMKEJGoutTG8Jj5YS2OjD6xFVgAMMIKu2Hc34ppDQ
	8fy3SEuXVArk+kPu4ynKwFJ974Ksk8RNAyf9Ec/mfJqsTmJXfRtXB28vZjRQ1LV0PS/NE8ITop+
	cbB1iTnu8ZOj8W2fot93q484Bib7LjgmWG78l623DLIrmanSI5YgFcW9CapFYZbFVUOz3blMc+p
	WJYUx4jImkvlPE4cobSW0g/RWknks2G7PyGsTfaylGsQr2VKlnNIiVJQcNJyHW3BMHp4cR4kf/z
	fRIbNDZxLtGwNoAxOAf7kVNJ2cPaEZuJ38YnPZg==
X-Google-Smtp-Source: AGHT+IEkJy+X2rkMV+yPVW2xjzWPCYrKbsoGMmkIDyi4FaBWZ7wFaUfDg5XEVFjM1Vy1QfUv1ab3jg==
X-Received: by 2002:a05:6512:3ca4:b0:553:241a:b93a with SMTP id 2adb3069b0e04-55a0463b92cmr821614e87.31.1752234568742;
        Fri, 11 Jul 2025 04:49:28 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5593c9d0821sm926339e87.128.2025.07.11.04.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 04:49:28 -0700 (PDT)
Date: Fri, 11 Jul 2025 13:49:27 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yukuai3@huawei.com, song@kernel.org, 
	herbert@gondor.apana.org.au
Subject: Re: [merged mm-nonmm-stable]
 lib-raid6-replace-custom-zero-page-with-zero_page.patch removed from -mm
 tree
Message-ID: <sr7kg67kaeuisbxitmvb3rfcvf2b6l2pelnrmgt2s4qsykw6eq@nxid2ju5tcho>
References: <20250710055932.49250C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710055932.49250C4CEE3@smtp.kernel.org>

Hi,

On 2025-07-09 22:59:31 -0700, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: lib/raid6: replace custom zero page with ZERO_PAGE
> has been removed from the -mm tree.  Its filename was
>      lib-raid6-replace-custom-zero-page-with-zero_page.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Subject: lib/raid6: replace custom zero page with ZERO_PAGE
> Date: Mon, 17 Mar 2025 17:02:28 +0800
> 
> Use the system-wide zero page instead of a custom zero page.
> 

> [herbert@gondor.apana.org.au: update lib/raid6/recov_rvv.c, per Klara]
>   Link: https://lkml.kernel.org/r/aFkUnXWtxcgOTVkw@gondor.apana.org.au

Something seems to have went wrong here, the version in mm-nonmm-stable
does not seem to have this folded in and the diff below doesn't either.

Regards,
Klara Modin

> Link: https://lkml.kernel.org/r/Z9flJNkWQICx0PXk@gondor.apana.org.au
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Klara Modin <klarasmodin@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  crypto/async_tx/async_pq.c          |    2 +-
>  crypto/async_tx/async_raid6_recov.c |    4 ++--
>  include/linux/raid/pq.h             |   12 +++++++++++-
>  lib/raid6/algos.c                   |    3 ---
>  lib/raid6/recov.c                   |    6 +++---
>  lib/raid6/recov_avx2.c              |    6 +++---
>  lib/raid6/recov_avx512.c            |    6 +++---
>  lib/raid6/recov_loongarch_simd.c    |   12 ++++++------
>  lib/raid6/recov_neon.c              |    6 +++---
>  lib/raid6/recov_s390xc.c            |    6 +++---
>  lib/raid6/recov_ssse3.c             |    6 +++---
>  11 files changed, 38 insertions(+), 31 deletions(-)
> 
> --- a/crypto/async_tx/async_pq.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/crypto/async_tx/async_pq.c
> @@ -119,7 +119,7 @@ do_sync_gen_syndrome(struct page **block
>  	for (i = 0; i < disks; i++) {
>  		if (blocks[i] == NULL) {
>  			BUG_ON(i > disks - 3); /* P or Q can't be zero */
> -			srcs[i] = (void*)raid6_empty_zero_page;
> +			srcs[i] = raid6_get_zero_page();
>  		} else {
>  			srcs[i] = page_address(blocks[i]) + offsets[i];
>  
> --- a/crypto/async_tx/async_raid6_recov.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/crypto/async_tx/async_raid6_recov.c
> @@ -414,7 +414,7 @@ async_raid6_2data_recov(int disks, size_
>  		async_tx_quiesce(&submit->depend_tx);
>  		for (i = 0; i < disks; i++)
>  			if (blocks[i] == NULL)
> -				ptrs[i] = (void *) raid6_empty_zero_page;
> +				ptrs[i] = raid6_get_zero_page();
>  			else
>  				ptrs[i] = page_address(blocks[i]) + offs[i];
>  
> @@ -497,7 +497,7 @@ async_raid6_datap_recov(int disks, size_
>  		async_tx_quiesce(&submit->depend_tx);
>  		for (i = 0; i < disks; i++)
>  			if (blocks[i] == NULL)
> -				ptrs[i] = (void*)raid6_empty_zero_page;
> +				ptrs[i] = raid6_get_zero_page();
>  			else
>  				ptrs[i] = page_address(blocks[i]) + offs[i];
>  
> --- a/include/linux/raid/pq.h~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/include/linux/raid/pq.h
> @@ -11,8 +11,13 @@
>  #ifdef __KERNEL__
>  
>  #include <linux/blkdev.h>
> +#include <linux/mm.h>
>  
> -extern const char raid6_empty_zero_page[PAGE_SIZE];
> +/* This should be const but the raid6 code is too convoluted for that. */
> +static inline void *raid6_get_zero_page(void)
> +{
> +	return page_address(ZERO_PAGE(0));
> +}
>  
>  #else /* ! __KERNEL__ */
>  /* Used for testing in user space */
> @@ -191,6 +196,11 @@ static inline uint32_t raid6_jiffies(voi
>  	return tv.tv_sec*1000 + tv.tv_usec/1000;
>  }
>  
> +static inline void *raid6_get_zero_page(void)
> +{
> +	return raid6_empty_zero_page;
> +}
> +
>  #endif /* ! __KERNEL__ */
>  
>  #endif /* LINUX_RAID_RAID6_H */
> --- a/lib/raid6/algos.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/algos.c
> @@ -18,9 +18,6 @@
>  #else
>  #include <linux/module.h>
>  #include <linux/gfp.h>
> -/* In .bss so it's zeroed */
> -const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
> -EXPORT_SYMBOL(raid6_empty_zero_page);
>  #endif
>  
>  struct raid6_calls raid6_call;
> --- a/lib/raid6/recov_avx2.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/recov_avx2.c
> @@ -28,10 +28,10 @@ static void raid6_2data_recov_avx2(int d
>  	   Use the dead data pages as temporary storage for
>  	   delta p and delta q */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -196,7 +196,7 @@ static void raid6_datap_recov_avx2(int d
>  	/* Compute syndrome with zero for the missing data page
>  	   Use the dead data page as temporary storage for delta q */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> --- a/lib/raid6/recov_avx512.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/recov_avx512.c
> @@ -37,10 +37,10 @@ static void raid6_2data_recov_avx512(int
>  	 */
>  
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -238,7 +238,7 @@ static void raid6_datap_recov_avx512(int
>  	 */
>  
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> --- a/lib/raid6/recov.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/recov.c
> @@ -31,10 +31,10 @@ static void raid6_2data_recov_intx1(int
>  	   Use the dead data pages as temporary storage for
>  	   delta p and delta q */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -72,7 +72,7 @@ static void raid6_datap_recov_intx1(int
>  	/* Compute syndrome with zero for the missing data page
>  	   Use the dead data page as temporary storage for delta q */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> --- a/lib/raid6/recov_loongarch_simd.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/recov_loongarch_simd.c
> @@ -42,10 +42,10 @@ static void raid6_2data_recov_lsx(int di
>  	 * delta p and delta q
>  	 */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -197,7 +197,7 @@ static void raid6_datap_recov_lsx(int di
>  	 * Use the dead data page as temporary storage for delta q
>  	 */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -316,10 +316,10 @@ static void raid6_2data_recov_lasx(int d
>  	 * delta p and delta q
>  	 */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -436,7 +436,7 @@ static void raid6_datap_recov_lasx(int d
>  	 * Use the dead data page as temporary storage for delta q
>  	 */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> --- a/lib/raid6/recov_neon.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/recov_neon.c
> @@ -36,10 +36,10 @@ static void raid6_2data_recov_neon(int d
>  	 * delta p and delta q
>  	 */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -74,7 +74,7 @@ static void raid6_datap_recov_neon(int d
>  	 * Use the dead data page as temporary storage for delta q
>  	 */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> --- a/lib/raid6/recov_s390xc.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/recov_s390xc.c
> @@ -35,10 +35,10 @@ static void raid6_2data_recov_s390xc(int
>  	   Use the dead data pages as temporary storage for
>  	   delta p and delta q */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -82,7 +82,7 @@ static void raid6_datap_recov_s390xc(int
>  	/* Compute syndrome with zero for the missing data page
>  	   Use the dead data page as temporary storage for delta q */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> --- a/lib/raid6/recov_ssse3.c~lib-raid6-replace-custom-zero-page-with-zero_page
> +++ a/lib/raid6/recov_ssse3.c
> @@ -30,10 +30,10 @@ static void raid6_2data_recov_ssse3(int
>  	   Use the dead data pages as temporary storage for
>  	   delta p and delta q */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -203,7 +203,7 @@ static void raid6_datap_recov_ssse3(int
>  	/* Compute syndrome with zero for the missing data page
>  	   Use the dead data page as temporary storage for delta q */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks-1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> _
> 
> Patches currently in -mm which might be from herbert@gondor.apana.org.au are
> 
> 
