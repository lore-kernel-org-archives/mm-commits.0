Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795453490;
	b=v9ys/flVYJXAS5rgZHdhD98i+JAYNUVcMmKt7ZwpN2hJRsfWkaN18dS2COmbwf9FIAnZ
	 yQVvgbgAbBeNg6G6RWTCWnRIYkyKW7GXcu0ZoOjks8fjkLiRTDim+gqzinpAblJMWepkE
	 uhlsEOEr4uALB3XmnECxQzwG2o1qXev1e3U9D+aj6yPlaFdVvUXLWBPzprO2KK4LKxZIu
	 GTtda+8TDLph1qI4fRJtMUZjDOjP2kciQpvGF9g8Abo2qTvgzx3x/BXFEkPcEQjPyiSPz
	 gayMTPf1BMUZapGcXqSbxUxvJnbYsuUuvH6XXap/HaHRGTLiZGPD6agaZTQ4PrsFWcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795453490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=6z6ak377Awv+mxJYPSVQS/ONw5MrRNWXM3G9SGJDdio=;
	b=WROGI0gw2O0Bml0TB++eG1ROciCIa6U6mGcLX+FINyO/xfQpE7wqTLUpc4+rCx6LAaND
	 GCYGjOIO7biXF9ewFjIymTthz7CaaTMEiE3QFkKHfjMsk1WM/bB6cQUyzmKWYdtCheWLj
	 cwqnkzTnbdVLnSX9eQrEt9PdFeyBffZXBifjKO9UUVvmDzbH+gEyA5Ci/ECGMJctNwNq7
	 V3RtEXFon85XtkcqeTnShNxRWUmnpiBpMW0Nw0ethrLtKgoEvLbE1aBVFcuhOZtj7Zhm+
	 Fi7evOXl6sP2p1yTlP4rHP+1uq4vz1dCcBK5ZLfeGgR9dH/Fm2t3xXFMscvVYaWmtJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z+tRy4TR;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35A5606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E35A5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z+tRy4TR
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f048bc09d7so120305ad.0
        for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 09:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795453489; x=1796058289; darn=vger.kernel.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6z6ak377Awv+mxJYPSVQS/ONw5MrRNWXM3G9SGJDdio=;
        b=Z+tRy4TRZ2gL1kXKXKkEFgbmqyWnnYHJVLAGknNmltW2SvH3rUvuHfPT4OMrCT90N1
         /lFjF6BnT3PbhQrPH2d6BnlBsJ1Hbv4jacUBCvFrbQFlHAcD+kgODZ7F3J3OO2QzXhwT
         AJNZBITZhOBQU6f/bJR0v6XTHkGzRNmxnnkNgVYQr369SGiEcZHo22EyqJGXzi9ABCe/
         st6EK0VFRDFfSatLnlNuALW4N2QW2HnPb2TM/jd+5PppbNboRz4TkYfirfWvnrpNqDI0
         G5VaZk0SY1ixLMjAXaIsdz09+ctv3M+ckBxgtDxE45te7d3fSqAcCqzLiKeo0E7O4iaI
         WPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795453489; x=1796058289;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6z6ak377Awv+mxJYPSVQS/ONw5MrRNWXM3G9SGJDdio=;
        b=WY4Uc0VKRqhdyZQLPBbEVzGNSLm2lGrTVAzyrMXhsGXI/F8sCAcq9s70B+4SqxqFzi
         tbI0UPzmmR2H/vedaQegB+3Nx9tivpsXTFBxGAdg1liphDCErRt8abg3cpCReeiwJ4b7
         1AsKnScwFAMnQiSnFHljisISPQ52gK7Gqb5e37pBqCRB3svDTO/J8OAyZurpzShxvUOZ
         D+sQ8TK3x1WQaRn9bM185QVkcurNqXbsnen1baVWQWVQPc5FgYi44R53A2La4t2C0zXF
         3TPNNj29xK2v7B6ZJ/Yvz6t/UuseZFA9ZFDOdrXeuy6m1sZBy3WyccDe0oNaCGwVFK1W
         LUbw==
X-Forwarded-Encrypted: i=1; AL+hErG0k7t/iwffmEM1f4MOcVmtPT5XskECBYNhiiPvm+Rzk2EE23jv2V5pFrW3H3WmpFV120sp+TBaZrad@vger.kernel.org
X-Gm-Message-State: APuU4Z8X3j9ZHDX/1T5F9qgPE5yB5dkOz0c5yqBW5anE8dLTKMSMLI5I
	mDSuJnUiPMHuGDnFqynpDpttldN2Cpbr0wq2UxX7tQ811Y7VptWKdpORADtGZ2pP8g==
