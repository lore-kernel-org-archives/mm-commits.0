Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245CA1A9F88
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 05:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782363750; cv=none; b=Ns3tdQgOOpa+XTCIsh+SnclLqZYlFLKdYfFIdpUGmKmWKs8KILLmoHkawhTGMtJ6P156E9dTbgjBf6Rpn/pHPdtt3akxF93wkN2GlGKpmuY1W1XlxAi+WFOplUOpkLmxDRpEOwntk9j/qH5dy2koJfl8KWT1iX8WLgoCIbh8FB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782363750; c=relaxed/simple;
	bh=6ZR4kvEmeWan94mCGqMjh4HlneUeZeEGFRG74tKnsf0=;
	h=Date:To:From:Subject:Message-Id; b=Iwtp8BDkHPm9YNjhJlG6+VoBGGrwefkBDoRCAS8BjID/lsDpJ8iCnISMe9sdH8B9MFo4OuhLlKGYYJQZZ50AiTMe0+EXV8ZRG2dnnnINGALFlNRbFokOzxyw1X5Lci/oK/jzemDZp0gQ7eSiE+Q3q3KCgpvbmU+OhL88hq3TfeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cQHQ1Lo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cQHQ1Lo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A962C1F000E9;
	Thu, 25 Jun 2026 05:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363748;
	bh=bzKAuJJ/aDKL40unq6IuiWKk3B6gSNnUzQaGetCJYzQ=;
	h=Date:To:From:Subject;
	b=cQHQ1Lo9FWnnc1zsGmu9ty+/2/TbfiiNqoSr6edmqIU2UO+40+BVwh+lwB1Bxx2Yx
	 iiV/Xl8I/z+1DMcT0N//f5ecVJLmNsK82Eu6PGv6aU2FhJ1Eq4ORm8e78iJwOn9hPl
	 6ddmcjLivFGwRdHofS6p5Gk2go+gJtlzfDEWgTos=
Date: Wed, 24 Jun 2026 22:02:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,agruenba@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-a-typo-in-the-wbc_init_bio-description.patch added to mm-new branch
Message-Id: <20260625050228.A962C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback.h: fix a typo in the wbc_init_bio() description
has been added to the -mm mm-new branch.  Its filename is
     fix-a-typo-in-the-wbc_init_bio-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-a-typo-in-the-wbc_init_bio-description.patch

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
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: writeback.h: fix a typo in the wbc_init_bio() description
Date: Mon, 15 Jun 2026 17:22:42 +0100

initializtion -> initialization (missing "a")

Link: https://lore.kernel.org/20260615162244.2170866-2-willy@infradead.org
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/writeback.h~fix-a-typo-in-the-wbc_init_bio-description
+++ a/include/linux/writeback.h
@@ -244,7 +244,7 @@ void wbc_attach_fdatawrite_inode(struct
 		struct inode *inode);
 
 /**
- * wbc_init_bio - writeback specific initializtion of bio
+ * wbc_init_bio - writeback specific initialization of bio
  * @wbc: writeback_control for the writeback in progress
  * @bio: bio to be initialized
  *
_

Patches currently in -mm which might be from agruenba@redhat.com are

fix-a-typo-in-the-wbc_init_bio-description.patch

