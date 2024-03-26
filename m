Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C1921344
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476680; cv=none; b=ArvJkOfEArnfj+AJAzzYSAuazNZII93WdZ0AC18/evjYUMriK/fu7ESnN8yD1cqE2eBDvTkSLInYisGQKn99i6ku1Og1S1XXIhGFTXJ8DB+98DQI3HBCWY1Jn4Z4upA73f3/q9Fn5aPQ2Vrxt39yFUWmXc2YSvF52OdE8Z5YKKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476680; c=relaxed/simple;
	bh=3mVijn5dSHROtsdHZoN/rYxZON3OKlP40rEV0ddg3DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hqt3q9Tn7qEgGo/L4uuZONt/9vYYk6jC2Y94xNKVZp5pliCwwGNeKsBmPKkfKzULIMbg2lDTXwerlNX9IhnAUMxHciv5wcm+1NBbpBZNJu88sqim0L/qJk/t281gu8xyHlWHVI18PxwXdppQQ1q7w+crw8L6R9HzS233v6NKOYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J/NCjUe2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/NCjUe2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711476677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TXAIJv9nAl74kU55mYeOMp2Ok3/4sY0r1ywNXMqvguo=;
	b=J/NCjUe20XDkbQOOlHUhv7670lNAIs0MsnycfYMPlV4r/imPQlll1msO9iJ2sOfPDy4xLX
	JXRpH5D/uLCCdYslJQV4VNAqACgQynRahIUCpruRe8p8SpTnqpV7FyFH6fXC9qXW/eYLG7
	/3DmlKfhP/0q95HBX7NgqlWn5o2c+r0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-hdDTbIB3PqGJfq9_fKY14w-1; Tue, 26 Mar 2024 14:11:16 -0400
X-MC-Unique: hdDTbIB3PqGJfq9_fKY14w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33eca7270ccso28761f8f.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 11:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711476675; x=1712081475;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXAIJv9nAl74kU55mYeOMp2Ok3/4sY0r1ywNXMqvguo=;
        b=XXf6amobT5vSSiwiEmzjeLdTOzFTLOGQle1bjFWq4lTLvEsqe/rqZwN79L5DzlHbFB
         KfgL1Q0b8f1W/JSSm4mQ9e5DgjnuF6P+Riz7qik+RlDN7KQgOI3ydl+byKV60CvZF8ve
         /qtaNHyHJ8G40QeAkwjt7xWDBNwNu5ROQdozYPmxBht0HVQJHJfYAjemacdWFZ48bj0c
         STmqMbqeQ1BYcM9c8wIg8g7o7sAib+eoxqgN+m0skruB5mnNRDQZam8cKx2B/1S6P9A9
         W7xNUy9peMC2icClvuBOxz31kEkYyrLQLu3ymwYF1QD/xqP0QynSCNnOSphNSgiQSjqA
         9C8w==
X-Forwarded-Encrypted: i=1; AJvYcCVPehZP9T4HE+vlJxNsIrJTFRpgrmHYUuVVvezqK6K1+jeJJ6koHKckaGXZHllpGSvuh3zfrt5SO46gSOp5cs+KcbvT1ozKL+fp/Q==
X-Gm-Message-State: AOJu0YyqKG0sqQ1luuG3wSMpg5ut7MHrjhDeTOrRiPEvhYCgJb6lga33
	0KdXmYZuRupxB/CDNM54kCs5H1DDzeXosO79Qtw5501E407bmfRHWFQoWvun52qIvGcFFGUFt1p
	xHi3Ta5aLH/IiepZFlcupxc6XyjoHZtiZVdPfVS7P2aFsJHVFUbkg/71q8Xg=
X-Received: by 2002:adf:e2c4:0:b0:33d:7e9:9543 with SMTP id d4-20020adfe2c4000000b0033d07e99543mr1971436wrj.32.1711476674789;
        Tue, 26 Mar 2024 11:11:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYVGiSSOiyeqSQtOzZRq9B0JuObQm7Kc94Eg0TF3ptGNq3roaO1WUP51o8blzyw0Tqp3knjw==
