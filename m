Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCEB1428E0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291663; cv=none; b=pli6fWyntV4IxKH46oceZkhHSuQH6w9fl9zjeSO2lB4SiHrzZLaN9v4LCEIhotLkqOZVTxLAFsJVrkppTu1h3RnG0yRxiU7g0+0a4kMM8xRQ/G7bZatXIjuKwLOFuD65v2BrlNLaLoRRmCM3Drx3fOF+PwO8Fxnh2lkZtknOTFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291663; c=relaxed/simple;
	bh=x/fm6Yi2maDP9pnclQxlnrQHrLogb6YhrKjcJLXfpd8=;
	h=Date:To:From:Subject:Message-Id; b=mV0OqXY/j36WA5Br8h8Zd/qBkMKwRl7s21+wxMiv3gX3AjhSax9KhmBEWlWnZVHx9a9a7d+u3/D0g9ahvfLiw/tL7NHYh4nff1AjWQJc6BZp8Frgjw3A0KIfjkoz++6076f63ovoj3Sl/fNygBknA7r/3hyHt/QSHVCYcEuo5SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2rJ+QBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2rJ+QBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8E6C32782;
	Tue, 25 Jun 2024 05:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291663;
	bh=x/fm6Yi2maDP9pnclQxlnrQHrLogb6YhrKjcJLXfpd8=;
	h=Date:To:From:Subject:From;
	b=K2rJ+QBEzRZ8Lw5QublYgf7JJdU+TIRyJzLr2akCxoHKfC6AZ8WonJlUUCoEcCGV2
	 TnQaVkYeydCoDN3nYSNczbWyACVDaeqk0CfGpNfSXXCibKVJYDmd9VjJCoKjTZ6ORa
	 HbtYvRIh8+lsnjYDDaR4WyGYZLtaHyhjgWG+w8kw=
Date: Mon, 24 Jun 2024 22:01:03 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch removed from -mm tree
Message-Id: <20240625050103.9E8E6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mseal, self_elf: fix missing __NR_mseal
has been removed from the -mm tree.  Its filename was
     selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
documentation, which still claims that one must run "make headers",
before building the kselftests.  However, according to the new plan to
get rid of that requirement [1], they are future-broken: attempting to
build selftests/mm *without* first running "make headers" will fail due
to not finding __NR_mseal.

Therefore, include asm-generic/unistd.h, which has all of the system
call numbers that are needed, abstracted across the various CPU arches.

Some explanation in support of this "asm-generic" approach:

For most user space programs, the header file inclusion behaves as per
this microblaze example, which comes from David Hildenbrand (thanks!):

     arch/microblaze/include/asm/unistd.h
         -> #include <uapi/asm/unistd.h>

     arch/microblaze/include/uapi/asm/unistd.h
         -> #include <asm/unistd_32.h>
         -> Generated during "make headers"

     usr/include/asm/unistd_32.h is generated via
     arch/microblaze/kernel/syscalls/Makefile with the syshdr command.

     So we never end up including asm-generic/unistd.h directly on
     microblaze... [2]

However, those programs are installed on a single computer that has a
single set of asm and kernel headers installed.

In contrast, the kselftests are quite special, because they must
provide a set of user space programs that:

     a) Mostly avoid using the installed (distro) system header files.

     b) Build (and run) on all supported CPU architectures

     c) Occasionally use symbols that have so new that they have not
        yet been included in the distro's header files.

Doing (a) creates a new problem: how to get a set of cross-platform
headers that works in all cases.

Fortunately, asm-generic headers solve that one.  Which is why we need
to use them here--at least, for particularly difficult headers such as
unistd.h.

The reason this hasn't really come up yet, is that until now, the
kselftests requirement (which I'm trying to eventually remove) was that
"make headers" must first be run.  That allowed the selftests to get a
snapshot of sufficiently new header files that looked just like (and
conflict with) the installed system headers.

And as an aside, this is also an improvement over past practices of
simply open-coding in a single (not per-arch) definition of a new
symbol, directly into the selftest code.

[1] commit e076eaca5906 ("selftests: break the dependency upon local
header files")

[2] https://lore.kernel.org/all/0b152bea-ccb6-403e-9c57-08ed5e828135@redhat.com/

Link: https://lkml.kernel.org/r/20240618022422.804305-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20240618022422.804305-2-jhubbard@nvidia.com
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jeff Xu <jeffxu@chromium.org>
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

selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

