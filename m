Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CFA1D9663;
	Sun, 13 Sep 2026 04:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789272756; cv=none; b=XaoBjS3ge/FnE1KxfE2UySTPQM8bQ9JYlMXDS0CS+npFv1rq8eyXxbGMBgPGhnJpTUSYIkpBzUGRV1yOPrnVXDsQDqmt+WA4ojA7JTh/2lZtS7a7l4pxyIsCaljM390Pl1OMZ+F5nsNIgbeUqzPiKRdPY+bRCPvpZZIkDG97w1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789272756; c=relaxed/simple;
	bh=iBWr4acveOkcwDPMd6TPQkCXnvPHEgqH4cfbiHlg9yg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=DMNt9zGQlnhQmzPW+USbW3J/EvjWxE9542Bj1E8Yl+Xg2br8hjI4ZD9Cja8jekvaUsp6AZZ3nqUZonC6fBX+1FjCVYgOgLDGVIJvmk1lGzfCpRzOkIOlWiOrUtqaGjkC8BA1J6gUwwX7NV7GDg3ibT0CGPhrLQARww0qJYI0SHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sWkgAtZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sWkgAtZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2861F000FF;
	Sun, 13 Sep 2026 04:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789272754;
	bh=eVNDefGcJZBq6zWgURaVBtCF0sa3QbVuYsr3pmVDqhs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sWkgAtZ78z5wkB8MCt8/uAVEQAzRNK99bUx/lVnXr3On9tqV1zWe1rlExGVxCMM4z
	 kko9Y5SBRDx/zb+hYYHundto//oHEDBV/4Gpfmcqur+eedcyD7PkVf2U+dEL+Uo7WD
	 /hWkf6+T1JxGHUUTlVqzOMgQ+TqyWQ7QtbsLmB8I=
Date: Sat, 12 Sep 2026 21:12:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
 stable@vger.kernel.org, ritesh.list@gmail.com, mhocko@suse.com, hch@lst.de,
 hannes@cmpxchg.org, dgc@kernel.org, david@redhat.com, dipiets@amazon.it
Subject: Re: +
 mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20260912211233.53f3e72bc35447972132940a@linux-foundation.org>
In-Reply-To: <aqYKsTHkyJXCyh_-@casper.infradead.org>
References: <20260911163243.808DF1F000FF@smtp.kernel.org>
	<aqYKsTHkyJXCyh_-@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 13 Sep 2026 03:30:09 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> > Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> > Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> > Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> > Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
> > Link: https://lore.kernel.org/20260911142102.2294202-1-dipiets@amazon.it
> > Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> > Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Dave Chinner <dgc@kernel.org>
> > Cc: Ritesh Harjani <ritesh.list@gmail.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> i'm just back from vacation, but i think the patch i posted was the
> better way to fic this.

whatpatchwasthat.  It was like 7000 patches ago ;)

>  at this point i'm confused why this one is
> being considered, but i'll review all the email from the last two weeks
> and see what's happened to cause this one to be included.

No probs, thanks for informing.  I'll add a wait-for-willy note against
this one.

It already has a few notes - hannes preferred an earlier version:
https://lore.kernel.org/all/aqQlUr-1h07G8JWM@cmpxchg.org/
