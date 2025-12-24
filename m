Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEA0339B24
	for <mm-commits@vger.kernel.org>; Wed, 24 Dec 2025 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766583982; cv=none; b=JzN/xgwEOxK+/ruzxGbuL5eeKkhPQk+Vpd0mSSY1XZAxDqK7dZ2NZtYKFWXz3M7hnGZx6L0h8VfwjpePL4hIV96AV3MPJlo4kwED1r2jgfmW31ieQza15PY3LyKUnqpMIVHK0NHTPR/NFQsGu+di5GT6koRgVsMEQfFhN4xHV9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766583982; c=relaxed/simple;
	bh=DFEEdTupWnHDs6i2uh6+tBe622MAwpsWLzK0YAhSZG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iw+8KoQqW3vBbOB5B05ZRCovGsjape/2jix2LJ7OpQ07xWFYRl9H5RrR2bjifNo145ryu73hqpWOaxLkcfof3dYL5bBnrDM/H0ucmrjtYdSn8fJOZyjGYF90q9oXc7MraGSQCIGsRWcSqHJJ/jn+tlI60E37elSoMBuFjkj/m5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3UEaA1q; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3UEaA1q"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64b61f82b5fso7847844a12.0
        for <mm-commits@vger.kernel.org>; Wed, 24 Dec 2025 05:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766583979; x=1767188779; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsCLUAjKnx29QujAIAOk58Mz7LuP/UQKE0/R/tCqC5I=;
        b=e3UEaA1qCNewzNKGsr9M1SxofWbivkw2KFp3qU1oN6aLNuwcDJezDtugJzkxOJMZjm
         BSFb5H0RxXLxtgODZsEE2bkn2piynqpqgCrCHO507GUuE5Js0TOdj0i4tK+2PObtF3Ec
         ltlmyK1dpDU/t2TdCj6MQ7ItbL9vhydk8Ha4bLBayZloBHOwMZxeB6qkLJT7l69piYVK
         Oo+SEzZJgnTwUaBksHZKzSne946kvsBF5lhrE1hgGWV+3BtR2l81j2KGVDxFuwaW48on
         mBJEuusAu/5qaktBJCKT1XjPXSaMWYJgQq4uzZZ3EX7zon6ZPp1sF5i5BE0yP+GQo+rV
         CuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766583979; x=1767188779;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PsCLUAjKnx29QujAIAOk58Mz7LuP/UQKE0/R/tCqC5I=;
        b=enpnNIn42HTW6YZ80moByzAlZ8QTHU7JUfS0akbUdMwrRD6cz6i2+l3/s5YErd4uph
         x818ksXamaRQd2aC8Lo/X+eQRyq2hEeEHyn5wq/s0Clm9rI4KzcJMOVZvxKZ0FdJQmOE
         NWxHOzegQiIYps/axYWmFgso14eDh+gA7ZuELTUiJFhlpnhCiymZWq0Aiae+RhCboGWi
         jPoxGFCirF1JyEpB29YlZYGCvIXloPrycuSGFQcQrVjOIfPTowXbBEP92oLsWjL8ieiB
         EpTNYq/O0qe5ZiNW/y8fl0D27YZUrl1zS+Acgm5m4r3BfgSYyP8HF4IwgN7NHiyId644
         hxjw==
X-Forwarded-Encrypted: i=1; AJvYcCW2dRWkGd7D7fxqIBw20zA4VABOhjgvQqI3PlZgf2k7mXe1tkM3hR2AjkO4sGkfAVB7OU5B2Ph6tMBp@vger.kernel.org
X-Gm-Message-State: AOJu0YyAJW4frXg79PfxaGMqLbK83bfd33k/o5ImRt0nKsPo0pWEwlf7
	K6DD3Q+NA7KudLa4ct310vx4lgdTGZO9MahMjpRQGdXH/O3nRK9PqX4N
X-Gm-Gg: AY/fxX4zxokO6f1KJHCdQRVySNQBZCrZ1aiJJRkgoCgaj9VBz9G/IymxpgIAIqNaVns
	StdCF2uwQhuOfZChoHKLFcF+3rNk3y73ioSF1Bq7YcRbqaVlo0KI+P9k84BbhDPHUrBChZHVTwz
	cWDi8PebTYmeYlGDtD1JyyBwtmKVjIC6t5tkJVUv61N+rcjcbvWQdCxXV/UUfxYARWvxvCIWXHk
	+DfyKklItAXqOAK9fW4WuWjZZ76jS3YXDwhrKGkullCPlJXdIu5KscbUibf8HzHB3S/51tarC6E
	u+OC2NV1XwmtEaTX52XGLurEzic0k5lqHqtDrWALOHTJUdt3UbdcktTDo48s6E0XtrFErKRWKRJ
	BI6B3Aqqyh9fp4tNbsUsanW3WmMjYXPKd6V/ofS0XCPWZd6Iq+p53qtYtJ1M6b9euekhVBihcE5
	5oSPIBDd0tpQ==
X-Google-Smtp-Source: AGHT+IG62aBpnm6A584Z7pGVmMFrRD+a4El7Ke+aN6U431ho2hRP3cJ5oXiW6fjMdNVPYn2lwhb/WQ==
X-Received: by 2002:a05:6402:5249:b0:64b:6007:d8dc with SMTP id 4fb4d7f45d1cf-64b8e947146mr16049572a12.7.1766583978812;
        Wed, 24 Dec 2025 05:46:18 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9105655asm17135756a12.9.2025.12.24.05.46.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Dec 2025 05:46:18 -0800 (PST)
