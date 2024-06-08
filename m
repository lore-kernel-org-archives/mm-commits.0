Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAD48BEF
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 02:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717813682; cv=none; b=pI8gsR7i6+2W1vtkHUJu2Xp8BkoFPYir0PtYxTBxWG4ZQN5k0/iw3Yaq1UFRwzyQEzADz4i5R0NS6UNhUUnoWrH9niV31g4gNhVed5PTFNXmpRA1hC6rH9tQxhefNtQpn6K8tm1CozYfXqVHSGglD+aE6IKREUpuLT0YzenrgT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717813682; c=relaxed/simple;
	bh=CqqRMhvNYbP0U48N0TSS0am6PLNXaFCrCtCN3Xp7+Wk=;
	h=Date:To:From:Subject:Message-Id; b=YfKiACQ1g6wLq+ECtPpsegW8ky4uJfnt4U01Gb61IxiZJbUFuVkCBE588VbjZjlznwWPMuBt7TQusAQL9gw5yaW7fmIVwtCfRIpXLSn9dA2HFk+LSE5vHKEr491d/ORlyUB/qZwgQ//ip1H2bxBsmd0I0gZ+rILVTMmBx//038U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EMat5i18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EMat5i18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3757AC2BBFC;
	Sat,  8 Jun 2024 02:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717813682;
	bh=CqqRMhvNYbP0U48N0TSS0am6PLNXaFCrCtCN3Xp7+Wk=;
	h=Date:To:From:Subject:From;
	b=EMat5i18AZv9Fo+JVNuTy9XtzI87IM968aEgGhL9sjiCuRfiTlgRaBVTHBLn6RElS
	 bFdBD4IeGyIkDg3XWp8LBHvU8zieYandCMXEHjRBzD5Rz4/6633FUJKFriu/X+6jCh
	 G7FsPnhNnw1YtXukYg1IQ+C7R88iGcm31YwffGkY=
Date: Fri, 07 Jun 2024 19:28:01 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch added to mm-unstable branch
Message-Id: <20240608022802.3757AC2BBFC@smtp.kernel.org>
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
Date: Fri, 7 Jun 2024 19:10:19 -0700

Pach series "cleanups, fixes, and progress towards avoiding "make
headers"".

Eventually, once the build succeeds on a sufficiently old distro, the idea
is to delete $(KHDR_INCLUDES) from the selftests/mm build, and then after
that, from selftests/lib.mk and all of the other selftest builds.

For now, this series merely achieves a clean build of selftests/mm on a
not-so-old distro: Ubuntu 23.04:

1. Add __NR_mseal.

2. Add fs.h, taken as usual from a snapshot of
   ./usr/include/linux/fs.h after running "make headers".  This is how we
   have agreed to do this sort of thing, see [1].

3. Add a few selected prctl.h values that the ksm and mdwe tests require.

[1] commit e076eaca5906 ("selftests: break the dependency upon local
header files")


This patch (of 5):

The selftests/mm build isn't exactly "broken", according to the current
documentation, which still claims that one must run "make headers", before
building the kselftests.  However, according to the new plan to get rid of
that requirement [1], they are future-broken: attempting to build
selftests/mm *without* first running "make headers" will fail due to not
finding __NR_mseal.

Therefore, add __NR_mseal, to a new mseal_helpers.h file.  That file is
small right now, but subsequent patches will add a lot more content to it.

[1] commit e076eaca5906 ("selftests: break the dependency upon local
header files")

Link: https://lkml.kernel.org/r/20240608021023.176027-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20240608021023.176027-2-jhubbard@nvidia.com
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_helpers.h |    5 +++++
 tools/testing/selftests/mm/mseal_test.c    |    1 +
 tools/testing/selftests/mm/seal_elf.c      |    1 +
 3 files changed, 7 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/mm/mseal_helpers.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __NR_mseal
+#define __NR_mseal 462
+#endif
--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-mseal-self_elf-fix-missing-__nr_mseal
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -17,6 +17,7 @@
 #include <sys/ioctl.h>
 #include <sys/vfs.h>
 #include <sys/stat.h>
+#include "mseal_helpers.h"
 
 /*
  * need those definition for manually build using gcc.
--- a/tools/testing/selftests/mm/seal_elf.c~selftests-mm-mseal-self_elf-fix-missing-__nr_mseal
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -16,6 +16,7 @@
 #include <sys/ioctl.h>
 #include <sys/vfs.h>
 #include <sys/stat.h>
+#include "mseal_helpers.h"
 
 /*
  * need those definition for manually build using gcc.
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
mm-selftests-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

