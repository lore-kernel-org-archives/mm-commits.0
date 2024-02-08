Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7681D524
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 03:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707362063; cv=none; b=aqh3hbzP4YDBLepvm+AVogzdK2UpT/B6EmYUXDpevNDBz8lG35XesDtmF5YeZarOu66Oyz6fz9lwXLpm1CWC5p0yaeXuEgAvdDxtQt52tt6SuAXAkPiekgjHNv0NfdILs+mHFZPtDkvQDcUe/vRDcaeqxprFoVMrSUbaCCDjZSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707362063; c=relaxed/simple;
	bh=2EKXeN0xMFL5tbNodU3s+q8FYkBKKv7qxx0Obe8JGLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P05rX8SzFuwwYReX0qWmVzpnUaG7npTaWtKQzpmkuAjwd/lSdNYLdXIvxYJsPVE5CjMxuld2S+VJBj3ADyJ2kAYecocakmARSxzAjtBzr/J9p9fvGpWhdrgBYwXuUX+f/Biy3/INtNsma1r93K8VZlUTjdWYkdE+dl7LVu2dIX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=hy2NCyLX; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="hy2NCyLX"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-560c696ccffso880129a12.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Feb 2024 19:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1707362059; x=1707966859; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WPUCoHEofFgg49g9U9KUN0vc9U/j5UvDYWJxEOF3QaE=;
        b=hy2NCyLXHw/1omYHTwAi4YNBLaQMQIMRF/YoJYTFa2wzQE/VY9hyeg66EiIvQTaOji
         YR0hoaIA+0FnqirAjDxtWtsvTrTxV6eWCJqE7s4kr+zNDdmY2+8mBWwIjbj++SPMzP/x
         DgTeBChiMe6Q/lpIyweEr0NkD34T9cQJhWWQI/FCYWv0UopPhJKU4RKG1WQJEwS/ebpG
         SHPjfFmb9hrW1Da+27kKh+cFRjq3a+VEw9BP3F9Y+E+uoCnDNgMn1hyK1NbPQWRYdPth
         1Va9XlVZAP4P5Fms4KnRBtweAFEqL72SnlJAC38j/Q4J4MoZmHkmHlp0G8wLVSbHhjc6
         t6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707362059; x=1707966859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPUCoHEofFgg49g9U9KUN0vc9U/j5UvDYWJxEOF3QaE=;
        b=kEQjA+IdfIQB2nNzp1I4DyP5TyvOz68LrdsGE5sJkohPciPxNkMtqXnGBy7fm0+C9W
         rd8gX7bso1PD7H+JJFmARHCpOH9UaMJEkWiqM8XHl9LwSfBb6eEDym6KwHI2Tf1fWL64
         gBcttkVKbTbqY8+erh7GN2EFWBBR4+1tyAdADR9EhzKt0B6xE+5RqeFoX8JOyneTQedD
         Y46vF2nokgv3RnNzC9FatODvj9w4ihySMM1jc9uu2kZ3WNrs2W5ySHTkVVufSRXHHoPQ
         s8pMXVwZ9qE6dYWDNbfa+TlpQSoIKgiydFPS+x1Y0kI9sjGv+lKIuTITEgVlYqNRJEFd
         tZuA==
X-Gm-Message-State: AOJu0Yy5h/D7RMB2YDfvP21bU89OJcFrsuUFWZqGY4aQbxyYMFTCj8Z6
	Pxihy56BognAeVj28S0ZltrgIPET6SYaQIflkUIt0jpJxGOQSL3l1iolBFphwdM=
