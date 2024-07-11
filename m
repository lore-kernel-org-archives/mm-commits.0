Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9CB157469
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 19:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720726972; cv=none; b=XtDJm4NkBh2yX7nZdPxljs/T/0lJeR6fem15j/pjYxNhmOOJ8dsvQrkR9hrwCDu+fAb3VLasztNoIDsVLPT3FoS11rSym7StO9lvsAeugbvcMfK46X7fkAbofKr6RLIP/QrY4jn2TCpAWyT6S+ux7oXz/1jBnDld1xFCvBU/6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720726972; c=relaxed/simple;
	bh=dXxeJEf6QSleyfSQ5Qu7jxWqAh+oppRi2nYWqKsM0VE=;
	h=Date:To:From:Subject:Message-Id; b=e5EvfrXr4HjHuGogmR0vvDWKd0fCS6El3RBJ9+s7R1Q1IJRSnGSMi1KFXb2e5PmnMgQUpHJ1WoCLHd3yRbwkeP7TvOkG9EQfTWEsn6Gi1NgC5NhKgqC7hWtz8cdnSDoNPhkypyG9ZRS2ozHOqLLmLdjX60M7fKtW4J12c5xpnSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kjTQ+H1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kjTQ+H1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB479C116B1;
	Thu, 11 Jul 2024 19:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720726972;
	bh=dXxeJEf6QSleyfSQ5Qu7jxWqAh+oppRi2nYWqKsM0VE=;
	h=Date:To:From:Subject:From;
	b=kjTQ+H1KcYrYjE2VLVd92TXaAQ5O6w+Xo2Cp0zwTVM4wDvYr77xRoQ+y/KkAgmIiK
	 SCwzUxR0MTeEADsdXIWbXstv/Q3F65w6lC0P6CLZQCjV0lnS7w3VuhRDJFcrAOP/NA
	 Ifu3JMGqBaX6Jx61HQimoP0+/go22m8uVAPNsCG4=
Date: Thu, 11 Jul 2024 12:42:51 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-replace-strncpy-with-strscpy.patch added to mm-unstable branch
Message-Id: <20240711194251.DB479C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: replace strncpy() with strscpy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-replace-strncpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-replace-strncpy-with-strscpy.patch

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
From: Kees Cook <kees@kernel.org>
Subject: mm/kmemleak: replace strncpy() with strscpy()
Date: Tue, 9 Jul 2024 17:13:08 -0700

Replace the depreciated[1] strncpy() calls with strscpy().  Uses of
object->comm do not depend on the padding side-effect.

Link: https://github.com/KSPP/linux/issues/90 [1]
Link: https://lkml.kernel.org/r/20240710001300.work.004-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-replace-strncpy-with-strscpy
+++ a/mm/kmemleak.c
@@ -657,10 +657,10 @@ static struct kmemleak_object *__alloc_o
 	/* task information */
 	if (in_hardirq()) {
 		object->pid = 0;
-		strncpy(object->comm, "hardirq", sizeof(object->comm));
+		strscpy(object->comm, "hardirq");
 	} else if (in_serving_softirq()) {
 		object->pid = 0;
-		strncpy(object->comm, "softirq", sizeof(object->comm));
+		strscpy(object->comm, "softirq");
 	} else {
 		object->pid = current->pid;
 		/*
@@ -669,7 +669,7 @@ static struct kmemleak_object *__alloc_o
 		 * dependency issues with current->alloc_lock. In the worst
 		 * case, the command line is not correct.
 		 */
-		strncpy(object->comm, current->comm, sizeof(object->comm));
+		strscpy(object->comm, current->comm);
 	}
 
 	/* kernel backtrace */
_

Patches currently in -mm which might be from kees@kernel.org are

mm-kmemleak-replace-strncpy-with-strscpy.patch
tsacct-replace-strncpy-with-strscpy.patch

