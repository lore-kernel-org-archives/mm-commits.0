Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE265223DF5;
	Wed, 13 Aug 2025 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755064836; cv=none; b=kdi8TsuMkGZSKPEOuNu1FKNgTAVlZJnmIiRT3l4GkDWL7KByl6wrXY8CUH8Hz+E8AUZdNRdWzlRB93cjkp7LDhODLMQ/t5/e8PPbIc886fmdFqDuIvvK9DCNYGNwVCcOSJ5HvljWP4MgAQKQHes9I8AFXGCw9x8/ZNh5P90ZhqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755064836; c=relaxed/simple;
	bh=gUwV6Vf6QGgTE8KjfTKH/cHCjcr8wpLlxefJASTfZUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJre9rSYQ29vaL2bk8Re56Ub0RU6+FuKsDnU89zFVAwpZjVmaEpptJqFH/CIedEYvkdbpkXkzQLFBqRUWE5F5634QR3g8hVvHF2tLEkwMq0IRqQbSuiAZ5hClw5W0Nr6FbErgEZMQUoPN/ijDr4m+OFWUiknRRJAQZ8Fv9TwPXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=A+xV3iG+; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="A+xV3iG+"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 2AA9D14C2D3;
	Wed, 13 Aug 2025 08:00:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1755064832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FKuYS5eg3Chh7fezaifP9b4J3wfHo/LxRYaoofRoLl0=;
	b=A+xV3iG+B1ktXCVydGHCid5h57sHdRnqw78Ggo8mPV1XuMaRFCg3ntGnugZj+NjyVj5tYb
	TBY96/IBjGjmd2bjyj/1d/EUqMHHKrfBbREO00yu17kVp7unCgtj2AOt6Vf5BrHE6ewkmc
	25SvyJ3HTTrmQVJywuTmplnEqiRxE6u0XkZgFVrIjKGUPrKFHVWA5Hpw3UZjy64Qbxig9k
	YW/tvnCtislexZDwfgvtwDPFHABP7lGMq4lORgXbYnBQxQpPuEo0FxyKx3plOLJxEiU06m
	b/Hisx60UQ3qtXpbmXXXUkZcLulJ14A/Ku2oICEwM9S2TCdXoJPbwzMxLS59Yw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id f649ba61;
	Wed, 13 Aug 2025 06:00:27 +0000 (UTC)
Date: Wed, 13 Aug 2025 15:00:12 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	viro@zeniv.linux.org.uk, stable@vger.kernel.org, ryan@lahfa.xyz,
	maximilian@mbosch.me, ct@flyingcircus.io, brauner@kernel.org,
	arnout@bzzt.net
Subject: Re: +
 iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch added to
 mm-hotfixes-unstable branch
Message-ID: <aJwp7FO0Twyhej0o@codewreck.org>
References: <aJuwDfwoSUP_M_0D@codewreck.org>
 <20250812010237.B52F8C4CEED@smtp.kernel.org>
 <650364.1754991487@warthog.procyon.org.uk>
 <677795.1755034711@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <677795.1755034711@warthog.procyon.org.uk>

David Howells wrote on Tue, Aug 12, 2025 at 10:38:31PM +0100:
> >   26923	  1104	     0	 28027	  6d7b	a.o
> >   27019	  1104	     0	 28123	  6ddb	b.o
> 
> That's a surprisingly large change.

Right, because the function is inlined multiple times in iov_iter.o it
turned out rather big... Here's what it looks like from busybox's
bloat-o-meter, which gives a better picture:

function                                             old     new   delta
iov_iter_zero                                       1706    1738     +32
copy_page_to_iter_nofault                           2491    2512     +21
_copy_mc_to_iter                                    1604    1624     +20
copy_folio_from_iter_atomic                         2620    2633     +13
_copy_from_iter_nocache                             1706    1719     +13
_copy_from_iter_flushcache                          1409    1422     +13
_copy_to_iter                                       1885    1891      +6
_copy_from_iter                                     1874    1880      +6
iov_iter_extract_pages                              2182    2166     -16
------------------------------------------------------------------------------
(add/remove: 0/0 grow/shrink: 8/1 up/down: 124/-16)           Total: 108 bytes

So the compiler obviously doesn't optimize the if (at least with
whatever default flags I'm using on gcc 15.2.1), but the impact is only
that big because it's copied so many times.

Anyway, as said before I'm happy to prioritize readability here, so
sending a v3 with just this changed.
-- 
Dominique Martinet | Asmadeus
