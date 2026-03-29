Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B98910F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744817; cv=none; b=grLWQsIMhbMCOiB1mYz0SdkRsnSFk1NlL7ciCOSt1qQ/QO0RaLN3eYMho535/a9ihDaw4XxRpiE5/Dm+aEbEIkrA824lrr4Jr8E0A2H84XN8CMpb5oOr3Jd/ApmATvX/8A0+5Fmb7ZW+EVNfvEI/ZnGl/kUcnyPxxOWvjUGsrm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744817; c=relaxed/simple;
	bh=4RAyQ5Sn0LczuXucWm1gdaa4xAYxmqdb8incuhmVtlg=;
	h=Date:To:From:Subject:Message-Id; b=R2etWnOKvzWzydhw79OtMwE7b56li3jGBz294eCeRH5SuCOkZ7UJ5b834r6SHsD0BaRO3vH66hHL6NMxRlhUsfzeNtnvNHazm0SPVMfq0ebEmJgvOzCN+SYW9iTx6wI0PDGnt/rgPz2BfVN/iQvy3nTzklDNO8SjpEQ686xOnZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSwd+HqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSwd+HqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73494C4CEF7;
	Sun, 29 Mar 2026 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744817;
	bh=4RAyQ5Sn0LczuXucWm1gdaa4xAYxmqdb8incuhmVtlg=;
	h=Date:To:From:Subject:From;
	b=YSwd+HqOPrtm+wHBpeq6dn7+TOcyYFWZtfZ/gCj+dfwofPkALMdk6BQt1qZhTxys+
	 gDSg4uuGnCGvXcr7qVefSoi64F89OBNByjspBCUGErE6tb14MGEnTUX2Yx/f2g+Sh7
	 BWVEy8ezEgKTxPgk9hzvsd5gMuAVogInCJrCx0Es=
Date: Sat, 28 Mar 2026 17:40:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-config_damon_debug_sanity.patch removed from -mm tree
Message-Id: <20260329004017.73494C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add CONFIG_DAMON_DEBUG_SANITY
has been removed from the -mm tree.  Its filename was
     mm-damon-add-config_damon_debug_sanity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add CONFIG_DAMON_DEBUG_SANITY
Date: Fri, 6 Mar 2026 07:29:04 -0800

Patch series "mm/damon: add optional debugging-purpose sanity checks".

DAMON code has a few assumptions that can be critical if violated. 
Validating the assumptions in code can be useful at finding such critical
bugs.  I was actually adding some such additional sanity checks in my
personal tree, and those were useful at finding bugs that I made during
the development of new patches.  We also found [1] sometimes the
assumptions are misunderstood.  The validation can work as good
documentation for such cases.

Add some of such debugging purpose sanity checks.  Because those
additional checks can impose more overhead, make those only optional via
new config, CONFIG_DAMON_DEBUG_SANITY, that is recommended for only
development and test setups.  And as recommended, enable it for DAMON
kunit tests and selftests.

Note that the verification only WARN_ON() for each of the insanity.  The
developer or tester may better to set panic_on_oops together, like
damon-tests/corr did [2].


This patch (of 10):

Add a new build config that will enable additional DAMON sanity checks. 
It is recommended to be enabled on only development and test setups, since
it can impose additional overhead.

Link: https://lkml.kernel.org/r/20260306152914.86303-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260306152914.86303-2-sj@kernel.org
Link: https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org [1]
Link: https://github.com/damonitor/damon-tests/commit/a80fbee55e272f151b4e5809ee85898aea33e6ff [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-add-config_damon_debug_sanity
+++ a/mm/damon/Kconfig
@@ -12,6 +12,17 @@ config DAMON
 	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
+config DAMON_DEBUG_SANITY
+	bool "Check sanity of DAMON code"
+	depends on DAMON
+	help
+	  This enables additional DAMON debugging-purpose sanity checks in
+	  DAMON code.  This can be useful for finding bugs, but impose
+	  additional overhead.  This is therefore recommended to be enabled on
+	  only development and test setups.
+
+	  If unsure, say N.
+
 config DAMON_KUNIT_TEST
 	bool "Test for damon" if !KUNIT_ALL_TESTS
 	depends on DAMON && KUNIT=y
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

