Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C724F21FF54
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731974; cv=none; b=o7WmM3fUPsoBKMr6dO5rCnR5aQB21c/lda6B8VcTu5IC8qHvDSo6iczkB88uaDfHpTlXfWTtRN6mqSDr7romMyZjXs47aROUgLpDVlNpPZ8IFtilK7Rwj8cQ72NpaMcvrA6hWHBu+pKa0PZ06WMX2DZtP7uYRe2RIPlX+KZ+3LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731974; c=relaxed/simple;
	bh=5bsCgJ4Q4ErmlCg/XN+NN6k92ohi0zQRQja9GRM4BMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHrdaqsjeCzc5Odjw/stoc6ToySvsUbUsse79Tp8qUbS/gr1qIfezKBBJ4I3M27zGAyTjqAVV/vHfKCx3bDdRC3PPfrOsm8FTHU0Bwme7qrH1blYb6HlaaTvdX3u2MpBB4Z0rRbWmhz6DnxdptwOb6gtwesSLhreSMlqwB/YoZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=otBrRYfs; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="otBrRYfs"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2da3c5729fcso1044378fac.0
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746731972; x=1747336772; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aoXe4kLhxkIgUIq8QgZ/wGH2cVMsc0ltDIccrLN+AjQ=;
        b=otBrRYfsnByTecexKGSB9irAJsQjzkSoo+C6soavSTenH8dYA08d+1DEoSmkzjJiql
         JklOdiKezgbIZVF2L3y0d67mgUjQSTHaIM/QYE0efI5y0++nzlrc1zczBGztCewxn+ld
         R2Qlr7mw0Qeew9Z0VeVnE/0DBlekl4l8luqGo/JsEjBbTE3go2MuiQzRX/DXBxHUsZ7f
         pVpBsOXh2VFdrlUUczvNNluqezGP/Rz2gv6y+IEDu3wRtZt0Y7tljJi0l+Z0xV8I61rj
         AXTtfp6dMv0O7WXDFS9fuzYWxtDfXPnVpPO9fjPqSyKdgXT/2ioXQULBtNka4eClhmqe
         U/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731972; x=1747336772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aoXe4kLhxkIgUIq8QgZ/wGH2cVMsc0ltDIccrLN+AjQ=;
        b=hgL7ia+geg4/C/FzHz1Kllbp6eIkHVWMX95cJm00K+1ZHCs/o751RkmyxYQry2MqnA
         efeNTGTGqUnnuiUp1zeQDGUjwBn4waUiCtNBjP/fgbvRdeMqlWNpKiYAbGBSSdpRTMM0
         hMd9B+nfoE8TgXlinFuYCbiB8mxQ1iLb0zUKhHpmSrfn8qrwd86cowk2Du/Nb/vmwUuf
         PFCp6Z5GkciB6dh2Z1N3t0WT4jdm5NHWPOPLuOKuO9VX8yVQxeykgfWbEsXoMSsHiRKy
         MMOQoGO/0REHTKAKxIO2V0xNK7tuOdgihu3eOHy5ccNrOX4c85lxjXPYV+qrkP6z/olE
         vcUw==
X-Forwarded-Encrypted: i=1; AJvYcCU5uzGK/hcgydwCLQzfD9/Qf6ol6WzY8vcc2pRBGpEd+wMDyi7G5HVibr5GJM8uRRxpIS5Anj+vZFBM@vger.kernel.org
X-Gm-Message-State: AOJu0YyxFPMYL8E6zKgnFDtNzMz3sSb10iEjbBOHHGNfIKm701TUn1Wd
	JDD2KF8nRV+7zBB4D5C/AeooOs6Pm9TWm6EE2ERCKbGRxouviaTOJHLpfFrfJ4lnVZTR5mq1evg
	r
X-Gm-Gg: ASbGncsjTFFLhVcrErZ6YybwMs632EU/y605jt6DYH6X/M/wOlxGz5l5mGs8FvV7WjQ
	agRHyIMTH0+nL5K7ZaZcN1UdR3Xghe7Kkz0ol+1cK96UUPtoRpiQ9MtbmBX+tOXHF9tTm9fpUpw
	HpZqKeZ7oZWoz411hVKugXfDHHAfX+SE6Qyy7f++eohwnUTZN5Qoo+Dmchid9JBTQELMX8Wbx/2
	OszSmQIk/cqR/O3YyOVHAOmj6QKLHv+HPOIK4Toi+oMm1DC80RKmDJ7jsVBLavG165Wy9ok7Wxy
	OlEx+maYIwo221qMwb4XDDdqS+Nk3r8++z6wAiV07t/j44DO/laX4v6lsfovt7zR0Nyf5TT2t9C
	O/b1iWew45VY8tG6Y
X-Google-Smtp-Source: AGHT+IHo2ZuX1X9VdlLHdXvpFKCeJ/Sf+W048TcU+lakQxNLpdOLCcqcbx315/ygTvzIwNNwbR+z7w==
X-Received: by 2002:a05:6214:4019:b0:6e4:6ee1:a282 with SMTP id 6a1803df08f44-6f6e47f264amr8495706d6.18.1746731961683;
        Thu, 08 May 2025 12:19:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e3a53a09sm3170536d6.116.2025.05.08.12.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:19:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uD6m8-00000000bg0-38x4;
	Thu, 08 May 2025 16:19:20 -0300
Date: Thu, 8 May 2025 16:19:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>,
	Pantelis Antoniou <p.antoniou@partner.samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508191920.GC138689@ziepe.ca>
References: <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca>
 <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com>
 <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
 <aB0BI-inU839lcIq@x1.local>
 <5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>

On Thu, May 08, 2025 at 09:14:38PM +0200, David Hildenbrand wrote:
> On 08.05.25 21:08, Peter Xu wrote:
> > On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
> > > It's doing the same wrong thing at a different place.
> > 
> > As I mentioned, I believe KVM has this wrong thing working so far..  and it
> > doesn't block us from going right ultimately.  It's a matter of time.
> 
> Yes, KVM has it wrong and vfio probably as well. And they are usually not
> dealing with actual kernel allocations, but rather with MMIO ranges.

vfio also doesn't take references on the things it pulls out of the
VMA. The vfio bug is different, it lets you take a pte special
phys_addr_t and reference it through the IOMMU without any
refcounting. So when the VMA is destroyed and the page free'd by the
GPU driver we just UAF it from VFIO through the iommu page
table. Woops.

What we are talking about here is very different from both kvm and
vfio, this is ignoring pte special and accessing the struct page
refcount anyhow. I certainly don't know of anything that is doing
that, though I didn't know about the old netfs stuff :\

Jason
