Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F528157E82
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560718; cv=none; b=LJ5NlYjIleMtcxkITTy2CWN2aIOiVR/SuqJN1vb8DNM8lj7qMLKGUVh3P4DsDQ5sI9kxj1F2+9IMk1uyf69jqK/Wovo6x8ixUom2GQhsbABkz2xBXWaWk/j2jXYwWAZqnB2xRyrBIPgiSm3tUAAr+YiuGPiJKsHYZC1YECtn7Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560718; c=relaxed/simple;
	bh=5iNF/z2x0TgkeosKVnFA/HZ2BZMPuUP1gNETiGbgGKY=;
	h=Date:To:From:Subject:Message-Id; b=OTEKJCQcTJtqg2xWkOg1VYH2vMSh4E59fqFfJ3zOArzKvTS2gedAfwNr5trPS4hFjt9IeTqySYx0XHt1Gn1HErUOdyPgZP4f3oTXQ9iz2/cQhR3VNtt8LCdTUzreq3IuCmr9oGgIeCJXPF1p3aEtgTKkCq4nsmyILnIDedTXNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ye9ordd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ye9ordd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F19C4CEC6;
	Tue, 17 Sep 2024 08:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560717;
	bh=5iNF/z2x0TgkeosKVnFA/HZ2BZMPuUP1gNETiGbgGKY=;
	h=Date:To:From:Subject:From;
	b=Ye9ordd0Wbsjb3mmb/JUFzXc9OsY1vMTiYh5t1Y9MwDyvFggZrddTZ5BEvz43u/T+
	 b52qoVbgrEmnXdTUZf7IxrZ/Ua3SdGssLPeIB/SscOXaM4GBZr5bz5+6phRje0YDTw
	 93Y/6RWy12WTWdOkBCKqqcrKfOMyGQtNIspXhGFA=
Date: Tue, 17 Sep 2024 01:11:54 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] list-test-increasing-coverage-of-list_test_list_replace.patch removed from -mm tree
Message-Id: <20240917081157.59F19C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list: test: increase coverage of list_test_list_replace*()
has been removed from the -mm tree.  Its filename was
     list-test-increasing-coverage-of-list_test_list_replace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


