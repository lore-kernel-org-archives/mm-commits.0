Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF693126A7
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 19:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768244973; cv=none; b=Wf59f9VscE8hh+K93Zo8wPzOHdq6p8RJ7ZUSWONIiOuUZ62naKoOB0Tgcb64O8PZrhRmDy42e4O084QRZYYu2dSNmR0NyHDV2jj1OVBgH7bibQQo/ZveTPtnF8okVe5ws02RPuJDkfc2mzs7Sv84+wEfR2zIklDuMQjBVCQetm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768244973; c=relaxed/simple;
	bh=cbQclYTtbsSdG09xI8FDTl+kJ3aaRJ4WewNNa/7gbbk=;
	h=Date:To:From:Subject:Message-Id; b=EF1mBVOM8V1I0FY833xfrY9E4dQLmpco2vClCT6QYgg2nNvG11zf4+SUcXRH9kiKJoabWKtwjJdKsk8LrEvwFD7E7Xtsk2n4IzV+rEUX4Xfwsfacgiiww0ZWwYjzyoQSjO4yP+KhuZUmzc5f63Z12hCxyLk1R2+JFZzbZKhRJLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yuUVJec0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yuUVJec0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FCBC116D0;
	Mon, 12 Jan 2026 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768244972;
	bh=cbQclYTtbsSdG09xI8FDTl+kJ3aaRJ4WewNNa/7gbbk=;
	h=Date:To:From:Subject:From;
	b=yuUVJec0gWDUrrfmqpZ89/rXkcJhvJXBx0LfZkrpSORfdPXXDZsJvFR9pI0XLGrlL
	 bPdBi9384EkH6bsqp/jnmC7yH+xcb8KSq9Dx7hYVkFyFu9JUULlyr5ep7jt24Is2yI
	 nqsEuMAyT0oB6oIcT+n1X/0Yq1MRe4JVQXZphs2E=
Date: Mon, 12 Jan 2026 11:09:32 -0800
To: mm-commits@vger.kernel.org,reinette.chatre@intel.com,edumazet@google.com,tony.luck@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch added to mm-nonmm-unstable branch
Message-Id: <20260112190932.C4FCBC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: once: don't use a work queue to reset sleepable static key
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

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
From: "Luck, Tony" <tony.luck@intel.com>
Subject: once: don't use a work queue to reset sleepable static key
Date: Mon, 12 Jan 2026 10:08:53 -0800

Pointless overhead to use a work queue to reset the static key for a
DO_ONCE_SLEEPABLE() invocation.

Note that the previous code path included a BUG_ON() if the static key
was already disabled. Dropped that as part of this change because:
1) Use of BUG_ON() is highly discouraged.
2) There is a WARN_ON() in the static_branch_disable() code path
   that would provide adequate breadcrumbs to debug any issue.

Link: https://lkml.kernel.org/r/aWU4tfTju1l3oZCu@agluck-desk3
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/once.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/once.c~once-dont-use-a-work-queue-to-reset-sleepable-static-key
+++ a/lib/once.c
@@ -93,6 +93,6 @@ void __do_once_sleepable_done(bool *done
 {
 	*done = true;
 	mutex_unlock(&once_mutex);
-	once_disable_jump(once_key, mod);
+	static_branch_disable(once_key);
 }
 EXPORT_SYMBOL(__do_once_sleepable_done);
_

Patches currently in -mm which might be from tony.luck@intel.com are

once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

