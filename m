Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14AA4A1D
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752360561; cv=none; b=FAJl305OBpazOKJw4SgQfIb7+tBlAofuDdeRKiHPh/K38L6rGJj713CYdHXayWduDCA/wXaMFzAmccP6uxy6/8CazH5AVnS1gOlxR6DbszADKkGm8jJv/1rS78nXWl8u9k1W0K6ZiIu0spOjjr8aS9wJoF6yI3GMnEFTCa9vYzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752360561; c=relaxed/simple;
	bh=UEm/xoBugqFFnuFXAkJGVrkiBNa6ffx/A+zgPcZ7ryU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=lOEL7gVRz7Azy7Blsa6MbObJ0hpM7TLgovoqvxQisy6HsW/Bsq/s2c2QvGRm8kWz/AqPWRAqhEEcrjBziOVrli8ywQFlUPr3oX6jsSNhze0L8vPmt9j4bob+74MJsdJi1uq+7dPI+cJiJM7PcDzkfQ5BdWk1HJg80i72LSZ8Y44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A98y7JKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A98y7JKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03235C4CEEF;
	Sat, 12 Jul 2025 22:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752360561;
	bh=UEm/xoBugqFFnuFXAkJGVrkiBNa6ffx/A+zgPcZ7ryU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A98y7JKFgf56WCy/gpGh4jdqOGbyBFRyPmywBNg4yfDvgMxdo7zAAnFjOjHNSik88
	 eaNL8v6StQJWgiuK3ODk8tq3IbvhfCSNibbu6Gh9LAZxRd0kESX82W9E+koOhGlKpH
	 fd+7dm+gkKEaEfdrr/bcjg9VX9I3pGbiLN5LHUvc=
Date: Sat, 12 Jul 2025 15:49:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Klara Modin <klarasmodin@gmail.com>
Cc: mm-commits@vger.kernel.org, yukuai3@huawei.com, song@kernel.org,
 herbert@gondor.apana.org.au
Subject: Re: [merged mm-nonmm-stable]
 lib-raid6-replace-custom-zero-page-with-zero_page.patch removed from -mm
 tree
Message-Id: <20250712154920.aa19ba0aaa09f46225b30db1@linux-foundation.org>
In-Reply-To: <sr7kg67kaeuisbxitmvb3rfcvf2b6l2pelnrmgt2s4qsykw6eq@nxid2ju5tcho>
References: <20250710055932.49250C4CEE3@smtp.kernel.org>
	<sr7kg67kaeuisbxitmvb3rfcvf2b6l2pelnrmgt2s4qsykw6eq@nxid2ju5tcho>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Jul 2025 13:49:27 +0200 Klara Modin <klarasmodin@gmail.com> wrote:

> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Subject: lib/raid6: replace custom zero page with ZERO_PAGE
> > Date: Mon, 17 Mar 2025 17:02:28 +0800
> > 
> > Use the system-wide zero page instead of a custom zero page.
> > 
> 
> > [herbert@gondor.apana.org.au: update lib/raid6/recov_rvv.c, per Klara]
> >   Link: https://lkml.kernel.org/r/aFkUnXWtxcgOTVkw@gondor.apana.org.au
> 
> Something seems to have went wrong here, the version in mm-nonmm-stable
> does not seem to have this folded in and the diff below doesn't either.

Yes, thanks, somehow I managed to not fold that change in.  How does
this look?

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: lib/raid6: update recov_rvv.c zero page usage
Date: Mon, 23 Jun 2025 16:47:25 +0800

Update lib/raid6/recov_rvv.c, for 1857fcc84744 ("lib/raid6: replace custom
zero page with ZERO_PAGE"), per Klara.

Link: https://lkml.kernel.org/r/aFkUnXWtxcgOTVkw@gondor.apana.org.au
Fixes: 1857fcc84744 ("lib/raid6: replace custom zero page with ZERO_PAGE")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid6/recov_rvv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/raid6/recov_rvv.c~lib-raid6-replace-custom-zero-page-with-zero_page-v3
+++ a/lib/raid6/recov_rvv.c
@@ -165,10 +165,10 @@ static void raid6_2data_recov_rvv(int di
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -203,7 +203,7 @@ static void raid6_datap_recov_rvv(int di
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
_

