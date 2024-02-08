Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CFA1DA32
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 03:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707362895; cv=none; b=CCVV2xKTPCVcsFOXsVtYuYv2ArXCvqCuVgBEeHuFgVH55lPdo90H8w7OTg4o+KJLiyjuKQKF0iH42OmATuH4iMj+fZUWXTqgrcby6mUSHNErGNDxOdW2rcQj6HBzVREn5/UF340V6ekl7NegxyQ6FiRP0aumlE98FjeARBrAIyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707362895; c=relaxed/simple;
	bh=XdrvUKJNjf6y9QsVSeQNoswGJR3ih0OOZ2U9TB4RRpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8H9KVk0O3UyeXudcqWY8G1fO1Mlo6d/ACwlkN0P13uKWcxuCuhiHC8Qp30NGD2o/nfmHsu5+Uvea7bGKUYcN3usZExgZuqgutvY+aC35Q+91gmnzdy2E/1jLXnXV3Of14RyKTG/iTz8p1o/1ewC/nTr5U3FEGqrQZbmxuTfOeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3J5ZpVpv; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3J5ZpVpv"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a3884b1a441so141265166b.2
        for <mm-commits@vger.kernel.org>; Wed, 07 Feb 2024 19:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707362892; x=1707967692; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eZXmNtHO4LkMWMpNTISVnvudkaQG6foYazMdYkK3SdI=;
        b=3J5ZpVpvpbVkA0dpMlONqJXfvSqm1goJusATps2ecMrkCfTi70XomjC74iDxMFzPbp
         LGJ/YnZmqVI1vdG7Ax8QH1x78RwA4Gdzi8UkljNCfcBqKjkpLWIQhdJ7z9wRsnHKXHGQ
         PT5/mr76qWxUajAL49Zjy+8mAUxQQ8eFiNYpplm6U6RrVW54EDQmu0GqvStpGnu3jcy/
         isd+uqDLbEXxdVZXlPISMp1NFVdjhPVR5tqDKVaC8Yj2jZvZHJg7QN2MkyCDIEpLSqnw
         C4xtVRwGNynGx8HLWI47+976A+VOSktuvQxoVIiIcHBr8UN6MgrQKrHHmzrpdNsjlrRj
         Jd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707362892; x=1707967692;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZXmNtHO4LkMWMpNTISVnvudkaQG6foYazMdYkK3SdI=;
        b=st6b4OBQUbqRN/J8Vo7K4LAwbfdryn02hZ1S5HLPkNGA3pwdT4WXGtn/fqE/s2bn93
         K4f+j6mDnd627A5679QNOULWCfzV5gnmGMgB+ID9zW2PphAFOuIX9mMXAjgWxyemo/QK
         2CL3CKWLzwAs/DQB0cHHBJBxrdE5INPINNuUYJTUq4YIGDbXJFfh+zBEtmtNidZeZxOp
         1AVl0sl9GYcU591PPulWtnpPbMDahVL+0yNGsSCrLXzcslERhn2AArXJzv17xef/ED8x
         s+XlGnzEqrV4RZrwDZ05Jw5kloNz2BO0jtdkVjqLZXJBOagdAns0k97VYhEbQLHUktNJ
         pIbA==
X-Gm-Message-State: AOJu0YxLSEB8ROthMhC2y5YeA3xF8JFARYJxicSU7es8LoeB9LIQqGrN
	UWMiSdiPRXOBXQz2C9rdAXZ2uzucy6/4iKSgZ4ywM0XIdE/z8WGOQqjIC23rHe+MwPIBMmQ/8wM
	JcTHTpppL4UpTRaFrH3Vzgp0HyIl8aY25D03e
X-Google-Smtp-Source: AGHT+IGTeXxjeL/GcxCmDQG/yuUkG37+kAYSIStBP/nhkEpkKrb+Hb4ihrjP6M62w7+NSjWpcPxM44UWa95DXzlgSxk=
X-Received: by 2002:a17:906:e943:b0:a38:45ea:a66f with SMTP id
 jw3-20020a170906e94300b00a3845eaa66fmr3891493ejb.52.1707362891720; Wed, 07
 Feb 2024 19:28:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207231014.3A3F0C433C7@smtp.kernel.org> <20240208031413.GA185687@cmpxchg.org>
In-Reply-To: <20240208031413.GA185687@cmpxchg.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 7 Feb 2024 19:27:34 -0800
Message-ID: <CAJD7tkbdzwjhhgK_-6iAHLn05Q-7wCOzEn9xug1Udr+Df-hLkA@mail.gmail.com>
Subject: Re: + mm-report-per-page-metadata-information.patch added to
 mm-unstable branch
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	yang.yang29@zte.com.cn, willy@infradead.org, weixugc@google.com, 
	wangkefeng.wang@huawei.com, vbabka@suse.cz, tomas.mudrunka@gmail.com, 
	surenb@google.com, shakeelb@google.com, rppt@kernel.org, 
	rdunlap@infradead.org, rafael@kernel.org, pasha.tatashin@soleen.com, 
	muchun.song@linux.dev, Liam.Howlett@oracle.com, 
	kirill.shutemov@linux.intel.com, ivan@cloudflare.com, 
	gregkh@linuxfoundation.org, david@redhat.com, corbet@lwn.net, 
	chenlinxuan@uniontech.com, bhelgaas@google.com, adobriyan@gmail.com, 
	souravpanda@google.com
Content-Type: text/plain; charset="UTF-8"

> >
> > Adds two new per-node fields, namely nr_page_metadata and
> > nr_page_metadata_boot, to /sys/devices/system/node/nodeN/vmstat and a
> > global PageMetadata field to /proc/meminfo.  This information can be used
> > by users to see how much memory is being used by per-page metadata, which
> > can vary depending on build configuration, machine architecture, and
> > system use.
>
> /me wonders what page metadata is.
>
> > Per-page metadata is the amount of memory that Linux needs in order to
> > manage memory at the page granularity.  The majority of such memory is
> > used by "struct page" and "page_ext" data structures.
>
> The term for this in Linux MM is "memmap".
>
> That's what's used throughout the code, in Kconfig options, and it
> shows up in the documentation as well. It's in the names of most files
> and functions that adjust your new counters. The new name is
> unnecessary, and frankly it's quite vague and nondescript.
>
> Also no reason to keep the stat name intentionally "open ended". As
> became clear from the side discussions on MemTotal, all proposals to
> change the semantics of counters later on will be nacked on the basis
> of established user expectations. So just call it what it is now.

I am not closely following this series, but I just wanted to point out
that this is not always true. We are actively extending
NR_SECONDARY_PAGETABLE to add IOMMU page tables in addition to KVM
page tables [1]. In that case as well, the name was left open-ended
exactly for this purpose [2].

[1]https://lore.kernel.org/lkml/20240207174102.1486130-11-pasha.tatashin@soleen.com/
[2]https://lore.kernel.org/lkml/20220823004639.2387269-2-yosryahmed@google.com/
