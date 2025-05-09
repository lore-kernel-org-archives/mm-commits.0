Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74C022CBF6
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746812010; cv=none; b=rtJ+D+P+NQDB/KgiROvTGZO2HsTn8setPpYev4t5KLNhy7DsHM0rcGRG4l2AMNeTuLfgionvQ7FZbN3sxt4GCCc0+su0VgmUnvWhO2F4t9WNBJVlktkWErj2C2bDZg7e5d+JpFvGUzvbk5JlQG7LQEEKW1BPaqUI08hL7Afrfqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746812010; c=relaxed/simple;
	bh=2lz6CiztjRIJX4ZixTDYtavJnqwa/o1HtR4xvohavSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzEKopFwvJQ0jqokqsIXDD3ccl9uIv8AhGEQMFvsHqkYGvTghhVWnsmeKd3PMcGu4GxQEKCjhGL71pFhgPqheDmlNZnMONLJFCTLWZFNyFVAtnFjlKotaFySvtQ/kyUNS5Ti6JFnYTQ6K5xRl2DYB7g/en1l/JFGHg6+mjEyviY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=CCzLUlpe; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="CCzLUlpe"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6ecfbf8fa76so32367376d6.0
        for <mm-commits@vger.kernel.org>; Fri, 09 May 2025 10:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1746812006; x=1747416806; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lnYgDBs5r5sKOiG4MtaytXlVGRMDZP5ZybVjaW+IENc=;
        b=CCzLUlpe1YXWn+bVT7b7Gwo4+4z69fY9+4g6t+wXjv9A8o77G2kMLb5b0AqbtMa9kN
         b8GSqjfg++FKdpLQuRy8PmenNUrg16l7zGmhKQnvn/85no3saQuNoAyZF4CLnJ4i9tF+
         aKPxLYqO6VRj8OjgAfwxNzH7rY5ZkupFSND0dXIZJH0AtjfxIzstAaNz8l3cJscv5oS1
         oOLnH/aXDtwIy0Ui9u27P8rJzs8WSYEsqismoOpla5oCB1T910IZ4ewwcU3BWRckK1+d
         i1Op7KzjMNuKhaoo10SzNVj8UaYH6ICfrBARM4QpN5gIcjWK8CbNdA1nS3VBVhbQwez4
         gUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746812006; x=1747416806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnYgDBs5r5sKOiG4MtaytXlVGRMDZP5ZybVjaW+IENc=;
        b=JfVL3m0Z+1JsfCjrz8p7QY14AI4ncZPxL96o3tZxEdKWXGWiXL7T2TsdUZry5g7Idr
         Oa0diWJsNbPbsvSXrvXCJsLa/vFD/tdDRuezpw01Xct4A1tth5uaMb2y6qWTZq+HliVU
         5elRTX8/uTVTLTfPtj51OK7jJl4FND2hrjGdvd/x7AUE03HjfFomC6kA9zqxJeaz2VkX
         aQXW9eVl5ci6sx2L8Prhbop8Sbc18xUhokQ5WGIh+1Rm27xrDjxK9i54qZnYw+HhDNkh
         7UG/P1DhXQDMFuB8ixOyG4pIIcNS8tX+c3ZBX5gWnjXRgGXvuellpp7yq5R9aAKIW+hr
         PqsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEnOqT7t/0rvG3U1opEjxT6vB1PHXwDuqUQEho8JVRomcDHY/6FjjuyFlImJS/Q7nGKWe3xv/DyY14@vger.kernel.org
X-Gm-Message-State: AOJu0YxoNO63VvJ/lcxQQgjYB+zbl9ya6I9Pd/B4NCBn4Nn3xW5/f1iN
	d0pEszlbt0WAc/VEMjkE6zKzcHKScVhjLE06QGBL+aDnxWAxUmqnv/9L/Q+tFJoDmAoDg3JGn1a
	b
