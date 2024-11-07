Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25DD219486
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019133; cv=none; b=J6WU6XdLSJiPE2RNuwVap5QowaTRXPRll8BH6ZoZt7mUdhFmk3jx0Aeyb7cvQQeUjSOMFXHgqATGeFWKDqQjnnz13KfO2gyFiu9bAA5h+bqNYYYTaktu2pWZMwC75nGNAFxAH4WnjQtQ4elgVWvDSuIQ0qM8j57V89SKzdA9H0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019133; c=relaxed/simple;
	bh=5HwcPHXlZ1CykOOy1B5Cp8qsNkxFEQI60mSpVp93FxQ=;
	h=Date:To:From:Subject:Message-Id; b=VWSB01ojrE7YPe9FnmFDao6dusQVJ9qe+kwXf2aJ7ylLaXn+0KlxRXrcxOX+vsAbwQVosO2q7nZTbR0kXjJRFimT3Z3U11ZgB4m92Mc5HXYhFtTJf671xIQj9u5aAX6bNZrp8QNpX/5UUvWPDqzKlwTJFE06lCzLO+qCwV8B6jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mj7am8SQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mj7am8SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63291C4CECC;
	Thu,  7 Nov 2024 22:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019132;
	bh=5HwcPHXlZ1CykOOy1B5Cp8qsNkxFEQI60mSpVp93FxQ=;
	h=Date:To:From:Subject:From;
	b=Mj7am8SQes979dusAiiqjxN/gM3Q9BZ+fgTpwgC1DRgTOModCY6ouKb5icDiRTDb2
	 mhux3WK/l2W59k0f4Je3O8jFmgo7KqKYj477KQRWVLahSbZqJYZavArhURDv9TvTqk
	 wNd8b3oxydbDLzExAXfOovezKLCVl5nBn3acokik=
Date: Thu, 07 Nov 2024 14:38:51 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch removed from -mm tree
Message-Id: <20241107223852.63291C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/dbgfs-kunit: fix the header double inclusion guarding ifdef comment
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/dbgfs-kunit: fix the header double inclusion guarding ifdef comment
Date: Mon, 28 Oct 2024 16:30:58 -0700

Closing part of double inclusion guarding macro for dbgfs-kunit.h was
copy-pasted from somewhere (maybe before the initial mainline merge of
DAMON), and not properly updated.  Fix it.

Link: https://lkml.kernel.org/r/20241028233058.283381-7-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/dbgfs-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/dbgfs-kunit.h~mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment
+++ a/mm/damon/tests/dbgfs-kunit.h
@@ -168,6 +168,6 @@ static struct kunit_suite damon_test_sui
 };
 kunit_test_suite(damon_test_suite);
 
-#endif /* _DAMON_TEST_H */
+#endif /* _DAMON_DBGFS_TEST_H */
 
 #endif	/* CONFIG_DAMON_KUNIT_TEST */
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch

