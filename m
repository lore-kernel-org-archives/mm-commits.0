Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795369038;
	b=beq8sXABQWmFLO+avVOyZDxn0OniYRrbowzMxIJgd1kQ2EkwXIzuECnFkGiEkm48Qv2W
	 faQQnqAoLLl/0tChBMwH6nA9EbMz2nac1SuQGEEkvSXz7BSkShNAmZJdz5fPQJeBbSz/v
	 /T8Dbo4X7okkNRMqAyf3kWLaWsk4fzItDkaf1DHEr+GoXNh+dZnyR7omdJfP0QKJLKayB
	 YoVV5PFfhSolUoZCC5ejGzZuRm1mpJyor/UDtSDjS4AS/MOSNcHgJruaP7aninTGWo3+O
	 5B6Ho/dbrqJ13b4nIxprOfiFE3g25N08AvDNH6SsiEX9WDSLh7XZdq0/+QeVEyl1WXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369038;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=3khkEbh3+4+UW9EqZNzFj2fkzRmCDGkNMhSbTs+zklo=;
	b=eJ15Qe1kJPXtoa5vIWnAZHlIvfc3EVzYv8npYd1D0IoAscH3lXLIcpI88U2UOfQ1LUiq
	 a/3ERZpwGqlZCf1ru5XWrz4P3EFMHJEEbA3Fa7TiuQiyItRpv1WQ42HEpmeeUgMM5op3s
	 lkNHixVxPJiJMoroy3rjX9QmHewqEWyLoI9EBZL7pOEDEQ5KawdKI+nmqHaKhN7hl3TbU
	 9exwn/7FACzKhL6A0/In9AriyImu0EJX5pbzsnmeYDk7xpDUB+TSo6rQZ1pLnDzBv/RLZ
	 j3CCCAo3QQyidWJHC21knWwrLYxAvp+veHAnIaMFqXqUfl1MczklsKL4XNboRhozvew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ijxLbAOa;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=FoQRkz3K;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5074606A32C
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 17:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5074606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ijxLbAOa;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=FoQRkz3K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795369036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3khkEbh3+4+UW9EqZNzFj2fkzRmCDGkNMhSbTs+zklo=;
	b=ijxLbAOayjsBBW6egURZWzzAOE/yP9cp5E94apNRkiY3hBLG1pqO+lRROovHmAt3GMAKKN
	TrsjWo6atYWxbBLtcSG0zAIwsMWR5NdIiKrmq2owByX50p7MPof1Tc5AOZ6CVSW3dUcRd6
	sHWiY+vxcxur8WVuOEMBtgjgNr2ybwA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-zLqQO4YtNRafXkEsSDs7fw-1; Sun, 22 Nov 2026 17:37:14 +0000
X-MC-Unique: zLqQO4YtNRafXkEsSDs7fw-1
X-Mimecast-MFC-AGG-ID: zLqQO4YtNRafXkEsSDs7fw_1795369033
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4bb64c99bb8so19353415e9.1
        for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 09:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795369033; x=1795973833; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3khkEbh3+4+UW9EqZNzFj2fkzRmCDGkNMhSbTs+zklo=;
        b=FoQRkz3KiyygfRoJRpnuz8MXfhTy13jYj69k+CVlAV91OuRPKz4th4G6pslrJ0EQIq
         Uw4whkiS7t+GQUXHTrNVX+XwCHyEVOtPc7cQPH+sg67vzMKCNkmxOX9t5vbGL4yk6DgM
         kaTPNLV3zg8N/lKpN8Flt06rSZPH4SaAqPjDZJzMU+niPUzxV8oSR0M+12OJqafNMH9l
         Fh261UXkVZjPP1YSO86ugCDWanY27zx7GfgB1qVGv7WZUS2LZV55oG9pLpyqbTR8UEwu
         1XytZkcrTob/I53e3u73IqTYIaOvYkF/QcsEhNzMPA/rAul0BS3zpFOHvkwFh/fmKfVg
         VoNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795369033; x=1795973833;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3khkEbh3+4+UW9EqZNzFj2fkzRmCDGkNMhSbTs+zklo=;
        b=g4dGILOxQpmW1NTDYhru4IpkNDQb5e1qxG0BzgudCogsHn8iWIrk9vfCkP4CfCBuNa
         AAP3CkG7RqwFl1rW3vfrpDRjd6dql9aTlXPUk47cEGyF/TO6sEtc0P5Q4KvcEf0Q7yVR
         Mdpz4y/o791FvZCjU4AF8drevqt2npyXAR9LQXwrOWhZDs1y0Q1NNIuMca1W7L3ekP77
         SCsAODXGPKYyEOfn6gUUOG2e3Q9gqA7EacpHjfnan8NCZ/g69q6LV/CUTvuJXXsoB/oe
         jYSD7mACiGo7Kz5D32sm6mIG6sA6kj6lCgBG7PGKFo3pVrLS8gq+dFv444qyK8e2AsRj
         SODw==
