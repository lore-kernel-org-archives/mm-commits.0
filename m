Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F329EACE
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 02:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739587498; cv=none; b=LWT9SiDjhPzgcvAXK0337Wu6Cw5tgtI4DijRxHLWT+ZF2Se8aStTbCFDMWzq9BKr1A8ujczGMLerW/D2dQLxKv1poSVuAMzZaLmT8KsEZF0tcvk9nhdXqPlPj3KRuk833AJkKjNo0YJRO9XHl/ZxoaSrxBthbk9+DCgtS3NCtQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739587498; c=relaxed/simple;
	bh=46kSxmM5iaHFQIokdsPHEf1zgs0vnEkAaG997uODjGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4fbaQkoxypWvIx2x856JH1LOmizJgLWo6ptFhDBmx/xAh/G45Kaw2dHL49WtXNphWNxFy0wvlQnkELXHNOHmApiwKFD/7Epmm2bDvjWAYlO73gJtbRcKW9aP9+goUunUH2ZYqTPwyCdLoKG1lR9SHjvxZF7o8857i635mYNIv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CMaalOh0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CMaalOh0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7C9Ek6LoPNiiqjOzp6S4sLjQmie7WmiQu8bbxoBBGmg=; b=CMaalOh0gh4zzDzKB+HsHfeTPg
	Y9D8uHea9kIW/HP43dpVUZJlM9NTD/F63D3U5Z6bDMsEXrAYses1mMkr9vrjPUva9kFGwC0t06afz
	B6h+GH7x8iUr3nLnckjL1j3HMDMFs1d2uYmMA8dLcVKl0ZjA+sO5ypS2h7tjRh3h4qnV03CyVUty9
	CuGthL3AvTRm/Qg6KKl1edloEmVYaDx59qiYOzebpnMHy46I2lH5E0h6kfXWawJ3JOUuG8ttNGUyy
	gInYy1FBCeGkjyhWk2ZvBMLIkIwwNiYyVW6u4fbvuVNalh/z76AII7JPCew2bOePSDmsS/gTMxrh+
	B7hmBuXg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tj8Ai-0000000CPiH-1Xen;
	Sat, 15 Feb 2025 02:44:48 +0000
Date: Sat, 15 Feb 2025 02:44:48 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
	jane.chu@oracle.com, dave.jiang@intel.com, dan.j.williams@intel.com,
	apopple@nvidia.com
Subject: Re: + dax-use-folios-more-widely-within-dax.patch added to
 mm-unstable branch
Message-ID: <Z6__oNi0a0dO0N1e@casper.infradead.org>
References: <20250214234034.BCF54C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214234034.BCF54C4CED1@smtp.kernel.org>

On Fri, Feb 14, 2025 at 03:40:34PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: dax: use folios more widely within DAX
> has been added to the -mm mm-unstable branch.  Its filename is
>      dax-use-folios-more-widely-within-dax.patch

I'm confused.  The patch from Alistair in -next that conflicts with
this looks like it comes from your tree?  I don't think this patch
should be included as Alistair's patchset is far more comprehensive.
