Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A0B1FECBD
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 22:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745448651; cv=none; b=ilN7vK3MNCZab1ToyC9x9xo9CLMC62E07b4HEorVdBO2kKziGofbOMd5ljN0MIc/qy8Pj08h7EPTr/yIdPpN/eSOCBFR4OdLmwMMlaw7MSvBkaY3amV2asgIqG+GkgUKXfTtDPLt1kvRkKG/wflIUZIDM5EVrDqJ/AUZu2+c7Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745448651; c=relaxed/simple;
	bh=68zgmBvZPs8SlEx14y4XeepQ0dKO8hyLSfqvuG+kpPw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fec1gUFk2MM/4hE1P6KFlmUQhVewQmMnXSP/A8tWLQ9nj6/YXo1tMj7Iz1hDY159NaYUUD3Xh/OSLvWZsIQm90jz90gXE93lsLO9Nz7v4yrdt4r29CyE8uGs7suIZvOpAoHZJyWuv/26GDndLbUkKC1RT1ma25W1GF1mWOxRCY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QMELwhW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QMELwhW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57E8C4CEE3;
	Wed, 23 Apr 2025 22:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745448651;
	bh=68zgmBvZPs8SlEx14y4XeepQ0dKO8hyLSfqvuG+kpPw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QMELwhW4AixyFK/jNXDzWof3ZSUPrvXffu6WJNMsJq6fSAUrP19Zs7NRum6Qrz+BV
	 U5PIyUCFNcYj2aXeT3WdPbJADFCZYAbrKm3lXam1nz1cCaoKs8NjfBTbBcvQouZzI/
	 jYPBi2iV72RRNOtetSXBjXeNa7WxvgNcwHTkkF5U=
Date: Wed, 23 Apr 2025 15:50:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: mm-commits@vger.kernel.org, will@kernel.org, rppt@kernel.org,
 maz@kernel.org, mark.rutland@arm.com, lrh2000@pku.edu.cn, david@redhat.com,
 catalin.marinas@arm.com, ardb@kernel.org, anshuman.khandual@arm.com
Subject: Re: +
 mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch
 added to mm-new branch
Message-Id: <20250423155050.512589fca49a84dcb6db7437@linux-foundation.org>
In-Reply-To: <a79ce7177da2d8d47e9247f8274503089a2c823c.camel@infradead.org>
References: <20250423214930.C9D7FC4CEE2@smtp.kernel.org>
	<a79ce7177da2d8d47e9247f8274503089a2c823c.camel@infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2025 23:43:56 +0100 David Woodhouse <dwmw2@infradead.org> wr=
ote:

> > There are cases where a nave loop over a PFN range, calling pfn_valid()=
 on
> > each one, is horribly inefficient.=A0
>=20
> Hm, that definitely said 'na=EFve loop' when I sent it=B9.

I guess one of my eleventy scripts is stuck in the 90's.  I'll take a look.
