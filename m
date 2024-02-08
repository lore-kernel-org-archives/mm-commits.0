Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B4D67C70
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707374661; cv=none; b=ppOZM1vbmgSMQfxNs0qDIcajTYNRLKUaE/e7ANFEufxQ8lJx0v58/TC0jNwVvZQM3BnEkX+VK+XzFZpI7s6wsWwlqWFgUmAVYDwSrcT1/RoMzT71Iib7smFtpsRg5oOm9LW28pXj//Uhuid/5I2gis0AA0dwki3KJI273BMSRL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707374661; c=relaxed/simple;
	bh=mfTsflgWRUVHEmsfkMYCWKIP5S6Qp0VCKEzbBB9eG+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjm7AvFqvAo263229aTrP3eTKpcf3Pm9PlZmVU9nWYD1hFXMl7NMdqMkYAFTKxoY0euQfSz01Z7sDgL6u81lewTu8/pmdYBlTTAQJQKwsGjZfN+jy2w47046NLBNSj670oUyDU47wWnzMqtW/biLeWGMaQ1M8HNurOs0OP3FLYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=baIgBusW; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="baIgBusW"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-55f279dca99so2148283a12.3
        for <mm-commits@vger.kernel.org>; Wed, 07 Feb 2024 22:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1707374656; x=1707979456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fSYJax6p0xEXNxJ7Lof15/Ar6n2hqhmaTbNbh0ZRO68=;
        b=baIgBusWE1vgfRmhU1JB0M/12L5czqFOIlvpa3I0VjD+Q0wgSmXU82OzmXIktRcyO/
         g89RN90R2PPH5LnhhTDas+wZvhT6t7McuFpDW5miSlttZKCWVAEaA8HS4TW2EEJGGgAx
         UvpLexjGzzCnyS5qkC90mqj+S/k8tj8Ee4l3jVQ3X4qX1bjisy68/rLofvZGvp1gprd0
         sQ6jAaJLuFMv8cIa1ZujeF8y8ta3D5XGbdnuQFQuTdZOvqDwT5U1FQj+uqgYOLa0Tmmz
         rm84c9JNFm4PFCCXThhY4rIVvXFhdZsh7vo+FauA0SA0gdkRLUD2n8xxUeWFRf+n7qS7
         nPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707374656; x=1707979456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSYJax6p0xEXNxJ7Lof15/Ar6n2hqhmaTbNbh0ZRO68=;
        b=EA8BeLxI0PIGE8ydnzbZ8LgnRsGEUVJbSf1fY5vaxMuwbvVMZpFkY2jemz3kJQUlSB
         0qQ8EqwVv9h6L+xJqkjh0OQP7n8Mhrw2TVxEs4ux9aAUo8EFPeQN1NMTJXz6degL25kh
         A6qx9HQDK3iImqNUDppX7DT1h447225UrPv9lPcnyAGjq9fRV3khyn9O4KyRWGwZUQBW
         UgNuSLsd9HyK+qBseInnZYAe4u1puaEoEnpVvoet1EvAWADOmStO0Ucvjviwzjak13SQ
         oMUEACAnJPQc4TTfVrMKHR5JVgg157IJUqTTesST8e/4J4ZMJPrF2HPXe4ZoHzUYL8k+
         k41g==
X-Forwarded-Encrypted: i=1; AJvYcCXdfQ6R8c8IeJqYQYbndVnQjuuQ9nt81kqv1e04wFornZEPzZXEMtIhB104/XncjDh+gnzdxtUbfBoPcIe6ppU+1CMm0j53DFCM9w==
X-Gm-Message-State: AOJu0Yzo/fjUC2+XzNcYqnfXNEgJOUocT780ozb0CD16hm3OEVahMtFO
	2w9JNM4FgJWiGRKfG199aKqlBBE2WkkkY8ePNOGLO2OwnlfoITa9YsHuV71Z5TM=
