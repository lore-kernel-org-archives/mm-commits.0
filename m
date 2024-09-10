Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D00C1A2574
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725994108; cv=none; b=ArRKhdDJczDhYCGPz8juQdlLPGlDioT/e0awg85ancFbqWSPS/Qi/Q8pPgtHEnPvOs3A0i6xWvOjeU+lLkjtwb5gPPGMhihtMZV9C0NA3MJ1DxkABTVIHKn7Sj18qjFD9YoJYLvhGO7X31Sx9q3sxiMcEkiIVHyXUXWPxl7GSiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725994108; c=relaxed/simple;
	bh=ZHSbInzBfdrSf/uOdrNXS++PlAYm7gIXSu8kJp/PIss=;
	h=Date:To:From:Subject:Message-Id; b=bDowjhbhpLZ5cMby+P8F9fSBiArxJ8243H/VTANhiof9IwY+i3Bd3kjNN3JAoiXHPXSghjlBdWV07zIvDLh7btabIxLC8Q0W3r3wGl9qGnoUUMwJOjVLbxrBOm6QWriIGkObCgbvmLb6MiyI9zhbFnXcXF/QtaiV35GeEgz+7tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xq0r9Rdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xq0r9Rdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C5EC4CEC3;
	Tue, 10 Sep 2024 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725994107;
	bh=ZHSbInzBfdrSf/uOdrNXS++PlAYm7gIXSu8kJp/PIss=;
	h=Date:To:From:Subject:From;
	b=xq0r9RdtWCq/EEDEqGYgdlkmOEzSZ+5a70CCyYA4M7oJX03xv/WDEfgUu2tFCAH3w
	 zf1kzCTiZylalNv5V26sHHP+vO78VApPv2jvWLQlUCqznqurQbUFvUAsdOarzeSHUP
	 Cwmm6OfG2XYEPaHJA+ozVGotOArWYsnPG6vQJxVw=
Date: Tue, 10 Sep 2024 11:48:27 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-test-mending-tests-for-list_cut_position.patch added to mm-nonmm-unstable branch
Message-Id: <20240910184827.A7C5EC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: test: fix tests for list_cut_position()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-test-mending-tests-for-list_cut_position.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-test-mending-tests-for-list_cut_position.patch

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

list-test-mending-tests-for-list_cut_position.patch