X-Google-Smtp-Source: AGHT+IGQZcgdwZFXDDKQMcyiC0YMWd4qcYVgq0mM4yNhuGk+ExoemeEG+/s0Nr5h4zbY0mQgd+Qcmg==
X-Received: by 2002:a17:906:b853:b0:a38:5a98:3a8a with SMTP id ga19-20020a170906b85300b00a385a983a8amr1190077ejb.30.1707362058731;
        Wed, 07 Feb 2024 19:14:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX33J4iiuZKrH+Sqz+O5nDDL827PiAEdPSccSYlRUPUHeYa3N9NsV3ExgQ61HdYNP5jWBMgEGBlnQkTLCGHkzjk4exeslqzNF1qpJ8yI9WJacFqRlSyQ29dnODwoPc7Mh2lmExHaFcQL6fDvLLzwytpAsaMw9oN5dMJChfNLbNP4w0IgFvFlytnMlmvmx5pJJQ8qdvYkuzlVD71meejXMifnr7N09aiHs1eqe6nKjuD9dTLjPG+SUTDlOjrcBcfBfxwNoxo0thDPeDtRs1HQLtKyIM6od3MSI2XQq/1OxPnT4f90XNEml4eUZ8fqgpPuol/eXJb6KeqY/cuIwoX9YxCb0JPm13tC7f8yU9BWiudNxLONBBO19AerG7+C4auZzy7Jw1iX1R3kczHoDfks/Y+VEH2Mn2FOq7UqxoEUL+T5iP8hM+vFtbVXaoJ6tITLmIunY3v9YDBoV2nkrONYClAOGfRrc90OskiHMU2HF5xwUNK23hZE27ICrcBMJFZWzAEh5Dp6NfnotlKh6vuQKuvgUQk/YMU4W5q2fnBrITrgHdEBPG9hsAWxpwqT6WLvXRbUZfAs5MLOrdask3DFI/MpsOOE7iOHwYBpKJv5KDIV0yS1n4OAbzwWC+8EYqq0+/vg+c/YVs2Gv7qD/YkUio8zCyfBJyKTgTSFhgJt3AJa449OvENlIZP/yBqy4sQktVBXe9BylaXizN2wCkFehyriMtiA0Ceg97w9vYXG7DBpTSSSlahyamTnT4kvC4mFrIEqZp0sfJJmkYp/Q==
Received: from localhost ([2a02:8071:6401:180:f8f5:527f:9670:eba8])
        by smtp.gmail.com with ESMTPSA id ss11-20020a170907c00b00b00a3868b8e78dsm1431229ejc.52.2024.02.07.19.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 19:14:17 -0800 (PST)
Date: Thu, 8 Feb 2024 04:14:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com,
	yang.yang29@zte.com.cn, willy@infradead.org, weixugc@google.com,
	wangkefeng.wang@huawei.com, vbabka@suse.cz,
	tomas.mudrunka@gmail.com, surenb@google.com, shakeelb@google.com,
	rppt@kernel.org, rdunlap@infradead.org, rafael@kernel.org,
	pasha.tatashin@soleen.com, muchun.song@linux.dev,
	Liam.Howlett@oracle.com, kirill.shutemov@linux.intel.com,
	ivan@cloudflare.com, gregkh@linuxfoundation.org, david@redhat.com,
	corbet@lwn.net, chenlinxuan@uniontech.com, bhelgaas@google.com,
	adobriyan@gmail.com, souravpanda@google.com
Subject: Re: + mm-report-per-page-metadata-information.patch added to
 mm-unstable branch
Message-ID: <20240208031413.GA185687@cmpxchg.org>
References: <20240207231014.3A3F0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207231014.3A3F0C433C7@smtp.kernel.org>

On Wed, Feb 07, 2024 at 03:10:13PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: report per-page metadata information
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-report-per-page-metadata-information.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-report-per-page-metadata-information.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Sourav Panda <souravpanda@google.com>
> Subject: mm: report per-page metadata information
> Date: Mon, 29 Jan 2024 14:42:04 -0800
> 
> Adds two new per-node fields, namely nr_page_metadata and
> nr_page_metadata_boot, to /sys/devices/system/node/nodeN/vmstat and a
> global PageMetadata field to /proc/meminfo.  This information can be used
> by users to see how much memory is being used by per-page metadata, which
> can vary depending on build configuration, machine architecture, and
> system use.

/me wonders what page metadata is.

> Per-page metadata is the amount of memory that Linux needs in order to
> manage memory at the page granularity.  The majority of such memory is
> used by "struct page" and "page_ext" data structures.

The term for this in Linux MM is "memmap".

That's what's used throughout the code, in Kconfig options, and it
shows up in the documentation as well. It's in the names of most files
and functions that adjust your new counters. The new name is
unnecessary, and frankly it's quite vague and nondescript.

Also no reason to keep the stat name intentionally "open ended". As
became clear from the side discussions on MemTotal, all proposals to
change the semantics of counters later on will be nacked on the basis
of established user expectations. So just call it what it is now.

This should be NR_MEMMAP, nr_memmap, MemMap etc.
