Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F961865E6
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727219417; cv=none; b=UxV0lXEj4EtFbIXjgMj806aVfYKwHrXRDjvgVw3VZWLfrhN8nOSr1/tPDPy38xYDvGXsiF+1CoVqOYl+GttjK1eekOQ/ckK2p9YGYg36k6QKyvsx+MAJ7DOLjYyZ6zDpEXKiuKkjzrzxcpl3nHn+zhW5WMORkRUOkoX9MfkJ3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727219417; c=relaxed/simple;
	bh=mYu4Fqi/GvuY1qLrFZmTfNEiH1f2LytVLHs5SI98ty4=;
	h=Date:To:From:Subject:Message-Id; b=VknzXElhJg6FzuAvN6tnIsC/SkKmfsXrQSPWOtgglPx6nWjmBLqDmBJrbXnVFyKeTbqYgbzqnwD0OPG4RVnCOIzYcdsqv5WqUuQSP3xf0NwsLBCOgNKi+5usgIEiwMFWzg4YqMxdpM7OsN2ZZOVcnv8V9BWoq7j2GYfsEcya6Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KoJ1RV0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KoJ1RV0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E70C4CEC4;
	Tue, 24 Sep 2024 23:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727219417;
	bh=mYu4Fqi/GvuY1qLrFZmTfNEiH1f2LytVLHs5SI98ty4=;
	h=Date:To:From:Subject:From;
	b=KoJ1RV0OUIqTmVJcG51ultloXH2tcITRmIfNDy3F6+gfG8izuSlrrJLFDsuLdjEv0
	 KWr/vkNjfIka+Av6IxpCvjg4YnYZFXcd3aVbZzOohCIMHpwq4gpD4aUb/CbTYfNP0h
	 ZTdj6boHGg+Bd7ns6YP8vvbO1EiMgZ7rIz78wp2g=
Date: Tue, 24 Sep 2024 16:10:16 -0700
To: mm-commits@vger.kernel.org,richard120310@gmail.com,davidgow@google.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-list-test-fix-tests-for-list_cut_position.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924231017.31E70C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "list: test: fix tests for list_cut_position()"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-list-test-fix-tests-for-list_cut_position.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-list-test-fix-tests-for-list_cut_position.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Guenter Roeck <linux@roeck-us.net>
Subject: Revert "list: test: fix tests for list_cut_position()"
Date: Sun, 22 Sep 2024 08:05:07 -0700

This reverts commit e620799c414a035dea1208bcb51c869744931dbb.

The commit introduces unit test failures.

     Expected cur == &entries[i], but
         cur == 0000037fffadfd80
         &entries[i] == 0000037fffadfd60
     # list_test_list_cut_position: pass:0 fail:1 skip:0 total:1
     not ok 21 list_test_list_cut_position
     # list_test_list_cut_before: EXPECTATION FAILED at lib/list-test.c:444
     Expected cur == &entries[i], but
         cur == 0000037fffa9fd70
         &entries[i] == 0000037fffa9fd60
     # list_test_list_cut_before: EXPECTATION FAILED at lib/list-test.c:444
     Expected cur == &entries[i], but
         cur == 0000037fffa9fd80
         &entries[i] == 0000037fffa9fd70

Revert it.

Link: https://lkml.kernel.org/r/20240922150507.553814-1-linux@roeck-us.net
Fixes: e620799c414a ("list: test: fix tests for list_cut_position()")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: I Hsin Cheng <richard120310@gmail.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list-test.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/lib/list-test.c~revert-list-test-fix-tests-for-list_cut_position
+++ a/lib/list-test.c
@@ -408,13 +408,10 @@ static void list_test_list_cut_position(
 
 	KUNIT_EXPECT_EQ(test, i, 2);
 
-	i = 0;
 	list_for_each(cur, &list1) {
 		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
 		i++;
 	}
-
-	KUNIT_EXPECT_EQ(test, i, 1);
 }
 
 static void list_test_list_cut_before(struct kunit *test)
@@ -439,13 +436,10 @@ static void list_test_list_cut_before(st
 
 	KUNIT_EXPECT_EQ(test, i, 1);
 
-	i = 0;
 	list_for_each(cur, &list1) {
 		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
 		i++;
 	}
-
-	KUNIT_EXPECT_EQ(test, i, 2);
 }
 
 static void list_test_list_splice(struct kunit *test)
_

Patches currently in -mm which might be from linux@roeck-us.net are

mm-make-split_pte_ptlocks-depend-on-smp.patch
revert-list-test-fix-tests-for-list_cut_position.patch