X-Received: by 2002:adf:e2c4:0:b0:33d:7e9:9543 with SMTP id d4-20020adfe2c4000000b0033d07e99543mr1971419wrj.32.1711476674422;
        Tue, 26 Mar 2024 11:11:14 -0700 (PDT)
Received: from ?IPV6:2003:cb:c741:c700:3db9:94c9:28b0:34f2? (p200300cbc741c7003db994c928b034f2.dip0.t-ipconnect.de. [2003:cb:c741:c700:3db9:94c9:28b0:34f2])
        by smtp.gmail.com with ESMTPSA id ez19-20020a056000251300b00341c88ab493sm7842972wrb.10.2024.03.26.11.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 11:11:13 -0700 (PDT)
Message-ID: <8a4c167f-6dcc-4fe2-9edc-a722badd4df9@redhat.com>
Date: Tue, 26 Mar 2024 19:11:13 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-hotfixes-stable]
 mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch removed from
 -mm tree
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 xrivendell7@gmail.com, stable@vger.kernel.org, samsun1006219@gmail.com,
 rppt@kernel.org, mszeredi@redhat.com, miklos@szeredi.hu, lstoakes@gmail.com
References: <20240326180828.AC6E1C433F1@smtp.kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240326180828.AC6E1C433F1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.03.24 19:08, Andrew Morton wrote:
> 
> The quilt patch titled
>       Subject: mm/secretmem: fix GUP-fast succeeding on secretmem folios
> has been removed from the -mm tree.  Its filename was
>       mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 

I sent an updated patch that removes the LRU check completely. Still 
time to fix that? :)

> ------------------------------------------------------
> From: David Hildenbrand <david@redhat.com>
> Subject: mm/secretmem: fix GUP-fast succeeding on secretmem folios
> Date: Mon, 25 Mar 2024 14:41:12 +0100
> 
> folio_is_secretmem() states that secretmem folios cannot be LRU folios: so
> we may only exit early if we find an LRU folio.  Yet, we exit early if we
> find a folio that is not a secretmem folio.
> 
> Consequently, folio_is_secretmem() fails to detect secretmem folios and,
> therefore, we can succeed in grabbing a secretmem folio during GUP-fast,
> crashing the kernel when we later try reading/writing to the folio,
> because the folio has been unmapped from the directmap.
> 
> Link: https://lkml.kernel.org/r/20240325134114.257544-2-david@redhat.com
> Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Reported-by: xingwei lee <xrivendell7@gmail.com>
> Reported-by: yue sun <samsun1006219@gmail.com>
> Closes: https://lore.kernel.org/lkml/CABOYnLyevJeravW=QrH0JUPYEcDN160aZFb7kwndm-J2rmz0HQ@mail.gmail.com/
> Debugged-by: Miklos Szeredi <miklos@szeredi.hu>
> Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
> Tested-by: Miklos Szeredi <mszeredi@redhat.com>
> Cc: Lorenzo Stoakes <lstoakes@gmail.com>
> Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   include/linux/secretmem.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/include/linux/secretmem.h~mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios
> +++ a/include/linux/secretmem.h
> @@ -16,7 +16,7 @@ static inline bool folio_is_secretmem(st
>   	 * We know that secretmem pages are not compound and LRU so we can
>   	 * save a couple of cycles here.
>   	 */
> -	if (folio_test_large(folio) || !folio_test_lru(folio))
> +	if (folio_test_large(folio) || folio_test_lru(folio))
>   		return false;
>   
>   	mapping = (struct address_space *)
> _
> 
> Patches currently in -mm which might be from david@redhat.com are
> 
> mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
> mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
> mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
> s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
> mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
> mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
> selftests-memfd_secret-add-vmsplice-test.patch
> mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch
> 

-- 
Cheers,

David / dhildenb

