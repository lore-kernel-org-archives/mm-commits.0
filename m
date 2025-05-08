Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0D2820C6
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746727281; cv=none; b=T/zADpjTT+5g0UysbNuthzKcdNv20p+J9ICvJaO5P6p3Lyw0zhJTDkNfxmFX6UYS6goabO4Bjkm7oTjX1/n0QCfBW1Ef7Xb7iqPNRBENT92nal5zKHlRD08prby0twH1D0KzF4wJL7LsRakqjV4KCISTJABY/N1We5fFr7GSpDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746727281; c=relaxed/simple;
	bh=RYJyKCdZ7d1u9NwF45rfd3tqa1PVgesq+iwedxHqPwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsOsSfw0Qsx+VUHoscU0B1eVvBgvuZ0Urq/mlxeyAH7SnklLTazGFlsh4lbi5W2sGzvjBIxpEZ0cDg4k1V2qwKUxM1ZxR1PFORCJBKkqShxQzit18TUDqvabvRIENXtyiBpU32bCgr1RdSQY5FjOVJv+K5H/RqTiYL2TTIJaiHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AcMkQbEO; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AcMkQbEO"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c5b8d13f73so167007685a.0
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 11:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746727278; x=1747332078; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k+koHeu5HwFxfSymNlmNUFFmqUWrpsv7erSzMRplU34=;
        b=AcMkQbEOFjKK7wJP3waa3C7aP6DRuqZg42D/GW/lAQYnh0COr1T5riYJJ5BjklvhK0
         c99887bReRdqDwZwLFww4qmEHPwDttm4Dp2NRH6QSPzp4M9b9fGNh7tm49VjQ+/7nG6U
         YNM2A3JlD5v1E+gt9p1HeTGlCvDi1WhO07CTvG3+xMRT7yrP9M9efSFPGVWpiqiEoPzF
         XOUi/xA2nthmGj15Rvqsl7eiy6YpXajmpVth69HLJQS6V1+/ppwdodlULwMN403n7HuC
         WW06kReOdoErKR4O6DzZcLtYVSLymYWEXKaMP4O3bc9FvtfhM44TnFtxhljB4Zv+U8li
         CKvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746727278; x=1747332078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+koHeu5HwFxfSymNlmNUFFmqUWrpsv7erSzMRplU34=;
        b=SfBWx2yzmAvXQupfCW9GH7SFTIcF+soJN0L5Mwp/mtvbkffYxZF+JkBvbDkI2g5ZfN
         R1qR5DSeCFXMJArQYPBkyggAze+psT/hlP1RU41LqPgvOcoDVHm4wjVrwZmju6Ukfw7E
         FPbXE13FjohoA5+3mrDRP2ZmlYnxf9mnZBeHwdh/LPBYOQCi6Na37yT+TLlecmhDxxaI
         Z9yRzx0MFkqY5wwoXWifB6qyMabo6zHNhEJrEIFnAeoKSZ4ms/mdvausSrfsGi/GWQsl
         Yh9EcKP2gXoBTO1NWeVKF3U+oQvPW7e5nmYv9bpOTmHfGffcSxH+K///I7l50LhPKaVn
         HqFw==
X-Forwarded-Encrypted: i=1; AJvYcCUF4u9HZPz+uBVxXyIAaVXXFo5/ozonpQw5M5KnzbYulq0qiZjmAl1kzuKESqAvg5dxLfwQKT8NqW4y@vger.kernel.org
X-Gm-Message-State: AOJu0YyBpQOLuM02tqUOtHcDKSqX9gQrZV7jxs6japdqQgaj3hhriPoC
	0ZehNi+zK3ma2SVdwYVX1xKlW4Kt29iXTraiCrBekdC+K7D1Gb7cJnvJQZ8lX2o=
X-Gm-Gg: ASbGnctG0GW4rqCFuNoWH1Z8kbSj1sT1HLimRaw1ZoSGPNaCSSdVd+VDIJmi86YhTZw
	5PR0616F3W3vvXjOanDfZmmuZs3BV+9sG8FvMFOlFTQ93xY+BYeJDseRpLZM1A/s7ZJrj8wMPqL
	qB6TjUPsglCBN78nkX4oolerdVTE9zMnrkerI2WJR99Sw1t8ihsLaLgFADPFrn36kN/pSjDzWnw
	z5If7m20LhD64jJHJ0v5PhhaCa9lbRG44lVjogfbq6BCHgCgqQH03uUyQC0T0hSP+ukTZJNXukM
	KJa4S3QmJGCJ5TdjDnmUS+R9saut64a4p4MxgpOZ9RhDLYbjDYBt31pOmo9tDaVLK/Uh78joFke
	zva8BrP/pJZ0mu8ng
X-Google-Smtp-Source: AGHT+IF/9LxpSFlqkyv0bFRITaT73RWFQr7Sz0tUkKTTdbewdWwsbN7N0rM7kohpguSqRcG8bJf/3Q==
X-Received: by 2002:a05:620a:4706:b0:7c9:13a0:b014 with SMTP id af79cd13be357-7cd01103cacmr101181085a.14.1746727278320;
        Thu, 08 May 2025 11:01:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f4e172sm21603785a.15.2025.05.08.11.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:01:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uD5Yb-00000000a4a-0xgc;
	Thu, 08 May 2025 15:01:17 -0300
Date: Thu, 8 May 2025 15:01:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508180117.GB8129@ziepe.ca>
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
 <CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
 <aBy8v7gi3tsQ5-iy@x1.local>
 <20250508173612.34d1bea3@sarc.samsung.com>
 <aBzI3sl6r3HtAWP4@x1.local>
 <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca>
 <20250508204711.6cf9f6e3@sarc.samsung.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508204711.6cf9f6e3@sarc.samsung.com>

On Thu, May 08, 2025 at 08:47:11PM +0300, Pantelis Antoniou wrote:
> > But who knows if DRM can do that on arches that don't have
> > PTE_SPECIAL..
> > 
> 
> The question from me is why a __get_free_pages() area that is passed
> to remap_pfn_range() gets the PFNMAP bit set.
> 
> Even if DRM sets the MIXEDMAP bit PFNMAP will still be set.

remap_pfn_range() is the wrong way to install a PFN that has a working
struct page. It sets the special bit and it is unambiguously wrong to
try to convert a special PTE to a struct page. Special bit means
without any doubt the PTE's address must never reach to a struct page
even if it has one. It is very meaning of the special bit.

I see some DRM drivers using MIXEDMAP and remap_pfn_range() together,
that seems to just be creating a confusing mess. Having
VM_PFNMAP|VM_MIXEDMAP set together is a nonsensical
combination. Having struct page backed memory in a VMA marked with
MIXEDMAP and with the PTE set a special is pointless.

Jason
