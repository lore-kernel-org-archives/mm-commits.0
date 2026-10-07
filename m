Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DC634C130
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338405; cv=none; b=CsRmdjhQognBP+yNI+wBIOhUb5osqTo3aRj894+GWRAMWtEBMrG1Pfg6zIWL9a4LZy/psQMPg8oggluuLTthzQznYzqsthL6PZPhlIqg1dP7h6HFEzsQEotM+ESqvYQtNV+MluaFVUIWcwD1iyEHIOIwp3iyUPSlPV4gT8Z4Zbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338405; c=relaxed/simple;
	bh=4uYzWOw3hW9leA1qprFyCywqZEexX1viszsIKD72p0I=;
	h=Date:To:From:Subject:Message-Id; b=c7xM1V41hVqnIimFz/A3/KLwHi1BSX+hqcDH8rFFzzBGIPaPDncuwfddFwpD1364byuB7sq0cU5zMgoQdVzSSpakit3+jXeEbynhM5tOQ8XKic/MJmHQYKxKpRM/gJwVfsfttM4g1e916rDluLS08eHLZup0KOp1GF6Klwygpi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wIYBYU1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wIYBYU1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508ED1F0089E;
	Wed,  7 Oct 2026 02:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338404;
	bh=oDn28v4aANyU7Nf2kIHUq6mukfQJ2KvLvVM4cifp3kc=;
	h=Date:To:From:Subject;
	b=wIYBYU1RbtUcr6RmGNkxj6n3xzhVDAY/26bfff6hw3dnCgrO99OAyaFgMEdJ3l7lw
	 WPuoaWj9GsEIitze1avXG7nWwo3h+gZvbSCKw1IbsmRMSqBk9WxkbtglFVMwTFIkHh
	 JE6frgDoBjf6DchVHaxagx6R93lCEgQRZ6HMZqlk=
Date: Tue, 06 Oct 2026 19:00:02 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-tests-string_helpers-check-null-terminator-too.patch removed from -mm tree
Message-Id: <20261007020004.508ED1F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/tests: string_helpers: check null terminator too
has been removed from the -mm tree.  Its filename was
     lib-tests-string_helpers-check-null-terminator-too.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jonas Rebmann <jre@pengutronix.de>
Subject: lib/tests: string_helpers: check null terminator too
Date: Wed, 16 Sep 2026 19:38:06 +0200

Patch series "lib/string_helpers: fixes and test cases for
string_unescape()".

This series fixes two bugs in string_unescape() regarding the destination
buffer length.  Both fixes are accompanied with kunit tests which would
fail without the fixes.

To make this possible, preparatory patches 1 and 2 improve and clean up
testing helpers and 3 introduces test_unescape_one() which allows for
targeted testing of the string_unescape() function.


This patch (of 5):

string_unescape() returns the number of character written to dst, not
counting the null terminator which is always written.

Ensure string_unescape has included the null terminator by adding a
separate check.

While at it, improve output for failed tests by showing the memory dump
even if the length differs.

Link: https://lore.kernel.org/20260916-string_unescape-v1-0-7f8bd986fa33@pengutronix.de
Link: https://lore.kernel.org/20260916-string_unescape-v1-1-7f8bd986fa33@pengutronix.de
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---

 lib/tests/string_helpers_kunit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/tests/string_helpers_kunit.c~lib-tests-string_helpers-check-null-terminator-too
+++ a/lib/tests/string_helpers_kunit.c
@@ -22,7 +22,7 @@ static void test_string_check_buf(struct
 				  char *out_real, size_t q_real,
 				  char *out_test, size_t q_test)
 {
-	KUNIT_ASSERT_EQ_MSG(test, q_real, q_test, "name:%s", name);
+	KUNIT_EXPECT_EQ_MSG(test, q_real, q_test, "name:%s", name);
 	KUNIT_EXPECT_MEMEQ_MSG(test, out_test, out_real, q_test,
 			       "name:%s", name);
 }
@@ -103,6 +103,7 @@ static void test_string_unescape(struct
 
 	test_string_check_buf(test, name, flags, in, p - 1, out_real, q_real,
 			      out_test, q_test);
+	KUNIT_EXPECT_EQ_MSG(test, out_real[q_real], '\0', "name:%s", name);
 }
 
 struct test_string_1 {
_

Patches currently in -mm which might be from jre@pengutronix.de are

lib-tests-string_helpers-drop-unused-parameters.patch
lib-tests-string_helpers-introduce-test_string_unescape_one.patch
lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

