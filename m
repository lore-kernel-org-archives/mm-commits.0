Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37EF1FBEB0
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777129455; cv=none; b=GRitmJIt3bYIjRcTrA2nDSdZP5/xCGWmwUmmy7YIM/oQhJsr4FqICpHmNMMmBYrYrnpmrfjthbwF1gY6emVJzNnJ9Oxk6H3qPGZJakQ8lAgB7T1Ud+XNNHuNwA92uPUBlXRI+RwodQcsp18+SGecG1H28pEGxDAzUPD6bhqRFqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777129455; c=relaxed/simple;
	bh=tGWoEVudDjiGVy4IW0H1p9e5kdg9E4eRwQ0WzzMNceI=;
	h=Date:To:From:Subject:Message-Id; b=d+mMZYmyN93Z3wFuq2E9EzMI+nDfEm5JJRLoWnts2M3MeOtt+Z35dJM5D6yV0rSHkslTHnCwuiI4CScjo2wM5FJTBOLDNfkX4KK/qi3AtBXsnPTS/jjUBgKALGsH4WqLk0matU2p5cbyUDGz9XUR6Jsru/cFwy8eQPGiIFvqwN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2mParZG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2mParZG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F8FC2BCB0;
	Sat, 25 Apr 2026 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777129455;
	bh=tGWoEVudDjiGVy4IW0H1p9e5kdg9E4eRwQ0WzzMNceI=;
	h=Date:To:From:Subject:From;
	b=2mParZG5qh7e5dATD/GLV3PVfhCZpNIkKNyc0p3Yb9kwNARgfc5K2DgNhPyd8N0Y7
	 tgz/UmH3vCjrp9nu51yAKM3j74xpVy04Kwi14dX3RFhDSl1qMD6EjFOICTjl92vOS4
	 StM86Fu44+77XKcPpwqTJQ3GO1DSvDWgQ2q8h6yk=
Date: Sat, 25 Apr 2026 08:04:14 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,stf_xl@wp.pl,pabeni@redhat.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuba@kernel.org,horms@kernel.org,glider@google.com,elver@google.com,edumazet@google.com,dvyukov@google.com,davem@davemloft.net,allison.henderson@oracle.com,airlied@gmail.com,achender@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-use-special-gfp_t-format-specifier.patch added to mm-new branch
Message-Id: <20260425150415.85F8FC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kfence: use special gfp_t format specifier
has been added to the -mm mm-new branch.  Its filename is
     mm-kfence-use-special-gfp_t-format-specifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-use-special-gfp_t-format-specifier.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/kfence: use special gfp_t format specifier
Date: Thu, 26 Mar 2026 12:31:59 +0000

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Link: https://lore.kernel.org/20260326-gfp64-v2-3-d916021cecdf@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Allison Collins <allison.henderson@oracle.com>
Cc: Allison Henderson <achender@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/kfence_test.c~mm-kfence-use-special-gfp_t-format-specifier
+++ a/mm/kfence/kfence_test.c
@@ -263,7 +263,7 @@ static void *test_alloc(struct kunit *te
 		break;
 	}
 
-	kunit_info(test, "%s: size=%zu, gfp=%x, policy=%s, cache=%i\n", __func__, size, gfp,
+	kunit_info(test, "%s: size=%zu, gfp=%pGg, policy=%s, cache=%i\n", __func__, size, &gfp,
 		   policy_name, !!test_cache);
 
 	/*
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch

