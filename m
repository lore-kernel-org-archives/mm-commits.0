Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8896F12F59C
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384663; cv=none; b=oUfDf9Y35tN1dOiiEhVfVbhO/affZ0UEKEDEj8d0385L41Th5G9DdjV40JOsCOrzkfXlj/UEj+JOYOi+XRRYdQlR8dS4t9/df2/+zCDP5nJjfKL/hif6ANb2jrqHfA3Oj5x6xGv7S5XeYafDIpwl3aHjV0/luc8MyVfnQac8CDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384663; c=relaxed/simple;
	bh=jmRhdUxSIxipad3MBXKH/i1bT/BjE/Qg0dAdihyLHf8=;
	h=Date:To:From:Subject:Message-Id; b=NeySpOQbV/7QnJz5mdhtHc7tfe6ONHOVt/HukdESePmkb8ZmgoEUzNHsAkXWfaey2e/rZNi89N+zCfuBrnG5lMmfLsC8DicmPTecRhAm0lg831Ew9hl2KokTt0Zivwur2iPNZZASabWGxFHRznip25J2S/tIPyjzQyIV78GA9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ycrleroU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ycrleroU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140DDC4CEC7;
	Thu, 26 Sep 2024 21:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384663;
	bh=jmRhdUxSIxipad3MBXKH/i1bT/BjE/Qg0dAdihyLHf8=;
	h=Date:To:From:Subject:From;
	b=ycrleroUdPnqMHUMoI2heRGbjG7s4mf7q0Oq2zBLU3ef8mLsKTOFfzSWwkSyfRVqM
	 IaRZ3LvtfvkQd2rRaDW50vuNGHFmC2eUX1uwNTc9Kg8lh0CzTnwo+WoWaUAyP3f4TS
	 +w4tBjpEtOMDJAa/PcqXpe7OTxiVw9wBDGx9LYX4=
Date: Thu, 26 Sep 2024 14:04:22 -0700
To: mm-commits@vger.kernel.org,richard120310@gmail.com,davidgow@google.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-list-test-fix-tests-for-list_cut_position.patch removed from -mm tree
Message-Id: <20240926210423.140DDC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "list: test: fix tests for list_cut_position()"
has been removed from the -mm tree.  Its filename was
     revert-list-test-fix-tests-for-list_cut_position.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


