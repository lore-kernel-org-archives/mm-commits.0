Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD38D364
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 00:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438348; cv=none; b=FtoWBrC+Fqo6PN4ki/g0DHv2s6BXM/LME+v4p1MsS6W1fJSso2IZc2bTAzGYVleM8Rv9KKo5CH1Ab0da4oEW6z+kqPsh67N4V32YMR4qWVI57Qp1//BFGgs27FKMneGBOhWatY6P/Vw2qW8r3hGoC+T1reGoAYEKu4vb7iWhPNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438348; c=relaxed/simple;
	bh=8NUBWAGSAANirPtmpV4sQhtKPKMk9NLbNWvJRPkJ5+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUH0A7OmNOyvcAShpztFq/bTlfbnwRS2YKo4+JWlgSNNvWx3+k2ToRQLZL2YCV2t3C5hAzAEhFROlLzAt+GpPD/vrO4qwCsaHUu4+LhNUucsd08v/X6zM+ZSbXrHREoVAA07Liv6xK5Pqhju2Fm2q3moYoZ+2uov/5DtD5NKLG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=vK54dfZM; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="vK54dfZM"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a293f2280c7so52778766b.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Feb 2024 16:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1707438344; x=1708043144; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0fYenfxvGpsgVBwiEZtBEWh+ELviNau/ByfTk/UkUxI=;
        b=vK54dfZMiUFbYJh3twA+UK08JXP3SMfvZKFDxmV0JZB0oun9yvzBMm7YYU9HmHsAZi
         e5rgW51J4G1O5vOn6nRTQD58MerPL1K6ln+9Qmg+efWnAP+ZfgJoqkNhir4RcwoEHccI
         8oMgJIKA8m6e/kMP8IlU/LOez76ELoCp/moVb8IMuu10XhlZO/tYXbLFOZFh317jWMhk
         pnlRrq3XVRAsbYozLyoMXuv8MZVFprdVqR8R3TOyG/uZvJJjymepfXbpuU/AmOYY4OX0
         vz6AR5eiy8uNfK+jRrcmy2GSaIGvRnoHu291ZW6MGwQ1mlL2Y05+R8L88I3agJyp24t/
         OuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707438344; x=1708043144;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0fYenfxvGpsgVBwiEZtBEWh+ELviNau/ByfTk/UkUxI=;
        b=fFxe2GSiYfp0j08GMKIopeLDScv5dETAYl58Va9B9776c/gaB36CHrcuK0UaSRi1qn
         TQ558fKeaq/QqucHthqwYiFlEplzm5KkOTBtK8t1w30riItIuluE02Os48NnWCKcRvbX
         4nlJjcHXKhnsVsRuT4s2vjn18qT1CHoXhfRk7VJ3Z/L3gfJm2NnCEKKAWJOsfFlc85Al
         I0lPYF300IaQW65Mk6WEBxuvCc8Aur+tYy1O42dWgPzNjWBYV0SUE0onCEZyJGXBO2l+
         OhVWCL73t+C7Wkx8GWAhFIZ3f6xIdQ0NQvDrmeQiurqbZd98tnR6uavnYvE8RvMYo2V/
         +YXA==
X-Gm-Message-State: AOJu0Yw5JQ3T+5C/dXM/fIAJqyyI36DwY+/2LMooJ4L4HrE7JrJMP3Jj
	iCPGkyh7O/5e7NLL5gY03cynxIBviTDx/MJqeNPJ2BqX7pUiTZTYiHL1G8D+XGo=
X-Google-Smtp-Source: AGHT+IGiyOKHBH4dk/sJlbzMjqu2aDBm+TKrrUrY4u20Bnmtg321YN8AU4zxf8wj/hdG2HthYKF/ng==
X-Received: by 2002:a17:906:260d:b0:a36:fd11:3f98 with SMTP id h13-20020a170906260d00b00a36fd113f98mr706138ejc.17.1707438343808;
        Thu, 08 Feb 2024 16:25:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVh3zpS92rjGhUp8j494HUTaSnuxhk1a8FqLlBRUfrex9CerQ+8zl4CeMhFQM39B7Rs6hwlyU4kTu7y8t1lgZ8aJbNfqVNViILY11U/v2rAXTLuU701CyUfMxpHdkepGDpWWEZLjPjg3N/gow7QkjfxgBIYjgpZyRPxtDXpFJQuBfRepkE+5iPyBWj0u7PKU9YcQWJY2Bbjh5JbqYADn0qY9xvi0mDGZh0qxZMaVDYaboc4rtmVgjSDUI2/xz9F5qGWcWO9tOR4bJjp+f3krFCx651flMZ2Nw4ALnPVRZV2SluZyyauzARu3r6KhAXKEaN9/SBNQFlHuEIU82eK7soW1OLzr0QQhUggFWUxdl9P+JvcGHLJ51oVAYwp3uD0p6hJ/GLXTJKQyNtn9efy+/aS6PrLkAJq01wSdijReZS/NgBvCFhTOrUWY5lMRZ905hXyKBYrkeEWI1o6X8ZXmElAZ840/uFvoBDATKIMLEv5uDSZFNxHB7vEbYFgg2N0xckqpLY/P70tc7EdmQGk99EGgFah/x9V/6eLMzQiGTucF/bn0OIDlGCZY8wrKHgYsY3jmjxsASil3O8vpZTGIkbLVCwQh1FTPomilmFgP8zzf1dkjCxOxT1QosC8p2cmPKS2s/7vAUchDJCFdjLK8b3K1VlFcYXy4/Jb3RCUYixXtpynHxe7NWHcoeoPbkj8ufDD5Q0J9lj6CMnpTwp03ZfRtBGXj04Pzg7MSsEHtILyewPn6nNaHRsdNSNPok3oOP6wctG7B11FYmtEZKnn2ahQ0CVq
