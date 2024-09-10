Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0811C69D
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725994167; cv=none; b=AmARJiHgtMKUIiPA3gk/1ql3B1CQ0rSgD2JB/uZ3TQL58Dau4dL6+lMSFarUYYerl6qSg67zqnHJOCIP2luuJe8gZ149RMSwVTGMBtgmOzto+5sAyAwjjwYnDBzRk0tUOxiGUX5N11VAPHq8HkwI2SwWYLkfarksGdvQhkhGsKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725994167; c=relaxed/simple;
	bh=B/xO8CFT8j0mFNbBs/vsybfb7hXH5Pb61YISzfEfkPg=;
	h=Date:To:From:Subject:Message-Id; b=ATcjxpF6U58ZD9Syyga3Ximp3UjujPos7fE9wJDX6BYs1KdvYo0ToU5wMU/T7158L+Nhxq1701XWi/uSJvuOeZ1TRHSCM1B37N2Y2uzH/cAFfUcKzHaHEtGA1ftm/nbo7gICRu2zuy7CPgTz/O5z7/ZLm/9upAB2dwIoqFTkCU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R0Kp92p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R0Kp92p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6894C4CEC3;
	Tue, 10 Sep 2024 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725994165;
	bh=B/xO8CFT8j0mFNbBs/vsybfb7hXH5Pb61YISzfEfkPg=;
	h=Date:To:From:Subject:From;
	b=R0Kp92p3+4MD1U6gBzG+gaSuBGC89S4aetfS6ZoITnJZjOzLVXeZVSSm4OiH0Tbh3
	 3v8kRj9Ir9mgLPU44BRPkJnMnGCYaew/CPy/sEXJGazCh97GhGkXMFOX574fsXOPYO
	 3s2HjgS53QQXqdQ4lxzg+0tOUQKIfEVY+hX4kcrY=
Date: Tue, 10 Sep 2024 11:49:25 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-test-increasing-coverage-of-list_test_list_replace.patch added to mm-nonmm-unstable branch
Message-Id: <20240910184925.C6894C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: test: increase coverage of list_test_list_replace*()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-test-increasing-coverage-of-list_test_list_replace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-test-increasing-coverage-of-list_test_list_replace.patch

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
From: I Hsin Cheng <richard120310@gmail.com>
Subject: list: test: increase coverage of list_test_list_replace*()
Date: Tue, 10 Sep 2024 12:08:18 +0800

Increase the test coverage of list_test_list_replace*() by adding the
checks to compare the pointer of "a_new.next" and "a_new.prev" to make
sure a perfect circular doubly linked list is formed after the
replacement.

Link: https://lkml.kernel.org/r/20240910040818.65723-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list-test.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/list-test.c~list-test-increasing-coverage-of-list_test_list_replace
+++ a/lib/list-test.c
@@ -102,6 +102,8 @@ static void list_test_list_replace(struc
 	/* now: [list] -> a_new -> b */
 	KUNIT_EXPECT_PTR_EQ(test, list.next, &a_new);
 	KUNIT_EXPECT_PTR_EQ(test, b.prev, &a_new);
+	KUNIT_EXPECT_PTR_EQ(test, a_new.next, &b);
+	KUNIT_EXPECT_PTR_EQ(test, a_new.prev, &list);
 }
 
 static void list_test_list_replace_init(struct kunit *test)
@@ -118,6 +120,8 @@ static void list_test_list_replace_init(
 	/* now: [list] -> a_new -> b */
 	KUNIT_EXPECT_PTR_EQ(test, list.next, &a_new);
 	KUNIT_EXPECT_PTR_EQ(test, b.prev, &a_new);
+	KUNIT_EXPECT_PTR_EQ(test, a_new.next, &b);
+	KUNIT_EXPECT_PTR_EQ(test, a_new.prev, &list);
 
 	/* check a_old is empty (initialized) */
 	KUNIT_EXPECT_TRUE(test, list_empty_careful(&a_old));
_

Patches currently in -mm which might be from richard120310@gmail.com are

list-test-mending-tests-for-list_cut_position.patch
list-test-increasing-coverage-of-list_test_list_replace.patch

