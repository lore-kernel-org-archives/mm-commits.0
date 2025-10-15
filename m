Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92052652A4
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 22:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760566217; cv=none; b=ACEe9+9DazSIaeK5roEtJiDQQFl5HSAsvQpxtxTKseb4tE00GuZxgQeFUY8tj3FRodohBTg0T0riJMtsYc+8b0iqyLU/8P/lxNggywlkRwWZWexYaZq5gPDLBby7RbgICNyxajN0dPIbubr83oHaSaz4qW//c8/70ydJlo0E9k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760566217; c=relaxed/simple;
	bh=l5CBgdi/4dMbGNEd2slMc+fNCEL98KwNfOYIIy9pUfs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=P1VF4Gx/YuN0tPmfTduUqfyKpxgLoYWluf29YGptDVa649JzQboktPgdhezt8SNtmf7f59WDkiuuSHHtfmpCrQr5TDhRD7ye62tJ+qFu0dhPZdEnX5u7BBiQih33O11LYY8HX7tr22r1fVOEEZ/3eHP4NGx2OcrdXB32kfNYWjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJ8B4DIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJ8B4DIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ED8C4CEF8;
	Wed, 15 Oct 2025 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760566217;
	bh=l5CBgdi/4dMbGNEd2slMc+fNCEL98KwNfOYIIy9pUfs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nJ8B4DIXCGOWzt3FooE4vq6H6flgXV33kS7CD07vO39eyDAiGQwYjbXr1rYwp7gf+
	 zs33tCM7WOirttAbI8LBcLh7maBYdmz4hzOAyuFVU3DBNPYoupoxh46frU47io23cu
	 8ET/VCWZp/6FHAqu2Iu2HycGOY5D8XDdq3hONtTc=
Date: Wed, 15 Oct 2025 15:10:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, guoren@kernel.org, rppt@kernel.org, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: + csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20251015151016.bf3f31797dea74558dc00c67@linux-foundation.org>
In-Reply-To: <aPAZAVMunRWb-QHk@casper.infradead.org>
References: <20251015215059.D610BC4CEFB@smtp.kernel.org>
	<aPAZAVMunRWb-QHk@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Oct 2025 22:58:25 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Wed, Oct 15, 2025 at 02:50:59PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: csky/mm: fix build errors cause by folio flags changes
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
> 
> Again, it seems churlish to merge Mike's patch insteaad of Thomas' that
> was sent two weeks ago.

I can't find such a patch from Thomas and the message-id you sent
didn't work for me  - what was the Subject:?
