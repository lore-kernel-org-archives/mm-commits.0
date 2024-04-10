Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0E2181B97
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 20:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712780836; cv=none; b=JubuoJLYUGmJILYeNbzOTyAnxeuy4rV8A0AxSOiba8W69ZhkSRSiHm24PM5MOMQdsOnGLohYaBTjINThwkiF1tEOajluWXLIBpfiB0UCEfBFHeY7zLbyRAcTQSrZN1BvNcW1LBtnZNUCH6R824KrTYuDDc5E2Vo8kbTUj3CDTeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712780836; c=relaxed/simple;
	bh=W5Mq4E7y5ZEpzAJrKO4VypPZUmD23hhViMFVbV9pjtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lq5PcfxWGOn0gM3j4FJIJI3AWhT+jpcYztmzSrCtmO1noy1c3ftrx7fyA5wPdkuXAwsKZ0WJFyreLmwS3mnFzAK7ghG/beIRzjFmNh6tNuWFOF8vw2IVHSn4YB/p3ce6WRRnNJsocfJX8NXH8Wb7MBJ/e9/AOPyOYqRpkoaCo7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=esz52jVi; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="esz52jVi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X3SUPvsTuygzkBXlA5a8YOn40Mfb6mKbj52GFlk+QT0=; b=esz52jVihGE6J6V/aSEgZmn1kC
	+ETC2R3s0EKYbuL7UNGn5zP0rRu0SHZ2MPTsnuL1h5H+B3m5fyhJUGXNyBVYzhGFbu/JmzaPi0rVL
	PLM7FNCIOND8nnGb9StUYypmMfA6z7llX4e3VM0sZIshpzFhasYziXTRaxZnTBuu/XBNZqN3TY82F
	/Ori8TDgRvL3PH2zzSVfrbZF6LU/DD6Mj8nYIUvg1u2+Y8QuzteF/fr4npMGexUESd1CJhv6U3Ujn
	SLFUz/ZPdSX6MVbkHMRpMJVWNfccBcBpMfL98FzVe3cSgnPB9YorulmI4Jotni+OfR2srHTHvgFRj
	y8Wg9Umg==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rueXJ-00000005EIA-1hc1;
	Wed, 10 Apr 2024 20:27:13 +0000
Date: Wed, 10 Apr 2024 21:27:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, surenb@google.com, lokeshgidra@google.com,
	Liam.Howlett@oracle.com, apopple@nvidia.com, peterx@redhat.com
Subject: Re: + mm-always-sanity-check-anon_vma-first-for-per-vma-locks.patch
 added to mm-unstable branch
Message-ID: <Zhb2IbDiIy2paMLV@casper.infradead.org>
References: <20240410181057.9610AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410181057.9610AC433F1@smtp.kernel.org>

On Wed, Apr 10, 2024 at 11:10:57AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: Always sanity check anon_vma first for per-vma locks
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-always-sanity-check-anon_vma-first-for-per-vma-locks.patch

I just sent a review NAKing this patch.  Replying here to be sure you
see the NAK.
