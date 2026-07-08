Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4802F3A7D6E;
	Wed,  8 Jul 2026 22:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783548408; cv=none; b=fS00Mv/SfeZ22mSqb8NcmmydlupD1dvstyIKK48tLAceetFnBUyq+jUn0WMPbR1u9wIj5+7JizPolNpK9GGDmqq33nJRk5e9hHNeWlRXDdOfcf2DJ0b4CjBcWL1yzvWk85sF9WLCUPdIOL4iZXYOHHD3p3CX0KfdNhc/f3xZuL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783548408; c=relaxed/simple;
	bh=ofd8vLEoEze/KbxczkXPc5iC0f/zo3fIZp6aOZEKhRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbT38dL1ZgMQswHWMFj5894gRjm5OaObnHe+RstGkW0OnC8ISO8uGWA5vlyLaUAYqtkZFt97pkcq4g1Tb4hi2GzYcIgoejYn2L7dmXOSiCmdE4WpPzQrZ8EQ87SWb8ku8CpFkywMe08sgUPLw4L3YYiUVuMcP+/A5cAE4cp5uPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kmVqc2lW; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kmVqc2lW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MSi8nwkovIzEEphFPpprWyeRS6xjscWNqnDGyaKormY=; b=kmVqc2lWqtcMm/jCgSL1sEn37O
	WYzOl/3rHs54LgXp8eAOx/qHYMgRIavRoZZTijRGzcZIERqD540PITKaHTzUx8l+zyZ3K5HeJFVy7
	QCPm2mtkY4nZ9b1+Milf0OsxzJ53hRWI7YYOkH+DVnldPj6jx9W+nOGk9Pym+zUjhzqOGhRUIm8lo
	iJHJyO+TGcYSCK2KpFmH4LQjsxdhuQs9wLXWQnwM+hmqxDAE2yG+vsdou9XslcBd/629AdLfSK6OL
	GTAl6BPY/SrPNFmODQb2HZXi2ecRaA0eB7ryTJNrDynd6gFyfHCH9aPHmsFqAqqRyDMCw/T0vuj8C
	J+/2Ghwg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whaPi-00000003Wmf-1lIp;
	Wed, 08 Jul 2026 22:06:42 +0000
Date: Wed, 8 Jul 2026 23:06:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@kernel.org, surenb@google.com,
	stable@vger.kernel.org, sourabhjain@linux.ibm.com, rppt@kernel.org,
	ritesh.list@gmail.com, mhocko@suse.com, luizcap@redhat.com,
	ljs@kernel.org, liam@infradead.org, david@kernel.org,
	aboorvad@linux.ibm.com
Subject: Re: +
 mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch added
 to mm-hotfixes-unstable branch
Message-ID: <ak7J8oaLkNsWNOrx@casper.infradead.org>
References: <20260708205653.14D251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708205653.14D251F000E9@smtp.kernel.org>

On Wed, Jul 08, 2026 at 01:56:52PM -0700, Andrew Morton wrote:
> From: Aboorva Devarajan <aboorvad@linux.ibm.com>
> Subject: mm/util: don't read __page_2 for order-1 folios in snapshot_page()
> Date: Thu, 9 Jul 2026 01:49:54 +0530
> 
> snapshot_page() currently reads __page_2 after checking nr_pages > 1, but
> it should only do so when nr_pages > 2.
> 
> If an order-1 folio is allocated at the end of a vmemmap section,
> __page_2 will not exist and reading it will cause a fault.
> 
> During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page() oopsed
> on the page isolation path while reading an order-1 folio's __page_2 from
> an adjacent absent section (unmapped vmemmap).
> 
> Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
> hole).
> 
> Link: https://lore.kernel.org/20260708201954.686111-1-aboorvad@linux.ibm.com
> Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

You're taking my R-b without taking my rewording of the second
paragraph?
