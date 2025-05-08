Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63104B1E7A
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731543; cv=none; b=ntXqqiX9A+1lVS6NxdLbFDQykXCXIztE5goQfpfjQ9o5whvTqWb9jTG+EoMaLCKJ7dgGBoNFi4kSXd4LT+PidzXshewOI6nMixV3guzvPdqgQFpm11DOfRYwYvnQaHsxjcE/VVWGWWpXca3UVL/SnfXa5+JF8S7Fc99cYv21ZpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731543; c=relaxed/simple;
	bh=iWP5D68YEoFLT5RdZXk4Rp85zr5DXEHcYAN7oY9s9i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlAgfUaj29NquqSvH3ENWdm917ynvlLMQYjg0uAF1Al1hzcH7Rz2A4loK8i4F9qmUmqfY1xxeSM5iOscuXGJL4dZOKoIMeTCr0Ii+VKNZ0wU7MuxiSdUOtWM1phizPs6/3bDxoepEqJEL1PZNH4kOZZVwoiA9EhMWu/rSbc0cro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=adgcrcH3; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="adgcrcH3"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7cadc92771dso139191085a.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746731540; x=1747336340; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=apE2mHdi78DXjXfgqpDT8InRXMmiVEoz3iNeQH34P9w=;
        b=adgcrcH3VqI/8THIiHkZYOPkJeYyjoaoZscWC8/v+1BGoh1DXFKlZJrQq2FvoJNwTP
         tmlFMUsfx+rUYY4rrCcYG3NQme3eNSDbnV9yDmF1MVyAz96h4Mr3MH23RFCE8ny/aEd+
         vA8vqCZdl8IATr8IRuzdn8wqO26W7HoisIeCjbZXzz+gvMDBZDBVgdIt7+JTA7BRmGzF
         bVbg4ejKzc2K+oZuUEPM0O1+Ar+lsMiSOY5m0HH/1DCq15M5YDVoC6fj8rKdA0VE4Z1O
         FfBz+E3bCvjIaRSp30ELdLEP/Rf9Q1Xj2kEc27PZowGfUu8qTP1SNoQzLvH9Qp49E8Ri
         DfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731540; x=1747336340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apE2mHdi78DXjXfgqpDT8InRXMmiVEoz3iNeQH34P9w=;
        b=CdEeZI/3CRZKxpi005OmCnRc69E2fS7/w3suwQinCcZlqAZgV+hcqb/IFRo1k3rjb/
         S6zhRCqg6a7ak9LikdDeyjJ7A1N52SjXTk+bW6Se0xyyD8HGqT3gB/6q1UWJb671ncfe
         /II7pWM1gV1NoOu1Bh8MK/mfsGxCHrTBDqAYhILaQq5CDd+APoOFtLJVrA9WDM/c/r9s
         FU0xoEytngGyGZe0pRDfNbjBHTzvuAwsLnTcYtauippjj/ylzy9cR6nE09gXkHqtk+tJ
         v2Z8ESSPVvuhVBtrgQB655ymhY3WJOz7JNujVEHonZ1gxXbG42qJ9cMVcpmDxneCZCJt
         ZXmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGl4B4GaJrIXKjf40zQGhSxfAs0lFW7j9DlnlXcur7/x3ccSwWc9688rBIgLyDR1/J8VDOBWZjfcCV@vger.kernel.org
X-Gm-Message-State: AOJu0YyhSZgWRU6QSNxDcHgXrUotyHrIgu5p46S7QM0RIWhiBxKUXh1q
	tyG0GRCF8o0i8+qS+L2xnx2nGolz4PA0IwMGJgKBB93rPW6z4bfwdSenfUGRCKw=
X-Gm-Gg: ASbGncsK2JTVvO5hH6+E/UHvjZlWBWIK38pmmIPtM0EsDnM2ZpF2qiAwvY5PzcafJg7
	rn0ACp09vrJ02/Jy8MqkrkonCeQLWBI682z/NZ/Tzcvu0GTuVcAjWgtXvtPq7Ho/nAT7GJJCqkb
	Q3fkUt3HcRpIow8k/OlgWQabCLups9vX+NL7E/bVhd9CG5aXxMokMSKzVClHTr6YX4Rrb9663vR
	c2ymUTn2Cf2L61v8lSivq/KSsn4UhItZml57BNRN8Fz1xqi1NYJqfS4XRMAa/1MnrJ2oVcGcuB8
	yghqDujWctPvi7gY17ARLVK56/CTonBR8XGlBw1QHX66jy0370jsChXd0bBPKC3XJsoJ5NVL9ut
	AF/EMXEsx3N9U7UBs
X-Google-Smtp-Source: AGHT+IEQtrSuNmEgHvBIyym4/BWSKtaUPfXOr1bq3JsllGKR0af9loRTKRA0kr5tGbGJtBIOBXkEtw==
X-Received: by 2002:a05:620a:2a0f:b0:7c5:43c2:a8fc with SMTP id af79cd13be357-7cd01150292mr116724485a.38.1746731540430;
        Thu, 08 May 2025 12:12:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f4d55asm28982485a.12.2025.05.08.12.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:12:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uD6fH-00000000bdc-1fN3;
	Thu, 08 May 2025 16:12:15 -0300
Date: Thu, 8 May 2025 16:12:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>,
	Pantelis Antoniou <p.antoniou@partner.samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508191215.GB138689@ziepe.ca>
References: <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca>
 <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com>
 <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
 <aB0BI-inU839lcIq@x1.local>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB0BI-inU839lcIq@x1.local>

On Thu, May 08, 2025 at 03:08:19PM -0400, Peter Xu wrote:
> On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
> > It's doing the same wrong thing at a different place.
> 
> As I mentioned, I believe KVM has this wrong thing working so far..  and it
> doesn't block us from going right ultimately.  It's a matter of time.

AFAIK KVM is doing this wonky thing using mmu notifiers, it doesn't
take page references on pte special pages..

Jason