X-Gm-Gg: AZFdTZfVbzhicsT+KexR2uxVgR8CD8h4WVRX517PKUzhPHEJXBI2/pALOujjodlZFkj
	FHZj0SfiR3+f0KX1Hv+nqT4q31YzonLomnBTWNaquXUR7xbE1XBTxRTNoPjz8ZGJK6YKi+91vQy
	/fn7QPB0U8dpojGvifRfPoZexEjjegPivpCjt5J4Zr++kJGswBftqCh+ILhrfuJKORoK1wfRJPe
	NJzs3JCYYCy5kTD1z6fSgGxJ9maLrtPY9oRKH2HgVjPDY6HE14uTHhvFPu+gpRsvMqDk2pZtTJi
	KqlKWugC9kDmK+dPysOAbsGF/GV7PB8g1wWawhd+8isFdvxQs9rB9lPseEI6d1Z8rUXxZbFVrX+
	tISRCpIyM7Rv1h6muA5TA46VYWGi85DzQkshFj5VD/1PDOzYu5nTYoFB4E1jqINt9eIQc8clrk1
	4wE0LLUiPtc6GLbSM3vUrZWJ4dtFgybd3KQrHnsgvrybKWN32Bo13AcdFH5Q83hc8V5WCZNQrl4
	j59kF2X1SNoqFyE0t3B4cg1XVaw2NRSyyLbGwy1EYQe/XkVqb+89FhD1KI+5E2CqIC4z4nLytjC
	juD7xsXQmA//lYEN5KYD2IU6RNCsfz4Yqn1Yk1gZFr6ew213aBlk2I7PfkdodgIZGiZQmWTVH1J
	E24Qtoorw1fE+x0pWy9SGbWqphQaBd4MfYEll1AYmaf04LxJnx5Pt4zcgcuVyQzEKMl/see6bAn
	mDEQI7pitaCok0w92S6JOlIli5qWMSACT9IQBrW+BZ2ipTZA==
X-Received: by 2002:a17:902:f790:b0:2e5:9bdf:6b65 with SMTP id d9443c01a7336-2f0615ca0f5mr7681115ad.0.1795453488528;
        Mon, 23 Nov 2026 09:04:48 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:2973:837c:48c1:1e91] ([2a00:79e0:2eb4:9:2973:837c:48c1:1e91])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285b60csm5993799b3a.9.2026.11.23.09.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:04:47 -0800 (PST)
Date: Mon, 23 Nov 2026 09:04:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kernel test robot <lkp@intel.com>, 
    Christoph Lameter <cl@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
    David Hildenbrand <david@kernel.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 327/327] arch/arm64/include/asm/percpu.h:261:1:
 sparse: sparse: cast truncates bits from constant value (ffffffffffffd8f0
 becomes f0)
In-Reply-To: <20261122194825.2541c7389c2f958ef3d07fbc@linux-foundation.org>
Message-ID: <7d1f916f-2a4b-c31e-617c-e1da7623fca3@google.com>
References: <20261121133112.48w1QOqw-lkp@intel.com> <20261122194825.2541c7389c2f958ef3d07fbc@linux-foundation.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 22 Nov 2026, Andrew Morton wrote:

> On Sat, 21 Nov 2026 13:34:45 +0100 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   7d1a16abe4cc5dccd21e3d6262e44433a5885d27
> > commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27 [327/327] mm: vmstat_kunit: add synthetic benchmark for mm stats
> > config: arm64-randconfig-r2305-20261121 (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/config)
> > compiler: aarch64-linux-gcc (GCC) 15.3.0
> > sparse: v0.6.5-rc1-21-g84ec0658
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
> > 
> > sparse warnings: (new ones prefixed by >>)
> >    mm/tests/vmstat_kunit.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/kref.h, include/kunit/test.h):
> > >> arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits from constant value (ffffffffffffd8f0 becomes f0)
> 
> Thanks.  sparse is being a bit silly here.  Using a variable instead of
> a constant silences it.
> 

Thanks very much for taking care of this, Andrew!

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/vmstat_kunit: avoid sparse warning in vm event cleanup
> Date: Sun, 22 Nov 2026 18:51:40 -0800
> 
> Sparse warns about -TEST_COUNT in an unreachable 1-byte arm64 per-CPU
> case; the actual counter is 8 bytes.  Pass the completed loop count
> instead to silence the warning, with no behavior change.
> 
> Link: https://lore.kernel.org/r/21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com
> Fixes: 7d1a16abe4cc ("mm: vmstat_kunit: add synthetic benchmark for mm stats")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Sarthak Sharma <sarthak.sharma@arm.com>
> 
>  mm/tests/vmstat_kunit.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/tests/vmstat_kunit.c~mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix
> +++ a/mm/tests/vmstat_kunit.c
> @@ -107,7 +107,7 @@ static void vmstat_test_interleaved_zone
>  
>  /*
>   * Test 3: count_vm_event() benchmark.
> - * Restores counter balance with count_vm_events(item, -TEST_COUNT).
> + * Restores counter balance after measurement.
>   */
>  static void vmstat_test_count_vm_event(struct kunit *test)
>  {
> @@ -124,7 +124,7 @@ static void vmstat_test_count_vm_event(s
>  	time2 = get_cycles();
>  
>  	/* Restore balance */
> -	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
> +	count_vm_events(SLABS_SCANNED, -(long)i);
>  
>  	time = time2 - time1;
>  	avg_cycles = div_u64(time, TEST_COUNT);
> _
> 
> 
