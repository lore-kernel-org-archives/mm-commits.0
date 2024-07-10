Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD264C6B
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 02:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720578270; cv=none; b=KBzvrW/+2C6QQ6nxBJEC1HHYU7Ez7rwvaDITydVkPaEEbDdue1ok3w8EA4SHc8NYC5RA2f3VWLzGJU5WoGfRHfkwF0NkOherj/1KXAWCCj0/B5+n+hDsJTk3PVhQW7Tp1RpHyxUJl3YefauIGihq6BF4WVGlA0yBHX2JvFLeHNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720578270; c=relaxed/simple;
	bh=NTDVxFpLlAoXB9h/nK/rAw7b8gA7Fy7/eULyEpMMWFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ScInAZeZmSiNBrMFmPHeH1pfcCzwrXY/BT515LZi9SmaVqXIcea1CQsxWDWYNO6fbeTm/wpqjq5Rt2nRhkErUsOWXYwxjmZGzHm3htaVYUjY5vcPL2dxmwpaqZgE0b27S20OY8tSwE2cHwWI7SYsmPDHYj4epWwgEqK+5uX2Ub0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XM9MnHaV; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XM9MnHaV"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fb72eb3143so2522805ad.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Jul 2024 19:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720578268; x=1721183068; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HiOWRgn23Q0BBDT5LcU+amOiGEDDTEkspIzu0tn8Yzs=;
        b=XM9MnHaVWo7xCwEcGknUSCjKCWplsvIwGJ5VjpFSn2ajhKPz6OPKUt3+230XCXHGFy
         RTjmjR2JI2zuebuMp8Mn2DR/klzotut1D9/n/F1qF0K+FiHO/bVUjkCfi4I/n0PcHXWl
         vzaRQBsXfnsaEgDGjqR8wdIwsWgcy5ZFg9zsRbVVK4UCPIRNVL2epIdpyfc3sXqxvv9p
         T11qvJhaUg5TfYm3axu88PP0MlAUcoPwP39+yT0uMpsV6TcNa/wadOL3vHRDi0/JOJ4L
         mrNcd1DmPtjQIWzJyESDGnfOkEd7XEU9kFrFxd1qd0x8S5IRNofCVZXw9DTNh3n+QdRI
         fbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720578268; x=1721183068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HiOWRgn23Q0BBDT5LcU+amOiGEDDTEkspIzu0tn8Yzs=;
        b=iRCFWqxI2cLrpj/WkkQuAMd5EE0bplW6LswJ78adDYxr/88Kxx5W25DhEtQ5p12sum
         ouGEeJbsrb1uVoRFH41k70i42ly7mH4YG34oqTQNHuXfM3l3a3rJ7rejpyGqsQRAzZiL
         Mu0hEOgu7hCoeS7+0Hl6SYbmiN8rUasvcPUnVh4qhAeme5XjtuOnpjYh0k3VA7flvAUT
         SanfIi/WuqrFgiN+N/xSm1tgsYO+9iyLwZ16gw6ThMH7lL3edB/S+E+xiVujmn9dQMVf
         imzUQh+VkcYZy85llBjm7vYVEM68kao2N/M8v6fR9nqZnWj6zGZpXnoAhGAJPFuSefx5
         5sdw==
X-Forwarded-Encrypted: i=1; AJvYcCVqL0AnjheHOqxNG1iY2/NwsSR1yPnTLcxh+VbX5/R+sVF84o7RQb8fmDtKyzgOITG4TfDihjpCB25zehsZaG0FM/Jt/L/N7cn4CA==
X-Gm-Message-State: AOJu0Yz0gvSON3yZ+Ay1zTZ3hpYas2dVlyeomiyy+DuXW4861PVdhu7H
	i+hzosv9F63j/eEOTiSnlS/flJpefQwgv8joyvuUPCj/GkGTu2/W
X-Google-Smtp-Source: AGHT+IHEIi0QDwfABAGpcUEr0THSgkApWGvpn1ixCM3ZQ2O/tsJw/gEP6j0/W4ZOL2ZoAZJDZ9Z+Gw==
X-Received: by 2002:a17:902:d488:b0:1f9:a69d:4e05 with SMTP id d9443c01a7336-1fbb7fe5a5amr54321595ad.19.1720578267764;
        Tue, 09 Jul 2024 19:24:27 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6ac1625sm22489335ad.217.2024.07.09.19.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 19:24:27 -0700 (PDT)
