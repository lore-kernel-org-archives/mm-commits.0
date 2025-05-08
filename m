Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE32D288CA3
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731517; cv=none; b=bdQlnTP+tvwOjiBS3JEHJINQ1wKSBjmejxuvsAIKvuh754BdoWSzkfi3VDaCpjV/f6qGx6f33pqz1PjqYkG+hcOv/EJkPxMSus9oD6QumxVQwLrlETJgUHfraI55PB93grLrGs7T64i8164wDUjdTi/gP1LCchh6tv7ln6WacbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731517; c=relaxed/simple;
	bh=jO2WFBHOxaUe131j3cQci/ql7TBu7zvDQUF/shqnR4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZRArBVB1wBPiANgpAJoQCgyckA/3AA7uvWWPfeHzz0gamZPgmZvZXbqLh9byEq964dDza9dZptXghRBzjjLy7JOzuHGHPD0jUr+Fa210Zp626KbQIVOnIQIYly1oFuEMmdbYKwT1lMqd6QdeXrqec4mahgMw5Akqt/SMvNTL6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=iLHxPrLb; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="iLHxPrLb"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4033c89f2aaso916579b6e.0
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746731513; x=1747336313; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jO2WFBHOxaUe131j3cQci/ql7TBu7zvDQUF/shqnR4I=;
        b=iLHxPrLbTK3UQP2BAaDobHCvvizEF/ByLctNwIV+dZHJPZki52xhEFLSqG8kav9bit
         wxJY0YGq5Dp19d2z0Q/D/HURP4b5M5Y+z4zNkOcvhD31YAFXglc19IP9xkFLaLPVoJXE
         Shh4RNnhA4T18ASSr/tixrMKpJjw4gVbA7DZBcW+qK3H5nikMstyCrWS+kUrTh+vK/tp
         DuHvLhSafxCdtaAdzSO1qyEJgXJHq2Vea2z8Mb4rwzgFwCQwx8gQQs0T5ayE0iIT/dEI
         WsvUxzwy9M2CVMmIv80WxCEZtVy6J3OI5WUi5oiZbcatZWD+mGPAe/1TtVhW4cpJzT+O
         NT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731513; x=1747336313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jO2WFBHOxaUe131j3cQci/ql7TBu7zvDQUF/shqnR4I=;
        b=rVkAY+taySsM3VNgRpEhLESCpxFpwWyIJJDKstN1URapkKV5v57hU1cZeEyqZrEQb6
         XQyOOppULXu71sq5dQLIzmNgoF2vBZbqosU+iDIubTxzccnpxJ2NKHeyUO+bvcDUWTcU
         8Xffxddn3Cfm7N6Xqoz+ko3CDliKznbcoM7gbnwg3SEECCckwWUnG9zJYLEfgw19lFuJ
         jqENrhvwISuYfJ4KVETE0+O2Wv9VViIdhjrvRWfCbHgr1RtDwN5B9d9K7K383JnlkevY
         qho2SxiIjE/qh1n0alyorEL5Easjo/d8jbWQlrgUOoreLvu7cXkyKNOVaasGoGmlrU2b
         KnDg==
X-Forwarded-Encrypted: i=1; AJvYcCUZW8z99IrVmSP2HVFfYc6JBjtbc0ATngiC92qq2HlchSLuTXjlPG2gUFmMHF5oGB8cLvfl4oOfzOlb@vger.kernel.org
X-Gm-Message-State: AOJu0YwNvkdvwLv3mKjnKklzYxEYouHsSTyt7CEuL4Qvv+9hg6zgC7TX
	AcdyYclvJDCq3FAAVkxhgjian/ATm9W2a0Mbn61yVVOaLe033LqIivM3nquPEvTJxGc1v2jPg4P
	R
X-Gm-Gg: ASbGncvt0CjeRpePLNDH4i4DDaGEBWoG7Hli2ScB8hO5MiQbQ5rkHF6t9sW1K9TGc8+
	Zep1/Q5irBUVr3QSCHC+KxQxjo+wg/587kA1e0tjon0Hg8nmsXThHXF38+2MIA+IXvoU6umoFFf
	75sWH8m+wNBLFSSmfex9PBWgXfTdCHaarMeCfwgJdZoyaRl6qsdoG7edpFIJRkMkayTvqTFzPMi
	s2LSxiU1ZRSHiD5BvS3Ui+bPGmOoNEqwF5frFGZqV99K6uff0gmdZW1gVkiDXBz5+zM9QN20F8d
	yQDzBW82XFR+P7KVmaUNrl2ORn3hiJBMha1Tquc9zzj+MOMB7Re4XYMTcpybnpX3032PuSEKeUb
	mdYN1zNfw3aWISSNq
X-Google-Smtp-Source: AGHT+IGqofNms8uRgn9Qo1rp/yBqkwRCZhH3+uNXOT0rQhKnGlxWgBEIf7y+2ElD216Rq9BsDg0iBw==
X-Received: by 2002:a05:620a:27d6:b0:7c5:5206:5823 with SMTP id af79cd13be357-7cd01118785mr151980185a.29.1746731502865;
        Thu, 08 May 2025 12:11:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f4e146sm28913685a.19.2025.05.08.12.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:11:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uD6ej-00000000bcy-1oJU;
	Thu, 08 May 2025 16:11:41 -0300
Date: Thu, 8 May 2025 16:11:41 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250508191141.GA138689@ziepe.ca>
References: <aBy8v7gi3tsQ5-iy@x1.local>
 <20250508173612.34d1bea3@sarc.samsung.com>
 <aBzI3sl6r3HtAWP4@x1.local>
 <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca>
 <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508211136.7a0a3865@sarc.samsung.com>

On Thu, May 08, 2025 at 09:11:36PM +0300, Pantelis Antoniou wrote:

> 3. While we go about fixing it, this has caused a pretty significant
> userspace regression, where the address space that those BOs reside
> cannot be used for I/O when a network filesystem is involved. I think
> it's a matter of time when regular filesystem start using the same
> method of pining and doing I/O instead of using the filecache on fast
> memory mediums.

Regular file systems already uses GUP on O_DIRECT paths and already
didn't work basically forever. It seems like a kernel bug in the net
filesystems to have done something different in their O_DIRECT for so
long :\

Anyhow, the fixes must come from DRM using the mm properly, not by
hacking up the mm to ignore the well defined API rules we have.

I don't know enough about DRM to say exactly what that means, but that
is where you should be focusing your attention to fix it.

Somehow I suspect the number of places actually using O_DIRECT from a
network filesystem to a DRM buffer is going to be pretty small since
it never worked on a normal filesystem. Meaning this isn't some
general common code that is feeding generic files into GPUs, but
something custom built to only use a network that happened to stumble
onto this kernel bug and abuse it. Do you know differently?

Jason
