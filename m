Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80B61F5834;
	Thu, 23 Jul 2026 23:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784848636; cv=none; b=QiLQlUsZ5Tc8pSjrJU6tWOQzgH+KFooy26DKs8SEstw4wMNhkFycI9Q9nuqzDtvEs0vBktR2Fqu0Ae6prTEICGlonQpQcR+JpGJmVMdthcC1uQy7i8ZbOSSy49vKPnxkXFtdVYqGFVKI2ghpCa7O+8GEXTIzqMRQEttJxNopu4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784848636; c=relaxed/simple;
	bh=YZW43UP0EiUwh6oPs5xCaho2zRoZFQ/uBWG7eK7GUIA=;
	h=Date:To:From:Subject:Message-Id; b=Yr+zioyOVLDD2vSGncq+IjU2Z5PwmmGwLwy6vGZdGRmni3vyU8JVx+B20ueh4dFDdpOA7uIUF8ev5jIWTvcT7mkIlZyXSi9hxekf6yG4Gq3Ev0HNVvtX/y8f83GVLV2CJU8rSKNtCrEdzzJYpuVuDfCoOTrSET3xwqV5LzTvMgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RaIbKb+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RaIbKb+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5E61F000E9;
	Thu, 23 Jul 2026 23:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784848635;
	bh=eG6Oqf0YZcczL6VoG1QnJcwYCNZawvddgyURdelaJE0=;
	h=Date:To:From:Subject;
	b=RaIbKb+YUZ/KJyxBWm77uo5D4X+GGXt7hYFbRWasrypFtxp5gvoOdrVe7Q1x2X0Jm
	 u50uJCxGfttqHxrKGA3zxoYHbXYyuXMPJBhefK/RKXW+F//KYmmWTCgQVjVa1Yy4L+
	 Z54E2qaNnqWRo5M4EeEDyEW1O9crtjAQMrpKMuH4=
Date: Thu, 23 Jul 2026 16:17:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oleg.deomi@gmail.com,bsingharora@gmail.com,akpm@linux-foundation.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch added to mm-nonmm-unstable branch
Message-Id: <20260723231715.3B5E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: fix cpumask parsing cutting off the last character
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch

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
Subject: taskstats: fix cpumask parsing cutting off the last character
Date: Thu, 23 Jul 2026 21:09:22 +0000

parse() hands nla_strscpy() len as dstsize, and nla_strscpy() copies at
most dstsize - 1 bytes.  When the attr payload comes in without a trailing
NUL, srclen == len >= dstsize and the last character of the cpumask string
gets cut off.  Register "0-15" and you are silently listening on "0-1",
exit data for the rest never shows up.

The bug only bites when the sender doesnt NUL terminate the payload;
senders that include the NUL were always fine (srclen gets decremented for
the trailing NUL, so srclen < dstsize).  Thats probably why this survived
20 years.  And the policy is NLA_STRING, not NLA_NUL_STRING, so a payload
without the trailing NUL is legit input here.

Skip the kmalloc/nla_strscpy dance entirely and use nla_strdup(), which
already allocates srclen + 1 and terminates.  The nla_len() bounds checks
stay as they were.

Link: https://lore.kernel.org/EC49FE41-7F5F-41E0-A07A-ABEB8ECA514D@grrlz.net
Fixes: f9fd8914c1ac ("[PATCH] per-task delay accounting taskstats interface: control exit data through cpumasks")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reported-by: Oleg Deomi <oleg.deomi@gmail.com>
Closes: https://lore.kernel.org/CAByWkfZ6b1=3H9pwkz-dDQOs9cZaF-HYQ6b9Yb0=Hq2r1Vv_Pw@mail.gmail.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-fix-cpumask-parsing-cutting-off-the-last-character
+++ a/kernel/taskstats.c
@@ -368,10 +368,9 @@ static int parse(struct nlattr *na, stru
 		return -E2BIG;
 	if (len < 1)
 		return -EINVAL;
-	data = kmalloc(len, GFP_KERNEL);
+	data = nla_strdup(na, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-	nla_strscpy(data, na, len);
 	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch

