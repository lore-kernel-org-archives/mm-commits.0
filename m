Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A71418EAB
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 22:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718144480; cv=none; b=qhe14E4HUNYZEnmTjdj2deo8GcsnFwjnksPm+GaRSgp5JrTdNwpZRDusuNVYpMajZI9Sk7RyqMoyUA31X7MXcIb8gPfGPBkTuWH+F5bOB1m14Npe9fDzKrnEnJ8ifAdQnPz3hk4KASzsVkjihqnzTB31vZPti44yJGxQ0TsGMsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718144480; c=relaxed/simple;
	bh=nNQE2jng3Czm39A3dSV//RjeuGFVACgPUJZ76QiHdpw=;
	h=Date:To:From:Subject:Message-Id; b=JsSTEAujlwFgf4W1RfiHlz1x9xQkwyAkpuVlMSak7O3C/0RQhhkce2DQ5WJpBmy7WBQhuIvG/bj/UecrTIec6ZlQGhlwpf6/uT9gSVyJSPgfMjzlG4eJzfnqIakedDogz+iwXNA4evMpY4yJej7orUAOAtBvbz0aG1hUwTDq/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Ks8Ca5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Ks8Ca5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0628CC2BD10;
	Tue, 11 Jun 2024 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718144480;
	bh=nNQE2jng3Czm39A3dSV//RjeuGFVACgPUJZ76QiHdpw=;
	h=Date:To:From:Subject:From;
	b=0Ks8Ca5i6hjJEzqx2uWrj+ZvzQOqQQKTRVIxIPtVP14pOozVcpTaltsQ2maYxc4CJ
	 cYr1kDZEs3RNyIFen8RLF766u4a8X8n18Zxt0+izBrCZ+u1L3oCQBLjr4Ms0wHzul+
	 IPXDRjXNzhHoyms1CUQodt5EmiHiqDJvInbCpDYk=
Date: Tue, 11 Jun 2024 15:21:19 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,cmllamas@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-guard-defines-from-shm.patch added to mm-unstable branch
Message-Id: <20240611222120.0628CC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: guard defines from shm
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-guard-defines-from-shm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-guard-defines-from-shm.patch

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
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: guard defines from shm
Date: Wed, 5 Jun 2024 22:36:35 +0000

thuge-gen.c defines SHM_HUGE_* macros that are provided by the uapi since
4.14.  These macros get redefined when compiling with Android's bionic
because its sys/shm.h will import the uapi definitions.

However if linux/shm.h is included, with glibc, sys/shm.h will clash on
some struct definitions:

  /usr/include/linux/shm.h:26:8: error: redefinition of ‘struct shmid_ds’
     26 | struct shmid_ds {
        |        ^~~~~~~~
  In file included from /usr/include/x86_64-linux-gnu/bits/shm.h:45,
                   from /usr/include/x86_64-linux-gnu/sys/shm.h:30:
  /usr/include/x86_64-linux-gnu/bits/types/struct_shmid_ds.h:24:8: note: originally defined here
     24 | struct shmid_ds
        |        ^~~~~~~~

For now, guard the SHM_HUGE_* defines with ifndef to prevent redefinition
warnings on Android bionic.

Link: https://lkml.kernel.org/r/20240605223637.1374969-3-edliaw@google.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-guard-defines-from-shm
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -34,10 +34,18 @@
 #endif
 
 #define SHM_HUGETLB     04000   /* segment will use huge TLB pages */
+#ifndef SHM_HUGE_SHIFT
 #define SHM_HUGE_SHIFT  26
+#endif
+#ifndef SHM_HUGE_MASK
 #define SHM_HUGE_MASK   0x3f
+#endif
+#ifndef SHM_HUGE_2MB
 #define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
+#endif
+#ifndef SHM_HUGE_1GB
 #define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
+#endif
 
 #define NUM_PAGESIZES   5
 #define NUM_PAGES 4
_

Patches currently in -mm which might be from edliaw@google.com are

selftests-mm-include-linux-mmanh.patch
selftests-mm-guard-defines-from-shm.patch

