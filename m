Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4CD15748F
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560714; cv=none; b=PncFTIoCnY3hmYzmQVM1TqhRXCmPk8f+da6QlkpWhpiAvUr8uVSMqUj4kWhLC+DMkF75U867ASURSQwI6c70qSxO+FccSqUlWJ1yYbzxdo/DQBdprZwhAHTT2CryomhEjHpM4pyFWSpR3OS69h64FRZZKobiyYC772YZR/V3cCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560714; c=relaxed/simple;
	bh=ZOauDDn4qDmCjk2XyplmZbraWxH1KBOF2UHcsbVTZG8=;
	h=Date:To:From:Subject:Message-Id; b=qk7FqPNCaP4YfB2NNzNYXNqQxdO2hL6UJfHuRg2OCkBraTbeHP9ZepCi9thZHuSc2dqjbE9xKrTSIFfbTErqn7jEsI0yqWmQmdAmRYHaa7j5hVXg7m5AZTTz6E09Ba8PTbxppyYc6jz8q4IN3AE5IMntD2vjNSSUk24iTFrWeoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Is/AF0dH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Is/AF0dH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D59CC4CEC6;
	Tue, 17 Sep 2024 08:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560714;
	bh=ZOauDDn4qDmCjk2XyplmZbraWxH1KBOF2UHcsbVTZG8=;
	h=Date:To:From:Subject:From;
	b=Is/AF0dHJOZkGjIt5yrQ98739PL4IiyasR3LX1bMPcuyEwwjJ7mrZ4ap/18gYM47g
	 0ZUHXpUF2YuKpkuCxy7ZhhAPv0v2ol1GoLy/OYKtDelz0t7ThSv12cBEZ8sleHvK8n
	 bsc8AogFZuCYgha9Xq5kntNcOixz2AtpzkyFPXEQ=
Date: Tue, 17 Sep 2024 01:11:51 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] list-test-mending-tests-for-list_cut_position.patch removed from -mm tree
Message-Id: <20240917081153.9D59CC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list: test: fix tests for list_cut_position()
has been removed from the -mm tree.  Its filename was
     list-test-mending-tests-for-list_cut_position.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: list: test: fix tests for list_cut_position()
Date: Tue, 10 Sep 2024 12:35:31 +0800

Fix test for list_cut_position*() for the missing check of integer "i"
after the second loop.  The variable should be checked for second time to
make sure both lists after the cut operation are formed as expected.

Link: https://lkml.kernel.org/r/20240910043531.71343-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list-test.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/list-test.c~list-test-mending-tests-for-list_cut_position
+++ a/lib/list-test.c
@@ -404,10 +404,13 @@ static void list_test_list_cut_position(
 
 	KUNIT_EXPECT_EQ(test, i, 2);
 
+	i = 0;
 	list_for_each(cur, &list1) {
 		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
 		i++;
 	}
+
+	KUNIT_EXPECT_EQ(test, i, 1);
 }
 
 static void list_test_list_cut_before(struct kunit *test)
@@ -432,10 +435,13 @@ static void list_test_list_cut_before(st
 
 	KUNIT_EXPECT_EQ(test, i, 1);
 
+	i = 0;
 	list_for_each(cur, &list1) {
 		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
 		i++;
 	}
+
+	KUNIT_EXPECT_EQ(test, i, 2);
 }
 
 static void list_test_list_splice(struct kunit *test)
_

Patches currently in -mm which might be from richard120310@gmail.com are


