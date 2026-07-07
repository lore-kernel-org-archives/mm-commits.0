Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2A366045
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783454156; cv=none; b=Fzb95+Jq1AeKgDAAWN3yVjV2vBq/PBSb6GKNVV4x0d084Rf+xfZi9tmAZnbT92gQAXFa9N76IfXfpnkjEEKldxZrO3IuxScwWZMezNfxFapogx9I3L9xNuoHtFH09Lhux2LFNl7Jt4HAojJUcy2B+xtQ3ji41W8ZdpHaX2I+6H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783454156; c=relaxed/simple;
	bh=++q4meppws5oh+QBFbgJ+Ng1vIaP1T5gc8M2zUjtojY=;
	h=Date:To:From:Subject:Message-Id; b=QU3aWHbXrc9IQIMOtEgCCjUE2ykG8Lsje1k4qAMkGKuklxAlu2VzeR1aMBEJ/2WzBcNdqIR9QjWj8pS2OHznd/XpJ6BLona+GWZUAfwoDdm+VQb0TsKFQYHH1tTXj5Emgan4xakcoHxGdPC5qaAMSk9PhxC0+6xIHqLyKZzaB5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Di16+Pmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Di16+Pmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187901F000E9;
	Tue,  7 Jul 2026 19:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783454155;
	bh=ZeqnIdEgLU9K98YRMwWw1anN1gXqq2JdgUIfTR127DI=;
	h=Date:To:From:Subject;
	b=Di16+PmkAN8tqOBaVQ++EKQSy0F7vd4pUCM/RcGUnNbFCi1Qb4pgMru62am+Cpl7k
	 gZWdNGlUO698U6xj0Rec2iArzynCu7bHhXBcTT7ebOJfJ8IFUBMSv77jLP5c5ne4M7
	 1b75Fobsz4tG6rY5AIwYR3mVv6b7l5oP9bfSEF1U=
Date: Tue, 07 Jul 2026 12:55:54 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,kees@kernel.org,error27@gmail.com,david@davidgow.net,acarmina@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-bugc-fix-backtrace-supression-test-failure-as-a-module.patch added to mm-nonmm-unstable branch
Message-Id: <20260707195555.187901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit/bug.c: fix backtrace-supression-test failure as a module
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-bugc-fix-backtrace-supression-test-failure-as-a-module.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-bugc-fix-backtrace-supression-test-failure-as-a-module.patch

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
From: Nico Pache <npache@redhat.com>
Subject: kunit/bug.c: fix backtrace-supression-test failure as a module
Date: Tue, 7 Jul 2026 12:54:05 -0600

When running the backtrace-supression-test as a module most cases produce
failures.

Upon further investigating the issue presents itself due to the ifdef that
wraps the kunit_is_suppressed_warning, which is not compiled in if using
CONFIG_KUNIT_MODULE.

Fix this by switching to IS_ENABLED(CONFIG_KUNIT) which properly checks
for either CONFIG_KUNIT_MODULE or CONFIG_KUNIT.

Link: https://lore.kernel.org/20260707185405.571277-1-npache@redhat.com
Fixes: bbc960d009a6 ("kunit: Add backtrace suppression self-tests")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Alessandro Carminati <acarmina@redhat.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: David Gow <david@davidgow.net>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bug.c~kunit-bugc-fix-backtrace-supression-test-failure-as-a-module
+++ a/lib/bug.c
@@ -219,7 +219,7 @@ static enum bug_trap_type __report_bug(s
 	no_cut   = bug->flags & BUGFLAG_NO_CUT_HERE;
 	has_args = bug->flags & BUGFLAG_ARGS;
 
-#ifdef CONFIG_KUNIT
+#if IS_ENABLED(CONFIG_KUNIT)
 	/*
 	 * Before the once logic so suppressed warnings do not consume
 	 * the single-fire budget of WARN_ON_ONCE().
_

Patches currently in -mm which might be from npache@redhat.com are

mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch
mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch
kunit-bugc-fix-backtrace-supression-test-failure-as-a-module.patch