Received: from localhost ([2a02:8071:6401:180:f8f5:527f:9670:eba8])
        by smtp.gmail.com with ESMTPSA id tl14-20020a170907c30e00b00a3bcfe76170sm210963ejc.2.2024.02.08.16.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 16:25:43 -0800 (PST)
Date: Fri, 9 Feb 2024 01:25:38 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wei Xu <weixugc@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
	willy@infradead.org, wangkefeng.wang@huawei.com, vbabka@suse.cz,
	tomas.mudrunka@gmail.com, surenb@google.com, shakeelb@google.com,
	rppt@kernel.org, rdunlap@infradead.org, rafael@kernel.org,
	muchun.song@linux.dev, Liam.Howlett@oracle.com,
	kirill.shutemov@linux.intel.com, ivan@cloudflare.com,
	gregkh@linuxfoundation.org, david@redhat.com, corbet@lwn.net,
	chenlinxuan@uniontech.com, bhelgaas@google.com, adobriyan@gmail.com,
	souravpanda@google.com
Subject: Re: + mm-report-per-page-metadata-information.patch added to
 mm-unstable branch
Message-ID: <20240209002538.GA896819@cmpxchg.org>
References: <20240207231014.3A3F0C433C7@smtp.kernel.org>
 <20240208031413.GA185687@cmpxchg.org>
 <CAJD7tkbdzwjhhgK_-6iAHLn05Q-7wCOzEn9xug1Udr+Df-hLkA@mail.gmail.com>
 <20240208064411.GE185687@cmpxchg.org>
 <CA+CK2bCxPVyB8ZVk3dA5TKROScNHMzdu_PkBTK9b3zStvgemDA@mail.gmail.com>
 <CAAPL-u-vmt9qx=E=tLq5NGQbam5i3WFqvuAepxzYMJ7EkRYgMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAPL-u-vmt9qx=E=tLq5NGQbam5i3WFqvuAepxzYMJ7EkRYgMA@mail.gmail.com>

On Thu, Feb 08, 2024 at 03:50:12PM -0800, Wei Xu wrote:
> On Thu, Feb 8, 2024 at 10:08 AM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > > > I am not closely following this series, but I just wanted to point out
> > > > that this is not always true. We are actively extending
> > > > NR_SECONDARY_PAGETABLE to add IOMMU page tables in addition to KVM
> > > > page tables [1]. In that case as well, the name was left open-ended
> > > > exactly for this purpose [2].
> > >
> > > I think you're glossing over quite some nuance here.
> > >
> > > Sure there might be highly specific scenarios where you can get away
> > > with it. Like with a very recently introduced counter for somewhat
> > > niche audiences, and bucketing/grouping that was IIRC planned from the
> > > start. It's probably not reasonable to advocate nondescript interface
> > > names as a strategy for getting out of ABI commitments.
> > >
> > > My point was that "memmap" is the established term for what the author
> > > describes. And that this concept is sufficiently first-class that
> > > mixing it with other things later is unlikely to be acceptable. I
> > > didn't know WHY a new name for this was chosen, so I provided
> > > arguments for two motivations that I could think of, that's all.
> >
> > Sure, we can rename it to NR_MEMMAP_BOOT / NR_MEMMAP. We picked
> > NR_PAGE_METADATA_BOOT/NR_PAGE_METADATA as we thought it was a clearer
> > choice. It directly conveys the concept of page metadata overhead,
> > eliminating ambiguity about future potential structures. Today, it is
> > "struct page", and "pag_ext", tomorrow memdesc and more.
> 
> Technically, page_ext is not part of memmap if we go by the kernel code, right?

From a user POV it's the same: the fixed linear overhead of mapping
out physical memory for kernel use. struct page is the build-time
component, struct page_ext is the boot-time component, but I'd say
that distinction is mostly just an implementation detail.

If between memdesc, folio, slab etc. struct page disappears entirely
some day, "memmap" remains a valid concept and a cost of interest.
