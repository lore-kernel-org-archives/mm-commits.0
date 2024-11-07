Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC75218D8C
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019131; cv=none; b=qBtmbmyizgGupBgniry92zIFjE8fbCXvbTNYOr15x0TVH7uUeEIqqO9bjejE8GvWDKdE0RBIPu3El7XqqHCq8/plfpo+h7ZDnXgrBzZlAwYxGosPlVVHCeFlQibHMuCL0dl9VOJoun0Li78EGUjjVD8ucZWTvtR7xUVQGHD4QM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019131; c=relaxed/simple;
	bh=wm4Zo2FE2XXuwEvDQXIAcohVVK3KyWI9Mvl1NybIUsc=;
	h=Date:To:From:Subject:Message-Id; b=ot18JPpInP1ry26gx1f+bEiJ+qy57BkP+Fm0lsJSxhTKASpV6pI7cQAm/km+vjLvSTDYCDe528V6EF62Vq3LC+IxAUkIiMGKSGMLe2kyR/PyrowpHJgBKstEV18I5+BekttYdmC53uEWRPEGbRvCE1tGkqyQ7PrgE1aitI19biQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=khGzekuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="khGzekuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F13DC4CECC;
	Thu,  7 Nov 2024 22:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019130;
	bh=wm4Zo2FE2XXuwEvDQXIAcohVVK3KyWI9Mvl1NybIUsc=;
	h=Date:To:From:Subject:From;
	b=khGzekuNuWeX1AragwREZTVDmj1aHC47SKB43etEUErJ/QrDFQNnieOG9978kDkA9
	 gvx2fml/rHRknpO25FJ2FwG3m256A9eNbxvJ99/xrr41YTx3BdfkoyXIRZRZD6RtWs
	 LYG55ujc29/252qJ+Nwwz+FLV/waUniSMxx5OYBQ=
Date: Thu, 07 Nov 2024 14:38:49 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch removed from -mm tree
Message-Id: <20241107223850.7F13DC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/debugfs_duplicate_context_creation: hide errors from expected file write failures
has been removed from the -mm tree.  Its filename was
     selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/debugfs_duplicate_context_creation: hide errors from expected file write failures
Date: Mon, 28 Oct 2024 16:30:56 -0700

debugfs_duplicate_context_creation.sh does an invalid file write to ensure
it fails.  Check of the failure is sufficient, so the error message from
the failure only makes the output unnecessarily noisy.  Hide it.

Link: https://lkml.kernel.org/r/20241028233058.283381-5-sj@kernel.org
Fixes: ade38b8ca5ce ("selftest/damon: add a test for duplicate context dirs creation")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh~selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures
+++ a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh
@@ -12,7 +12,7 @@ then
 	exit 1
 fi
 
-if echo foo > "$DBGFS/mk_contexts"
+if echo foo > "$DBGFS/mk_contexts" 2> /dev/null
 then
 	echo "duplicate context creation success"
 	exit 1
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch

