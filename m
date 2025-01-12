Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F36233F7
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736660083; cv=none; b=s+fk7pQF5J+kp/r7B/keWZd00q/7iUZ5aHtYWjOfn6/KSZzd06IErTjayCmoq9jxfq1TEWKay9RcohzSaF37DagAc3ZMTNLwn+mYmXMPNz/aAV9k2eF2v6MwPpbKhK3srJ/djwsj8oyPF1GE9/B0eW1xRhnO+5gn+Y/rNMQclho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736660083; c=relaxed/simple;
	bh=jo90WdXpRe9MLvDoNwnUUCgHzvUiyzpFtNAbCBoH8RA=;
	h=Date:To:From:Subject:Message-Id; b=S1h4W6iFxcQv8y3ro1AmMeL119j44WJAfgd1d1QcY2tFGvNwzLlB+yz3iMTB47smd3sGyQ3ctuJ88gTvjwnuQKChAJZeq75KPTC5++Rh4MlUcH9SlhwXjV+0cd3c2aPNn5C/Rxb0gf8rQiUElA+RL9ZnCnNnv0w+aVYktDN828k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y3cR7SbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3cR7SbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41DCC4CEE0;
	Sun, 12 Jan 2025 05:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736660082;
	bh=jo90WdXpRe9MLvDoNwnUUCgHzvUiyzpFtNAbCBoH8RA=;
	h=Date:To:From:Subject:From;
	b=Y3cR7SbBQd5kRYakixXkBCMzX7Im4uWcRIJiHg6URXcNZe6CTTzVyRR3JtkQ3HSyc
	 bsMlSCPGq3BP7RaWPHjF8rNExKirwLbAqFbAdpindOC2YudAqBY/D09h2QIWY/IgXz
	 Gu3613DheGMipoW4v2SP5vqPKdRO9v7bmatD7GSQ=
Date: Sat, 11 Jan 2025 21:34:42 -0800
To: mm-commits@vger.kernel.org,oberpar@linux.ibm.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-clang-use-correct-function-param-names.patch added to mm-nonmm-unstable branch
Message-Id: <20250112053442.B41DCC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gcov: clang: use correct function param names
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     gcov-clang-use-correct-function-param-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-clang-use-correct-function-param-names.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: gcov: clang: use correct function param names
Date: Fri, 10 Jan 2025 22:29:44 -0800

Fix the function parameter names to match the function so that
the kernel-doc warnings disappear.

clang.c:273: warning: Function parameter or struct member 'dst' not described in 'gcov_info_add'
clang.c:273: warning: Function parameter or struct member 'src' not described in 'gcov_info_add'
clang.c:273: warning: Excess function parameter 'dest' description in 'gcov_info_add'
clang.c:273: warning: Excess function parameter 'source' description in 'gcov_info_add'

Link: https://lkml.kernel.org/r/20250111062944.910638-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/clang.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/gcov/clang.c~gcov-clang-use-correct-function-param-names
+++ a/kernel/gcov/clang.c
@@ -264,10 +264,10 @@ int gcov_info_is_compatible(struct gcov_
 
 /**
  * gcov_info_add - add up profiling data
- * @dest: profiling data set to which data is added
- * @source: profiling data set which is added
+ * @dst: profiling data set to which data is added
+ * @src: profiling data set which is added
  *
- * Adds profiling counts of @source to @dest.
+ * Adds profiling counts of @src to @dst.
  */
 void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch
kasan-use-correct-kernel-doc-format.patch
latencytop-use-correct-kernel-doc-format-for-func-params.patch
kthread-modify-kernel-doc-function-name-to-match-code.patch
gcov-clang-use-correct-function-param-names.patch

