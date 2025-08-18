Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D4200113
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 03:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755486488; cv=none; b=Kra68dgCI29GmwkcF0bV5IZ5NZHE9UDyA9gK6J3Zs+0oF7SdlqO3+j3+difb+fVo8A8DnZQkEgVxtY2yfD3DqPJt8TE4JXbJ993H8KxzNuPH6N71HsfKDa00XB3BcThKWFfRaRLUawS8oVDw2xlMD38fjpcRG/pJS4E1C+vF3ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755486488; c=relaxed/simple;
	bh=sNym8G/sgDtML+FNk9Qx5bmHmyKRV8akdY0cS1O0t34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXtTC9pJFcmAf+nxMGY2bLtFFPxohSnJqV9vJusWM3gVPR1DXXdPTNIMTPBKgmCLXA7AVZ0I1PZOa6Q9/0kE8y02F8FSETSMfGa5QI18XfCCVTk+YDW3vSFrXBtL3lr5NjGHwvLZzd0OXssPb6T0/ape0FnxRyyCt1EVo5qpz4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GtzjakWX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GtzjakWX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NT4Ye4OEr6Jzg4fc9d/W0ZuxP+0DyApTbsj0E2UuNws=; b=GtzjakWXmuQ6xUXfzel6hvcJOg
	Yc7AjNJS0bafksJp+p6tvqSCeKeBAWqlH03lS2smkl/UU8YA0LlGjW8YmHCKWx1IBkfVZW5ooxCxW
	UWQ2y/BX2b257qpXPdfqB5d5pYttG+lyFnejBgfxY+JGzE3+XX18Cwjbe0srbmbYBlVIEBVq0R7JR
	7VDBrDMGYQNavk7JjpH9Xkh4jJHkvgGpEMN6BPI12v9AheXA5N50KVRD7pBqszaP69uBzfILJbdi3
	KWYpe24SlejYqxfzdlVjtlzAVGjL1SX3qS/QLjxNzm3iRL4nXvRq9Xkiid5MfiRB+2IkrLFrkNYsN
	CRVFWS6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unqDw-0000000H9Zj-15yn;
	Mon, 18 Aug 2025 03:07:52 +0000
Date: Mon, 18 Aug 2025 04:07:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, Yuezhang.Mo@sony.com,
	viro@zeniv.linux.org.uk, sj1557.seo@samsung.com,
	linkinjeon@kernel.org, jack@suse.cz, brauner@kernel.org,
	chizhiling@kylinos.cn
Subject: Re: + mpage-convert-do_mpage_readpage-to-return-int-type.patch added
 to mm-new branch
Message-ID: <aKKZCBHCNQYxWKXX@casper.infradead.org>
References: <20250818024604.7A133C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818024604.7A133C4CEEB@smtp.kernel.org>

On Sun, Aug 17, 2025 at 07:46:03PM -0700, Andrew Morton wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> Subject: mpage: convert do_mpage_readpage() to return int type
> Date: Tue, 12 Aug 2025 15:22:25 +0800
> 
> The return value of do_mpage_readpage() is arg->bio, which is already set
> in the arg structure.  Returning it again is redundant.
> 
> This patch changes the return type to int and always returns 0 since the
> caller does not care about the return value.

This makes no sense.  If the caller doesn't care, then it should return
void.
