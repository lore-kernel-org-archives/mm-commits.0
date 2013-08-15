From: akpm@linux-foundation.org
Subject: [merged] selftests-add-infrastructure-for-powerpc-selftests.patch removed from -mm tree
Date: Thu, 15 Aug 2013 13:20:38 -0700
Message-ID: <520d3816.9Omty00xoY3drUIe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719Ab3HOUUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 16:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mikey@neuling.org, jk@ozlabs.org, benh@kernel.crashing.org, anton@samba.org, michael@ellerman.id.au

Subject: [merged] selftests-add-infrastructure-for-powerpc-selftests.patch removed from -mm tree
To: michael@ellerman.id.au,anton@samba.org,benh@kernel.crashing.org,jk@ozlabs.org,mikey@neuling.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 13:20:38 -0700


The patch titled
     Subject: selftests: add infrastructure for powerpc selftests
has been removed from the -mm tree.  Its filename was
     selftests-add-infrastructure-for-powerpc-selftests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

