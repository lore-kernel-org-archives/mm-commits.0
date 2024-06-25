Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B12F33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293190; cv=none; b=VCdwfkCzZIezqp+yKxj45sIuZMg1Blj1aTnv4Dax+xnphXvSJgRSOOhKPjFDHJDLxCV4jvKcgiDEJIpNeI9y/xUtxBdJUCWahOYC9CY6w/wVLDAN6asHQne0EfsP5jR+49T/pLpkvNfSdUcmYb6VBPiN/4BzVeF+z8nOqsRgudY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293190; c=relaxed/simple;
	bh=wTbdvC2ki89Uv/T6gRmdwD48PryQzujCBWZkUgaSodE=;
	h=Date:To:From:Subject:Message-Id; b=dCtiIt//2AidwKaQ0smg5HrRzeci7VfofqAaRXI5JW9uK9TFP7EKTw1k26HAQYdB1lZVEG4owfboc9avDTsfOuZ3JlC6eEOACnhmRzXX3nnCPW7bYlGyyV8eDZBx7DcE6QH476JOGLNgvrDJ4eT7Y2+FPQEglmH554TMOMXiC0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1wASN6yV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1wASN6yV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E025C32782;
	Tue, 25 Jun 2024 05:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293190;
	bh=wTbdvC2ki89Uv/T6gRmdwD48PryQzujCBWZkUgaSodE=;
	h=Date:To:From:Subject:From;
	b=1wASN6yVSexjrw/p4RRDHyK/ODJn+ZMFQI7P+XA7e+FrppPPAVuRqUt1tgBULmpm0
	 vi4Eqv0fVl55dSy0dhnhGycMzQVr8DIW3WiEIbg/tRnY1n3bqqD9k/N2XHLH/2Tu+5
	 2dnvOdVbuOP2SvOpOWnnKHCwWDXfJkPs6OvwnexY=
Date: Mon, 24 Jun 2024 22:26:29 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch removed from -mm tree
Message-Id: <20240625052630.0E025C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_sort: add a testcase to ensure code coverage
has been removed from the -mm tree.  Its filename was
     lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/test_sort: add a testcase to ensure code coverage
Date: Tue, 28 May 2024 04:30:11 +0800

The addition of an if statement in lib/sort to handle the final unsorted 2
or 3 elements is not covered by existing test cases, leading to incomplete
test coverage.  To ensure comprehensive testing and maintain 100% code
coverage, add a new testcase for scenarios where the if statement is
triggered.

Since the if statement is only triggered when the array length is odd and
the first element is greater than the second element, a testcase is
created using an array length of TEST_LEN - 1 and a suitable random seed
to maintain full code coverage.

Link: https://lkml.kernel.org/r/20240527203011.1644280-5-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sort.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/lib/test_sort.c~lib-test_sort-add-a-testcase-to-ensure-code-coverage
+++ a/lib/test_sort.c
@@ -29,7 +29,19 @@ static void test_sort(struct kunit *test
 
 	sort(a, TEST_LEN, sizeof(*a), cmpint, NULL);
 
-	for (i = 0; i < TEST_LEN-1; i++)
+	for (i = 0; i < TEST_LEN - 1; i++)
+		KUNIT_ASSERT_LE(test, a[i], a[i + 1]);
+
+	r = 48;
+
+	for (i = 0; i < TEST_LEN - 1; i++) {
+		r = (r * 725861) % 6599;
+		a[i] = r;
+	}
+
+	sort(a, TEST_LEN - 1, sizeof(*a), cmpint, NULL);
+
+	for (i = 0; i < TEST_LEN - 2; i++)
 		KUNIT_ASSERT_LE(test, a[i], a[i + 1]);
 }
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


