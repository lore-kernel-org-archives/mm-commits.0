Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBA63806C4
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 10:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776941628; cv=none; b=qiLncEcBosf1JL+5+/tUIcfuAK3/FKetI6iNuKnMf5W7rc19DrZdWqAv3pU8ltYN0t0mtx5v0gORBOeJ3Y81/xjT39p51Xmy20OdGZrhdhZTDTD52oJNrn8KMd0sFgQddQAmQGjZuXFOA2L6nMYOJf9dRAywPwzFE5Ci1ZguBxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776941628; c=relaxed/simple;
	bh=dpvf06f+l7uz/YCcjrU9hxbBLzcMzTOhjtTix9wqulI=;
	h=Date:To:From:Subject:Message-Id; b=rcN9PqpF/Gr/mNXHd/Vm+4+psX+eFjEMwKbadeQ3gVZ5gwPu5q8lLg5WQAJTgXmWu6l3z39K94sxHuOH/2fb8Icg2UyLM0Qu33tMYOJCpFK3WmIFKqNgPMHEoc/FuZs00YeDMcr5hNSvUB873ueY35UZ00UlckJqo/dalMsXs1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aSxJQ6Yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aSxJQ6Yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6744CC2BCAF;
	Thu, 23 Apr 2026 10:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776941628;
	bh=dpvf06f+l7uz/YCcjrU9hxbBLzcMzTOhjtTix9wqulI=;
	h=Date:To:From:Subject:From;
	b=aSxJQ6YgGawB+cbRo5o5+fGc19U4Rp2cHw/bn4DalWkWQ/AXvtzj+NlhFaQEd9DU8
	 h5Mh6O2TGeKGZEcGbDgNEXwvhqujH0VxlP2alnWLSgkpGfTLD9ODhQnpm/YYIvY3xS
	 vKMCjQn1I8QxY3Qis4NECO//TgLIMGMlir4EuhvI=
Date: Thu, 23 Apr 2026 03:53:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,wangli.ahau@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-suppress-compiler-error-in-liburing-check.patch added to mm-new branch
Message-Id: <20260423105348.6744CC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: suppress compiler error in liburing check
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-suppress-compiler-error-in-liburing-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-suppress-compiler-error-in-liburing-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Li Wang <wangli.ahau@gmail.com>
Subject: selftests/mm: suppress compiler error in liburing check
Date: Wed, 22 Apr 2026 16:04:46 +0800

When building the mm selftests on a system without liburing development
headers, check_config.sh leaks a raw compiler error:

  /tmp/tmp.kIIOIqwe3n.c:2:10: fatal error: liburing.h: No such file or directory
      2 | #include <liburing.h>
        |          ^~~~~~~~~~~~

Since this is an expected failure during the configuration probe,
redirect the compiler output to /dev/null to hide it.

And the build system prints a clear warning when this occurs:

  Warning: missing liburing support. Some tests will be skipped.

Because the user is properly notified about the missing dependency, the
raw compiler error is redundant and only confuse users.

Additionally, update the Makefile to use $(Q) and $(call msg,...) for the
check_config.sh execution.  This aligns the probe with standard kbuild
output formatting, providing a clean "CHK" message instead of printing the
raw command during the build.

Link: https://lore.kernel.org/20260422080446.26020-3-wangli.ahau@gmail.com
Signed-off-by: Li Wang <wangli.ahau@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile        |    3 ++-
 tools/testing/selftests/mm/check_config.sh |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/check_config.sh~selftests-mm-suppress-compiler-error-in-liburing-check
+++ a/tools/testing/selftests/mm/check_config.sh
@@ -16,7 +16,7 @@ echo "#include <sys/types.h>"        > $
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-suppress-compiler-error-in-liburing-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -263,7 +263,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
+	$(call msg,CHK,config,$@)
+	$(Q)CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
_

Patches currently in -mm which might be from wangli.ahau@gmail.com are

selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets.patch
selftests-mm-suppress-compiler-error-in-liburing-check.patch

