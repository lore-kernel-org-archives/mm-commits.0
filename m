Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3A721369
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705509924; cv=none; b=Usge5NmPFZMQhNWo3iADmxg9WiCrCvAlskgvnqYhJDd+Owbm18Oq3Ioodfm6mO/tdvfQaRPrO8V+isDMD45htbeqbOlYe0/K1KYhSU7Ox2HSV/GFWnvQrfGhDpjnLfTrqV64Sh7C4FTPGM+sF5BCfPSS1TrEsC2iWO0WUS5IbzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705509924; c=relaxed/simple;
	bh=sQirDIdhUxQbD6INpSASJHzEvfO70Nz8S/nIJ1U/us0=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To; b=gtQfhJJdfib+b72UkL2xs7vm6KrB2MwILz2Bl96XeSMFivztpGXc3s74/pDvcl8DiRaYCbggSK061AjJE6xG8NjmCjEdT3+1XyqxyECif5IyXfwx2GL3HRswSyRbTGOWQcEoTU/q+EW7ilwmh0eD0CVCASGinjupzJpDhBLQ82w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a2cea0563cbso796452566b.3
        for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 08:45:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705509921; x=1706114721;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KHgZYZpiBQToL+HDXPEboPhH2N7k7mR/qEsEwQiOSZ8=;
        b=h9fvz0WMwtVjF0PWjSzRvHPc2xdJmsdqNrqDV0f/W1aaopZIi+LfIl0HO/zzPfv1KL
         5rxuD0vOwM2Z7ztbUgLojlYlL+ghYWh1Vq/KEczsxJYyELK1YRthU4XgiIvpiMuc2lMo
         b18EhCivwIHWxteg5rQJs0il9tRjxrOb+BLUNzFzTKMGINEIv2MuK9Xf59F5t81T8sif
         yBpkaanEgeppy2qDrX/v8QQtVGkcQx/t0n+3krz+Daq5ghou++jQVZnH7+42fYqhu4uh
         rHvrbAEz7ECtIZoJDzLIZSXkf/Ew4+6XLXUKnewTo3xLxvMlqCr7LnhE35gTZObT6dbC
         0+nw==
X-Gm-Message-State: AOJu0Yy5JpLTlv7sGZzNolep0yWYCPS0BD/q2wfHx2Z8ANe2MWxkXI/5
	bfEn2X/i535X/e+waR2XKaI=
X-Google-Smtp-Source: AGHT+IEkZUalbTV8R1HMvGnxcDVPhAGrkWJN3E+RWzOXQw9g6s4o5Ck5Z5DBNqNoC5R5dDw62fgXfA==
X-Received: by 2002:a17:906:ff53:b0:a28:fa55:3597 with SMTP id zo19-20020a170906ff5300b00a28fa553597mr5030347ejb.98.1705509920800;
        Wed, 17 Jan 2024 08:45:20 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-003.fbsv.net. [2a03:2880:31ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id tk4-20020a170907c28400b00a2ce236ed71sm6530397ejc.43.2024.01.17.08.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 08:45:20 -0800 (PST)
Date: Wed, 17 Jan 2024 08:45:18 -0800
From: Breno Leitao <leitao@debian.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	tglx@linutronix.de, ming.lei@redhat.com, linux@rasmusvillemoes.dk,
	andriy.shevchenko@linux.intel.com
Subject: Re: + lib-group_cpus-rework-group_cpus_evenly.patch added to
 mm-nonmm-unstable branch
Message-ID: <ZagEHj9v9n9M80YW@gmail.com>
References: <20240110160755.3E20BC433C7@smtp.kernel.org>
 <ZZ7e3xbIKfVa3yqd@yury-ThinkPad>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZZ7e3xbIKfVa3yqd@yury-ThinkPad>

Hello Yury,

On Wed, Jan 10, 2024 at 10:15:59AM -0800, Yury Norov wrote:
> diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> index 3a0db0f51f09..c9c95b21e6c6 100644
> --- a/lib/group_cpus.c
> +++ b/lib/group_cpus.c
> @@ -353,8 +353,8 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
>  {
>  	cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) = alloc_node_to_cpumask();
>  	struct cpumask *masks __free(kfree) = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
> -	cpumask_var_t npresmsk __free(free_cpumask_var);
> -	unsigned int curgrp, nr_present, nr_others;
> +	cpumask_var_t npresmsk __free(free_cpumask_var) = NULL;

I am testing the akpm's mm-everything branch, and I am seeing this
compilation error when compiling with clang.

	lib/group_cpus.c: In function ‘group_cpus_evenly’:
	./include/linux/stddef.h:8:14: error: invalid initializer
	 #define NULL ((void *)0)
		      ^
	lib/group_cpus.c:356:52: note: in expansion of macro ‘NULL’
	  cpumask_var_t npresmsk __free(free_cpumask_var) = NULL;
							    ^~~~
It seems related to this patch. Are you aware of it?

Reverting one of the change above "solves" the error:

	diff --git a/lib/group_cpus.c b/lib/group_cpus.c
	index c9c95b21e6c6..7644bd99085d 100644
	--- a/lib/group_cpus.c
	+++ b/lib/group_cpus.c
	@@ -353,7 +353,7 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
	 {
		cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) = alloc_node_to_cpumask();
		struct cpumask *masks __free(kfree) = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
	-       cpumask_var_t npresmsk __free(free_cpumask_var) = NULL;
	+       cpumask_var_t npresmsk __free(free_cpumask_var);
		int curgrp, nr_present, nr_others;

		if (!masks || !node_to_cpumask || !alloc_cpumask_var(&npresmsk, GFP_KERNEL))
