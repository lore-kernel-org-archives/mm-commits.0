Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61852CCD0
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389551; cv=none; b=s2hCTs7uZWIn79p05dlpDdPPOgEGim4cNyAx+RJBaIIXpDzJ156+47oLmz7EVEcic0aiDVpTEZqBGt/8d9zutyR1zsGDoQdlYO0JA4xjDFKzrlggEiL+Lcy7Pi15L9Ad99jlvd/+t1UcFA3drrGZRTflvYM+LvpO+lR80gCZQ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389551; c=relaxed/simple;
	bh=GQ1hMQwwIcVXuzkhWgauGfW9Zyb/7EB2L+Am5AichnA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=i8M5wRnR5hPy9vqibplfs56MgC9hgXBFLGMBXLUeBUWNEmw3MVobzbhRb4lx7jO1UouvaRVdZGvbBncP0E6gTMmqCbKKrUStRml074Se4mBQ4xlV3xwS5chm2JFIFaVQOEDgYGPrUajhRMmbHjy7NcJlyGTJcDff+Ulendt3BwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MjR6FTip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MjR6FTip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B83C2BD10;
	Fri, 14 Jun 2024 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718389550;
	bh=GQ1hMQwwIcVXuzkhWgauGfW9Zyb/7EB2L+Am5AichnA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MjR6FTipRoJrt/Py/QRELjVYmZ90osU1VVjFjOQbaKnLrlXx5U5tJOwrn7VinSrBP
	 p0fBQCrK6HkUpDb+6rT2ekdhcYifqUo59pPJonHbRtraET7TJZ42960b8jLPbCQG7e
	 OrP7cqar9HbMgzn5h2fZjrI9WP0NSiyT56L+Of18=
Date: Fri, 14 Jun 2024 11:25:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Xu <jeffxu@chromium.org>
Cc: mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject: Re: +
 mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20240614112549.7edf65ca59b1899fa7687061@linux-foundation.org>
In-Reply-To: <CABi2SkWSip60dF95A_UeViAWDP=EMVULdqBeU+5tXw5E0osFnw@mail.gmail.com>
References: <20240612192325.009E0C116B1@smtp.kernel.org>
	<CABi2SkW4eg27XTe6otutK8P1MgK0MMnLdwWAuEDks98_aZku=Q@mail.gmail.com>
	<20240614103154.2dea6d48dfbbb2e1328acc9f@linux-foundation.org>
	<CABi2SkWSip60dF95A_UeViAWDP=EMVULdqBeU+5tXw5E0osFnw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 14 Jun 2024 11:05:58 -0700 Jeff Xu <jeffxu@chromium.org> wrote:

> Hi Andrew
> 
> On Fri, Jun 14, 2024 at 10:31 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 14 Jun 2024 07:32:07 -0700 Jeff Xu <jeffxu@chromium.org> wrote:
> >
> > > Hi Andrew,
> > >
> > > By fixing the document, the usage of MFD_NOEXEC_SEAL shall be clear.
> > > Was the previous patch (which  changed ABI)  removed from unstable ?
> > >
> > > I pulled the mm-unstable this morning, it seems that patch is still here.
> > > I'm not sure about the process of reverting it, hence asking.
> > >
> > > c1e11be9abae86ebe5cecc42abc412f61ae563c6
> > >  memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
> > >
> >
> > I'm not completely sure what you're asking here.
> >
> > Please try not to use terms like "the previous patch".  There are a lot
> > of patches!
> >
> > I *think* you're saying that the patch "mm/memfd: add documentation for
> > MFD_NOEXEC_SEAL MFD_EXEC" (and its two fixups) are tied to the patch
> > "memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`".
> >
> > If so then this escaped me and I shall rearrange the grouping to be
> > more logical.
> >
> > The base patch "memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`" is in mm-unstable but I need to revisit the discussion to see whether we should be proceeding with it.  Any guidance you can offer here will be helpful.
> >
> >
> Apology for the confusion.
> 
> The  patch memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`"
> changes ABI, and I think it is risky and should be removed.

OK, I'll drop that one.

