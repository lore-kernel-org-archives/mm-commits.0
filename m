Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5967717BD3
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 02:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012516; cv=none; b=kbqNOa6wcifTuWJUzQET/Z+CNxQJ0zz2FZERiqszMACe3d1XnH4q7aAg8MXKVWGw36sUrjYBpjPocGQdtwn07+MGZ8B+9qgR4EFhG6Al+uAtX94w8gZcSp3Qt+b5MzM4W5poy/KBxz20/5ahoMtHSZZI+ljnTiVCPjtxRPAluPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012516; c=relaxed/simple;
	bh=N9EoU1+5nGGhtHKRNaj91ou56s4CPmBRPh8GFnCQW9A=;
	h=Date:To:From:Subject:Message-Id; b=Xk/fXMsojZTajXv2wzUaP7DO6MiVBs5JW1QFEI4Tr9X91K+uFGEoiPm1Vm982ZK/x8iHO7jiKBPK6gAXivV1aWZpIxZB0HHmdI9ICVihkwEvmwhn4xZgT6HxbJTZq1rEVp3IkVR97zqURv8QLkJizMA2eOclSC/ZbIV1jmjaFnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tq2MUBGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tq2MUBGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1A3C113CD;
	Thu, 25 Apr 2024 02:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012515;
	bh=N9EoU1+5nGGhtHKRNaj91ou56s4CPmBRPh8GFnCQW9A=;
	h=Date:To:From:Subject:From;
	b=tq2MUBGVcBFnBIvsR/vzMrxlGgeUuPc96x+n2zbWOxcQ1QHlne+Ls3ytad0zrEKGG
	 kJUnVQXXGZqKj4xsJRPLErBw1vec9zWWLnKRJx2pJddXaQebEJehnwJ9sPU1YotXEN
	 hJM8PlOsBtvmLC4Dct0XzrTwy+ZoS90f+c7qZ+6s=
Date: Wed, 24 Apr 2024 19:35:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-unused-and-uninitialized-variable-warning.patch removed from -mm tree
Message-Id: <20240425023515.AF1A3C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix unused and uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-unused-and-uninitialized-variable-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: fix unused and uninitialized variable warning
Date: Tue, 16 Apr 2024 21:26:58 +0500

Fix the warnings by initializing and marking the variable as unused.
I've caught the warnings by using clang.

split_huge_page_test.c:303:6: warning: variable 'dummy' set but not used [-Wunused-but-set-variable]
  303 |         int dummy;
      |             ^
split_huge_page_test.c:343:3: warning: variable 'dummy' is uninitialized when used here [-Wuninitialized]
  343 |                 dummy += *(*addr + i);
      |                 ^~~~~
split_huge_page_test.c:303:11: note: initialize the variable 'dummy' to silence this warning
  303 |         int dummy;
      |                  ^
      |                   = 0
2 warnings generated.

Link: https://lkml.kernel.org/r/20240416162658.3353622-1-usama.anjum@collabora.com
Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-fix-unused-and-uninitialized-variable-warning
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -300,7 +300,7 @@ int create_pagecache_thp_and_fd(const ch
 		char **addr)
 {
 	size_t i;
-	int dummy;
+	int __attribute__((unused)) dummy = 0;
 
 	srand(time(NULL));
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-exec-make-binaries-position-independent.patch

