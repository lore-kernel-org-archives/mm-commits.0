Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00CB28E5
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810101; cv=none; b=giSf6rS3xEXO6xbOpNxG4f7LyBbKbQGXZjD2fsmdGtFiF2BDpQyUTzJIPG60L8TJT2yWKHe6smARnzs+AKPL6pZlWoXB2ksanaRU4D0m2cbS+M1YR7rfPbsGMoZ3n4B46oX32MpR+ELQh7r3iP5i22Oj5b5S7J88mlBryaswPQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810101; c=relaxed/simple;
	bh=VwGVZakbmLbndT0tbykUWnLaLWb3/pkZzzdafURo0jU=;
	h=Date:To:From:Subject:Message-Id; b=GNn0kgx5guTjA+GsTLXER0TiUKwTU8ilH8mhhL8cX0uz9iwXt5elh03lMStr+VdMTWZM6/F0qY842t6RrHbU5evcOCrP6+ZnfaZqGAv50nqgPpXrlqwmg4W33Kq2wR7nVBrOSCGtoTxp4VVL1awbYaySnVy6kkGKloc4lJlNmEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cqFcPeF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cqFcPeF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431D4C4CEEB;
	Sun, 14 Sep 2025 00:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810101;
	bh=VwGVZakbmLbndT0tbykUWnLaLWb3/pkZzzdafURo0jU=;
	h=Date:To:From:Subject:From;
	b=cqFcPeF5xg5wvUqX+rCeIhTKvPD6nrQYQosOFm5sFY/R3bTH2vmqpZUX0eA/8Vy5s
	 87kieJHc3biHLW06N4GO+wTTTaFK2qxdodo3quk3Zvm+zalicSxlYiCVAy9Ydn5Lsc
	 5F+E/mWDMMtXSEErYgeyU5AHNsgHviVIODbrF5nU=
Date: Sat, 13 Sep 2025 17:35:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch removed from -mm tree
Message-Id: <20250914003501.431D4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: idr test suite: remove usage of the deprecated ida_simple_xx() API
has been removed from the -mm tree.  Its filename was
     idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: idr test suite: remove usage of the deprecated ida_simple_xx() API
Date: Mon, 14 Jul 2025 10:17:08 +0200

Patch series "ida: Remove the ida_simple_xxx() API", v3.

These are the final steps in removing the ida_simple_xxx() API.

This series was last proposed in August 2024.  Since then, some users of
the old API have be re-introduced and then removed.

A first time in drivers/misc/rpmb-core.c, added in commit 1e9046e3a154
("rpmb: add Replay Protected Memory Block (RPMB) subsystem") (2024-08-26)
and removed in commit dfc881abca42 ("rpmb: Remove usage of the deprecated
ida_simple_xx() API") (2024-10-13).

A second time in drivers/gpio/gpio-mpsse.c, added in commit c46a74ff05c0
("gpio: add support for FTDI's MPSSE as GPIO") (2024-10-14) and removed in
commit f57c08492866 (gpio: mpsse: Remove usage of the deprecated
ida_simple_xx() API) (2024-11-22).

Since then, I've not spotted any new usage.

So things being stable now, it's time to end this story once and for all.


This patch (of 3):

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range()/ida_alloc_max() is inclusive.  But because of the ranges
used for the tests, there is no need to adjust them.

While at it remove some useless {}.

Link: https://lkml.kernel.org/r/cover.1752480043.git.christophe.jaillet@wanadoo.fr
Link: https://lkml.kernel.org/r/2904fa2006e4fe58eea63aef87fa7f832c7804a1.1752480043.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/idr-test.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/tools/testing/radix-tree/idr-test.c~idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/tools/testing/radix-tree/idr-test.c
@@ -499,19 +499,17 @@ void ida_check_random(void)
 		goto repeat;
 }
 
-void ida_simple_get_remove_test(void)
+void ida_alloc_free_test(void)
 {
 	DEFINE_IDA(ida);
 	unsigned long i;
 
-	for (i = 0; i < 10000; i++) {
-		assert(ida_simple_get(&ida, 0, 20000, GFP_KERNEL) == i);
-	}
-	assert(ida_simple_get(&ida, 5, 30, GFP_KERNEL) < 0);
-
-	for (i = 0; i < 10000; i++) {
-		ida_simple_remove(&ida, i);
-	}
+	for (i = 0; i < 10000; i++)
+		assert(ida_alloc_max(&ida, 20000, GFP_KERNEL) == i);
+	assert(ida_alloc_range(&ida, 5, 30, GFP_KERNEL) < 0);
+
+	for (i = 0; i < 10000; i++)
+		ida_free(&ida, i);
 	assert(ida_is_empty(&ida));
 
 	ida_destroy(&ida);
@@ -524,7 +522,7 @@ void user_ida_checks(void)
 	ida_check_nomem();
 	ida_check_conv_user();
 	ida_check_random();
-	ida_simple_get_remove_test();
+	ida_alloc_free_test();
 
 	radix_tree_cpu_dead(1);
 }
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


