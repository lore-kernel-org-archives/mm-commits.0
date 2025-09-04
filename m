Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A631D27586B
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 06:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756967838; cv=none; b=CZbu75z6IXMKgGlpQL8kpxbjS0+ImiqF1k5ssjl2iXrjFx0RKmOUfgAkKoyKq33V2aqI0vbMHQgrGBqSRzn/ZU/+oUxeCKzVuc1sTsZwQkw0JYETeU0efq+Rmd+vYFcPImGjav7YLoZFIeAmjikCcs56SBOz6l4sE9SO7huJA2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756967838; c=relaxed/simple;
	bh=YHq/XIieocbbYO3BZCcAzW8vjY67iNJT2fbtzZ9u23Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ddXT9fZ1cWbEC2GNm/+tCLLcWOF1Q8dL8cs5jyYgC6M/7rwZla+B4lSHBHkHt1S2ClZBqtTWIsDAu4lhW9oYjaD8VnuaezLRWK2FpaTQdnFCUi0+5LlkEgZaZP7ffnDj0oTZXTTNbIpI6fcniuelggpDXJ0B2PfexYumTRuMnjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JyayckdF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JyayckdF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756967835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g6G1boJeFmwgDQtVE8Y6Uo78SaicntEmdNiGU6eaUts=;
	b=JyayckdFsmXQIqW4ppOfcxz/0JkKmz+CxFfCQ/yqdVObvW5QUIgLZ0AMIWHahRk0PV/KIO
	gjEyOe7bPEkf0nPf1oyf/gbRdN8+23XoA3HIXH7sX8g4wyM+Fdo+b79ExQPSKHbessiz7g
	R9V4rl+s2Q41FtxwiO0RwLZVDyQSvzw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-gMAZiiPcPoCquJ5L-7QlMQ-1; Thu, 04 Sep 2025 02:37:14 -0400
X-MC-Unique: gMAZiiPcPoCquJ5L-7QlMQ-1
X-Mimecast-MFC-AGG-ID: gMAZiiPcPoCquJ5L-7QlMQ_1756967833
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso3735095e9.0
        for <mm-commits@vger.kernel.org>; Wed, 03 Sep 2025 23:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756967833; x=1757572633;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g6G1boJeFmwgDQtVE8Y6Uo78SaicntEmdNiGU6eaUts=;
        b=Z4752cerKDaY2t2cxQNaJ8elL0LVIk3dAYIdfnBH3KgMQhZKgr4SKBAgg7QhZLv5wE
         ZLLQuHalFDKv+LTT1be7tSZk+OaSlnntWyc5lgZb3X2yR6k2tuP7jYYomXSRv36reTNJ
         KAdT1jkDuYX+C4W15BCcDAaEZsz821AK6UYTVtE0YFttNRQknbIK6q/otFh5YKyNpgpY
         5kIE4ThM93keFgmJbAMcMMFJgmukmJII4h/52K6FOwiEfOmeO9ST/eKnoqa1IIAOI57d
         hVqtwE/zT9gE+gkygG6Z04PLCh9A43cjI/t4a7098mtqc1xs2e8qrtqEEfben2jzldeu
         PKAw==
X-Forwarded-Encrypted: i=1; AJvYcCVggMe2CkHCy4/dIgPjfNiCTn0zL9tWZzanMdz+ONcwV+kWTf40TTxuF936vEEWivk0c0EdHF0eCzOx@vger.kernel.org
X-Gm-Message-State: AOJu0YzIkLpSbHbFA3IzwtcHU4NdqJeDoFpT8KExlhwpgMcLA+aYb2tQ
	j2X8/R1iJMWu9PSZnH8nnEByH8xGbKVBBqCWxwHbCxpyEnp+mek+VKgPncKNcAiLj6txZK1i0z/
	tUeGy9n1oBxQ+PBrXNu8eeoaa1qYPq954y85G8kHRqBo3zu78oBUJ0STpl9XOxaahld57bWk=
