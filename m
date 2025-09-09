Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00756238149
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 01:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757382627; cv=none; b=OQ61709aBbRe1B2mZSJ4egfADp4dJizkuUInu+fPWi1vjysbeHnAuZrNdW2l1lFjLM5PZsgRZypASkONOQ6ivA6lHA6EZ12OY6uir/vHlgmyN+cKqYjpti8bOediF1GPy4+TaywZFiYGu2y5bqCRv6skt2HprZf726m3xp/FYBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757382627; c=relaxed/simple;
	bh=GBJ0AFYE09N9LCdfNf4GOGHyeeJb22i2YwKHJI+SXVM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=iTTZfl5JBFb5lr5Iq1+/UuitQ+3cemkScDfZVucqsECpfJBoRu9vUZDW9y8lMovFvW5AHwhFbNlqWPxTqqMLZJr/fZYvhH2b3VfgyW9lHwNWZrkjOc+oD+6+C0hCa+DMLismiwGYOoaQESoEVCyaHlw8n6SYVlC/lj17e9cd2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GdW3VG7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GdW3VG7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E2AC4CEF1;
	Tue,  9 Sep 2025 01:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757382626;
	bh=GBJ0AFYE09N9LCdfNf4GOGHyeeJb22i2YwKHJI+SXVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GdW3VG7AaOvHSoDqRGA23Y8hy29+y4jTyCcBa2zy/3k2eGWinvgTkeF92Gi8R6DOd
	 t9uJfqmznFPlZH7SOOp5W3LniTFuERZvVmkhZqD1CNR3D9ON17ebf3hHRxv3DcLBKE
	 IK/N2rA9irx/1fTgpN5OY7yVW1nB/QIpbG476LOU=
Date: Mon, 8 Sep 2025 18:50:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Francois Dugast <francois.dugast@intel.com>, airlied@gmail.com,
 apopple@nvidia.com, balbirs@nvidia.com, christian.koenig@amd.com,
 leonro@nvidia.com, matthew.brost@intel.com, mm-commits@vger.kernel.org,
 mpenttil@redhat.com, thomas.hellstrom@linux.intel.com, ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: populate PFNs from PMD swap entry
Message-Id: <20250908185025.7891685737a1626d22dd7bd4@linux-foundation.org>
In-Reply-To: <20250908134619.GH616306@nvidia.com>
References: <aLmTWhL36_ciqajA@fdugast-desk>
	<20250908091052.612303-1-francois.dugast@intel.com>
	<20250908134619.GH616306@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Sep 2025 10:46:19 -0300 Jason Gunthorpe <jgg@nvidia.com> wrote:

> > Even though subsequent PFNs can be inferred when handling large order
> > PFNs, the PFN list is still fully populated because this is currently
> > expected by HMM users. In case this changes in the future, that is all =
HMM
> > users support a sparsely populated PFN list, the for() loop can be made=
 to
> > skip remaining PFNs for the current order. A quick test shows the loop
> > takes about 10 ns, roughly 20 times faster than without this optimizati=
on.
> >=20
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Leon Romanovsky <leonro@nvidia.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: David Airlie <airlied@gmail.com>
> > Cc: Christian K=F6nig <christian.koenig@amd.com>
> > Cc: Mika Penttil=E4 <mpenttil@redhat.com>
> > Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
> > Cc: Matthew Brost <matthew.brost@intel.com>
> > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > ---
> >  mm/hmm.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 65 insertions(+), 5 deletions(-)
>=20
> Please put version numbers on your patches and include a change log.

yep.

But the diff between this and the previous version is larger than the
patch itself.  So it's basically a whole new patch.

