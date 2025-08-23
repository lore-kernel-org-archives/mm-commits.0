Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FC5AD4B
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 01:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755913699; cv=none; b=o0UhqhmdJGJjNfT8pLc3XT72vsBwcV0Yp+pt+dT5ovXxDqpx7DfQbX7rVA73MIY6sMzxVLRgRNbrod2DJosxaB3JIt1XSBQxXo8GzKEjfXSMo8sp/SKJdBvfUIyB8j4kUUpqW9yH2LRlHbStim/eg+z30N7+t0+uSf8xeqof408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755913699; c=relaxed/simple;
	bh=6eIjw0ONbyQ55IcJXsUHbps+XtL38+sSsmphmCkyayY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=J5yiJNlfXE4ukc16Y/XQPupnqsqxl6PXwYDYFpXIl0oCj9DhlKt9suqfWJErTZq3IaQR64Ve98AQERCdQAgVVfJL7uv0ACcpkL1AQu/ZJ0outLmPntDwT82m0mb1J2wqLI8V9fOx+6EoV3K5wKiYvGGKicgKweCfdfMrGldnDVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xFnz651r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xFnz651r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F043C4CEED;
	Sat, 23 Aug 2025 01:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755913697;
	bh=6eIjw0ONbyQ55IcJXsUHbps+XtL38+sSsmphmCkyayY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xFnz651rnzQf+5FHaKIIgvLx0/qhE6L19/gHiiVvA273cRRpI5OW74iMfgDTp1r/G
	 CupT9qI8siQasx/9V5ljsBccT0vlfHkvyba5g1SkqShFtg2m4U6CXnsduWQxu1MwJZ
	 7kUPTVmIwI0b/zlzhijyoj5VKeydUQ0fTWPk5yBY=
Date: Fri, 22 Aug 2025 18:48:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: mm-commits@vger.kernel.org, vgupta@kernel.org,
 lorenzo.stoakes@oracle.com, lkp@intel.com, liuye@kylinos.cn,
 dev.jain@arm.com, david@redhat.com, chrisl@kernel.org
Subject: Re: +
 mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
 added to mm-unstable branch
Message-Id: <20250822184816.9cc697b714431e0952fdb0ee@linux-foundation.org>
In-Reply-To: <2D142A2F-4D76-46C9-9E4F-760F9CFEA6CF@nvidia.com>
References: <20250822220159.7AB3BC4CEED@smtp.kernel.org>
	<2D142A2F-4D76-46C9-9E4F-760F9CFEA6CF@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Aug 2025 18:37:45 -0400 Zi Yan <ziy@nvidia.com> wrote:

> > --- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
> > +++ a/arch/arc/include/asm/arcregs.h
> > @@ -146,13 +146,13 @@
> >
> >  #ifndef __ASSEMBLER__
> >
> > +#include <linux/mm.h>
> > +
> >  #include <soc/arc/arc_aux.h>
> >
> >  /* Helpers */
> >  #define TO_KB(bytes)		((bytes) >> 10)
> >  #define TO_MB(bytes)		(TO_KB(bytes) >> 10)
> > -#define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
> > -#define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
> >
> >
> >  /*
> > --- a/include/linux/mm.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
> > +++ a/include/linux/mm.h
> > @@ -75,6 +75,8 @@ extern void * high_memory;
> >   * PAGE_SHIFT is the shift for page size (e.g., 12 for 4KB pages)
> >   * So (20 - PAGE_SHIFT) converts between pages and MB
> >   */
> > +#define PAGES_TO_KB(pages) ((pages) >> (10 - PAGE_SHIFT))
> > +#define KB_TO_PAGES(kb)    ((kb) << (10 - PAGE_SHIFT))
> 
> Left shift and right shift with a negative value. Aren't they undefined
> behaviors?

bah, thanks.  This?

#define PAGES_TO_KB(pages) ((pages) << (PAGE_SHIFT - 10))
#define KB_TO_PAGES(kb)    ((kb) >> (PAGE_SHIFT - 10))