X-Google-Smtp-Source: AGHT+IFhiQCeMMpzHdSnqi3Gu/04v9CV6BXRy99Hx+0vrF+23u38K67DtEgbu6xCSUW9s/TfyyaFiQ==
X-Received: by 2002:aa7:c6d4:0:b0:55f:fe4e:1f17 with SMTP id b20-20020aa7c6d4000000b0055ffe4e1f17mr5907213eds.7.1707374656612;
        Wed, 07 Feb 2024 22:44:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV3h15MZtJpW1wFhpmtuMKttqYVmRdrUtJ0UnEBMjMcR/JjE0D5mAic6a7sQrMvbueZdzpg1t17bmGio0naEp99RCBBFZE20QvfghJ2LDNBLiR7CrakbNS6j5qyRfLRc9CgEUddYM8a0QrKOxB/q5XkYurO6HH+T0p4crtIHfFPYX+bmnStyP1jw+4Jx1914EkBX4d45v5gedrdwULCA6h3qqu+MVZUvZofVmr0t6UbNYMBXbX7oBtpnZ8NN37ttRCMXI4pVaHATcq1pTGVUuna6I+fDJvIkrZHjX3THyZ+ZNj+DLyqYMR2Zz31N4j+wSIv1cegD3pBmrFTq2NLSYysaWwBEAOGOkE5/VLnmkkNAxFcwSp7RXJeE4KJ+FYDgtzPJ2/bUcs81C8zaKg0VwrHMxLKvMsjQ37PFjZ5iL3L5Y/wLxKGTrrMkjY/HoJP9pbLxVXoHByrk4WF8M/p6HZO6NpYykVxCyvdnmrsoXWbseOiHTywV0pVThcSnFfrun9ECNYekyc7agpHEQ7082widgJuR2yMmcLWJZ7a1uyFd5r8DLPZE+ZP0FSkxoJvr7iMkaiv/kBcZfbAooaCnJOFmgFdTu9fL7mMHEMULGYXESVjk9ZC7FocBpBtJCOAuFyPbFwsfw85YSS6nEc6L7tl3BG185cyHqHjP02WCCMYDEX7VSD6h6upb8oMPaliNd3ju4CWY9yOTRcCcATwztJw5DJgX4Ea+cwh+gLh2reWwWxE1lhneoQkXtiFOG+z9PZlyx0XhW5+GsZQuT+DqddJ
Received: from localhost ([2a02:8071:6401:180:f8f5:527f:9670:eba8])
        by smtp.gmail.com with ESMTPSA id c8-20020a0564021f8800b00560aad89f08sm505191edc.8.2024.02.07.22.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 22:44:16 -0800 (PST)
Date: Thu, 8 Feb 2024 07:44:11 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
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
Message-ID: <20240208064411.GE185687@cmpxchg.org>
References: <20240207231014.3A3F0C433C7@smtp.kernel.org>
 <20240208031413.GA185687@cmpxchg.org>
 <CAJD7tkbdzwjhhgK_-6iAHLn05Q-7wCOzEn9xug1Udr+Df-hLkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbdzwjhhgK_-6iAHLn05Q-7wCOzEn9xug1Udr+Df-hLkA@mail.gmail.com>

On Wed, Feb 07, 2024 at 07:27:34PM -0800, Yosry Ahmed wrote:
> > >
> > > Adds two new per-node fields, namely nr_page_metadata and
> > > nr_page_metadata_boot, to /sys/devices/system/node/nodeN/vmstat and a
> > > global PageMetadata field to /proc/meminfo.  This information can be used
> > > by users to see how much memory is being used by per-page metadata, which
> > > can vary depending on build configuration, machine architecture, and
> > > system use.
> >
> > /me wonders what page metadata is.
> >
> > > Per-page metadata is the amount of memory that Linux needs in order to
> > > manage memory at the page granularity.  The majority of such memory is
> > > used by "struct page" and "page_ext" data structures.
> >
> > The term for this in Linux MM is "memmap".
> >
> > That's what's used throughout the code, in Kconfig options, and it
> > shows up in the documentation as well. It's in the names of most files
> > and functions that adjust your new counters. The new name is
> > unnecessary, and frankly it's quite vague and nondescript.
> >
> > Also no reason to keep the stat name intentionally "open ended". As
> > became clear from the side discussions on MemTotal, all proposals to
> > change the semantics of counters later on will be nacked on the basis
> > of established user expectations. So just call it what it is now.
> 
> I am not closely following this series, but I just wanted to point out
> that this is not always true. We are actively extending
> NR_SECONDARY_PAGETABLE to add IOMMU page tables in addition to KVM
> page tables [1]. In that case as well, the name was left open-ended
> exactly for this purpose [2].

I think you're glossing over quite some nuance here.

Sure there might be highly specific scenarios where you can get away
with it. Like with a very recently introduced counter for somewhat
niche audiences, and bucketing/grouping that was IIRC planned from the
start. It's probably not reasonable to advocate nondescript interface
names as a strategy for getting out of ABI commitments.

My point was that "memmap" is the established term for what the author
describes. And that this concept is sufficiently first-class that
mixing it with other things later is unlikely to be acceptable. I
didn't know WHY a new name for this was chosen, so I provided
arguments for two motivations that I could think of, that's all.
