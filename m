Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55BB1A256E
	for <mm-commits@vger.kernel.org>; Fri,  1 Aug 2025 22:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754087090; cv=none; b=I19ELaXUuU9LnpCh5/szYCsjS61AvQnRxdWf+3Pxv1253hZH4x8GbJ6zdh/+lIXxCVSOKza1zW4JOKNf05HMaQEBKEE8Xkh3OvwIps6+RE3nauIfhn23kIovN7gokqgDdOvN3bY3CGKV/0jQHdk6v7bDbE1sK8pgQOeK9HpKJwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754087090; c=relaxed/simple;
	bh=OH2ehW1ywL4LpFbLKhuXk0+VKe2Bh32zqPy5NaVnTrg=;
	h=Date:To:From:Subject:Message-Id; b=nyxL93qCu+WwOYni8V9ZmZqzgSIQhhJ/cW63ejeezQoRFg7fffBVDjLw98mZ1nnf02RAkJdwVSKXNtn1IIErlEgiR1jyfQ6sXxjXAtpHl6P3/I3c+QSHHjvCvsW0sWGLB5OdH7VWS4G7tkQ6qLOEbIH2diJfwV8rWQPfycNSNA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v3Bmsq3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v3Bmsq3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50155C4CEE7;
	Fri,  1 Aug 2025 22:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754087089;
	bh=OH2ehW1ywL4LpFbLKhuXk0+VKe2Bh32zqPy5NaVnTrg=;
	h=Date:To:From:Subject:From;
	b=v3Bmsq3AXBVeeE37+7wUXnVUsLSw+M9m8qb7rs12T6MPWWd3OGfdfvFQiRSP9KIkA
	 RATSG+IjhEXeC+n0Sn7/cg7VyRx/yrvq7P7Lxl77ez1Yl/aa6zYtshrVxzO4yZnq+o
	 evFW62f8picjvJFUuft/LqyjPhWSwMqq80azz+vI=
Date: Fri, 01 Aug 2025 15:24:48 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-masami-as-a-reviewer-of-hung-task-detector.patch added to mm-hotfixes-unstable branch
Message-Id: <20250801222449.50155C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Masami as a reviewer of hung task detector
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-masami-as-a-reviewer-of-hung-task-detector.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-masami-as-a-reviewer-of-hung-task-detector.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: MAINTAINERS: add Masami as a reviewer of hung task detector
Date: Wed, 30 Jul 2025 23:25:08 +0900

Since I'm actively working on hung task blocker detector, add myself to a
reviewer of the HUNG TASK DETECTOR feature.

Link: https://lkml.kernel.org/r/175388550841.627474.3260499035226455392.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-masami-as-a-reviewer-of-hung-task-detector
+++ a/MAINTAINERS
@@ -11287,6 +11287,7 @@ F:	drivers/tty/hvc/
 HUNG TASK DETECTOR
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Lance Yang <lance.yang@linux.dev>
+R:	Masami Hiramatsu <mhiramat@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/hung_task.h
_

Patches currently in -mm which might be from mhiramat@kernel.org are

maintainers-add-masami-as-a-reviewer-of-hung-task-detector.patch
hung_task-dump-blocker-task-if-it-is-not-hung.patch

