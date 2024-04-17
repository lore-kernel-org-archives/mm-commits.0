Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED27EAC8
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713386990; cv=none; b=rgGq4LpA4CEnnlp3PkdjIhh3XCjq5GWzMBYIkQP6Cei/DPlAEl8uDUT1EeIDZLv7uudiVaHotazz2FJDrOdcKlt1Zuhu51qBVDr4TrMWpbj7V1siO1tShK2PKQAb37y7dTcadyvDL4OATIJHyLimFwp+aAOJOyLUtLbVxV6/0ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713386990; c=relaxed/simple;
	bh=FQ3fjefFDy4o0vTzpTN6QxMmAlMG0mVS48kytpUUhiY=;
	h=Date:To:From:Subject:Message-Id; b=hw7KK4/NLGAmIZ3mN/NR3DEh0z2kWf6iJ5SG4Fy7e1d0IRoiGO7sI7O9/XbeqUQb9tqWvzz25AOeWvBGWDeVSlYR4P7kWCHy7AXI946K/SwVuKA1pdHiDk1mYKVX4G7EHam5IG7mPMh2olHUCX4FhXp7chmmd05ZDbC+nelG0ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wrSTps+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wrSTps+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B077DC072AA;
	Wed, 17 Apr 2024 20:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713386989;
	bh=FQ3fjefFDy4o0vTzpTN6QxMmAlMG0mVS48kytpUUhiY=;
	h=Date:To:From:Subject:From;
	b=wrSTps+iKbBfWQjrLz891RbtNHs2xMA09WLz6NDzY4xQ9tlQj815G3Sgb0EUi6cJ0
	 c0WnJsIILIsHPktHeHSZyrK0h0n0V89qwBWb5PYXal+XeHjauU926xWGyRYVhB5Jhr
	 PNkCNqlG8IRBSnvcdfOPQ5qjWl+LIjWKUfDPS0d0=
Date: Wed, 17 Apr 2024 13:49:49 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,luto@amacapital.net,keescook@chromium.org,justinstitt@google.com,edliaw@google.com,david@redhat.com,axelrasmussen@google.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-harness-remove-use-of-line_max-fix-fix-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240417204949.B077DC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: fix undeclared function error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-harness-remove-use-of-line_max-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-harness-remove-use-of-line_max-fix-fix-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: fix undeclared function error
Date: Wed, 17 Apr 2024 12:55:30 +0500

Fix the error reported by clang:

In file included from mdwe_test.c:17:
./../kselftest_harness.h:1169:2: error: call to undeclared function
'asprintf'; ISO C99 and later do not support implicit function
declarations [-Wimplicit-function-declaration]
 1169 |         asprintf(&test_name, "%s%s%s.%s", f->name,
      |         ^
1 warning generated.

The gcc reports it as warning:

In file included from mdwe_test.c:17:
../kselftest_harness.h: In function `__run_test':
../kselftest_harness.h:1169:9: warning: implicit declaration of function
`asprintf'; did you mean `vsprintf'? [-Wimplicit-function-declaration]
 1169 |         asprintf(&test_name, "%s%s%s.%s", f->name,
      |         ^~~~~~~~
      |         vsprintf

Fix this by setting _GNU_SOURCE macro needed to get exposure to the
asprintf().

Link: https://lkml.kernel.org/r/20240417075530.3807625-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Edward Liaw <edliaw@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mdwe_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/mdwe_test.c~selftests-harness-remove-use-of-line_max-fix-fix-fix
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -7,6 +7,7 @@
 #include <linux/mman.h>
 #include <linux/prctl.h>
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/auxv.h>
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-harness-remove-use-of-line_max-fix-fix-fix.patch
selftests-mm-fix-unused-and-uninitialized-variable-warning.patch
selftests-exec-make-binaries-position-independent.patch

