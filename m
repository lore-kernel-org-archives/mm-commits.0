Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569C4285418
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731310; cv=none; b=j0VNgSs22Azpbsvbv/inLC3v1FZa1HmWmluAmfqkR+aWeQuArfrQ1pbBPSHF1iYK0PEXJonQ0vysuZcr9YIUIsnOiUPSOxUdjNMuEfahhYFWXZ12hIyajUcrnJai8YyVnksKhQ9MKsQAJk93X90IKzrcSI1WA339TBpHYG6QmtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731310; c=relaxed/simple;
	bh=1zQ4mIgpf5eBaahe0dwYQ4R+17L0i8aCBvvHCvEZR3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnrcVijMyl4kJy1XA4kl9nQNy5Mhk2yo3JGSYuRww4SB6Pg2kO+55Uh6lkevDhbxxxAJkeCcjVCtedHMqMbBSVF3iAl+hQT8EvoYuKOhgoVzX6INCIVZIjUGjEL1J3hog3/Y/WpW5Dd9PHcRTal4djR2+/WbFXQ3H7Ae2BP5G30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QbrpAF86; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QbrpAF86"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746731307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YZUYMG4Wzxfhi3uiXClkd9ZQZ/Ayw1Mj2LX62mDYSEo=;
	b=QbrpAF86uzugIth+18SPFOQu0urpiO4neUJ9qUngBlFa1Lmw0z4hHUdyHxK0xut3xhtgdK
	EMwQYn/kbUQCLxkXWvdsiX7H/CyIeWMnpGJUP5j9tyWKKMfoSNTbxgyrvvtEpurIxJJQeP
	BL51jKN+uLPqWouEcdqmS8voWtgY4m8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-tqzTRtv1O82RNKQMcCSmjA-1; Thu, 08 May 2025 15:08:25 -0400
X-MC-Unique: tqzTRtv1O82RNKQMcCSmjA-1
X-Mimecast-MFC-AGG-ID: tqzTRtv1O82RNKQMcCSmjA_1746731304
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c5cd0f8961so258001685a.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731303; x=1747336103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZUYMG4Wzxfhi3uiXClkd9ZQZ/Ayw1Mj2LX62mDYSEo=;
        b=nh8XIivt0+kTxtWjzHYI1T1mrd5E1bDj4/c0q0H89L96w99jAiAdHb2Li86uPdPtXd
         W2kO7VIESyXET8KW8US5rSDB231Oq0LxvJvZAtwq5MEG2W1UNJWfmJmePBqcyXnqkPng
         0WpvukyMq8hAh8tOkseYd+HgSQF8T4B9AMsPj1c4Gl1KzycDDZ/HMuvVVRbqkH7S5TZv
         l/0owDD1RbSsFVTxTWP/+WCUFhYJ8hCOesTPrhQ28VbifVf28poo8g/NtJfQwnG+WpVi
         6HZMRLSVh89gA25pTWOh025NEIpWsMGV82VDbGRJt25IqyjWjPglJMc6SpAOzHW9Qt4p
         9v9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXj1YPvhBNK6ovUvn7OD8sZQ7mheyxSlGFR4boccR/VbuAtnmzirIk11GAwi6Qb4biAMhJbJT4/S7l1@vger.kernel.org
X-Gm-Message-State: AOJu0YwPzH2qQwM3bRkU2Ni9FVcU8JJyaaq7HF+oRal3TJxQ4A/ZcBDv
	s1wkuPYAvbsoRgwOgVlJb0TJ6xP0VWPiAMV3T5EqaGPVtISJ0/QSAopyy9VGnhDIelqXLqhspeX
	AmYZydPMA102LsIYblQalcBpMPyPt4LxvtK3pGRRcMwH9Hh8jFeHHFRwAFaVK6FBDoj0=
X-Gm-Gg: ASbGnctyp29jwQhZCXd3LJ1lkqrs7Bz5VdYTfO0BAnOo8LwrWKFfZorjOUlzywzdgCZ
	h3LS3xo4SIyQ1c96CH9bQsvx30NlpLvYXIXVJSddbBj16jQ3kd40qYJ75dysSwAimEUcwuDx0Og
	iFz4JUOxFZtn4ZlbHItwF1/uUm/+rpmtLszOh4/hl4J5Ia9cLCqGmiVH6Xh6UB2zp0zS6bTG8U4
	fC4cXx6s64ANsWRQdNM7+PnwffYh3kj6u0R9fg11iXuHIqUk9S7/MksTi2rv2Klz6fZqFvN69eK
	7rg=
X-Received: by 2002:a05:620a:408b:b0:7c7:a614:7214 with SMTP id af79cd13be357-7cd010d5206mr145264685a.5.1746731303567;
        Thu, 08 May 2025 12:08:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/nK4RbDX863V09uKU0dFru5NTvPqGZB7vfVd/9CMZhHT4eX3BizBDUgAwg0kZRUrVYbzTnw==
X-Received: by 2002:a05:620a:408b:b0:7c7:a614:7214 with SMTP id af79cd13be357-7cd010d5206mr145260085a.5.1746731303155;
        Thu, 08 May 2025 12:08:23 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00fe6dc4sm27431185a.90.2025.05.08.12.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:08:22 -0700 (PDT)
Date: Thu, 8 May 2025 15:08:19 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Pantelis Antoniou <p.antoniou@partner.samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aB0BI-inU839lcIq@x1.local>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>

On Thu, May 08, 2025 at 09:04:11PM +0200, David Hildenbrand wrote:
> It's doing the same wrong thing at a different place.

As I mentioned, I believe KVM has this wrong thing working so far..  and it
doesn't block us from going right ultimately.  It's a matter of time.

-- 
Peter Xu

