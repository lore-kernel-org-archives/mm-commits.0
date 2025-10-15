Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D1630F95B
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 22:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760567808; cv=none; b=sEDuuMiIJBRmWjlJ1gM28sUzNDJTEcDdOWR4ELGbxuhc0mm81jWhH2N5v6OGSjUBU18+PmTmfG2IPgDT7XpId87PC5S7F5dgTZbPn4mbTNbocryDghHmYaVCPriPbJ1v+xFWgE5/v4kD8IHx2IxP/0E6yigGX8sMwZGDZ8FGm7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760567808; c=relaxed/simple;
	bh=r0pAPGmyShwaP+YVawzpRUOn8bOg48KbwREfwg49k8w=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=uo3hyKvjIO6rz0jc8eGqHgtYK5Ovlwn7jhONC8PeoRo7IolygwYcc0dymz2UnG/syrGsD9A33wIkiEWaYYyHyoUG5df+Fu0pC/dJkYobgn9Sc6+J1J6Wbyadrs4PrG+ZOTEJ2B64VI2I0wfOTWXLbHDzLMkDAtJRkMDkZGf9Scg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3SXhH+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3SXhH+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B92C4CEF8;
	Wed, 15 Oct 2025 22:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760567807;
	bh=r0pAPGmyShwaP+YVawzpRUOn8bOg48KbwREfwg49k8w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j3SXhH+yVUDaSxolprF5jbVJemBcBtyswiGl/tPvQubbIOsQNjkXfXlxqdkm83Iak
	 RjbQxmZ/Um+J3xCJdYupSKFwt9KIbS2ne+dhOm5Xibra72ReAk9yp502OiEO2l+ICC
	 FrK3/CTaR8QRim69s84e1qcp6L94DbpnmOuryYek=
Date: Wed, 15 Oct 2025 15:36:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, guoren@kernel.org, rppt@kernel.org, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: + csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20251015153646.d7730fe119c0895dfcd06e21@linux-foundation.org>
In-Reply-To: <aPAgR6FNizJTKGJu@casper.infradead.org>
References: <20251015215059.D610BC4CEFB@smtp.kernel.org>
	<aPAZAVMunRWb-QHk@casper.infradead.org>
	<20251015151016.bf3f31797dea74558dc00c67@linux-foundation.org>
	<aPAgR6FNizJTKGJu@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Oct 2025 23:29:27 +0100 Matthew Wilcox <willy@infradead.org> wro=
te:

> > > Again, it seems churlish to merge Mike's patch insteaad of Thomas' th=
at
> > > was sent two weeks ago.
> >=20
> > I can't find such a patch from Thomas and the message-id you sent
> > didn't work for me  - what was the Subject:?
>=20
> Date: Mon, 06 Oct 2025 14:13:37 +0200
> From: Thomas Wei=DFschuh <thomas.weissschuh@linutronix.de>
> To: Guo Ren <guoren@kernel.org>, "Matthew Wilcox (Oracle)"
>         <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Andrew Morton
>         <akpm@linux-foundation.org>
> Cc: linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Wei=
=DFschuh
>         <thomas.weissschuh@linutronix.de>
> Subject: [PATCH] csky: abiv2: Adapt to new folio flags field

Ah, thanks, I expect "^csky: abiv2" was as far as my filter got ;)

I'll adopt Thomas's version.
