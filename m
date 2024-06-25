Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D7C13D289
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291694; cv=none; b=PKNge18mDfj6py9CKvzI4ziYkxR4yfXz2vQgzBajbDR7fg1i8YvKVnlc6+lCSKzebBivhc/pokdppJR0eK06ftWg3FrddHFr8edrfDqB+/szzaE8fbZ1r1yw+Sn1AEnLtLuHzT52V1c4ADdBOckVjRx0ipoNV+HN/pBzfFuvE30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291694; c=relaxed/simple;
	bh=C800pLp7cJnFSf1zGyLzUnkyeWga5xAwg1Os+2XaWiw=;
	h=Date:To:From:Subject:Message-Id; b=gE5z5byGNd9xnk5Wxp+vkijX9xxoKjH6+XYfZBySpGHZ6U53tFco5vMJcM+drkNNY7Lxc8vN231WwJ6XSTtdIXu3ow1UZ5tbSPap+8jHIq9Y+N0d9ZQu6On87wJJNufSDrL4GGq5CBTE6WdtVCqN+RurA2v7nBeq+MX1grrKpyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLLJXK85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLLJXK85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA39DC32782;
	Tue, 25 Jun 2024 05:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291694;
	bh=C800pLp7cJnFSf1zGyLzUnkyeWga5xAwg1Os+2XaWiw=;
	h=Date:To:From:Subject:From;
	b=sLLJXK85YBu0aaKbEaBodTUJkoYghDUTy8mUzgqihHW1EjIDqMel7ImDT0lwdMKZ9
	 Q0Il81SJ/JYnW8aFsVvb+x9kBDdQiyImqxdRase3qF14RYyn60RdmD/YSSzfvUPr5/
	 MaKcYiv0YeB7vXTBHxr7hVlINky5OhEjh7KgwAzg=
Date: Mon, 24 Jun 2024 22:01:34 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,cmllamas@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-include-linux-mmanh.patch removed from -mm tree
Message-Id: <20240625050134.AA39DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: include linux/mman.h
has been removed from the -mm tree.  Its filename was
     selftests-mm-include-linux-mmanh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: include linux/mman.h
Date: Wed, 5 Jun 2024 22:36:34 +0000

thuge-gen defines MAP_HUGE_* macros that are provided by linux/mman.h
since 4.15. Removes the macros and includes linux/mman.h instead.

Link: https://lkml.kernel.org/r/20240605223637.1374969-2-edliaw@google.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-include-linux-mmanh
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -15,6 +15,7 @@
 
 #define _GNU_SOURCE 1
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <sys/ipc.h>
@@ -28,10 +29,6 @@
 #include "vm_util.h"
 #include "../kselftest.h"
 
-#define MAP_HUGE_2MB    (21 << MAP_HUGE_SHIFT)
-#define MAP_HUGE_1GB    (30 << MAP_HUGE_SHIFT)
-#define MAP_HUGE_SHIFT  26
-#define MAP_HUGE_MASK   0x3f
 #if !defined(MAP_HUGETLB)
 #define MAP_HUGETLB	0x40000
 #endif
_

Patches currently in -mm which might be from edliaw@google.com are


