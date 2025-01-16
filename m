Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE01214A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006490; cv=none; b=QLYECPlIwRzGhuZNESzqtfquMJPrmuVTER8wP0PtdlToVgm5g60FMPK+NWQCiSweQPmDZXDH2BuHEhFJZC1QakH9kRkrD3ZNW6Ry3DW/NVgWzL7jbKfIgPg4wO5QInrNkORhFCtvu0nb2ZeGIh7nib/myWiQMYO/qult6RJRZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006490; c=relaxed/simple;
	bh=0peHWsajmpStVKLM9QbntkoD7YhL5spfTVezWagmOXc=;
	h=Date:To:From:Subject:Message-Id; b=CuXVViCVgyly3tFAFxHWzL5HcqPy+MzlqkowrrcTUhJu9EFMxUVggnQXjO4z/0ckIgFk2H4Xm7B4RTe1px6bil9V8VXDtRECKqYuTFGGRtKX4TbrkBtKU4R+Lz5KpvU1LFb3kv6bZ6sFsgIrnrF/Th9l9LmtC5SoIJEt+IVhTco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zHhe74q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zHhe74q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CAFC4CED6;
	Thu, 16 Jan 2025 05:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006490;
	bh=0peHWsajmpStVKLM9QbntkoD7YhL5spfTVezWagmOXc=;
	h=Date:To:From:Subject:From;
	b=zHhe74q+fsqIB6Is4Kc5yoli71U5aJvn2qWyR2x3PQkGABpHJmLt3Ite83ANRUnRX
	 1B6iEkuV+/ChVb0bFtdXdG+JCfVul/MoQZi4vtn4nbdmOQ5j8zmZyD7DXykmsqCHib
	 ZcOg/PK4UpGeUP6thEvpIh8zyz8BY31MrzWPTA8U=
Date: Wed, 15 Jan 2025 21:48:10 -0800
To: mm-commits@vger.kernel.org,oberpar@linux.ibm.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] gcov-clang-use-correct-function-param-names.patch removed from -mm tree
Message-Id: <20250116054810.A1CAFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gcov: clang: use correct function param names
has been removed from the -mm tree.  Its filename was
     gcov-clang-use-correct-function-param-names.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


