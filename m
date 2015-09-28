From: akpm@linux-foundation.org
Subject: [merged] cleanup-membarrier-selftest.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:16:09 -0700
Message-ID: <560983e9.vxaekLEHyV2vXjPZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, bobby.prani@gmail.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: membarrier: clean up selftest
has been removed from the -mm tree.  Its filename was
     cleanup-membarrier-selftest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: membarrier: clean up selftest

We don't need to specify an explicit rule in the Makefile, the implicit
one will do the same.  The "__EXPORTED_HEADERS__" define is not needed,
because we build the test against the installed kernel headers, not the
in-tree kernel headers.  Re-use "$(TEST_PROGS)" in the clean target rather
than spelling the executable name twice.  Include <unistd.h> rather than
the rather specific <asm-generic/unistd.h>.  Include <syscall.h> rather
than <sys/syscall.h>.  In both cases, the former header is located in a
standard location and includes the latter.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/membarrier/Makefile          |    7 +++----
 tools/testing/selftests/membarrier/membarrier_test.c |    5 +----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN tools/testing/selftests/membarrier/Makefile~cleanup-membarrier-selftest tools/testing/selftests/membarrier/Makefile
--- a/tools/testing/selftests/membarrier/Makefile~cleanup-membarrier-selftest
+++ a/tools/testing/selftests/membarrier/Makefile
@@ -1,11 +1,10 @@
 CFLAGS += -g -I../../../../usr/include/
 
-all:
-	$(CC) $(CFLAGS) membarrier_test.c -o membarrier_test
-
 TEST_PROGS := membarrier_test
 
+all: $(TEST_PROGS)
+
 include ../lib.mk
 
 clean:
-	$(RM) membarrier_test
+	$(RM) $(TEST_PROGS)
diff -puN tools/testing/selftests/membarrier/membarrier_test.c~cleanup-membarrier-selftest tools/testing/selftests/membarrier/membarrier_test.c
--- a/tools/testing/selftests/membarrier/membarrier_test.c~cleanup-membarrier-selftest
+++ a/tools/testing/selftests/membarrier/membarrier_test.c
@@ -1,9 +1,6 @@
 #define _GNU_SOURCE
-#define __EXPORTED_HEADERS__