Date: Wed, 24 Dec 2025 13:46:16 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, ziy@nvidia.com, ryan.roberts@arm.com,
	npache@redhat.com, lorenzo.stoakes@oracle.com,
	liam.howlett@oracle.com, dev.jain@arm.com, david@kernel.org,
	baolin.wang@linux.alibaba.com, baohua@kernel.org
Subject: Re: [failures]
 mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable.patch
 removed from -mm tree
Message-ID: <20251224134616.5pmm6cptuw763xty@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251223182916.E9BF5C113D0@smtp.kernel.org>
 <20251224020219.lutpqt64qqunutgu@master>
 <ac94c922-0caa-4d17-963e-f83f3df58508@linux.dev>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac94c922-0caa-4d17-963e-f83f3df58508@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)

[...]
>> > --- a/mm/huge_memory.c~mm-huge_memory-consolidate-order-related-checks-into-folio_check_splittable
>> > +++ a/mm/huge_memory.c
>> > @@ -3700,6 +3700,10 @@ int folio_check_splittable(struct folio
>> > 			   enum split_type split_type)
>> > {
>> > 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>> > +
>> > +	if (new_order >= folio_order(folio))
>> > +		return -EINVAL;
>> > +
>> > 	/*
>> > 	 * Folios that just got truncated cannot get split. Signal to the
>> > 	 * caller that there was a race.
>> > @@ -3714,28 +3718,33 @@ int folio_check_splittable(struct folio
>> > 		/* order-1 is not supported for anonymous THP. */
>> > 		if (new_order == 1)
>> > 			return -EINVAL;
>> > -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> > -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> > -		    !mapping_large_folio_support(folio->mapping)) {
>> > -			/*
>> > -			 * We can always split a folio down to a single page
>> > -			 * (new_order == 0) uniformly.
>> > -			 *
>> > -			 * For any other scenario
>> > -			 *   a) uniform split targeting a large folio
>> > -			 *      (new_order > 0)
>> > -			 *   b) any non-uniform split
>> > -			 * we must confirm that the file system supports large
>> > -			 * folios.
>> > -			 *
>> > -			 * Note that we might still have THPs in such
>> > -			 * mappings, which is created from khugepaged when
>> > -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> > -			 * case, the mapping does not actually support large
>> > -			 * folios properly.
>> > -			 */
>> > -			return -EINVAL;
>> > +	} else {
>> > +		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> > +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> > +			    !mapping_large_folio_support(folio->mapping)) {
>> > +				/*
>> > +				 * We can always split a folio down to a
>> > +				 * single page (new_order == 0) uniformly.
>> > +				 *
>> > +				 * For any other scenario
>> > +				 *   a) uniform split targeting a large folio
>> > +				 *      (new_order > 0)
>> > +				 *   b) any non-uniform split
>> > +				 * we must confirm that the file system
>> > +				 * supports large folios.
>> > +				 *
>> > +				 * Note that we might still have THPs in such
>> > +				 * mappings, which is created from khugepaged
>> > +				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>> > +				 * enabled. But in that case, the mapping does
>> > +				 * not actually support large folios properly.
>> > +				 */
>> > +				return -EINVAL;
>> > +			}
>> > 		}
>> > +
>> > +		if (new_order < mapping_min_folio_order(folio->mapping))
>> > +			return -EINVAL;
>
>The comment clearly says "we can always split a folio down to a single page
>(new_order == 0) uniformly", but the wrong placement made this
>mapping_min_folio_order() check apply to all cases, including splits that
>should be allowed ...
>
>Specifically, this check should only happen in two cases:
>1) Non-uniform splits (SPLIT_TYPE_NON_UNIFORM)
>2) OR when new_order > 0
>

Thanks for pointing this out.

>But we put it outside the conditional, so even uniform splits to order-0 got
>blocked by this check，right?
>
>The report[1] shows up when madvise(MADV_PAGEOUT) calls split_folio(), which
>uses new_order=0 and split_type=UNIFORM. If a filesystem has min order > 0,
>it incorrectly returns -EINVAL and triggers the warning in __folio_split().
>

Agree with you analysis, the warning and call trace means this is the case.

>So, let's just move this check inside the conditional, right next to the
>mapping_large_folio_support() check :)

And it looks your approach is correct.  But my question is the original code
may not correct. Since this change doesn't expect to alter the logic.

For current upstream, when we split a folio uniformly to order 0, it pass the
check in in folio_check_splittable() since only non-uniform split or non order
0 split should be checked. Then it goes to the check between new_order and
mapping_min_folio_order(). Current upstream will return error for this case
too.

But there is no warning now, and madvise_cold_or_pageout_pte_range() would
continue. So nothing reported. But after this change it catches a warning.

So IMHO, we should fix that first and then apply this cleanup.

Does this sound reasonable?

>
>---8<---
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 01e5139a5e56..068a17317e26 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3741,10 +3741,10 @@ int folio_check_splittable(struct folio *folio,
>unsigned int new_order,
> 				 */
> 				return -EINVAL;
> 			}
>-		}
>
>-		if (new_order < mapping_min_folio_order(folio->mapping))
>-			return -EINVAL;
>+			if (new_order < mapping_min_folio_order(folio->mapping))
>+				return -EINVAL;
>+		}
> 	}
>
> 	/*
>---
>
>[1] https://lore.kernel.org/all/694ac438.050a0220.35954c.0000.GAE@google.com/
>
>[...]
>
>Thanks,
>Lance

-- 
Wei Yang
Help you, Help me
