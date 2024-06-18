Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E220A53E24
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743493; cv=none; b=QkABXxW397e58UmuH1H4gdk7FM/2/bws242+6xGPkFz4zBT1/EMGU6NPDKXGx6wmOxTJ04qocrLk3m7Aaz8uqSB2VnC1TpQDZWK6kgFmRqDeZCimmOfxlB8v2TUGLjjsBefNrNcODOBhAXLQ4pi5VLMOpSqCvcmFYZZrE7CZTDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743493; c=relaxed/simple;
	bh=lf44kbEOvhrkP7OLj/8aM5eUcDPZV8XigNIcnIdlY0o=;
	h=Date:To:From:Subject:Message-Id; b=PWmVbQvsi5O69SKDkTDkV+FzFWToYJmFV8BhPo4yx1W9lHc1ihBNEfRsbcwm78t18CbVLlYSFEAc9ayoylUfVPFAk/f66Bvi6nTbVN9twz5Hia3AYIDEQYi3Ha8e/eYLcgWv+oSx7bMocmv/ODwJOAKDhIv+ta5Yix6oTmM0s4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kdZvD5Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kdZvD5Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38354C3277B;
	Tue, 18 Jun 2024 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718743492;
	bh=lf44kbEOvhrkP7OLj/8aM5eUcDPZV8XigNIcnIdlY0o=;
	h=Date:To:From:Subject:From;
	b=kdZvD5UsFPw4aKNnWOhX7BPMbRHS3KJANNNbR64QtaA9Zkw23xgqH8sE3FQeC3iYS
	 HADJpTrKJh15tpxxtwAV4rkuuplpaZTO/nx49QM7WpxC4FSIB061t0b96uInkXyZJL
	 tBEz8pFJdbHUG4w8rwNV8neIIj+u2DeWZkZ0CE3Y=
Date: Tue, 18 Jun 2024 13:44:51 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch added to mm-unstable branch
Message-Id: <20240618204452.38354C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mseal, self_elf: fix missing __NR_mseal
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch

This patch will later appear in the mm-unstable branch at
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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: mseal, self_elf: fix missing __NR_mseal
Date: Mon, 17 Jun 2024 19:24:17 -0700

Patch series "cleanups, fixes, and progress towards avoiding "make
headers"", v3.

Eventually, once the build succeeds on a sufficiently old distro, the idea
is to delete $(KHDR_INCLUDES) from the selftests/mm build, and then after
that, from selftests/lib.mk and all of the other selftest builds.

For now, this series merely achieves a clean build of selftests/mm on a
not-so-old distro: Ubuntu 23.04.  In other words, after this series is
applied, it is possible to delete $(KHDR_INCLUDES) from
selftests/mm/Makefile and the build will still succeed.

1. Add tools/uapi/asm/unistd_[32|x32|64].h files, which include
   definitions of __NR_mseal, and include them (indirectly) from the files
   that use __NR_mseal.  The new files are copied from ./usr/include/asm,
   which is how we have agreed to do this sort of thing, see [1].

2. Add fs.h, similarly created: it was copied directly from a snapshot
   of ./usr/include/linux/fs.h after running "make headers".

3. Add a few selected prctl.h values that the ksm and mdwe tests require.

4. Factor out some common code from mseal_test.c and seal_elf.c, into
   a new mseal_helpers.h file.

5. Remove local __NR_* definitions and checks.

[1] commit e076eaca5906 ("selftests: break the dependency upon local
header files")


This patch (of 6):

The selftests/mm build isn't exactly "broken", according to the current
documentation, which still claims that one must run "make headers", before
building the kselftests.  However, according to the new plan to get rid of
that requirement [1], they are future-broken: attempting to build
selftests/mm *without* first running "make headers" will fail due to not
finding __NR_mseal.

Therefore, include asm-generic/unistd.h, which has all of the system call
numbers that are needed, abstracted across the various CPU arches.

[1] commit e076eaca5906 ("selftests: break the dependency upon local
header files")

Link: https://lkml.kernel.org/r/20240618022422.804305-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20240618022422.804305-2-jhubbard@nvidia.com
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    2 +-
 tools/testing/selftests/mm/seal_elf.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-mseal-self_elf-fix-missing-__nr_mseal
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -3,7 +3,7 @@
 #include <linux/mman.h>
 #include <sys/mman.h>
 #include <stdint.h>
-#include <unistd.h>
+#include <asm-generic/unistd.h>
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
--- a/tools/testing/selftests/mm/seal_elf.c~selftests-mm-mseal-self_elf-fix-missing-__nr_mseal
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -2,7 +2,7 @@
 #define _GNU_SOURCE
 #include <sys/mman.h>
 #include <stdint.h>
-#include <unistd.h>
+#include <asm-generic/unistd.h>
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-remove-local-__nr_-definitions.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

