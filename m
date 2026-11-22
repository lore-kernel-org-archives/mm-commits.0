Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795349082;
	b=ZODNL0MzVpWbY6t7q0l/xp9YhY9Ut9SmA5ijrC5PAWXO5kWh+tTa469mF4iB1vlEKpN+
	 muBXhJ51zMBCGW6RwpM9n09F4mwKmHtf+JRFPIEoCAsD7OpR3gpA/YhaMBfglIufsURKg
	 PyevYX1EEOimBKVRKOxHBMYA6R0VTmucGnZILCUbeM1zuvg9TvOMpTPa3C4DpYIdowxIJ
	 D7gJ5cqUd2g2nmeWfwwOMl+FZfZrBKdX1mxmlhSN5d1LkFVxCMSoNHwCoS2mOo3AiyK6n
	 EHsPP2UnD7+ZMbmGMW1u4Mmd09kU/xejm2hVuhRrhBUaDIn3rUwiyjeRDaLaR4Mx/CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795349082;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=V+yb/y9hVY4gQHBtq0ety+i4x7YbvicEI/eHAt9Cm/M=;
	b=cIW6bF8R6ZmzQ79UPFN4sqwcGLIiBQuypEX72xeVnRugbN/3fixrhidygkTtSTfL4cTB
	 /6pxfApNu4+uXtnJ6f4WHFk/2FMxRY+KyojAMELNDS4dEOWOzC4QESZ4erSbuDIqM3JH0
	 F17tWejN3Kj3PyTesKjS2liIvT7XcBd7UGvPwZU1zKRXf9k74xR7B8NGMcLzN+ERarGmQ
	 D76FrpMzj5rH3vGEjp0WQ6PpzVYj+KHx7Nm6MG0HM495L56lsV0hDRjIoBTi9IbabYCWU
	 yf9YRBqo+p+EYUqWQbUC3Qp/6uLZlGOAqgBkKMmHdGdqVddKt3K5IxJX+920jHoCEvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QtATdAra;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=OtisCIjF;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACC0606A320
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 12:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ACC0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QtATdAra;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=OtisCIjF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795349080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+yb/y9hVY4gQHBtq0ety+i4x7YbvicEI/eHAt9Cm/M=;
	b=QtATdAra9RhIwPgRhS7ygnxiUsv7aGRaEtVv/V9javQUjljEfvnitQt838MpxOLMnZQZRy
	5UgPfmIB9WMmlg1dSMEBQzTlRSh3lMBl8ka372+01J7jf3jP1w1YCTtvdvtXVR7x77X2AU
	MzJ4RIfh4ETtbo47V2tFa10PXO+Gosk=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-XE8bRuyNN2mpBtQOxoE25Q-1; Sun, 22 Nov 2026 12:04:38 +0000
X-MC-Unique: XE8bRuyNN2mpBtQOxoE25Q-1
X-Mimecast-MFC-AGG-ID: XE8bRuyNN2mpBtQOxoE25Q_1795349077
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3ad09084d85so7771661fa.3
        for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 04:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795349077; x=1795953877; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V+yb/y9hVY4gQHBtq0ety+i4x7YbvicEI/eHAt9Cm/M=;
        b=OtisCIjFnkmapXhgv/AMAE8iiLPUGerDvNC2GKYbHMY00DKB0gTBfRz+TSjApaphhA
         Rz0gXQZcNwq9TJwQT3P92cFsPTARBZV41xR/b04oHKFrZpJKxjCkWOUvBhmbaowkGfLo
         i+AL7oatqJTWDPh5G2NNEQd0TgZ6wgbYjIv9uWaiMOq5NuiFb9H9PH+zfz4YjC5rRSWn
         ny2Z5Qb+Zg1TAxJPFQtzBY6Gb3oi2bGB8Uj7NjS1hVsfJfZoSzHQXTZZf8C+itmGeNpg
         ebTWMzykp2cQKzg+gZZcP+LGEklVuB1IvhXUn0Q91JWZ2G68lZbSv3kAFIPMd1fOzKCv
         EK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795349077; x=1795953877;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V+yb/y9hVY4gQHBtq0ety+i4x7YbvicEI/eHAt9Cm/M=;
        b=vn3nHcTIQNLkqgwBe0V45K4cD3U+ud7WOWPvupMHZ+H4UCsjF58pbASUY8znPoMk4i
         CPg3wUpPPtRZ+gJe556vlAYRz2mUugDee/sJjNjOag0Zgs9RF/K2HCsM1uzWF2TkQQWP
         +NoDS9wGrg4aCzQFTBDDkgPgOydnWkeroPugmCpU8quNT5/7NvkEd7xJmRxxWMgjzeOE
         fZI0IknRFvw6cKPyfiKdsndXWjn7SOtm8dStyW023Vm1lbgkOfDFfSUJhyJj955UnGXV
         HXObvQXYr6sknZ/6bt6OwHcZl0CJEd4+y41T4gWIRXAIxxbP1b+Eb2NJ28W89WZS6fef
         I7Cw==
