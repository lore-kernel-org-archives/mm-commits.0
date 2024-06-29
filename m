Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CCC21364
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 18:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719685408; cv=none; b=PlQ8JND9EP8fWOS71TpwqZR+G/0hatttltLaRUD7yO92ehjPWuzDEKXxnXht28y92gB/1H8xja1++ZUVEU83E3I2TPBsU1OqNdKNdd2nMP3wor4IZS1Ocy64YJJznAR39+KIaOfQiUqKQq55waG6V3Hw5Axsk5rN+r2dAGpQ9v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719685408; c=relaxed/simple;
	bh=edHMhQ4/0LnygLIWf5GaSIK9F7fmMPc2/i2jlJJq454=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=aDRt/qnqjr88SFq+wfcxTR8nET2mw6z3Hs2q31wcTrmMEGQg8sM4j+vtP6KPAKRU9GQDunNFCpPJuxudNBUPaTap3iKx2QR/GCDo70+jdZRNsiEd4jrnTueCM13XvdoMnBTo3AGhpFReMoDL52zR01uVUBmeq2BTCm488Xrkw2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQpxgD/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQpxgD/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD48DC2BBFC;
	Sat, 29 Jun 2024 18:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719685408;
	bh=edHMhQ4/0LnygLIWf5GaSIK9F7fmMPc2/i2jlJJq454=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FQpxgD/hPdwcalu76Zu3dBdjqkznQ7/cOnY0sppovluE8aGu2g/1a9Hug87qC7zkP
	 9ySQt6CxTD2xVEePg7CcLQQQmYIsHdpdHDmv84GKAot++ceFJao2OejETFzYBAWELE
	 UzgwWKqqb9nbeR84GDkxLZH3I3VsTyv/OdsF6ZJU=
Date: Sat, 29 Jun 2024 11:23:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <baohua@kernel.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, nphamcs@gmail.com,
 hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
 chengming.zhou@linux.dev, yosryahmed@google.com
Subject: Re: [merged mm-stable] mm-zswap-add-zswap_never_enabled.patch
 removed from -mm tree
Message-Id: <20240629112327.0bc8e8ec5c4c314d90b9eb26@linux-foundation.org>
In-Reply-To: <CAGsJ_4zt+zuO9HJs-cVhybd8E7mTgML7MjwJgYDBdWdDM9Wo+Q@mail.gmail.com>
References: <20240625050128.597AFC32782@smtp.kernel.org>
	<CAGsJ_4zt+zuO9HJs-cVhybd8E7mTgML7MjwJgYDBdWdDM9Wo+Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 29 Jun 2024 19:52:04 +1200 Barry Song <baohua@kernel.org> wrote:

> >  struct zswap_lruvec_state {};
> > @@ -64,6 +65,11 @@ static inline bool zswap_is_enabled(void
> >  {
> >         return false;
> >  }
> > +
> > +static inline bool zswap_never_enabled(void)
> > +{
> > +       return false;
> 
> Hi Yosry & Andrew,
> 
> Sorry for reporting the error too late. It should be "return true".
> 
> As it has been in mm-stable, do we still have a way to fix it?

Please send a patch in the usual fashion, with

Fixes: 0300e17d67c3 ("mm: zswap: add zswap_never_enabled()")

