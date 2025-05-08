Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE3C286D66
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731179; cv=none; b=ZwMd1Qc48b4qXdzwm51CikKocZSS0E3kntTm8lxdKzV0CBrZOlT6Gll6mKVD4X/y1me/Y1ZduHRi6tLOckah4MPKvR0BCH5HIJoWzk0irVu91oyyTPBD/AUwmMCsoQsbp2gLYLeXIviUQwmynRML534mkzYiHQ2nkOpzlStCOIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731179; c=relaxed/simple;
	bh=zHXyee+Wd9DUew3G5uM4bGQ8x2nTUcTzo4XZXmvNmJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YbLigRU9cSaOSMLwSDwQ36uQgi9NiR6g59PU0S0aUNvd9tdTrPmuh3ygsnf1n9ZDrUDBtEYfH3h5IL9IBq3RrBZMZCQdEFXOxjXSorRmgkWyDVf5ORuhkCgv6b+iWr8Zj2j2QFtaAqsvhs0329oA4ANoiND0H1Oz5l11N/BqOak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ABeJrQ+v; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ABeJrQ+v"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7c7913bab2cso145260885a.0
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746731175; x=1747335975; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CD/UzAf3+VoTj1pUxaTJF78K14Aqe/RHAOs9gBSU0s=;
        b=ABeJrQ+vxPOdJzdcq8vdGQkAHXKYVmW/BtjpRSsQlDw6lMQxMwjrU5HTVglAIijddv
         pQUMMUh1tFlgQnbUwTcTcJEJoA7xqc3D6osUBMVeefYvuQaNEdLHe59cOjHfPrZjD+vR
         N0Uhzzi3QUqQaREEAWSQooewZzMYyjE721Avh+x2r2Qifcy6HL2MJubCYiOsIhe6mrXR
         /2H8IcJaTKB3N+p7Zaj9bWgW04nJJrIxPQaBfycW4+ihn5km8s8XWZxV/bQ4VtQpnPdx
         ihQuRIbzldXOZG+GlCP3DhQcTlkGab6zETIbLU6mBFfWO9fAV95g2HY4AeCxh9ArXa+s
         VF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731175; x=1747335975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8CD/UzAf3+VoTj1pUxaTJF78K14Aqe/RHAOs9gBSU0s=;
        b=LYdugrS+kdHjbKtuA0OOm5e3E0fvc8k+qdiz9UtuozPOnPXyYmpH94xBJYG3hf3Lfp
         pIEAt0/zRUiOdktpEAzb/64vbVbxI4Vh6036XtXgQd3QX0AuvIuZV6Vb4VTXkD4wBgte
         nQ6H2dmwDpOGneI7jyQm1Z0P/3Lu3R2H4/JWKyDloOLiaSv5uHYjzElg7jtxCX3xIMuB
         V8pHbc4gSpMQXcwVIbRT/RFj4WEB6zBeNa1mXLoqfKmZA5K6uHi2wG7kOyxA0JnY1uL0
         Ec5QgWbFrS4Pd10OSKUtvbgc6aQ8DUH6fMt2ZtUiQSmg4sDAmqOlDOkFgZRsio5CG7OW
         cUNQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6GnsjO9fzJWCnYn4zT1XE6u/ch1yFJvA6qBNGfZb7v67dU0pr9jbgerW0oPNLC2FmZfux3bNAqSPk@vger.kernel.org
X-Gm-Message-State: AOJu0YwfzqWxKGNh6zPTOvVjALf77ofWCyPNewbrHbZ2EXlNDGAvYrVG
	lwOqA8yA+2E2fcA9EcAC1w5qIs6GcHXahBskh/L6js6Zwv34/F+wDzwZlq742CQ=
X-Gm-Gg: ASbGncvzwr4qQBUFhaSo5AMniH5RDUQPzqSrF+p4AAv1ebpjLeDFv+xJxV5EsDahF9O
	giLcfvauS6y+YUH3Y0vNYXzMnUrYhoBCJqP4dnD7cLgHOZY7TF9jIpcgjum+hR9xJ7WsaD535YK
	REXyFotg6t0CYwficUI0Rcx8DZn3qWXUnJkO3GlOrVcaoFlbM9FqlkB4mC8V9sLm6b+4ddI9/Df
	J6+3Osgx9GB9EHbC8S+rGxs2IFf02L+zaz4icuHwmKiGHyIUgzA2+fZRssb/L0AfemO093gT1u9
	CBp4KaBZvLtweGPytPHnj1hvWQGJc1zIV3nF78KGlRd6DHEyzTOuJWwMDbjL55F2cz/oWpBKDGA
	xbWY8PZcw6c+cPxBA
X-Google-Smtp-Source: AGHT+IHcQ9isxW3cCAOqWDYj3nFF2Qvf3ElYElt6ELggCkHTm+WUKcGVuDhR4UN93GfK6SEI6ivJmA==
X-Received: by 2002:a05:620a:4011:b0:7c9:256d:f6b6 with SMTP id af79cd13be357-7cd010d0575mr117031585a.2.1746731175394;
        Thu, 08 May 2025 12:06:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f9a7c9sm27997185a.59.2025.05.08.12.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:06:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uD6ZS-00000000bbD-1SxB;
	Thu, 08 May 2025 16:06:14 -0300
Date: Thu, 8 May 2025 16:06:14 -0300
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
Message-ID: <20250508190614.GA144496@ziepe.ca>
References: <aBzI3sl6r3HtAWP4@x1.local>
 <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca>
 <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com>
 <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>

On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
> > +	/* Did we find a special page under VM_PFNMAP? */
> > +	if (pfn_valid(args.pfn) && pin_user_page(pfn_to_page(args.pfn)))
> > +		res = 1;
> > 
> 
> It's doing the same wrong thing at a different place.

+1 this is a DRM problem, it must be fixed in DRM drivers.

Jason
