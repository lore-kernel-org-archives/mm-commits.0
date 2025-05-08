Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E493A258A
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746725740; cv=none; b=eBPFZ+O6QRfrBh0zEag3TLS4991U/0YPePda3jzCVNgrKdb5kbUhnZ7FU8+372P6tTBPYAHNo0Qiom1rW7feyXfCsKfI+lEObOR9sEHszJ9PiVDmADyRI1ojQ6XqZythTq34/Py9bF2RtD6e8PIUhYf2hEXS6h/yjHCxH3rQ6T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746725740; c=relaxed/simple;
	bh=IEP8zw+4Y8+xw0S3mV+uzkl7KcYBk1eyGBiInU1Qdik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fs6tHK5WB5osLXqrNEx4qPfy4teg6znaqxK3VdimwirnB7UjE0u39Qi7tHKdV8/gg9fEMs8NASLX9sshvgZSAxPDqPeKKcBeEhPCW6tv1/iFEI7WJHg4YNIyqtofz5M9CBcReDb76M2ImtarGJyKhef+Sfe4BlGmUkqianXQwsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=L3b1iSNA; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="L3b1iSNA"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6f549550d96so16894836d6.3
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 10:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746725736; x=1747330536; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FFxicwaWl32FD3tj3JZIbxabLR7+wbIE6QvoU0+Q6pg=;
        b=L3b1iSNAqT/iFfgj+sBNCuxh2Xe3V65dwA1RayO9U38xLlFZvNZbfZL6pTmYb2aWsn
         pQZKNlMMqMkJXQxDvO9Y9B8egO62kqbK6gYOkLc9sX4m85zjhJVkfGE51Z9N9oUJzkqs
         m770OuO3F3mh4sAUYoSzvptzjjt43f9QCIpOb6uD7YG+YcWPcS0/IxHyDgMYMy1ZQMUi
         nTc7py3A4OEO2AgJ1ANAr0e1IBhOMU7glxQii0F7/uVQuYDTMPEyn1FipoofXEOQq9s5
         h39DyZ9N4cRoDBeUB95mf3hjAs+o1YZ9MRBf3i+QJdFnXdVaTA3m+VKIC85MZ6+VRkYN
         wg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746725736; x=1747330536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFxicwaWl32FD3tj3JZIbxabLR7+wbIE6QvoU0+Q6pg=;
        b=fKbPAk/lPSWoq65hcI6jPNvJnRo12NrUgCRQe5iW4DLLuOVob0/jFDi9/H4lhLRdZC
         aSvPyeJ/AEisqd31Xgu/LUgO4Ovj2s/16eNgfnq1wmMmLdFTRDi6R5runc+QaZysk3Ws
         W2soLDnmbDHWtqlP7NV7ourVhFoO31QRm95VR7Kr1if9tw2e0U2dyevJA/CU13uP4uHM
         qsPsdfaEs2jGO7bp/Jgow6O/l/JibAdW0bRozgdA7VVhd5X5Iy92Gs68mAvbOEgmXkFo
         7zEZZveU6KHfDM5T7DVW1o+uO2iMShKjut7Eu5goeowYxnO7jHucCf/J38PMRcVirOzB
         ZuHw==
X-Forwarded-Encrypted: i=1; AJvYcCVskq6Zpe9KRp7jn3gYLJY/tCfnBzk3MFC4VCc4OUVEhglvxbteEpYa2cPaZdg+slpxaicRoyOxVcwl@vger.kernel.org
X-Gm-Message-State: AOJu0YwBhP3Mdy5CUp74B+l/43DhF11tlWIDf1NwgOjnQda6g0YNcXcM
	H2PR8aDNTfRuBO5ML22xMdmI2N1aMjEO1a7btCAQgAPc2mnVA5bHIOjNPd7cAZA=
X-Gm-Gg: ASbGncsMuUCnKVmHSepzf5rUz+N53Ihu24p32X9tnYjB9Ua2ikN2wg+KqofZGqyYCHQ
	/P8nDY3qHldhFVocnvLSaXjpbD+kvDG/M+jHFThTfZwhd/2D1I6bK1AR7R4jcgbdH9u/2ok9J4p
	dOgyZQtPLSYjJ4DyRq+IkZsOXERielB1pswTA/XSzEbOubAA1Xji+f0cft9iDPi0JxhW4ErA6vh
	GiYHamzHbnPG2sin14eRleiYZnA9mazL80Mzi/K1uyC1KtX0ES87+jThdj0ZnJxdFX8z6gse9uV
	+77XzaSORwEItMMLFjBeS/ywcaD9ovvYqPqMlPfCmt+hnSYbno27RCz7n6xQlJXdnaFHTgc5s7p
	SSFQ5n7CSRI2IOr5b
X-Google-Smtp-Source: AGHT+IFBnYrAnRwErsuAcZbpCa7TVoTUtPWJ9XujMwM+sTh15e0LnRoOoVNp+glVfIpWZ6XWDma12g==
X-Received: by 2002:a05:6214:1949:b0:6f5:41cd:9dd2 with SMTP id 6a1803df08f44-6f6e481d160mr1442946d6.37.1746725736559;
        Thu, 08 May 2025 10:35:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e39f47c5sm2291966d6.43.2025.05.08.10.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 10:35:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uD59j-00000000TSN-0y63;
	Thu, 08 May 2025 14:35:35 -0300
Date: Thu, 8 May 2025 14:35:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: Pantelis Antoniou <p.antoniou@partner.samsung.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508173535.GA8129@ziepe.ca>
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
 <CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
 <aBy8v7gi3tsQ5-iy@x1.local>
 <20250508173612.34d1bea3@sarc.samsung.com>
 <aBzI3sl6r3HtAWP4@x1.local>
 <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>

On Thu, May 08, 2025 at 05:40:15PM +0200, David Hildenbrand wrote:
> > I don't think there was a deliberate decision here, but there was no
> > conversion to remap_pfn_range(), the code (in DRM) was always there.
> > 
> > The regression occurred when netfslib started using GUP for I/O and
> > when filesystems switched to it we hit this case.
> 
> Okay, so GUP and DRM always worked that way. They are essentially
> incompatible at this point due to VM_PFNMAP.
> 
> So netfslib requesting something that is impossible is the problem .. or
> rather filesystems switching to that and not realizing the problem.
> 
> Hmmm

This patch definately doesn't look very good as is. 

We *certainly* should not be even trying to touch the struct page of a
VMA_PFNMAP *at all*. By definition that is forbidden.

It looks to me like vm_normal_page() already supports MIXEDMAP, so
probably the better hotfix is to have DRM use MIXEDMAP if it is
installing PFNs that it is willing to be used as struct page.

But who knows if DRM can do that on arches that don't have
PTE_SPECIAL..

Jason