X-Forwarded-Encrypted: i=1; AL+hErGIcyp7FC+aC1OeU8PjMJRRH+RhKEhyepKogmfH9jcg+QfHqjhymq61g0/yqcX9Yy/AmP39taFVIAJO@vger.kernel.org
X-Gm-Message-State: APuU4Z91vOrqG4SjqA8SyVz7IS3Y1XAZk7VTbns8cp0Ie/UukHNB5Q97
	rWYSp0D98rG0MqrBveDKky9Ez7bE6sU8kvy3FhyHyV9WPJFFFIpjaJlWLRY7wXUF7Z2gvCnIxQE
	fMfCkTuu+PJAF3Zd7qnloqq4MyhyNpfy9+eLhJul/Ai/PemG/CGtgWyeaZRcVlw==
X-Gm-Gg: AZFdTZddrExb1vByblGdRjll3hANjzZ3XrXqN2F3NFVqBKq8+LbwUdQ2sQO4syxuUt5
	Su2GcT6KAU2Rm1v4MPPr9YyAVw5Qf2f3Jkl4Ud4mE0CFVwdaCFWVI94eAQG+5YjZurla3E7p1eg
	bOTdFZo+bxGJR/hkVGYHQb18C28erqNvJxY+00pDRey4iWAFJNrMRklDFFBcO4j0ulevtn7dQSL
	h7o1bWHVaVGGvgcfpr4QKUDSx8Iju2xsScUiP5h3CRDAoEA9GJso+p+gXNjk3X2bsdURWxz9pRX
	G2H0aFghp2yL6mCoFXNmYzk6uQiMvGLSQrYIGix7n9rVxlTPlUnWSN22s765VMCcW73evFX4mmi
	ME8xGss6B3UwQvXony2/s9ShQBMmM5b6vpajztD43iD4ElMTY6/HleoJ6Sy5AhY0EOPRcsLGRwa
	1zBxJT
X-Received: by 2002:a05:600c:674f:b0:4bb:56bb:1196 with SMTP id 5b1f17b1804b1-4bb8880fb9bmr195004125e9.23.1795369033352;
        Sun, 22 Nov 2026 09:37:13 -0800 (PST)
X-Received: by 2002:a05:600c:674f:b0:4bb:56bb:1196 with SMTP id 5b1f17b1804b1-4bb8880fb9bmr195003715e9.23.1795369032886;
        Sun, 22 Nov 2026 09:37:12 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm114828375e9.2.2026.11.22.09.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 09:37:12 -0800 (PST)
Message-ID: <2f60e148-f9ea-4b48-b8b9-3c524b6a8a2d@redhat.com>
Date: Sun, 22 Nov 2026 19:37:09 +0200
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
Cc: Aveline Noir <jm5905938@gmail.com>, airlied@gmail.com,
 apopple@nvidia.com, balbirs@nvidia.com, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, jgg@nvidia.com,
 jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 Patchwork <patchwork@emeril.freedesktop.org>, Shuah Khan <shuah@kernel.org>,
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com,
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
 <179535872126.34.4789080961796247940.b4-reply@b4>
 <af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
 <20261122091419.f82e88761dbd12771fb6c976@linux-foundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20261122091419.f82e88761dbd12771fb6c976@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/22/26 19:14, Andrew Morton wrote:
> On Sun, 22 Nov 2026 18:41:39 +0200 Mika Penttilä <mpenttil@redhat.com> wrote:
>
>> On 11/22/26 16:45, Aveline Noir wrote:
>>
>>> Hi Andrew,
>>>
>>> On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:
>>>
>>>> Store the corresponding RAM backing page instead.
>>> This avoids the oops on the first read through the second descriptor,
>>> but leaves a stale backing page pointer after CPU faultback.
>>>
>>> Since the mirror XArray entries don't take a page reference, they rely
>>> on invalidation.  When the CPU later faults the page back to RAM,
>>> dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
>>> mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
>>> migrating descriptor's entry before the backing folio is freed.  The
>>> second descriptor still points to that freed backing page.
>>>
>>> Reading the same page again through the second descriptor in QEMU
>>> triggers a KASAN use-after-free in dmirror_do_read(), and the read
>>> returns the stale data instead of what the CPU wrote.
>> I think this is right, but a fairly artificial scenario: it needs two
>> descriptors open on the same test device in one test, a migration through one,
>> a read through the other, a CPU fault back, and then another read through
>> the second descriptor..
>>
>> The fix lets the device private page content be read without an oops
>> in the context of one fd which is an improvement. 
> May as well fix it.  I'll test this updated version.
>
> Mika, please feel free to take this over, perhaps integrate it (or
> something like it) into whatever you've got going on?  Or not, let me
> know ;)

