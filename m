Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA59325605
	for <mm-commits@vger.kernel.org>; Sat,  9 Mar 2024 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709974015; cv=none; b=m6Dzv8TrCGDZx4f6YiUZzq+ZNfBzbekasGSl8cf2pZJ7D1MRILlGrJxIh8lDx8rFaxTvugXHAcKT7qb/qEUn5VOjFA6I9ZWBJKRofQlAAwhnjmNdFY47brwSAVRA9AAaLjphiYD52+L4LX4WufkSXajfBfAR3MCoCBvjFz28BJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709974015; c=relaxed/simple;
	bh=jmVvIGqVspwWLyl1lwYQTCIIBu2f9O8Nklpv9v7JltQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LRpjc/t/o+b38uxH7S8YLJmZ0Y9QvzJ+/C+RihePUfrpB9UEsWIhJSITiVfmA1fbbs2BWnFiZPxYQX1a+/mJKmitm50ZA9H0jp8X/iDIoCXShCTR99TuRlCwgegKHcr68T4evrwx1VVsZLxsLyjJXADggxt1HmSXzd2hm2MdTlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hFGF6WcG; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hFGF6WcG"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-36631ba416bso5910975ab.1
        for <mm-commits@vger.kernel.org>; Sat, 09 Mar 2024 00:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709974013; x=1710578813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMbSshcwFaAyBLCy0s9suXTMChg7RdZkyGiUoLAFjQc=;
        b=hFGF6WcGln7xIBQdcLJLktGG4hVetNZdrmWr1DyhiDQREO7wE7vSOE5K7WyLGoBcZd
         0wWN57sScv05tbQvicWV1byj/+VCpEy5eou+69E8w+0rg/vepNJlDqrF9TmPu8cItKZh
         ObKbfcXq7RY5MrefSpm+etAsOu4xkZlrvoDCmGXUqjfpACkWXnWaGrCmAAEqCiUG9QKB
         6z6Wc/14oujbFFiqoUtgJnrasN+niLVpoTBQgjOolk45fzrAtfv21K5A9xshO3DcYOIW
         RGH/Iyt/lanDZC7c0u3CGlNapnvoivCOq5JL4YhniofTkczRQEWAr6e8FTbtmIoNU0H3
         S/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709974013; x=1710578813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KMbSshcwFaAyBLCy0s9suXTMChg7RdZkyGiUoLAFjQc=;
        b=f2v3n0Pe6o6upk0YcxoeyQWOPS+LIB3uC0f/GU8VjScYFiK5dMPhnLHB2aROlfFHij
         8Mkfdf26o8oUn6QGrFZJYyoP8mj51AQDlIFwcg96sBazJghHB16Z8dJieDGQBL9IqfSa
         ALCxQhJrDs8DbF7wLna3GOfhQ8+Sbz3ySX+Z09whkCfhivRs68OuI6l4hh6l9yu5LMhc
         DhMnBEungszzq1tMk8kNOBGVw8zygPlUab5LCJNHd3LXcX54P8XD5EG3vc5dmZwgWIkO
         fE8ixRyFXqNEf027PXMnGT9/QBBB9ffC/5j4OZiITjixvJXCthnUSjbHY1EmmxR4TMXx
         4s2g==
X-Forwarded-Encrypted: i=1; AJvYcCXEH08STTXXCU0KAN9p7clmfxiDX+ewdQKl00wnTgeTgsQC9pxE42qs72FbEmPG3DnQVCRW1mlx172yJsJ23+cqVHXGzugfkE2Giw==
X-Gm-Message-State: AOJu0Yw3f6DHNq4CmNE5PwdoG4A/J8hLYVq4sv4AseIiSnAQff9gi8sy
	qQkyCogFFf/VfdaEIyyVYvTrWeuz5hrpqzgk09tBSJDKdFRgZNqY
X-Google-Smtp-Source: AGHT+IEO6DR/NpR8+DAbTwrYzDwJfcVGo3VLDR+Kh383vcgmMKTaEWf1P3ChqLBe8xksuq/xQlAIBA==
X-Received: by 2002:a05:6e02:b47:b0:366:2f7d:d292 with SMTP id f7-20020a056e020b4700b003662f7dd292mr1551319ilu.6.1709974013038;
        Sat, 09 Mar 2024 00:46:53 -0800 (PST)
Received: from localhost.localdomain ([2407:7000:8942:5500:aaa1:59ff:fe57:eb97])
        by smtp.gmail.com with ESMTPSA id hq18-20020a056a00681200b006e60c08cbcasm852657pfb.50.2024.03.09.00.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Mar 2024 00:46:52 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	herbert@gondor.apana.org.au
Cc: chrisl@kernel.org,
	davem@davemloft.net,
	ddstreet@ieee.org,
	hannes@cmpxchg.org,
	mm-commits@vger.kernel.org,
	nphamcs@gmail.com,
	sjenning@redhat.com,
	v-songbaohua@oppo.com,
	vitaly.wool@konsulko.com,
	yosryahmed@google.com,
	zhouchengming@bytedance.com
Subject: Re: [failures] mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch removed from -mm tree
Date: Sat,  9 Mar 2024 21:46:37 +1300
Message-Id: <20240309084637.5795-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240309044335.C9CAAC433F1@smtp.kernel.org>
References: <20240309044335.C9CAAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The quilt patch titled
>      Subject: mm/zswap: remove the memcpy if acomp is not sleepable
> has been removed from the -mm tree.  Its filename was
>      mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch
> 
> This patch was dropped because it had testing failures

Hi Andrew,

As clarified in another email [1], kindly include the crypto modification below
into the mm-tree prior to merging the problematic zswap change to address the
build issue - specifically, the absence of acomp_is_async().

[PATCH v6 1/2] crypto: introduce: acomp_is_async to expose if comp drivers might sleep

Herbert Acked it instead of merging it into crypto. Therefore, it is supposed to
be in mm-tree to prepare for the zswap change.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4zRM1Epk-OqRmm6ZfB_FA1TyNBtOA=soz_5cZB=_CsrgA@mail.gmail.com/

> 
> ------------------------------------------------------
> From: Barry Song <v-songbaohua@oppo.com>
> Subject: mm/zswap: remove the memcpy if acomp is not sleepable
> Date: Thu, 22 Feb 2024 21:11:35 +1300
> 
> Most compressors are actually CPU-based and won't sleep during compression
> and decompression.  We should remove the redundant memcpy for them.

Thanks
Barry
