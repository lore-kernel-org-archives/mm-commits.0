Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE923F26B
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746815954; cv=none; b=pnu+TTsuRsWWybS0SJJ4bnVU5W/g+fk1G7KSR+s9G4OZ9o+4eSAfI5ANwDJhtyfHqlxS7cXM/vw0I/RA3NCG9CZqwr+Ogu+YpJrcK3oLWiWarkmxeEQr1EH6E20bB5wDDf1d0shsvleiKzo1aYHoNiKfLUqBOLlfbKhsnl8WyJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746815954; c=relaxed/simple;
	bh=n2Ox8UM62db7qjnCGmOP9TUlKPfaSBpGyOmbdb8Fepw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHfgq4nHPSmwiY5gW1c7w5V8tCOmkLMYlbYfw5zTvxWoPFj78tx6WZKky/mlfPdDypWJ85CJaq0QCUZKQSkjL9smv5kGJPVnisT9NZt/dvFnbloBwFSa/TYEYSvxCpasXHJt0da9bP2vzjaJbdS8FoPXQ2aiaeb/3fPSeW0UWDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=C8EyAV4/; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="C8EyAV4/"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c9376c4bddso278737085a.3
        for <mm-commits@vger.kernel.org>; Fri, 09 May 2025 11:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746815951; x=1747420751; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n2Ox8UM62db7qjnCGmOP9TUlKPfaSBpGyOmbdb8Fepw=;
        b=C8EyAV4/By1xsjZbs96xB8FbpA4nAdAFsW7LbRJ54AnNMwE6xMieO7zPWrhaexLcuN
         8+Mr8sHQiwTvt4bwi3/aV9OD/9OpexXLpoc+wsJcBCJqVKSnzIGlSdrLwT6YeF//2lmn
         5yscnPvPPFqJOZ7wF25d/LixLhKfgcbCsK0x+LGYygveu2jcLGbJh8zAWf20iU8C+lPy
         h/7ay8LmzxfsUP/jzajJjk6l5t9faDN/ndcb3wLZDzD30ie9hMSMk+40O9WK+em85jKf
         XWRpwEpjzX+prxccs6bl8vqInvixbU3FAQB0B6dt+fMUMxDyhoUawmR8mq6Nw18970UH
         ZtWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746815951; x=1747420751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n2Ox8UM62db7qjnCGmOP9TUlKPfaSBpGyOmbdb8Fepw=;
        b=qfwqd6EXjb1dDT60D6RRIGjgvJJGg3B+pHT3gSg6oEtNRhNeFJmHx77WJD9c4sTxj+
         vRzJ35JUTRVtdQoMusCx9iWTHjxZjax6q2z367DhIw8i7qctCHdIuolqEq/4/5EUKAC7
         314BVtSwOej+kWmKjSvAr3mBTTlEYKR1ymdDi3p5ElKOyMhbAgxKbfzLOq9AK23n3mdn
         Mi/IyXpIePQNhtLwUQ7nsmmeR814q7q+hlzIDnuU7U2DxDmXNVGiY3w2MY8rnz5Jg4Rk
         6oCBBXwXxRcMtHGiTiXz+YN6GFcCV8eRwhuB4vbMiPZFjeuhCjE2wVACAlm5snKkdCqy
         eZFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTFl4RyzKqEa+Mfh6SCSH/sNsMLPjoL9CC1xOuoQo2gmozgFjurcPUvmlE8QJ0+kYeBw2NQRgTBjM3@vger.kernel.org
X-Gm-Message-State: AOJu0YxyEz5Rv01ydwtVOqD3nYAezCWq6JnkBMzwukyZ1SYr2JDuihrR
	AgaJJxwxF/bX2RBo8I5YqiUyuKMNfCnOC2tC63R7WmhNTF2wRy3EKbGAK3T8Fiw=
X-Gm-Gg: ASbGncvyX7SupKXnqqO5PnqPhSs/i95CMYgED4SsHX29Xj8ZB7ALg7v8sWkCEQzJSoR
	J7vFl8or6Wh1ogfctSa+ey3GObXpFCQ6+vgC4mc/EZRMQo4bnex/U/r5LnmT1pWNTdRmlLWWnkK
	49vyu5KVZbFRhkCS/YEnpVLh+lPr6D7jZseSYd6YjTXBbkIzAGo7rUwm62OsAqhPuXiL8tVEyea
	opaofY+MI/3EfemaNurtYBJe0KFUTISTYMK1b38CeQPXJwLGnc2u86OHD1kS0wKZbCn1mRwGp7Q
	UX7qsLGulpg4UEY5yJMDGSeW/Qnp9iEgsIwKteR4aSxyHkvfbBtSrmmb01ZdT3YxO4e5yMHbI83
	h0Z8vFbbzYFdzlwCQnPtwFpe0WB4=
X-Google-Smtp-Source: AGHT+IEL6ltgIlmJANPIUqQz2pTRscje3XK3xvt+I2TpCI/q6C525sBLz2VUuq+hDnyJLJywr6QfpQ==
X-Received: by 2002:a05:620a:44d3:b0:7c7:9379:9190 with SMTP id af79cd13be357-7cd01161de3mr729545685a.49.1746815950898;
        Fri, 09 May 2025 11:39:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f4e172sm171851285a.15.2025.05.09.11.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 11:39:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uDScn-00000000rmM-2Zw8;
	Fri, 09 May 2025 15:39:09 -0300
Date: Fri, 9 May 2025 15:39:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: John Hubbard <jhubbard@nvidia.com>,
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250509183909.GE138689@ziepe.ca>
References: <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
 <aB0BI-inU839lcIq@x1.local>
 <5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
 <20250508191920.GC138689@ziepe.ca>
 <CGME20250508193438uscas1p151cf203cd399facd3eb8dd950ff95775@uscas1p1.samsung.com>
 <5815c21f-7ecf-41bf-8bfe-89dbdc6c4595@redhat.com>
 <20250509193042.5a8af82e@sarc.samsung.com>
 <b7c796e9-81a9-4f1e-ba84-5e9af061ee1e@nvidia.com>
 <20250509173314.GD138689@ziepe.ca>
 <20250509205022.26357579@sarc.samsung.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509205022.26357579@sarc.samsung.com>

On Fri, May 09, 2025 at 08:50:22PM +0300, Pantelis Antoniou wrote:

> However our driver is dependent on the drm_gem_mmap_obj() method where
> all paths end up setting the PFNMAP bit, and the remap_pfn_range() method
> is the easier way we could reproduce the bug in a simplified test-case.

Not all paths, the obj->funcs->mmap() does not.

How do the pfns get installed in the flow you are looking at?

It seems to me that if the driver knows it is using CPU memory it
should follow:

 GEM objects can either provide a fault handler in their vm_op

And then in the fault handler use the normal vmf_insert_.* stuff and
never set any special VMA flags.

Otherwise it sounds like:

 or mmap the buffer memory synchronously after calling drm_gem_mmap_obj.

Means the driver called something like remap_pfn..

> Turning that bit off could expose the pages to the swapper which I guess
> would be pretty bad (maybe, not my particular area of expertise).

I think that's different..

Jason