I can handle it in the context where it made difference for me.

>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib/test_hmm: invalidate all mirrors on device-private migration
> Date: Sun, 22 Nov 2026 08:53:12 -0800
>
> When one open of the fake HMM device migrates a folio to device-private
> memory, a second open can fault the same address into its mirror page
> table. The second mirror then stores the inaccessible device page, which
> can oops the kernel when dmirror_do_read() copies from it. Store the
> corresponding RAM backing subpage instead.
>
> That conversion also makes the backing page's lifetime significant to
> the second mirror. migrate_vma_setup() notifies all mirrors before CPU
> faultback, but dmirror_interval_invalidate() skips the notification for
> every open on the same device. The faulting open clears only its own
> XArray entry. The other open can read or write the backing page after
> migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
> and stale data through the second open.
>
> Handle migration invalidation for every mirror under its mutex. This
> clears pointers before faultback can free the backing pages and waits
> for an active mirror read or write. During system-to-device migration,
> the migrating open installs new entries after migration; other opens
> refault on their next access. Remove the now redundant XArray erase
> from the faultback copy loop.
>
> Extend the PMD migration selftest to read its last device-private
> subpage through a second open, then fault it back to RAM, change it,
> and read the new value through that open. The trigger is available to
> a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
> enabled; it does not depend on physical GPU hardware.
>
> Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org
> Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-reply@b4
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Aveline Noir <jm5905938@gmail.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
>
>  lib/test_hmm.c                         |   20 +++++++-----------
>  tools/testing/selftests/mm/hmm-tests.c |   25 +++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 12 deletions(-)
>
> --- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
> +++ a/lib/test_hmm.c
> @@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
>  		page = hmm_pfn_to_page(*pfns);
>  		WARN_ON(!page);
>  
> +		if (is_device_private_page(page)) {
> +			struct folio *folio = page_folio(page);
> +
> +			page = BACKING_PAGE(&folio->page) +
> +				folio_page_idx(folio, page);
> +		}
>  		entry = page;
>  		if (*pfns & HMM_PFN_WRITE)
>  			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
> @@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
>  {
>  	struct dmirror *dmirror = container_of(mni, struct dmirror, notifier);
>  
> -	/*
> -	 * Ignore invalidation callbacks for device private pages since
> -	 * the invalidation is handled as part of the migration process.
> -	 */
> -	if (range->event == MMU_NOTIFY_MIGRATE &&
> -	    range->owner == dmirror->mdevice)
> -		return true;
> -
>  	if (mmu_notifier_range_blockable(range))
>  		mutex_lock(&dmirror->mutex);
>  	else if (!mutex_trylock(&dmirror->mutex))
> @@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
>  
>  			src_page = pfn_to_page(page_to_pfn(spage) + i);
>  
> -			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
>  			addr += PAGE_SIZE;
>  			copy_highpage(dst_page, src_page);
>  		}
> @@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
>  	}
>  	migrate_vma_pages(&args);
>  	/*
> -	 * No device finalize step is needed since
> -	 * dmirror_devmem_fault_alloc_and_copy() will have already
> -	 * invalidated the device page table.
> +	 * The migration notifier has invalidated all mirror page tables
> +	 * before the backing pages can be freed.
>  	 */
>  	migrate_vma_finalize(&args);
>  err:
> --- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
> +++ a/tools/testing/selftests/mm/hmm-tests.c
> @@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	void *old_ptr;
>  	void *map;
>  	int pagemap_fd;
> +	int fd2 = -1;
>  	int *ptr;
>  	int ret;
>  
> @@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  		}
>  
>  		close(pagemap_fd);
> +
> +		/* Read a device-private subpage through another open. */
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
> +	if (fd2 >= 0) {
> +		/* This open must not retain the freed device backing page. */
> +		ptr[(npages - 1) * self->page_size / sizeof(*ptr)] = -1;
> +		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
> +		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> +		buffer->ptr = map;
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, 1);
> +		ASSERT_EQ(buffer->faults, 1);
> +		ASSERT_EQ(*(int *)buffer->mirror, -1);
> +		ASSERT_EQ(close(fd2), 0);
> +	}
> +
>  	buffer->ptr = old_ptr;
>  	hmm_buffer_free(buffer);
>  }
> _

--Mika

