Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79442D781B
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 04:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783571840; cv=none; b=n6sih7Fr1dd1II1XNl9Z7LiNvK91Z6xmAAM8nbpvHQ0xW7R7tJVKHAufQqd7PfWjHI9PGCQQ2l11YycM3FBMmIctKkEZPOULUt2sUriTdGDCQag0wy4zJlx76l1G4mcQa/XF0vFaF3r0d/zQaZSegZ2UHjMYwKDoaExEIv2yvoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783571840; c=relaxed/simple;
	bh=vYExeJHEXeBV6q91ppXwq9ic5a3quekJQIS+krjdiYo=;
	h=Date:To:From:Subject:Message-Id; b=RRKdxUCXKZsazxpznxSFtCHjFEDAclIDfTt6EXaem+VKckukQfHnC+FgK7De6iHZbFtfWeVUjxhffc8yt1xZbq0WUlve2w07yErsjt2cz0gYvi4/rAnXWqng+MCf751XbqqHw9zxY8dtCDSEf964Uk7o+iGW9Xpy7LF0XH+4dhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6BOcbmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6BOcbmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9521F000E9;
	Thu,  9 Jul 2026 04:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783571838;
	bh=c/5KvIBCPSJ3JfvkpUaXOkcNRC5sZ0PTFGoP05TYgvI=;
	h=Date:To:From:Subject;
	b=H6BOcbmQI/wOTRzVyl62hRocoVZ3aKhL4tzTVnPcU8ft9E6t3jGBMUcb/YUuM5/4D
	 4oG37Rvo89Ra3Cn+cOnHEo3nQ7MlcHedEbc4e25nTrJzVDhOLCWtWhMYqa1+ZNiOsv
	 YwrDsk6hyfI+KYhnrv+szD9mTcCezlZbuGdU8RC4=
Date: Wed, 08 Jul 2026 21:37:17 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,kees@kernel.org,error27@gmail.com,david@davidgow.net,acarmina@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] kunit-bugc-fix-backtrace-supression-test-failure-as-a-module.patch removed from -mm tree
Message-Id: <20260709043718.5D9521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit/bug.c: fix backtrace-supression-test failure as a module
has been removed from the -mm tree.  Its filename was
     kunit-bugc-fix-backtrace-supression-test-failure-as-a-module.patch

This patch was dropped because an alternative patch was or shall be merged

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

