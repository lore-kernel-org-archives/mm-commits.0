Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6EE1422B8
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727271974; cv=none; b=Ic9jsDrFb3WagGPsYNJNWwqvEARhhEMgfQAQBgvzJj1vgngJrkjPp6C7NTwDJ8F0YrckYDnH4jlvN+Umk2Vqs+R/4wdbkD5TkXc3wxg/1FOD28+turFKieDn5t9+gb2Dp13qzKTxIdmf5YXZxus1wbFm6SoMPBa4y0FVJyQ37CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727271974; c=relaxed/simple;
	bh=/5DieIotP6ygOAEczRTsNxiJmAsxLagO21VkvwyA0lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxFkFdxjOPHoAummIBzDs07Mo3DjqIFu2XJw8Qr2wrBivBKFyt/qOp++K0mVb6vRr1xqetPip5Kfc/lav3GuoFLqzJCbj9qYcsu8RqInfdZSfQ4icHrgYclzMIYyn/zkALjXXjzn4hAAGjSLNtQ6nWCpWtqGcWbMB13v+h8dmq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kC3LhRdD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kC3LhRdD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=lnyrRIVZwGEmSSTjQTxl35npbIhgbjhCuBPKa9b2p7k=; b=kC3LhRdDukZK5lCVfcyAKOrJt7
	rP+UgDEtoScghbekpw+GMvIZBwKYC0oXPiG1m5Mz0LRIKb9tC+H991EErkNvEWM3Z3NV3dxl506FD
	s3Qju/s2pV+enjGa/xCsgwr24oKFOCSK5GG4IeGpjpWg3ir/YHWHMByYIptR10o1//p1kw6wRZ49T
	G+niHEwa6/TPXchY09Zgf+zYXMdavPKlsrrhdli+prNhRkrAyhLWe3lvrPXcNC1rpHxoYZkHMCk1i
	mk5IEETwO06JjzRhL6hD3RlElQLNV1ZXbzJ7jP8qlhs5qash3SrkjN0D3CPMZwU2z4ByT8X3mKWXu
	OZDLyovQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1stSLK-000000045nq-0Vcf;
	Wed, 25 Sep 2024 13:46:10 +0000
Date: Wed, 25 Sep 2024 14:46:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nanyong Sun <sunnanyong@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	wangkefeng.wang@huawei.com, peterz@infradead.org, oleg@redhat.com,
	mhiramat@kernel.org
Subject: Re: + mm-move-mm-flags-to-mm_typesh.patch added to mm-unstable branch
Message-ID: <ZvQUIXxkVmbdTkZG@casper.infradead.org>
References: <20240925100517.DFC29C4CEC3@smtp.kernel.org>
 <ZvP_g757PkAb6thl@casper.infradead.org>
 <42755d5d-f554-15d1-e0a7-2239f6d6bf1a@huawei.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42755d5d-f554-15d1-e0a7-2239f6d6bf1a@huawei.com>

On Wed, Sep 25, 2024 at 09:40:31PM +0800, Nanyong Sun wrote:
> On 2024/9/25 20:18, Matthew Wilcox wrote:
> 
> > On Wed, Sep 25, 2024 at 03:05:17AM -0700, Andrew Morton wrote:
> > > +++ a/include/linux/mm_types.h
> > > @@ -1499,4 +1499,85 @@ enum {
> > >   	/* See also internal only FOLL flags in mm/internal.h */
> > >   };
> > > +/* mm flags */
> > > +
> > > +/* core dumpable occupy bit0 and bit1 */
> > ... but why is that important?
> /*
>  * The first two bits represent core dump modes for set-user-ID,
>  * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
>  */
> Do you think if change it to this will be OK?

That seems reasonable.
