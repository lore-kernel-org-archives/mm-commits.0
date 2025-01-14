Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E7E22DC20
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 09:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736846614; cv=none; b=Q0p18R/McLSeV97UyrY+uNm8hJSJAEuoNYRUZzlvTf2BN+5ZgfrIZ1+qVyAD3vCGu4Fe0KwJ42GMvlKbwoN/PtjP9tOajl+cg0jUDQeWAlRuJPPh4kStSXdMuG4GDLt1Exv4RseWYWmVx8Ld1oYyCiTDEHwa0dNlHtCcEjOvMhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736846614; c=relaxed/simple;
	bh=AO6Ho6EvQcvcSP0huPYpZYCHeW6efsTL9+bKNTyS77w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OwvvFUeI1GkBhD4arSWZfFfLUra8Vtcy5voTv9x1dhWZ6DPcCimMCrWsnGIp3E3Jrt23TY9KRcL2wXjyRUrXmpIxOa66CFKpLiOgerUg63BkIe9sZyn3msiPbQMVlvC1mQFxwSDTb7VO7/t7TOy+1zzaRnFMj/La3NiyduzSQY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WjhvDRn0; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WjhvDRn0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bNtiZEdV6FqYThFEHdt7/7ZIJET0rprZAUXXO3eKqaE=; b=WjhvDRn0wbPwTlwQu2Uk9e5uhD
	UcAg6g7cLoGq0rJCGJ9BT92gPMfQRQ1eHFAexoVJz2I0pURiwH5upbmja7SG1Ck/TjW50VftC9JpB
	3a3gmhjv+itaUhr7vbVNKl4n6/2lipgKJ4/aIMKRn27AX8Hh467BALHIYdBS46PVeVUBuEno/rYKl
	h6ICqPgIQh69b/27tE2yGk+2mLpCSSi9qqg0Gusi1cEQ/pb5LELGeLuvIsLkbSGlUgTsC69qet4Fr
	k1iHYW1pUF8gZIQrqhGG+2DCSvxiBhgqNSSLtzvsXIHNGu7Anbg9fE/hC4XyZ+vTt928aqxFnY2EU
	/NCJF+tQ==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXd8v-0000000ARJ6-0btQ;
	Tue, 14 Jan 2025 09:23:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BA20E3004DE; Tue, 14 Jan 2025 10:23:24 +0100 (CET)
Date: Tue, 14 Jan 2025 10:23:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ville.syrjala@linux.intel.com,
	rppt@kernel.org, mingo@redhat.com, bp@alien8.de
Subject: Re: + x86-disable-execmem_rox-support.patch added to
 mm-hotfixes-unstable branch
Message-ID: <20250114092324.GJ5388@noisy.programming.kicks-ass.net>
References: <20250114022443.DC934C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114022443.DC934C4CED6@smtp.kernel.org>

On Mon, Jan 13, 2025 at 06:24:43PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: x86: disable EXECMEM_ROX support
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      x86-disable-execmem_rox-support.patch

The patch was already committed to x86/urgent, why are you insisting on
merging x86 patches :-(
