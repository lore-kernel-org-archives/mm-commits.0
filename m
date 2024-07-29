Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D01B84A36
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722285067; cv=none; b=Jz4mfAcptJUI8MQFeOLiG0rMmPySRAfCoN3P3QVWPicHsptkJ356akMUMpd9yP5wwPz6DZ+Qx8HQU8T1TyhPhdqn0wjhfZzPFQtB3Nk2poXw4FBWHGLxxRC6yYNbB1tBkh8o3e/nIceulCn3LPJ9S+z2BA1e4/SJpRs9nQAAaFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722285067; c=relaxed/simple;
	bh=ICTevch6fupPL9JmIhxCuvWSvNyCLk0XxTg34RMdKMQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=tyTJhYmHOy/1uCj5mVrygw9tVd1fg1KuGRP/tQvzWh3E4rTgYitYmd3iCH9I+3PBlqD5+DyRDt0/0MvvfN8idJuiO5n1M+IZIlKQyhznRmxxiejYX2idf8WZ/K9toMIl81xH9jhfSipIdHv8Z6aJheGCIAfoniJDwq4cCWiIXNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZJHIVmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZJHIVmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08431C32786;
	Mon, 29 Jul 2024 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722285067;
	bh=ICTevch6fupPL9JmIhxCuvWSvNyCLk0XxTg34RMdKMQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SZJHIVmyyuBYFp/btKF6JpZd0sIW7oGRrF7yrp+d4ERTagMfGKgtzRbyiBqayI8tn
	 Uyvel/1Xd6juKfqJKfMygn9dGcVF/t3aHrjQeyb4q2HWbmFqzbFRHayjWm2ERnJ7Qu
	 4o1vpHHb6WJGbhJ/Qq/jxYXy2jE4dBqmYbtW56ZE=
Date: Mon, 29 Jul 2024 13:31:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: mm-commits@vger.kernel.org, biju.das.jz@bp.renesas.com,
 npitre@baylibre.com
Subject: Re: + mul_u64_u64_div_u64-make-it-precise-always.patch added to
 mm-nonmm-unstable branch
Message-Id: <20240729133106.07068e6e3843611e1b126c88@linux-foundation.org>
In-Reply-To: <sgcnxxunli3rbzlf76aqf7rrtfczbtzya344lka2bms643pyxi@y6i3tj42zgis>
References: <20240708215551.35A6CC116B1@smtp.kernel.org>
	<sgcnxxunli3rbzlf76aqf7rrtfczbtzya344lka2bms643pyxi@y6i3tj42zgis>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jul 2024 16:34:08 +0200 Uwe Kleine-K=F6nig <u.kleine-koenig@bayl=
ibre.com> wrote:

> Hello Andrew,
>=20
> On Mon, Jul 08, 2024 at 02:55:50PM -0700, Andrew Morton wrote:
> >=20
> > The patch titled
> >      Subject: mul_u64_u64_div_u64: make it precise always
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      mul_u64_u64_div_u64-make-it-precise-always.patch
>=20
> this patch appeared in next-20240723 as
> 3cc8bf1a81efde105d8e57398cf8554b57768777. But it's not included in later
> next snapshots and also didn't land in v6.11-rc1.

All of mm.git has been excluded from -next for a few days, as it
contains rather a lot of 6.12 material.

> I have some patches pending that rely on mul_u64_u64_div_u64 being
> precise and want to add a variant that rounds up. So getting this "in"
> would be great.

It was a bit late for -rc1.  I plan to add it to 6.11-rcX soon via
mm.git's hotfixes branches.  Please send along a more complete
description of your need for more precision so I can add that to the
changelog to further justify a post-rc1 merge.

