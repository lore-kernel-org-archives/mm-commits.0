Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC68188CC5;
	Mon, 17 Jun 2024 20:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718655430; cv=none; b=gE3v3iFc7cHkaeF2wjzr8RMz50wu+xDrn4alniFVbJg019GErKmp2oyW7wGuSysc5zcGBJIhUqnEMWD3VRO1N6xwMXi0XyiVozxplYWUENhq/6D3iDLi6vrP+vsDyP/rSvOdFudfI0nBWk9JlNaKrkBb9lQd310C9qLADXcdQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718655430; c=relaxed/simple;
	bh=yce2wFp6TCGYzpWaMY/EErqrWEou6iIHq4EkUTlU/ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXrJ0fKcDu6hgC3U0RsRwc/5ExzPr/ASs3WSt6mb6P9qrMaW+pas6lb+cBS7KwoU86+bRIHXIr95mNWNctuUAg2WlAo37FAIqoU+y7yPuHAmqCluNZSSfTu52eeyJkUmH79DPPlGm+GGJ7mOUm2mx4Wj3ijzmIrYHiNW6PCRxcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XhywdV6b; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XhywdV6b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZfjjmF/iuX9aEbomRavGQoA4UyUj7ddR1t2UsIv6Upg=; b=XhywdV6b04tzZjUB669Tli4OW5
	X/RLI00+HdAnduc/SYB6w3ajEvBL6EUik02gwuTmzvjPYWWHjdtTRJfh3yMY87/K3jRffVYZbpkPG
	q6zTdglAwmjEsySQuAvjUVT3EPYfwhDbgoko6nQ85ECQzKnhMG84mRPfMZAvYj9g86V59XBk1v6hR
	wm1CEj6GOwH3V5M3OjC05l8XjFlYIDH5GWvxJCWngyAoSJrCea2Fr62c41l+8tlnTfqsHEZvU/gL2
	/Wh8sVVjCT2FfDwsjlUn62oczwEC+pr0byrkZF5LilbY5lKk+mhvf+2DNWXBWyPVHUCOdCCmiWQv6
	U7Ih9xFQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJImi-00000002Qff-3UeF;
	Mon, 17 Jun 2024 20:17:00 +0000
Date: Mon, 17 Jun 2024 21:17:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rafael Aquini <aquini@redhat.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] hotfixes for 6.10-rc5
Message-ID: <ZnCZvOHqbp-itE_-@casper.infradead.org>
References: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
 <CAHk-=wjiUzOHfHaWgUcByAygaG6w_BKOqbTN6EHrDHaXb_i+xA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjiUzOHfHaWgUcByAygaG6w_BKOqbTN6EHrDHaXb_i+xA@mail.gmail.com>

On Mon, Jun 17, 2024 at 01:09:15PM -0700, Linus Torvalds wrote:
> On Mon, 17 Jun 2024 at 11:47, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Rafael Aquini (1):
> >       mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default

This patch wasn't even cc'd to linux-mm, so I never saw it.  I would
have NAKed it based on this already being fixed.

https://lore.kernel.org/all/20240606180622.102099-1-aquini@redhat.com/

