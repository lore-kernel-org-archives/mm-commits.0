From: akpm@linux-foundation.org
Subject: + selftests-add-infrastructure-for-powerpc-selftests.patch added
 to -mm tree
Date: Tue, 06 Aug 2013 14:47:34 -0700
Message-ID: <52016ef6.FTawldW0zq1e8G3C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3HFVrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 17:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mikey@neuling.org, jk@ozlabs.org, benh@kernel.crashing.org, anton@samba.org, michael@ellerman.id.au

Subject: + selftests-add-infrastructure-for-powerpc-selftests.patch added to -mm tree
To: michael@ellerman.id.au,anton@samba.org,benh@kernel.crashing.org,jk@ozlabs.org,mikey@neuling.org
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 14:47:34 -0700


The patch titled
     Subject: selftests: add infrastructure for powerpc selftests
has been added to the -mm tree.  Its filename is
     selftests-add-infrastructure-for-powerpc-selftests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-add-infrastructure-for-powerpc-selftests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-add-infrastructure-for-powerpc-selftests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Ellerman <michael@ellerman.id.au>
Subject: selftests: add infrastructure for powerpc selftests

Add a powerpc subdirectory to tools/testing/selftests, for tests that are
powerpc specific.

On other architectures nothing is built.  The makefile supports cross
compilation if the user sets ARCH and CROSS_COMPILE.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile         |    1 
 tools/testing/selftests/powerpc/Makefile |   39 +++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff -puN tools/testing/selftests/Makefile~selftests-add-infrastructure-for-powerpc-selftests tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftests-add-infrastructure-for-powerpc-selftests
+++ a/tools/testing/selftests/Makefile
@@ -8,6 +8,7 @@ TARGETS += net
 TARGETS += ptrace
 TARGETS += timers
 TARGETS += vm
+TARGETS += powerpc
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/powerpc/Makefile
--- /dev/null
+++ a/tools/testing/selftests/powerpc/Makefile
@@ -0,0 +1,39 @@
+# Makefile for powerpc selftests
+
+# ARCH can be overridden by the user for cross compiling
+ARCH ?= $(shell uname -m)
+ARCH := $(shell echo $(ARCH) | sed -e s/ppc.*/powerpc/)
+
+ifeq ($(ARCH),powerpc)
+
+GIT_VERSION = $(shell git describe --always --long --dirty || echo "unknown")
+
+CC := $(CROSS_COMPILE)$(CC)
+CFLAGS := -Wall -O2 -flto -Wall -Werror -DGIT_VERSION='"$(GIT_VERSION)"' -I$(CURDIR) $(CFLAGS)
+
+export CC CFLAGS
+
+TARGETS =
+
+endif
+
+all:
+	@for TARGET in $(TARGETS); do \
+		$(MAKE) -C $$TARGET all; \
+	done;
+
+run_tests: all
+	@for TARGET in $(TARGETS); do \
+		$(MAKE) -C $$TARGET run_tests; \
+	done;
+
+clean:
+	@for TARGET in $(TARGETS); do \
+		$(MAKE) -C $$TARGET clean; \
+	done;
+	rm -f tags
+
+tags:
+	find . -name '*.c' -o -name '*.h' | xargs ctags
+
+.PHONY: all run_tests clean tags
_

Patches currently in -mm which might be from michael@ellerman.id.au are

selftests-add-infrastructure-for-powerpc-selftests.patch
selftests-add-support-files-for-powerpc-tests.patch
selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch
linux-next.patch