Message-ID: <8861d515-3759-4f3d-b0ed-aff974a83d44@gmail.com>
Date: Wed, 10 Jul 2024 10:24:23 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
To: Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 pasha.tatashin@soleen.com, keescook@chromium.org, hannes@cmpxchg.org,
 alexs@kernel.org
References: <20240708214255.9F454C116B1@smtp.kernel.org>
 <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
 <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com>
 <CAJuCfpFqVf=-e0b1ZbdY+7y5uuA7P267Z8AQ22wj7pRBMFSdYg@mail.gmail.com>
 <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com>
 <d1c603d0-6d6b-42c4-a690-a6647131998b@suse.cz>
 <CAJuCfpFQc2PLu-PzzKCLDYFbSDsrVeJzgLk7nDZqp6+ye-bLow@mail.gmail.com>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <CAJuCfpFQc2PLu-PzzKCLDYFbSDsrVeJzgLk7nDZqp6+ye-bLow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/9/24 10:54 PM, Suren Baghdasaryan wrote:
> On Tue, Jul 9, 2024 at 2:17 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>>>>> Hi Suren,
>>>>>
>>>>> Thanks a lot for point out the problem!
>>>>> Now I understand why we put page/folio.memcg_data under CONFIG_SLAB_OBJ_EXT.
>>>>> We need the memcg_data member only for SLAB_MATCH(memcg_data, obj_exts), even
>>>>> no CONFIG_MEMCG, isn't it?
>>>>>
>>>>> So for the config logical and SLAB_MATCH needs, could we keep this patch
>>>>> with a fix like the following? The match only checked with both configs
>>>>> enabled.
>>>>
>>>> No. The point of that check is to enforce that slab.obj_exts always
>>>> matches page.memcg_data / folio.memcg_data (enforcing the same layout
>>>> for slab, page and folio structs). Consider your original change when
>>>> CONFIG_MEM_ALLOC_PROFILING=y && CONFIG_MEMCG=n. slab.obj_exts exists
>>>> but page.memcg_data does not, so layouts of these structs do not
>>>> match. By adding the change you are suggesting below you simply avoid
>>>> the check that warns you about this mismatch. So, you are not fixing
>>>> the problem, just removing the safety checks that would correctly
>>>> complain about it.
>>>>
>>>
>>> Hi Suren,
>>>
>>> Thanks for reply!
>>> But what's the point of 2 members match each other in different struct?
> 
> "struct slab" is a "struct page" in disguise :)
> 
>>> Is there any problem w/o the match checking on CONFIG_MEM_ALLOC_PROFILING=y
>>> && CONFIG_MEMCG=n?
>>>
>>> No, the kernel works well under my test with MEM_ALLOC_PROFILING/MEMCG/KASAN
>>> random combined.
>>
>> I'm guessing it works only by luck thanks to _struct_page_alignment.
> 
> Agree.
> 
>> Once you keep obj_exts in struct slab, but remove memcg_data in struct
>> page/folio, it could (on 64bit) result in struct page/folio being 56 bytes,
>> and struct slab being 64 bytes, and then this will fail:
>>
>> static_assert(sizeof(struct slab) <= sizeof(struct page));
>>
>> _struct_page_alignment might fix it up silently, but only with
>> CONFIG_HAVE_ALIGNED_STRUCT_PAGE.
>>
>> We could maybe make it more obvious like this? for page/folio
>>
>> #ifdef CONFIG_MEMCG
>>         unsigned long memcg_data;
>> #elif defined(CONFIG_SLAB_OBJ_EXT)
>>         unsigned long _unused_slab_obj_ext;
>> #endif
>>
>> And adjusting SLAB_MATCH() assertions accordingly. As a result it will stop
>> exposing the unused memcg_data field in page/folio with !CONFIG_MEMCG &&
>> CONFIG_MEM_ALLOC_PROFILING.

Hi Suren & Vlastimil,

Thanks a lot for comments! I will follow your suggestion to update the patch.
But there are another issue related to the problem, in Suren's patch, make the
MEMCG select SLAB_OBJ_EXT? why memcg needs this? I checked the mm/memcontrol.c
seems should work with !SLAB_OBJ_EXT. 

Thanks
Alex

diff --git a/init/Kconfig b/init/Kconfig
index 26bf8bb0a7ce..61e43ac9fe75 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -965,7 +965,6 @@ config MEMCG
        bool "Memory controller"
        select PAGE_COUNTER
        select EVENTFD
-       select SLAB_OBJ_EXT
        help
          Provides control over the memory footprint of tasks in a cgroup.
 
