Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24271E534
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 00:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707350586; cv=none; b=ZXjPe5bzTgxVwL+UBAMFApJnYa7Hh8Hi1q3ypPzYWq54U1Gxlp3UxBCpetg5/C0JxHoG3mm1EevnMW0I6jiFjbREdWU1CQQN/SAN+zSzdRMKtd/w5Rion3u0/F2MQyhTjuJidQHu8VGJ11Src+P5AzwFlbPorte0IkoRcoVl1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707350586; c=relaxed/simple;
	bh=mTdEkBtopicEXpQJQfYEQVwrV8TI9OniJ1WkAyPQNoU=;
	h=Date:To:From:Subject:Message-Id; b=WsfEPIuYqrPTjofxgm2fuWQ8qff8PKgqpvCb0duar+VfPisUH3Ohz4J6ful4U5HjRFZehf2mMncxoMOXC6uY3rhorb70J0dO4CEPleHECZpn6ig/N9uppXr3ROyV/oE2IERnFc41gkeawyBdU8WNbxcvdLja7/RGkDtDBygXvp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ces22+YV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ces22+YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDD8C43390;
	Thu,  8 Feb 2024 00:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707350586;
	bh=mTdEkBtopicEXpQJQfYEQVwrV8TI9OniJ1WkAyPQNoU=;
	h=Date:To:From:Subject:From;
	b=ces22+YVHhBxByKblyX4J/CPjnYx2DhRuEvOGRJo+kAm3C68hHOsmtUmwFWOtLCnI
	 NjAXK1/PiAEWNjJuluQIJQ22D4Nh9hdasoyx4nbu6k04qPlg3DA3AByB66zuIuhluc
	 RUuRfw0VUEbZRaRTdK7E9v1obfOu2fSyBo4uUZvo=
Date: Wed, 07 Feb 2024 16:03:05 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,cerasuolodomenico@gmail.com,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-remove-unneeded-spinlock.patch added to mm-unstable branch
Message-Id: <20240208000306.1FDD8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/z3fold: remove unneeded spinlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-remove-unneeded-spinlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-z3fold-remove-unneeded-spinlock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm/z3fold: remove unneeded spinlock
Date: Sun, 4 Feb 2024 20:54:04 +0800

There is no need to use spinlock in this section, so remove it.

Link: https://lkml.kernel.org/r/20240204125404.2112384-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unneeded-spinlock
+++ a/mm/z3fold.c
@@ -442,8 +442,6 @@ static void __release_z3fold_page(struct
 	WARN_ON(!list_empty(&zhdr->buddy));
 	set_bit(PAGE_STALE, &page->private);
 	clear_bit(NEEDS_COMPACTING, &page->private);
-	spin_lock(&pool->lock);
-	spin_unlock(&pool->lock);
 
 	if (locked)
 		z3fold_page_unlock(zhdr);
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch
mm-z3fold-remove-unneeded-spinlock.patch