X-Forwarded-Encrypted: i=1; AL+hErGO8nqNJAo0wSScrb+GI6qOf8Nd/IuKuSmUE8HBZUSjNhp0yyrtct+y8aEwHnazo9AQmLQAzjNFezQM@vger.kernel.org
X-Gm-Message-State: APuU4Z8jwsbdWYEv9gzWO1PU+8k84bnHBtNCxzijfnoOW76gHZfMjLFn
	hibzpiCUozdRsIYeya89K7cYZb0RW3Ll/nvujaL85Bhy8/mGBVEL7P7acyZWCIDS1O5DdlCDn/J
	TCnaGuT9zTq8SV27zU8EvcJVjIbZOfZEdjlWNj+iRoN0nxb5TS9zyPqhJkJQM0Q==
X-Gm-Gg: AZFdTZfboEH3rmqGgxyPRF7WNul2N7pO5HK0KqdaKd6W2B60Sy/ZBu0ZRYRj3CsqTXm
	CRxaK1TvOEwwK1jSRIY9ytwmmC2wafNhECHTg5fQrQ5DORSgrqLjfNKsyBoB5b9l2OuP8etNWjv
	f7tgK8t7GZ+9RYGZhL8t4GfJ8T998fYFRGu3XBzMuIfc9Yz3xcNRSGGvZsvqSWbXP3VUni2tyep
	wKU78UNozH2YviSgRmTYJ8p2v06aAH3RmLx+TSdaPCRutbiKVXRxld5tibXEQmTomxBXN1DbgSM
	Nn8LbcLEKK9nAadkPTOlq9Tv57kC1jHORrvOQ8cAocf21oFcvrERXQDgDmpH7Wp63wly3l3Tu/X
	orMtb721Ona8zCOcpA+l4f3fxGOxTFvemY3k/RxjlfoM3h1VSVvyN50UHzfw3VZrH+R3Aae7cq3
	jI8thf
X-Received: by 2002:a05:6512:251f:b0:5bf:e540:85e6 with SMTP id 2adb3069b0e04-5c1bc80fc24mr2490865e87.24.1795349076681;
        Sun, 22 Nov 2026 04:04:36 -0800 (PST)
X-Received: by 2002:a05:6512:251f:b0:5bf:e540:85e6 with SMTP id 2adb3069b0e04-5c1bc80fc24mr2490845e87.24.1795349076163;
        Sun, 22 Nov 2026 04:04:36 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd017803sm2088742e87.38.2026.11.22.04.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 04:04:35 -0800 (PST)
Message-ID: <ab91c700-311c-4bd5-8d8e-d90d573f57c0@redhat.com>
Date: Sun, 22 Nov 2026 14:04:34 +0200
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>, jgg@nvidia.com, leonro@nvidia.com,
 airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 Patchwork <patchwork@emeril.freedesktop.org>, SeongJae Park <sj@kernel.org>,
 thomas.hellstrom@linux.intel.com, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/22/26 11:52, Andrew Morton wrote:

