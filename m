Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3364158545;
	Thu, 27 Mar 2025 18:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743101391; cv=none; b=ejoGn1Z3tm+ROezlHt/TZvzUBOwfn5aKFyHOLjoLDV//CwGmZM8eULw6pISceWzzQYNpvp7BjQPYtpFfnUiVYM7LnqQzdgRls5cMQvgs64mEvDArmsnc9SF5gKBza15a4VsR7M1L1x2VUdFdnpRYAai8Www2ufo1SC7yI4EQUtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743101391; c=relaxed/simple;
	bh=yo9h3+0O0jiuqGJBwr8AegoFYKEEY9KlXwdKgUTwsx0=;
	h=Date:To:From:Subject:Message-Id; b=dKbvvM2ys/l3YBu0h7d9Z/FsCpZWS6DxG3yq5hhlPwwHEiie0nlULosRJwkJO+wkQTWw8kk/wIOz05qpJWNoUfmFd28sliDOkmPBUtKyImFQmNfVobrWaxoanQIZiTr2GNJ9qXPJa+Wn51Z5JgkaHo87Fiarg8WtCVrdq3s3Loo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icw2OWCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icw2OWCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5369BC4CEDD;
	Thu, 27 Mar 2025 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743101390;
	bh=yo9h3+0O0jiuqGJBwr8AegoFYKEEY9KlXwdKgUTwsx0=;
	h=Date:To:From:Subject:From;
	b=icw2OWCaF5wzcc3feduQ2U/5QfotapROr/WMqKaM3K3145yFK3vzglJgEDIMPJzUW
	 I6ZX+zjT0jk1uqUL+Stum46d9pasY85cc34vlhSMa4NzXQHuZZG6TUrMzS0RPsF9Dg
	 UJ4JKFmbtCQifJhGKqNm85LcvMfopUrWM487n+YQ=
Date: Thu, 27 Mar 2025 11:49:49 -0700
To: mm-commits@vger.kernel.org,vigneshr@ti.com,stable@vger.kernel.org,robert.jarzmik@free.fr,praneeth@ti.com,kamlesh@ti.com,axboe@kernel.dk,t-pratham@ti.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets.patch added to mm-nonmm-unstable branch
Message-Id: <20250327184950.5369BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: T Pratham <t-pratham@ti.com>
Subject: lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets
Date: Wed, 19 Mar 2025 16:44:38 +0530

The split_sg_phys function was incorrectly setting the offsets of all
scatterlist entries (except the first) to 0.  Only the first scatterlist
entry's offset and length needs to be modified to account for the skip. 
Setting the rest entries' offsets to 0 could lead to incorrect data
access.

I am using this function in a crypto driver that I'm currently developing
(not yet sent to mailing list).  During testing, it was observed that the
output scatterlists (except the first one) contained incorrect garbage
data.

I narrowed this issue down to the call of sg_split().  Upon debugging
inside this function, I found that this resetting of offset is the cause
of the problem, causing the subsequent scatterlists to point to incorrect
memory locations in a page.  By removing this code, I am obtaining
expected data in all the split output scatterlists.  Thus, this was indeed
causing observable runtime effects!

This patch removes the offending code, ensuring that the page offsets in
the input scatterlist are preserved in the output scatterlist.

Link: https://lkml.kernel.org/r/20250319111437.1969903-1-t-pratham@ti.com
Fixes: f8bcbe62acd0 ("lib: scatterlist: add sg splitting function")
Signed-off-by: T Pratham <t-pratham@ti.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Praneeth Bajjuri <praneeth@ti.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sg_split.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/sg_split.c~lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets
+++ a/lib/sg_split.c
@@ -88,8 +88,6 @@ static void sg_split_phys(struct sg_spli
 			if (!j) {
 				out_sg->offset += split->skip_sg0;
 				out_sg->length -= split->skip_sg0;
-			} else {
-				out_sg->offset = 0;
 			}
 			sg_dma_address(out_sg) = 0;
 			sg_dma_len(out_sg) = 0;
_

Patches currently in -mm which might be from t-pratham@ti.com are

lib-scatterlist-fix-sg_split_phys-to-preserve-original-scatterlist-offsets.patch

