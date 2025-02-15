Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3221426C
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 03:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739588682; cv=none; b=AOaozyq3oJVo9RAlT0M1OrVloj877mwQmWO1+FEMe38kSm/tFHMZPHbDmC0pE2lwMmHmXkw2cWZ7RZhRIQMtsnDl+X8w5MbTlDpJq2+N2pR+s9jU2eGRQvTsnVaeyYhEuIKZqmvanj781jyY467Rof7GXLLZ2ggnTPCoGZXSFK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739588682; c=relaxed/simple;
	bh=ypw7j8wnC4vz846/5MhIAVZ4pZg4i7O6XyWoy5tpnKA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fioM3oLCoEIZ7dc7O+tRVFiWWVDfbV5B1nTzwPbPOvfYRTtOK5fWCEDvBvbk1ycxgiZxUaTpE2uJ4UpkxK8zHz6OWeeToHvsn0GpVcqJlPbPDbljuCXEKOou/AzjtM/4/rCWCeHguvZkQOAlggQoHj0yhpSWWNjNYneQr9u3v7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2sgj7LRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2sgj7LRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4883DC4CED1;
	Sat, 15 Feb 2025 03:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739588681;
	bh=ypw7j8wnC4vz846/5MhIAVZ4pZg4i7O6XyWoy5tpnKA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2sgj7LRLcWxILnghRMnnAY6L5/1ZzkAsK1x2cCHiA85J0R4XyyLgz6ZZ5rPRJ0crS
	 PkismVVS/FneFGTGsDfRZfH0PQjIBry4TuFZsEboHxcZ1ljT9Hgw49RRHXPQ+VrNC2
	 BI3xDDpiZfcakf9XyF+nqYbDQ89l+D/Tp9SBG/Uw=
Date: Fri, 14 Feb 2025 19:04:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
 jane.chu@oracle.com, dave.jiang@intel.com, dan.j.williams@intel.com,
 apopple@nvidia.com
Subject: Re: + dax-use-folios-more-widely-within-dax.patch added to
 mm-unstable branch
Message-Id: <20250214190440.948e7b16e76aa4f2bacae846@linux-foundation.org>
In-Reply-To: <Z6__oNi0a0dO0N1e@casper.infradead.org>
References: <20250214234034.BCF54C4CED1@smtp.kernel.org>
	<Z6__oNi0a0dO0N1e@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 15 Feb 2025 02:44:48 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Feb 14, 2025 at 03:40:34PM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: dax: use folios more widely within DAX
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      dax-use-folios-more-widely-within-dax.patch
> 
> I'm confused.  The patch from Alistair in -next that conflicts with
> this looks like it comes from your tree?  I don't think this patch
> should be included as Alistair's patchset is far more comprehensive.

OK, thanks, noted.

I've removed Alistair's "fs/dax: Fix ZONE_DEVICE page reference counts
v7" series from mm-unstable as a new version is in the works.

I could drop your "dax: use folios more widely within DAX" when
Alistair's v8 is received.  But then if that v8 gets re-dropped or
nacked or something, your (good) patch gets lost.  To avoid that
possibility I suggest that Alistair redo his v8 on top of this "dax:
use ..." patch.

