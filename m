Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3640306767
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 00:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785283205; cv=none; b=ULBo4k0eBxxxiXRUG0rxKZGDHGOJgHAA+boPomQNC3HJiTNW6K87fjb7c5OqtDztqAX2LHsZHdS7Coy6P5GbkG/H0dvAcJ8ISKwJlxn6Z/TSyzf15SMIXpUAsk+t9DVc3N/VUoThG6crlwIOpVTJrZJI3Q5Xifa0BtdyvOsSkUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785283205; c=relaxed/simple;
	bh=FEdxFfWThrIgR5dfdKAfTnKdO7f+UErwGGHoRyUrZME=;
	h=Date:To:From:Subject:Message-Id; b=odb0iRP+sKFxMLn4ffkOoJPQ2ppJhBSB0b6eakCuBpyY44p/bfVwvETxvI924XWW1r1LXff7MYllyDfB2Uo09mrLLRO2NjgX7ubfjPFnfvXsNnPpzTfTSDvumpTMaxIlA31iEKJWKLQFZYhZQc+CUkoIf5misqP5hAHuIX7cq7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uG0laEq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uG0laEq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A831F000E9;
	Wed, 29 Jul 2026 00:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785283203;
	bh=6HnOA+B2hRX2Cae8dQ3mwQ4xdfFKMcsROa4+/prQzYY=;
	h=Date:To:From:Subject;
	b=uG0laEq4Xd7jp7C62D6aKhBvEiuFubEftaj5noDc5NcVd9b8FB4avif0tlFKL1Er8
	 oRa6PHJgc7xsyhvunwJ6QTa0cLUIK84jHV4gtYsrs0BjpiA7M3/Y6FglrQ7loGr5TK
	 16jsCoAbSRgCok5kRDRC/tgrWf83iNaaoxCCQPRM=
Date: Tue, 28 Jul 2026 17:00:02 -0700
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-drop-the-dead-null-attribute-check-in-parse.patch added to mm-nonmm-unstable branch
Message-Id: <20260729000003.36A831F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: drop the dead NULL attribute check in parse()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-drop-the-dead-null-attribute-check-in-parse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-drop-the-dead-null-attribute-check-in-parse.patch

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
From: Bradley Morgan <include@grrlz.net>
Subject: taskstats: drop the dead NULL attribute check in parse()
Date: Tue, 28 Jul 2026 20:21:03 +0000

Patch series "taskstats: tidy up the cpumask command path".

Two small cleanups from reading kernel/taskstats.c. No functional change in
either one.


This patch (of 2):

taskstats_user_cmd() only calls the cpumask handlers after checking the
same info->attrs[] entry, so parse() never sees a NULL attribute.  Drop
the check and its odd "return 1", which no caller tested for anyway.

No functional change.

Link: https://lore.kernel.org/20260728202104.17839-1-include@grrlz.net
Link: https://lore.kernel.org/20260728202104.17839-2-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-drop-the-dead-null-attribute-check-in-parse
+++ a/kernel/taskstats.c
@@ -361,8 +361,6 @@ static int parse(struct nlattr *na, stru
 	int len;
 	int ret;
 
-	if (na == NULL)
-		return 1;
 	len = nla_len(na);
 	if (len > TASKSTATS_CPUMASK_MAXLEN)
 		return -E2BIG;
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch
taskstats-drop-the-dead-null-attribute-check-in-parse.patch
taskstats-fold-the-two-cpumask-handlers-into-one.patch

