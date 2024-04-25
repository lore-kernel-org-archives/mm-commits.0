Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA0B5240
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 02:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012094; cv=none; b=SrHhRs+hShZDTjrHKPXs4RnVdbOzT/MWO/QANbA6AHddzRGZI3WeFfiz3rumPVaRcbPVrrEG3L5pi8kHinagKJd0sHRICl4yexmWHlPyFNoNWybV3pYbDwaK3WILhAAfw06sAbxZVqtYRlcViulu3Jm0c6c/P+dGiioms98o9C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012094; c=relaxed/simple;
	bh=0pjPM6JXzmwG4dzzw0WQ9yZyEORiMoINTieDznkWSvw=;
	h=Date:To:From:Subject:Message-Id; b=mkVX4C0FdijTloR6zUShJpZNgC1YtE2JTXtrPYXRIOOD9TLrV8Only8eMeBV9w7LXnLCR5J26YICS4e7GxgsnQNWujipw8RENg8AHCvTflofjap6pJQ6x3fsHCvw0kuVZwdTnBnJUEcXdfBiJyNixzcl+oZRly1i7kIjLBrYdoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XcfnIpKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XcfnIpKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B214AC113CD;
	Thu, 25 Apr 2024 02:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012093;
	bh=0pjPM6JXzmwG4dzzw0WQ9yZyEORiMoINTieDznkWSvw=;
	h=Date:To:From:Subject:From;
	b=XcfnIpKUgQJ5hGPWRZzqxgcg7MCOv3UyFAfujnUlUxXWyd58wL4Tthz/BjA6xKGH7
	 u8/AL6XgT2Ed2ZaaW6GTz/YJJQX6cQiDKipuPA5QNAWjpgWj1csI+mBczbuOPc/jxA
	 zX2Bcb/W6EyRyHrtI1gQhLwb3MpTrhYgA0eTC35I=
Date: Wed, 24 Apr 2024 19:28:13 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,luto@amacapital.net,keescook@chromium.org,justinstitt@google.com,edliaw@google.com,david@redhat.com,axelrasmussen@google.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-harness-remove-use-of-line_max-fix-fix-fix.patch removed from -mm tree
Message-Id: <20240425022813.B214AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix undeclared function error
has been removed from the -mm tree.  Its filename was
     selftests-harness-remove-use-of-line_max-fix-fix-fix.patch

This patch was dropped because it was folded into selftests-harness-remove-use-of-line_max.patch

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

selftests-harness-remove-use-of-line_max.patch
selftests-mm-fix-unused-and-uninitialized-variable-warning.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script.patch
selftests-exec-make-binaries-position-independent.patch