> On Sun, 22 Nov 2026 07:55:37 +0200 Mika Penttilä <mpenttil@redhat.com> wrote:
>
>>> So it accidentally found a bug in lib/test_hmm.c on the way.  "The QEMU
>>> run exposed a real test_hmm bug: a second open of /dev/hmm_dmirror0 can
>>> put a device-private page into its page table, then dmirror_do_read()
>>> tries to copy from that non-CPU-accessible page and oopses".  I'll prep
>>> a fix for that separately.
>> I noticed that also and will make changes around it in my series.
> I came up with the below.  It all tested out OK.  wdyt?  I guess it
> should have cc:stable>
>
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib/test_hmm: use backing pages for device-private mirror faults
> Date: Sat, 21 Nov 2026 17:06:45 -0800
>
> When one hmm_dmirror descriptor migrates memory to device-private and a
> second descriptor reads it, dmirror_do_fault() stores the device page in
> the second descriptor's page table.  dmirror_do_read() then passes that
> page to memcpy_from_page(), which can oops the kernel.  This was
> reproduced with an unprivileged process using the fake device in a QEMU
> guest.
>
> Store the corresponding RAM backing page instead.  For a large device
> folio, retain the subpage offset when selecting the backing page; using
> the backing folio's head for every entry would return the wrong data. 
> Extend the existing PMD migration selftest to read the last subpage
> through a second open before faulting the memory back to RAM.
>
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> ---
> tl;dr: The unpatched kernel oopsed when an unprivileged process opened the
> fake HMM device twice, migrated an anonymous 2 MB PMD to device-private
> memory through one descriptor, then accessed its last page through the
> other.  The patched kernel returned the expected bytes on all three ioctl
> paths.
>
> A was reproduced and saved before B was built.  As uid 65534, a static
> userspace program verified that all 512 pages were device-private PMD
> entries.  A READ of the last page through the second descriptor produced a
> KASAN-enabled kernel Oops in dmirror_do_read().  Independent A boots also
> oopsed on WRITE and READ_UNLOCKED at the same last-page access.
>
> With only this patch added, READ and READ_UNLOCKED returned the expected
> 0x0a byte, and WRITE returned the expected 0xa5 byte after migration back
> to RAM.  The modified in-tree hmm_device_private.migrate_anon_huge_fault
> selftest also passed (1/1).
>
> This reproduces a userspace-triggered kernel Oops in the fake HMM device
> used by test_hmm; it does not establish reachability through physical GPU
> hardware.  QEMU guests used matching kernel configurations with
> CONFIG_TEST_HMM=y and KASAN.  The guest device permissions were set for
> uid 65534.
>
>  lib/test_hmm.c                         |    7 +++++++
>  tools/testing/selftests/mm/hmm-tests.c |   14 ++++++++++++++
>  2 files changed, 21 insertions(+)
>
> --- a/lib/test_hmm.c~lib-test_hmm-use-backing-pages-for-device-private-mirror-faults
> +++ a/lib/test_hmm.c
> @@ -292,6 +292,13 @@ static int dmirror_do_fault(struct dmirr
>  		page = hmm_pfn_to_page(*pfns);
>  		WARN_ON(!page);
>  
> +		if (is_device_private_page(page)) {
> +			struct folio *folio = page_folio(page);
> +			struct page *backing = BACKING_PAGE(&folio->page);
> +
> +			page = folio_page(page_folio(backing),
> +					  folio_page_idx(folio, page));
> +		}
>  		entry = page;
>  		if (*pfns & HMM_PFN_WRITE)

I have this same chunk. I think it's needed, all dmirror readers expect to
copy_to_user() from pt.


>  			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
> --- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-use-backing-pages-for-device-private-mirror-faults
> +++ a/tools/testing/selftests/mm/hmm-tests.c
> @@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	void *old_ptr;
>  	void *map;
>  	int pagemap_fd;
> +	int fd2 = -1;
>  	int *ptr;
>  	int ret;
>  
> @@ -2143,12 +2144,25 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  		}
>  
>  		close(pagemap_fd);
> +
> +		/* A second open must read the last device-private subpage. */
> +		fd2 = hmm_open(variant->device_number);
> +		ASSERT_GE(fd2, 0);
> +		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
> +		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> +		buffer->ptr = map;
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, 1);
> +		ASSERT_EQ(*(int *)buffer->mirror,
> +			  (npages - 1) * self->page_size / sizeof(int));
>  	}
>  
>  	/* Fault pages back to system memory and check them. */
>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
>  
> +	if (fd2 >= 0)
> +		ASSERT_EQ(close(fd2), 0);
>  	buffer->ptr = old_ptr;
>  	hmm_buffer_free(buffer);
>  }
> _

Looks good to me also!

--Mika

