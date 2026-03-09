Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B045E2367D1
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090420; cv=none; b=L+VujgGQ4CTeuM/pOt5iswbGZ+PpsScYhwoHeNGAxCdQdPLaqBITIWLFvIzJ7bO1J5A2xuG1FlJ1UEuDi2EuDoC8Z/3bmWrxSwNge/7NIUZAAVARzHgSJ5TWHOXXLAVo1tPrOz1e+41smbxdO613PhSXSkalSnR3L4fQ5sOjSPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090420; c=relaxed/simple;
	bh=2PMs3yRYvLoIMdZ0AObL8+0xhGg9TXkbzKp1BWTKl30=;
	h=Date:To:From:Subject:Message-Id; b=MWiSp6wCP35FE8TCByR/HZfNzVBqB7g1I/ghJLTayKzrw8IaRmeQmcRrASz2LoZ4opWT5fbdJ3tWrl9SiaW/9Van3su4NtRpGuy9E16jzPddBszdil/x6IbKgzVNpuu5YwxF7LwkPNVrSShZxmdulOjVJCggzg2NAyszrsOf5fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mi6X5/3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mi6X5/3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C937C2BC87;
	Mon,  9 Mar 2026 21:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773090420;
	bh=2PMs3yRYvLoIMdZ0AObL8+0xhGg9TXkbzKp1BWTKl30=;
	h=Date:To:From:Subject:From;
	b=mi6X5/3X4kSjh7y+6KPe7AJ5ypBp+nx26Lw4l952eht7/zEviXay77Cu80k9lbtG2
	 20tpLja3y5NjRXWp/JnVBcj4hNu75Eb3fVwweWZtklT4JP4rQ2X3nBulTcg68rVKQx
	 mc+qt2mLXgynd4tlqVE+39/unhdx6hkysnj1bz3k=
Date: Mon, 09 Mar 2026 14:06:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,aleksey.oladko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-fix-arch-normalization-to-handle-command-line-argument.patch added to mm-nonmm-unstable branch
Message-Id: <20260309210700.0C937C2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: fix ARCH normalization to handle command-line argument
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-fix-arch-normalization-to-handle-command-line-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-fix-arch-normalization-to-handle-command-line-argument.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
Subject: selftests: fix ARCH normalization to handle command-line argument
Date: Mon, 9 Mar 2026 20:51:45 +0000

Several selftests Makefiles (e.g.  prctl, breakpoints, etc) attempt to
normalize the ARCH variable by converting x86_64 and i.86 to x86. 
However, it uses the conditional assignment operator '?='.

When ARCH is passed as a command-line argument (e.g., during an rpmbuild
process), the '?=' operator ignores the shell command and the sed
transformation.  This leads to an incorrect ARCH value being used, which
causes build failures

  # make -C tools/testing/selftests TARGETS=prctl ARCH=x86_64
  make: Entering directory '/build/tools/testing/selftests'
  make[1]: Entering directory '/build/tools/testing/selftests/prctl'
  make[1]: *** No targets.  Stop.
  make[1]: Leaving directory '/build/tools/testing/selftests/prctl'
  make: *** [Makefile:197: all] Error 2

Change the assignment to use 'override' and ':=' to ensure the
normalization logic is applied regardless of how the ARCH variable was
initially defined.

Link: https://lkml.kernel.org/r/20260309205145.572778-1-aleksey.oladko@virtuozzo.com
Signed-off-by: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/breakpoints/Makefile                 |    4 ++--
 tools/testing/selftests/ipc/Makefile                         |    8 ++++----
 tools/testing/selftests/prctl/Makefile                       |    4 ++--
 tools/testing/selftests/sparc64/Makefile                     |    4 ++--
 tools/testing/selftests/thermal/intel/power_floor/Makefile   |    4 ++--
 tools/testing/selftests/thermal/intel/workload_hint/Makefile |    4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/breakpoints/Makefile~selftests-fix-arch-normalization-to-handle-command-line-argument
+++ a/tools/testing/selftests/breakpoints/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Taken from perf makefile
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 TEST_GEN_PROGS := step_after_suspend_test
 
--- a/tools/testing/selftests/ipc/Makefile~selftests-fix-arch-normalization-to-handle-command-line-argument
+++ a/tools/testing/selftests/ipc/Makefile
@@ -1,12 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-        ARCH := x86
+        override ARCH := x86
 	CFLAGS := -DCONFIG_X86_32 -D__i386__
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := x86
+        override ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
--- a/tools/testing/selftests/prctl/Makefile~selftests-fix-arch-normalization-to-handle-command-line-argument
+++ a/tools/testing/selftests/prctl/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 ifndef CROSS_COMPILE
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 ifeq ($(ARCH),x86)
 TEST_PROGS := disable-tsc-ctxt-sw-stress-test disable-tsc-on-off-stress-test \
--- a/tools/testing/selftests/sparc64/Makefile~selftests-fix-arch-normalization-to-handle-command-line-argument
+++ a/tools/testing/selftests/sparc64/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/x86_64/x86/)
 
 ifneq ($(ARCH),sparc64)
 nothing:
--- a/tools/testing/selftests/thermal/intel/power_floor/Makefile~selftests-fix-arch-normalization-to-handle-command-line-argument
+++ a/tools/testing/selftests/thermal/intel/power_floor/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 ifndef CROSS_COMPILE
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 ifeq ($(ARCH),x86)
 TEST_GEN_PROGS := power_floor_test
--- a/tools/testing/selftests/thermal/intel/workload_hint/Makefile~selftests-fix-arch-normalization-to-handle-command-line-argument
+++ a/tools/testing/selftests/thermal/intel/workload_hint/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 ifndef CROSS_COMPILE
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 ifeq ($(ARCH),x86)
 TEST_GEN_PROGS := workload_hint_test
_

Patches currently in -mm which might be from aleksey.oladko@virtuozzo.com are

selftests-fix-arch-normalization-to-handle-command-line-argument.patch