X-Gm-Gg: ASbGncvp36A+O5Ub/pZigqiUqAMz4bPlKwQdIdXO9LCSs7bTJiHgBVMUFWDVY21ALkH
	gw+lYwSqyohC/ZbynsUnxWOwvAgT0kwRg9Wo05LgxoV3EI8kgb1hzBUNcWqhAditIwT/t7JJFAm
	NEcKwDtmt68ATRZgV69h3WeoDuz1ndejgxM3ueDSg3I13LJriAMlJeXs1A7vB4KuKxOOTJCMiMs
	zYzsjhRkI436O4aGvxyzePo1a9LwcyEZ9jOmp1wWZ1MAWgZzYh4WtT5Jytc+amSub/UuX6TvAzX
	k7e7/EZRTYIDnUGXcuqOuf8nmNltMlHLtt3kZeOPyuvS2Wcv4owKELAGJum7MKYPEkhTuyQSqQx
	MBHy5R1QOcvHdxpn4qOHzfshggjmlCxGjvfwn2e0MEkctOLlu+TAt6pJqoZfpMvsm
X-Received: by 2002:a05:600c:19d3:b0:45b:8ac2:9761 with SMTP id 5b1f17b1804b1-45b8ac299a1mr132788555e9.13.1756967833000;
        Wed, 03 Sep 2025 23:37:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDYGVYGFzN6ntaujPgtBCz1sgx0RlPbJsY6fBzBPYpUIrwlcwBznC3M+2ua2TvTgxzQhJslA==
X-Received: by 2002:a05:600c:19d3:b0:45b:8ac2:9761 with SMTP id 5b1f17b1804b1-45b8ac299a1mr132788295e9.13.1756967832546;
        Wed, 03 Sep 2025 23:37:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e92a42asm268098815e9.20.2025.09.03.23.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 23:37:12 -0700 (PDT)
Message-ID: <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
Date: Thu, 4 Sep 2025 08:37:11 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 vbabka@suse.cz, sfr@canb.auug.org.au, rppt@kernel.org,
 lorenzo.stoakes@oracle.com, jcmvbkbc@gmail.com
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250904025957.EC982C4CEE7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.09.25 04:59, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
> 
> This patch will later appear in the mm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
> Date: Wed Sep  3 07:51:59 PM PDT 2025
> 
> nastily "fix" folio_page()
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   include/linux/page-flags.h |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/include/linux/page-flags.h~mm-constify-highmem-related-functions-for-improved-const-correctness-fix
> +++ a/include/linux/page-flags.h
> @@ -316,9 +316,9 @@ static __always_inline unsigned long _co
>    * check that the page number lies within @folio; the caller is presumed
>    * to have a reference to the page.
>    */
> -static inline struct page *folio_page(struct folio *folio, unsigned long n)
> +static inline struct page *folio_page(const struct folio *folio, unsigned long n)
>   {
> -	return &folio->page + n;
> +	return (struct page *)(&folio->page + n);
>   }
>   
>   static __always_inline int PageTail(const struct page *page)
> _
> 


I think we should do the following. And I'm wondering if we should squash that
into the relevant nth_page patch instead:

 From 6ada1d36d18969db587ab647757a9538ee1d09a6 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Thu, 4 Sep 2025 08:35:24 +0200
Subject: [PATCH] fixup folio_page() const correctness

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  include/linux/page-flags.h | 13 +++++++++----
  1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index faf17ca211b4f..3a9e73abea3e3 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -307,6 +307,12 @@ static __always_inline unsigned long _compound_head(const struct page *page)
  	const struct page *:	(const struct folio *)_compound_head(p), \
  	struct page *:		(struct folio *)_compound_head(p)))
  
+static inline const struct page *_folio_page(const struct folio *folio,
+		unsigned long n)
+{
+	return &folio->page + n;
+}
+
  /**
   * folio_page - Return a page from a folio.
   * @folio: The folio.
@@ -316,10 +322,9 @@ static __always_inline unsigned long _compound_head(const struct page *page)
   * check that the page number lies within @folio; the caller is presumed
   * to have a reference to the page.
   */
-static inline struct page *folio_page(struct folio *folio, unsigned long n)
-{
-	return &folio->page + n;
-}
+#define folio_page(f, n)	(_Generic((f),				\
+	const struct folio *:	(const struct page *)_folio_page(f, n), \
+	struct folio *:		(struct page *)_folio_page(f, n)))
  
  static __always_inline int PageTail(const struct page *page)
  {
-- 
2.50.1


-- 
Cheers

David / dhildenb

