Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B820371867
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028749; cv=none; b=PI2r5OPkrku7D2HoGS8O3BczT9nNMMfSMfCbLvYS3TzDLNw43C3K8Q+XlEq+bLm59m/oEunfpdbvpOI1BvR6VSzPhXIGAxW2oMFsam1a+AgwJP5GqX2ndpCUkSbwQO0dU7dRtOArkH/KaDpOT9S2Oebel/QVSgJxJ8eXXF4iGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028749; c=relaxed/simple;
	bh=Lq8SAjfE+v/AzxO6ThDNl4N8j7CNMZjd2lRuc43Xu94=;
	h=Date:To:From:Subject:Message-Id; b=qY1cN8OtyaCjV9nAawzLuS6EaH6UXTWumlpugDxBKURf3wA0w6hFv80HlhqciYikSunpntwvBh7DOTGDnqspX1AgNYch2frKpvQ3ZUVbgG1EkfbML+gXNDdW8MFHTi+DUnkPIPae4EZiyOBNVCflXqXXH5QbEHjohCUtU4vNgXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sIxk1u1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sIxk1u1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53321F00898;
	Fri, 29 May 2026 04:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028747;
	bh=rIbnQRCjp41gTrSuHHTedqqCAsSFA3BngKOOjlGDlso=;
	h=Date:To:From:Subject;
	b=sIxk1u1Ytr90dUEqWLuQbBc4qtS4DNcHxdI0WqXq4USFQ6n6RjUO5uwwkOH76VFwC
	 R1tbgoJ9kQfy7vZWnxg+UU0yBEIX1iL0tfONndldaxaPKTcuj5dwjmtY3+hW+rpXC4
	 r6hFED0XoirAoTPd6k9zGAfCFOwpy8ZcLmLKnA/g=
Date: Thu, 28 May 2026 21:25:46 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-tests-string_helpers-decouple-unescape-and-escape-cases.patch removed from -mm tree
Message-Id: <20260529042546.E53321F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/tests: string_helpers: decouple unescape and escape cases
has been removed from the -mm tree.  Its filename was
     lib-tests-string_helpers-decouple-unescape-and-escape-cases.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


