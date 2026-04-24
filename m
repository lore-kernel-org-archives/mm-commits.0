Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C677314D05
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057399; cv=none; b=lrVmBDr48n2IbS8GQNB8Pfnz3HTw35E9TS3E081sq5yUVUQsQClUrs8vTuOiYGIzf6fh1BXg69592o86WGEsia2MPmjYHDemySpg8XV6Cy9xDsGhObyAC55aUSAKZAJAJ8DD5AmINBJVor+4nrrKgYDeJ7LthpOTgTo7olRq2o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057399; c=relaxed/simple;
	bh=3aetPdUZGDZm4T3D0w1JFr2JJNoY0YMjpeynvuV6Ndc=;
	h=Date:To:From:Subject:Message-Id; b=M73w55bkHJw1g7Gmjze79110hy/6OP/4k3wLW8E0PKmkFlIXlaW2Qksm9Pg7EBh4zGYG9Fh+SzSAU4WwD75GTst3qLizK6H7rhuPA+4sqhFPkJ8Q+IL5u9FsstISnxw6AgkhZV/v8uw/03UIFkRP8QxZFPgemkHU7KBOSEr0msc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HOQ7d5x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HOQ7d5x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBDDC19425;
	Fri, 24 Apr 2026 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777057399;
	bh=3aetPdUZGDZm4T3D0w1JFr2JJNoY0YMjpeynvuV6Ndc=;
	h=Date:To:From:Subject:From;
	b=HOQ7d5x2zmNlO9fvRA053J7V9EYVaOkgpSdw8bhjmvc7m9/Zk3jzEXYTq52JDbLx5
	 o7clXFYKKfnzPSL8WELwoN2Vr465Nv97Io2WuL4VT4yv6nbpXr2BuccmOv2q5Hwily
	 RicCkgla+4ooio+kff/KNRHK+TbKvLMcqORZGVj4=
Date: Fri, 24 Apr 2026 12:03:14 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-string_helpers-decouple-unescape-and-escape-cases.patch added to mm-nonmm-unstable branch
Message-Id: <20260424190319.1DBDDC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: string_helpers: decouple unescape and escape cases
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-string_helpers-decouple-unescape-and-escape-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-string_helpers-decouple-unescape-and-escape-cases.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/tests: string_helpers: decouple unescape and escape cases
Date: Mon, 6 Apr 2026 21:32:47 +0200

Patch series "lib/tests: string_helpers: Slight improvements".

Two ad-hoc patches to improve the test module.  It was induced by another
patch that poorly tried to add (existing) test cases and make me revisit
string_helpers_kunit.c.


This patch (of 2):

Currently the escape and unescape test cases go in one step.  Decouple
them for the better granularity and understanding test coverage in the
results.

Link: https://lore.kernel.org/20260406193425.1534197-1-andriy.shevchenko@linux.intel.com
Link: https://lore.kernel.org/20260406193425.1534197-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/string_helpers_kunit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/tests/string_helpers_kunit.c~lib-tests-string_helpers-decouple-unescape-and-escape-cases
+++ a/lib/tests/string_helpers_kunit.c
@@ -601,6 +601,11 @@ static void test_unescape(struct kunit *
 		test_string_unescape(test, "unescape", i, false);
 	test_string_unescape(test, "unescape inplace",
 			     get_random_u32_below(UNESCAPE_ALL_MASK + 1), true);
+}
+
+static void test_escape(struct kunit *test)
+{
+	unsigned int i;
 
 	/* Without dictionary */
 	for (i = 0; i < ESCAPE_ALL_MASK + 1; i++)
@@ -615,6 +620,7 @@ static struct kunit_case string_helpers_
 	KUNIT_CASE(test_get_size),
 	KUNIT_CASE(test_upper_lower),
 	KUNIT_CASE(test_unescape),
+	KUNIT_CASE(test_escape),
 	{}
 };
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-tests-string_helpers-decouple-unescape-and-escape-cases.patch
lib-tests-string_helpers-dont-use-proxy-headers.patch

