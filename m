Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89FB22626
	for <mm-commits@vger.kernel.org>; Mon, 15 Jul 2024 23:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721086001; cv=none; b=X+bPUA+yRzcCVArS6dxEYlsbURro7n1V/J55T/m6qoZgtJzB5YPE283hr+flvXJepCwmz2OMXlqELj4mBG/Psgs77byGl80sPIWcMUQ5knSooys4DN02OPiF1BuMsWgvox8g9JZgRujHP9yjJUK9i+rjqEUvvsyXmHftjt2n3fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721086001; c=relaxed/simple;
	bh=0V2MzcK2utOLeLnmuAeY1lcSQgDKjjnJq3lE1zlYFAY=;
	h=Date:To:From:Subject:Message-Id; b=Bb5rr/5vsnwGHabX0WICZDJAft8EUuBu6tGe92MjFQ9wwnNc7IKDvtzBq2F/ML6FayqIBgS04LVpoCiE8oLhAuCzgVir2gD3yc9B8t0TDRZ23z3xWlGjaGcxMeP820zAu+hVjqR/I0BVH2sIY1wmx+wzYTUVRPiObJUlZWAJTUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LGtsFASA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LGtsFASA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87925C32782;
	Mon, 15 Jul 2024 23:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721086000;
	bh=0V2MzcK2utOLeLnmuAeY1lcSQgDKjjnJq3lE1zlYFAY=;
	h=Date:To:From:Subject:From;
	b=LGtsFASATQMjoDhRh5uOOYiWfd5ETxzxTs5bBeQMSNj4Xm+1RJsfMvEe3e3S3Ix8E
	 2V8ADWkCezXxZD+098HgZmPUH+wCXb8I7nVbxkbTP0oGrlK97UCZNhQyASUiNnBz+D
	 3MoZAXoZ342+7UdYIiFvvl+dUvokiGuVQjTB81QQ=
Date: Mon, 15 Jul 2024 16:26:39 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-scrub-ia64-from-poisonh.patch added to mm-nonmm-unstable branch
Message-Id: <20240715232640.87925C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ia64: scrub ia64 from poison.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-scrub-ia64-from-poisonh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-scrub-ia64-from-poisonh.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ia64: scrub ia64 from poison.h
Date: Mon, 15 Jul 2024 08:25:33 +0300

Link: https://lkml.kernel.org/r/c72e5467-06a8-4739-ae6a-7c84c96cad77@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/poison.h~ia64-scrub-ia64-from-poisonh
+++ a/include/linux/poison.h
@@ -52,12 +52,6 @@
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
-/********** arch/ia64/hp/common/sba_iommu.c **********/
-/*
- * arch/ia64/hp/common/sba_iommu.c uses a 16-byte poison string with a
- * value of "SBAIOMMU POISON\0" for spill-over poisoning.
- */
-
 /********** fs/jbd/journal.c **********/
 #define JBD_POISON_FREE		0x5b
 #define JBD2_POISON_FREE	0x5c
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ia64-scrub-ia64-from-poisonh.patch

