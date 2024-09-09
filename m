Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C6B18E05C
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925305; cv=none; b=KwMJDr5uTaOvh7nS5kCmrTErN/pZhIWma+w7io5o0MTtdCpnNqkbUAjsibyRPTxdL3UFAqiTs3K8wDzG27Q5wD2W/IQhg8apSLFo9L4frJjIPEJDdNFXWAupVI012VMuvez8XyeYoKv6DlwyoXJKCvfVmplqbFvpi6Ms3dz6btA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925305; c=relaxed/simple;
	bh=xd9BDlstJ7xGVPBQ+9VTg0Knnf1ecfeK2d+Ws4CKW34=;
	h=Date:To:From:Subject:Message-Id; b=iQbnWV6x9B2oa98o68Sg6ZVUY930J4ut5lvM6tYsIGRmBwX9Gm6hAtBDka+ozY/L3uzoqu0yXB6n3+rcRBF+yIcj5mOPEM04H6SpOIEgBdxtC2K0zLnzmlEYP/8e59vHOXhsQI6uegKIsvfesj/e5/lBhVioed3BvMgMGxxEEew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cBPa+Okf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cBPa+Okf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0CBC4CEC5;
	Mon,  9 Sep 2024 23:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925304;
	bh=xd9BDlstJ7xGVPBQ+9VTg0Knnf1ecfeK2d+Ws4CKW34=;
	h=Date:To:From:Subject:From;
	b=cBPa+Okf1TYBwh6uzVRpM2nR0glh6sA9yHgbMs+cSXl6ry5U1IdI0EZBcZDXG9CQW
	 tzB1p5wCd7oa5jsTPRn6jWWUYD3Ovh0wMLXJt3zxAa/rUqS4rjueWHWca+CYUldlvu
	 a9NxSf4XhssyQl0tB44Kf/Qr66GAAElp+GqlK4lc=
Date: Mon, 09 Sep 2024 16:41:44 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero.patch removed from -mm tree
Message-Id: <20240909234144.DB0CBC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: skip damon_test_nr_accesses_to_accesses_bp() if aggr_interval is zero
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: skip damon_test_nr_accesses_to_accesses_bp() if aggr_interval is zero
Date: Thu, 5 Sep 2024 09:24:23 -0700

The aggregation interval of test purpose damon_attrs for
damon_test_nr_accesses_to_accesses_bp() becomes zero on 32 bit
architecture, since size of int and long types are same.  As a result,
damon_nr_accesses_to_accesses_bp() call with the test data triggers
divide-by-zero exception.  damon_nr_accesses_to_accesses_bp() shouldn't
be called with such data, and the non-test code avoids that by checking
the case on damon_update_monitoring_results().  Skip the test code in
the case, and add an explicit caution of the case on the comment for the
test target function.

Link: https://lkml.kernel.org/r/20240905162423.74053-1-sj@kernel.org
Fixes: 5e06ad590096 ("mm/damon/core-test: test max_nr_accesses overflow caused divide-by-zero")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/c771b962-a58f-435b-89e4-1211a9323181@roeck-us.net
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    8 +++++++-
 mm/damon/tests/core-kunit.h |   12 ++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero
+++ a/mm/damon/core.c
@@ -552,7 +552,13 @@ static unsigned int damon_accesses_bp_to
 	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
-/* convert nr_accesses to access ratio in bp (per 10,000) */
+/*
+ * Convert nr_accesses to access ratio in bp (per 10,000).
+ *
+ * Callers should ensure attrs.aggr_interval is not zero, like
+ * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
+ * happen.
+ */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero
+++ a/mm/damon/tests/core-kunit.h
@@ -320,6 +320,18 @@ static void damon_test_nr_accesses_to_ac
 		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
 	};
 
+	/*
+	 * In some cases such as 32bit architectures where UINT_MAX is
+	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
+	 * damon_nr_accesses_to_accesses_bp() in the case will cause
+	 * divide-by-zero.  Such case is prohibited in normal execution since
+	 * the caution is documented on the comment for the function, and
+	 * damon_update_monitoring_results() does the check.  Skip the test in
+	 * the case.
+	 */
+	if (!attrs.aggr_interval)
+		kunit_skip(test, "aggr_interval is zero.");
+
 	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


