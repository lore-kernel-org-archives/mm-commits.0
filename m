Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880038DCC
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 02:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708396099; cv=none; b=jLGGKArDaB1Ap/O+HP+Bhaf+7PhK/LI5SBwLI7meSC94xzIdsYas+VKOI7pthLyvCIDpiAii6BpvwYMk21MHWi3ObUfIg0KBgSnSnHAKIJ/NxHbEaPaCudCLKhc2vCJ/2nK0zODDicYu60qy9eWGBN/cutmcZMJlr9r9EzCyelQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708396099; c=relaxed/simple;
	bh=dC6LaKtQVAyd4O8A2oFAaX7bV2tA5HUoRzUMGDCr/aw=;
	h=Date:To:From:Subject:Message-Id; b=OW9CzWYrflFOEJ3Kt28rybCu/HAOV/5EIkJCKNJj8MgE2IJo1JUA4VbQ8ZdfwWogbojZ4cZLj4EYLP6OqNHhjjjX7CujIkwly2q6dZglm7ffU17gNOTPNxqlA8gZDQTRduDu4y3vkeWuM226LE8nwfyX+3X45jAxi0QIqq3Kmpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i2YGApsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i2YGApsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C061C43390;
	Tue, 20 Feb 2024 02:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708396099;
	bh=dC6LaKtQVAyd4O8A2oFAaX7bV2tA5HUoRzUMGDCr/aw=;
	h=Date:To:From:Subject:From;
	b=i2YGApsHY0qkKTzmwkWdXhZS4yupgMij0r4ut9pp0ojiEyUtCrgw5xu+aGSDSAjMg
	 GVjs9crMeXn2BQQOF+yJ+KFIqznCPK8Mg/LZPu+i4ybLpk2glKoWkse4F/r4ftnAHJ
	 p+GqtAGQclHPT6GX665/gOetzAQO2uZxm9WkB8RM=
Date: Mon, 19 Feb 2024 18:28:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,oliver.sang@intel.com,da.gomez@samsung.com,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_xarray-add-tests-for-advanced-multi-index-use-fix.patch added to mm-unstable branch
Message-Id: <20240220022819.6C061C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_xarray: fix soft lockup for advanced-api tests
has been added to the -mm mm-unstable branch.  Its filename is
     test_xarray-add-tests-for-advanced-multi-index-use-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_xarray-add-tests-for-advanced-multi-index-use-fix.patch

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
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: test_xarray: fix soft lockup for advanced-api tests
Date: Fri, 16 Feb 2024 11:43:29 -0800

The new adanced API tests want to vet the xarray API is doing what it
promises by manually iterating over a set of possible indexes on its
own, and using a query operation which holds the RCU lock and then
releases it. So it is not using the helper loop options which xarray
provides on purpose. Any loop which iterates over 1 million entries
(which is possible with order 20, so emulating say a 4 GiB block size)
to just to rcu lock and unlock will eventually end up triggering a soft
lockup on systems which don't preempt, and have lock provin and RCU
prooving enabled.

xarray users already use XA_CHECK_SCHED for loops which may take a long
time, in our case we don't want to RCU unlock and lock as the caller
does that already, but rather just force a schedule every XA_CHECK_SCHED
iterations since the test is trying to not trust and rather test that
xarray is doing the right thing.


Link: https://lkml.kernel.org/r/20240216194329.840555-1-mcgrof@kernel.org
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lkml.kernel.org/r/202402071613.70f28243-lkp@intel.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/lib/test_xarray.c~test_xarray-add-tests-for-advanced-multi-index-use-fix
+++ a/lib/test_xarray.c
@@ -728,6 +728,7 @@ static noinline void *test_get_entry(str
 {
 	XA_STATE(xas, xa, index);
 	void *p;
+	static unsigned int i = 0;
 
 	rcu_read_lock();
 repeat:
@@ -737,6 +738,17 @@ repeat:
 		goto repeat;
 	rcu_read_unlock();
 
+	/*
+	 * This is not part of the page cache, this selftest is pretty
+	 * aggressive and does not want to trust the xarray API but rather
+	 * test it, and for order 20 (4 GiB block size) we can loop over
+	 * over a million entries which can cause a soft lockup. Page cache
+	 * APIs won't be stupid, proper page cache APIs loop over the proper
+	 * order so when using a larger order we skip shared entries.
+	 */
+	if (++i % XA_CHECK_SCHED == 0)
+		schedule();
+
 	return p;
 }
 
_

Patches currently in -mm which might be from mcgrof@kernel.org are

test_xarray-add-tests-for-advanced-multi-index-use.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix.patch

