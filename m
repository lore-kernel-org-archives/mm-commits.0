Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DED383316
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 01:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782352367; cv=none; b=fHxh2ZyRq/CoVc/vexKPRmbOFQLZsKOXSS9IKnIKXqlCRxhOAx7ZVJC8BK+MX8npUXnOb08OFIewmpseerIIGPxTnA6nyMUpj7hZJGlT9EmKQxwAhHRy+D3YR62WzKW3d4jtsHezKx1VRYw7/TnWPmr5MpU83oT63G5x3dynmMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782352367; c=relaxed/simple;
	bh=m7b4rheDWC6YcC9qa1JIXkAKQ0kSQiA9hrDBK4gWZ3Y=;
	h=Date:To:From:Subject:Message-Id; b=HaIXC1h9Nh2G2WauGC9twNQtyZjksdBE4WD+vpypeXy552uPI0GubziHqpvvh7/wOOHRtv3mcIZZoDTDK3TK0gW7BEychfB1BdQnGHdDSkH0+c3gwQIbvcShjp6usTl8PjoaDXTYtKjsMt8GgmKJjtf444YmWBPMi6jRRjZw4jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDOaz35x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDOaz35x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405B31F000E9;
	Thu, 25 Jun 2026 01:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782352366;
	bh=g85O1ErlInQvAJUHMefWjr7tBZPGyZAxbSS8KWx9F+I=;
	h=Date:To:From:Subject;
	b=TDOaz35x5X5IHfqDm3cMl7i9UTSGEVK+wblx5QQiGDaLxB61zRqxNwtDgJaD166xU
	 /z0wIVDJY25RWUQLR9CaBzM5LmzZXnPVUUVeaOldT+3/rLPDyAcJjigoJShav0Tp8V
	 mpbw8EeTQT3BhaKJ3uKYClu+Gd/HT37vp+VfSJ38=
Date: Wed, 24 Jun 2026 18:52:45 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-params-fix-a-pr_debug-%p-in-parse_one.patch added to mm-nonmm-unstable branch
Message-Id: <20260625015246.405B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/params: fix a pr_debug(" %p ") in parse_one()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-params-fix-a-pr_debug-%p-in-parse_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-params-fix-a-pr_debug-%p-in-parse_one.patch

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
From: Jim Cromie <jim.cromie@gmail.com>
Subject: kernel/params: fix a pr_debug(" %p ") in parse_one()
Date: Thu, 18 Jun 2026 13:07:15 -0600

Inside parse_one(), the core parameter-parsing engine prints the address
of the parameter-set callback function using %p: pr_debug("handling %s
with %p\n", param, params[i].ops->set);

Since the string value of the parameter being parsed (val) is already
available, print the parameter name and its value instead, and avoid
tainting the kernel by exposing a kernel-ptr.

Link: https://lore.kernel.org/20260618190715.3563047-1-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/params.c~kernel-params-fix-a-pr_debug-%p-in-parse_one
+++ a/kernel/params.c
@@ -136,8 +136,8 @@ static int parse_one(char *param,
 			if (!val &&
 			    !(params[i].ops->flags & KERNEL_PARAM_OPS_FL_NOARG))
 				return -EINVAL;
-			pr_debug("handling %s with %p\n", param,
-				params[i].ops->set);
+			pr_debug("handling %s with value '%s'\n", param,
+				val ? val : "no-arg");
 			kernel_param_lock(params[i].mod);
 			if (param_check_unsafe(&params[i]))
 				err = params[i].ops->set(val, &params[i]);
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

kernel-params-fix-a-pr_debug-%p-in-parse_one.patch

