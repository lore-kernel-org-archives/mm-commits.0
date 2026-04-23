Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8673A3806C4
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 10:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776941626; cv=none; b=Pls8zmpDM/i2BEOdsaRtvnuBR4ulSJFu2SstQXDoebhHdJPOCj8VBa7ZUMw7B9qIoyvDsvIQDpkOOVNtOK/Q8Liiu+4M2OJm6dDXxcYd1REVtfRg5GHAiLEInkgrBgGXYSCLicaHo5ljbQl3ZlZxbNMkVTpyq3v7UmSwSwQ4rRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776941626; c=relaxed/simple;
	bh=LLENSlNLr4craroLvm/8W8rZ/czM8kIGtITdHCiRsXQ=;
	h=Date:To:From:Subject:Message-Id; b=jcrVer0ME7rzerGW8kaX1Yf5vWGXyea2WEiPT0T2n+21xHnm1pxf++9A7Oq2v1X2qg9gZFzMR8RexN4b4tgvLobKwaF/uXsdF9S2/ojWCE5iQc4Tzft3k5P2/7od1hMFNjuVsNPunptOOhD71/Bb4hbbbh5x+Fj1lkUjZwkQ6qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IZNWPe6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IZNWPe6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38EDC2BCAF;
	Thu, 23 Apr 2026 10:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776941626;
	bh=LLENSlNLr4craroLvm/8W8rZ/czM8kIGtITdHCiRsXQ=;
	h=Date:To:From:Subject:From;
	b=IZNWPe6Y6F1OAMKOP7BaWSqQOsZTgiP91PNHkM1rf16mOHv537eeUS0CqSky97maK
	 G3XpEJd7JU4XY8Vm+xBD3KwnZ/xM/z9I3/ugz2g/FMqKb/PkCE6ZpGF5ZtjXFXTlE5
	 SrQOoAixo1wzdK36aZtscHGZU8AmIp5Wufbhxr/E=
Date: Thu, 23 Apr 2026 03:53:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,wangli.ahau@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets.patch added to mm-new branch
Message-Id: <20260423105345.F38EDC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: respect build verbosity settings for 32/64-bit targets
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets.patch

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
Subject: selftests/mm: respect build verbosity settings for 32/64-bit targets
Date: Wed, 22 Apr 2026 16:04:45 +0800

Patch series "selftests/mm: clean up build output and verbosity", v3.

Currently, the build process for the mm selftests is unnecessarily noisy.

First, it leaks raw compiler errors during the liburing feature probe if
the headers are missing, which is confusing since the build system already
handles this gracefully with a clear warning.

Second, the specific 32-bit and 64-bit compilation targets ignore the
standard kbuild verbosity settings, always printing their full compiler
commands even during a default quiet build.


This patch (of 2):

The 32-bit and 64-bit compilation rules invoke $(CC) directly, bypassing
the $(Q) quiet prefix and $(call msg,...) helper used by the rest of the
selftests build system.  This causes these rules to always print the full
compiler command line, even when V=0 (the default).

Wrap the commands with $(Q) and $(call msg,CC,,$@) to match the convention
used by lib.mk, so that quiet and verbose builds behave consistently
across all targets.

==== Build logs ====
  ...
  CC       merge
  CC       rmap
  CC       soft-dirty
  gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
                -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
                -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
                -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
                -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
                -m32 -mxsave  protection_keys.c vm_util.c thp_settings.c pkey_util.c
                -lrt -lpthread -lm -lrt -ldl -lm
                -o /usr/src/25/tools/testing/selftests/mm/protection_keys_32
  gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
                -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
                -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
                -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
                -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
                -m32 -mxsave  pkey_sighandler_tests.c vm_util.c thp_settings.c pkey_util.c
                -lrt -lpthread -lm -lrt -ldl -lm
                -o /usr/src/25/tools/testing/selftests/mm/pkey_sighandler_tests_32
  ...

Link: https://lore.kernel.org/20260422080446.26020-1-wangli.ahau@gmail.com
Link: https://lore.kernel.org/20260422080446.26020-2-wangli.ahau@gmail.com
Signed-off-by: Li Wang <wangli.ahau@gmail.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
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

 tools/testing/selftests/mm/Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets
+++ a/tools/testing/selftests/mm/Makefile
@@ -216,7 +216,8 @@ ifeq ($(CAN_BUILD_I386),1)
 $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
-	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
@@ -224,7 +225,8 @@ ifeq ($(CAN_BUILD_X86_64),1)
 $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
-	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
 
_

Patches currently in -mm which might be from wangli.ahau@gmail.com are

selftests-mm-respect-build-verbosity-settings-for-32-64-bit-targets.patch
selftests-mm-suppress-compiler-error-in-liburing-check.patch

