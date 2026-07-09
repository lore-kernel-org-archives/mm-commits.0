Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D07B316905;
	Thu,  9 Jul 2026 00:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783556547; cv=none; b=i/77ovcWm1yK7URoQ/3ny9w96JFGesh8xjKmMGCu0KrLVVLU+PKh6Z2XcveDFnnUguNwdAkpkNHVpWTrtBm/b7RFzCc7tY1L7IbVrFdDiLcA4fGgLei6DZ5v4Dgx34SjUh8dpQohS58RwwlPcc4mmaKVM8japAQJyh8zGc6NYME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783556547; c=relaxed/simple;
	bh=5otryLbL9wcehZn3JqeQ5NUvUHsoZRGcqi1rWDe5amk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=YyYPD07cFbShwAgnFXDIgTSfPpqXYtr3rM48JXxr6cPgtkDxA6e5QciWrKD50FvwluHdnJHS2Np6VcUO8zSf7IAZNYcFrai7Yj6SxDEXMoKimo919I8esDc9UJFf9HL6UAHtOqvn3v+s5iKXiz/CpxjKNRGbhM2iOdCq7ndnoAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SB4Vm80u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SB4Vm80u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D521F000E9;
	Thu,  9 Jul 2026 00:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783556545;
	bh=IFnt3Ev2dcFJzcdhHsm14oZW2o5/ZmcubtTPCpiK30k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SB4Vm80uRCpDeWODkTtcoxRBu/TZxPbDoj4rha6005eIZgtN8+gCEBn0JHU87x/Pd
	 GnYGX2v2Y6HCRSIIs+bSOIVpwQWlOqhfUje9GKX6JjxrCagbTAaquM4muIFsr7UfR2
	 GWfABpESVZZgwWxhqZYdNXWzLyiF46kN2z8yPgig=
Date: Wed, 8 Jul 2026 17:22:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, vbabka@kernel.org, surenb@google.com,
 stable@vger.kernel.org, sourabhjain@linux.ibm.com, rppt@kernel.org,
 ritesh.list@gmail.com, mhocko@suse.com, luizcap@redhat.com, ljs@kernel.org,
 liam@infradead.org, david@kernel.org, aboorvad@linux.ibm.com
Subject: Re: +
 mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch added
 to mm-hotfixes-unstable branch
Message-Id: <20260708172224.f919bee522da26d700cef447@linux-foundation.org>
In-Reply-To: <ak7J8oaLkNsWNOrx@casper.infradead.org>
References: <20260708205653.14D251F000E9@smtp.kernel.org>
	<ak7J8oaLkNsWNOrx@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 8 Jul 2026 23:06:42 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Wed, Jul 08, 2026 at 01:56:52PM -0700, Andrew Morton wrote:
> > From: Aboorva Devarajan <aboorvad@linux.ibm.com>
> > Subject: mm/util: don't read __page_2 for order-1 folios in snapshot_page()
> > Date: Thu, 9 Jul 2026 01:49:54 +0530
> > 
> > snapshot_page() currently reads __page_2 after checking nr_pages > 1, but
> > it should only do so when nr_pages > 2.
> > 
> > If an order-1 folio is allocated at the end of a vmemmap section,
> > __page_2 will not exist and reading it will cause a fault.
> > 
> > During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page() oopsed
> > on the page isolation path while reading an order-1 folio's __page_2 from
> > an adjacent absent section (unmapped vmemmap).
> > 
> > Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
> > hole).
> > 
> > Link: https://lore.kernel.org/20260708201954.686111-1-aboorvad@linux.ibm.com
> > Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
> > Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> > Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> You're taking my R-b without taking my rewording of the second
> paragraph?

I added your sentence.  Aboorva's info was potentially useful, absent a
Link: to a report,
