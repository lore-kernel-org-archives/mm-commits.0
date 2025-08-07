Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08174AEE2
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 04:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754540477; cv=none; b=sF5WRMBFJTqJpYkEUYijUlTQfkxW2aEoIB0E0itqp8ZnBAGS3KfDwdiiYXraFFunikmZthDNozSXZoLQfRFX0ruh6/sIRpxiqzpkIVSM8DCN9GklPd+/R+lw1/Algm/4TWiHFr4K+MTR6Gq++SVP5g6FpYLLvbpEwz/ELwb1Prk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754540477; c=relaxed/simple;
	bh=q2W1JQdvT1pd7swNJM9c9sLhZcOrOuizdXSQ6fjaZ44=;
	h=Date:To:From:Subject:Message-Id; b=Y3QJbixGWtK/KbLbufU95QSxyKlBT08VdexN6JUJ0tE5eN8h9ENiPLLhsg71ET8DssZuezKZKdDtk6/GLZuv3Feg8UQzb1ahygt+mI19FR75DgKjL5kMl5bCKYmLcReqLWNIJTE1kzLEaWgT6gi7VSPE+vT5xuWGitKHxbHPIgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZ4nwqke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZ4nwqke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C313C4CEEB;
	Thu,  7 Aug 2025 04:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754540476;
	bh=q2W1JQdvT1pd7swNJM9c9sLhZcOrOuizdXSQ6fjaZ44=;
	h=Date:To:From:Subject:From;
	b=FZ4nwqkeumHFH8StgYmfa+DtFdEfgHvifV5nv5PVEp+GkvK01tpxWLhWCue6WXQcq
	 9P1OaOK8lMnwAYgiyQ/3hva3v9nAv0KQNIoNF5iVWujmyaPAwSvlgwZB4zMOM6TdYA
	 1s6XW5ijMmhn0/d53OlwiH+0CeJfJSNlX2FO4uN8=
Date: Wed, 06 Aug 2025 21:21:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20250807042116.4C313C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: idr test suite: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
ida-remove-the-ida_simple_xxx-api.patch
nvmem-update-a-comment-related-to-struct-nvmem_config.patch