X-Gm-Gg: ASbGncvomx56wtcCSy+gkW0Dj30nc0yViL7uJaoUPGc0XNuqq0I4RCW+vPylXxx8CGB
	Djog7eUXO08AN5dEHkpbcrlYfc/kFNW0+K0yyaS481E38rjKk0Cc6E2GmGKAyn2C4dYJFu5za0M
	RJMdH651S4ai9xIw046KX8Ofl2gpJrIeY5fLfMuHe6jzEa8FzT08StFBD0YyxTOHGuzfxS0dGMF
	4egdVPICl8pmt0aWqheKqNZq+X+V+/s0JYObee/ZwUAF5V+ez+7jsNF4YD400snkP4z4N8ilVy1
	BEFya/g6jvAhEzCaI0xdZj+k5gQoxwqJuvdRWCqJatfIY82/S9QKqqKX9sNgEQQDFeOzpOm26l+
	zYFS5eWbwPv685/Q5
X-Google-Smtp-Source: AGHT+IFy++O302MGJu1KcftXwSpES30SSfkUDJXFQjoX0/JRRW1GaQggqjFzj2/bpUYlyPMCV5uL+A==
X-Received: by 2002:a05:6214:d2:b0:6f6:e5c8:d40f with SMTP id 6a1803df08f44-6f6e5c8d6famr36944536d6.11.1746811995482;
        Fri, 09 May 2025 10:33:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e39f47absm16302126d6.32.2025.05.09.10.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 10:33:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uDRb0-00000000qyL-1M95;
	Fri, 09 May 2025 14:33:14 -0300
Date: Fri, 9 May 2025 14:33:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Pantelis Antoniou <p.antoniou@partner.samsung.com>,
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20250509173314.GD138689@ziepe.ca>
References: <20250508211136.7a0a3865@sarc.samsung.com>
 <aBz8QuzT7YkPqrrF@x1.local>
 <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
 <aB0BI-inU839lcIq@x1.local>
 <5d791609-411b-4e4b-b502-ffee80e8b46b@redhat.com>
 <20250508191920.GC138689@ziepe.ca>
 <CGME20250508193438uscas1p151cf203cd399facd3eb8dd950ff95775@uscas1p1.samsung.com>
 <5815c21f-7ecf-41bf-8bfe-89dbdc6c4595@redhat.com>
 <20250509193042.5a8af82e@sarc.samsung.com>
 <b7c796e9-81a9-4f1e-ba84-5e9af061ee1e@nvidia.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7c796e9-81a9-4f1e-ba84-5e9af061ee1e@nvidia.com>

On Fri, May 09, 2025 at 10:11:01AM -0700, John Hubbard wrote:
> On 5/9/25 9:30 AM, Pantelis Antoniou wrote:
> > On Thu, 8 May 2025 21:34:28 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> ...
> > So what's the plan now?
> > 
> > DRM seems to be the first place to be fixed, however am I wrong in
> > thinking that most of the uses of remap_pfn_range() are wrong in the
> > context of system page backed memory?
> > 
> > Should we start with an implementation of something like remap_range()
> > which does not set PFNMAP bit. Its use is wrong in that context IMO.
> > 
> > And then move to DRM proper and replace the call to remap_pfn_range()
> > with it and see how far we go.
> > 
> That sounds like the right approach to me. Because the way we get into
> these problems is mostly due to the lack of a clear example, and so
> providing something correct to call is the way out.

Thing is if you want to just install struct page memory you don't need
MIXEDMAP or a special call, just insert the pages in the normal way.

The issue here seems to be that the DRM caller wants to mix and match
struct page and non-struct page memory, so I think you want an
entirely different API for managing effectively a scatter of two
different memory types and computing what the proper VMA flags should
be based on what was given.

OR DRM is actually using remap_pfn specifical because it does not want
3rd parties taking the page refcount because that destroys its
lifetime model..

Jason
