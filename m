Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048932BAF8;
	Fri, 20 Feb 2026 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771555917; cv=none; b=MpbcR//OnYlaBeqtxS9uZpW62c/3DV2Y+Ys5hRpFUgUAG+VpxXG2DHZ9NyQjLCoCYQnuVtrsEakzx6yxVKjI0zxMMtxAC8nqDBtkbLU3si/+o/Q/Vfqj7lwihOQOm9p0zmip5xpTHD8j7vBNryQWmiw7u0wDYFQ5n1f8+D5RGBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771555917; c=relaxed/simple;
	bh=AHELUwQPBzjKmeCEx6oeCsjua/bek7ErvL8tiwh9U/U=;
	h=Date:To:From:Subject:Message-Id; b=s0DYhA5slNog75oY0tfLtv1NYzsRrmLXqlcfUklO919aL0W1e9muNsQuXdlwvxgZzDoRmOj6LzBtWemfb+qcphxK/mhl9rnoHuc+an397q5C93MbYoK7iHjHYqmYiItwC6FXfj9sGPTom9TUAEMFShngl0bvnhXesBHDOLDXbto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k4qn2h1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k4qn2h1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F61C4CEF7;
	Fri, 20 Feb 2026 02:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771555916;
	bh=AHELUwQPBzjKmeCEx6oeCsjua/bek7ErvL8tiwh9U/U=;
	h=Date:To:From:Subject:From;
	b=k4qn2h1FjV+tDzeCy5RlUm/Rgcn4vhGXkA/tQvWv1DrS4LkO+drzoJRQUKxd0I41A
	 d6AK/8l6SewCrXORqvNZlbYB3794b3GvWegK1Zs+j4n2vax/uE3Im0yWNLkcSDRph2
	 6hewHgKqG7gkn0U5Xanp2VgdX9yve8IL1wKSmppA=
Date: Thu, 19 Feb 2026 18:51:55 -0800
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-disallow-non-power-of-two-min_region_sz.patch added to mm-hotfixes-unstable branch
Message-Id: <20260220025156.82F61C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: disallow non-power of two min_region_sz
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-disallow-non-power-of-two-min_region_sz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-disallow-non-power-of-two-min_region_sz.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: disallow non-power of two min_region_sz
Date: Sat, 14 Feb 2026 13:41:21 -0800

DAMON core uses min_region_sz parameter value as the DAMON region
alignment.  The alignment is made using ALIGN() and ALIGN_DOWN(), which
support only the power of two alignments.  But DAMON core API callers can
set min_region_sz to an arbitrary number.  Users can also set it
indirectly, using addr_unit.

When the alignment is not properly set, DAMON behavior becomes difficult
to expect and understand, makes it effectively broken.  It doesn't cause a
kernel crash-like significant issue, though.

Fix the issue by disallowing min_region_sz input that is not a power of
two.  Add the check to damon_commit_ctx(), as all DAMON API callers who
set min_region_sz uses the function.

This can be a sort of behavioral change, but it does not break users, for
the following reasons.  As the symptom is making DAMON effectively broken,
it is not reasonable to believe there are real use cases of non-power of
two min_region_sz.  There is no known use case or issue reports from the
setup, either.

In future, if we find real use cases of non-power of two alignments and we
can support it with low enough overhead, we can consider moving the
restriction.  But, for now, simply disallowing the corner case should be
good enough as a hot fix.

Link: https://lkml.kernel.org/r/20260214214124.87689-1-sj@kernel.org
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org>	[6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-disallow-non-power-of-two-min_region_sz
+++ a/mm/damon/core.c
@@ -1252,6 +1252,9 @@ int damon_commit_ctx(struct damon_ctx *d
 {
 	int err;
 
+	if (!is_power_of_2(src->min_region_sz))
+		return -EINVAL;
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-non-power-of-two-min_region_sz.patch

