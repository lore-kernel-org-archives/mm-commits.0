Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAF44071C4
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 01:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780708455; cv=none; b=GZ1eouQBKTSreVic1bKlJfy8AfHLNH/pvVIhE8xMempgpUMOIboZR55K2f3BiQmbTGjqN8GkYXTKyExJwCQqtaoK3CskQktb0KTih0G3FlfqCnzauBYE57AKy9fx3VnZXYq1gKQC5UUdrxROAY2uI4ETF0qPu/IRFBGz7f78yI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780708455; c=relaxed/simple;
	bh=e/+A6+ZkeI5JXXWrDtL0MNLlrmJFFRdecuKrZhCSZ2o=;
	h=Date:To:From:Subject:Message-Id; b=J+cL/bw1uGNqlVkX7rq+mHymBkVciv4EdUKXjvxLUzGYxZ7LsEk/fZo9IIsStlyn4PZBGFVhirkmueyHkk8dhwTEBT2mFjqQIGt7Xa4Y1X4V/zfpIX3vZgvPHBM5D2+W/huB6OAaDw919Hs0E70yVerO55VKcLfL1keDRxXJqsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nMPuBlPj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nMPuBlPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7D71F00893;
	Sat,  6 Jun 2026 01:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780708453;
	bh=AFiMi5LZ1bVqmFQoRD31UbJgsTYuom7BdocYkl7LFwE=;
	h=Date:To:From:Subject;
	b=nMPuBlPjWWcXS/L5xalrBUB2ggLm/cMUY4C2ok2JXARCT6CggOn0U9tHjS1kH6DS/
	 rhoWSLLNM3vStVhouigDsIY4IDYddcXKs5xBiAhVeJ1oTgoGgaPxpbgAnVcgkOaIP0
	 SwafuoYApo0X/AsOdwoSRdo2559a80792My4JxPQ=
Date: Fri, 05 Jun 2026 18:14:13 -0700
To: mm-commits@vger.kernel.org,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-self-as-a-kcov-reviewer.patch added to mm-nonmm-unstable branch
Message-Id: <20260606011413.9A7D71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Alexander as a kcov reviewer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-self-as-a-kcov-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-self-as-a-kcov-reviewer.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Alexander Potapenko <glider@google.com>
Subject: MAINTAINERS: add Alexander as a kcov reviewer
Date: Fri, 5 Jun 2026 10:54:23 +0200

Also move Dmitry Vyukov to the bottom of the list.

Link: https://lore.kernel.org/20260605085423.1962700-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-self-as-a-kcov-reviewer
+++ a/MAINTAINERS
@@ -13837,8 +13837,9 @@ F:	fs/proc/kcore.c
 F:	include/linux/kcore.h
 
 KCOV
-R:	Dmitry Vyukov <dvyukov@google.com>
 R:	Andrey Konovalov <andreyknvl@gmail.com>
+R:	Alexander Potapenko <glider@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
 B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
_

Patches currently in -mm which might be from glider@google.com are

maintainers-add-self-as-a-kcov-reviewer.patch

