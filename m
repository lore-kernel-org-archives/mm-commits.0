From: akpm@linux-foundation.org
Subject: + cleanup-membarrier-selftest.patch added to -mm tree
Date: Mon, 14 Sep 2015 15:17:10 -0700
Message-ID: <55f74766.ndRblxLNUj0Lmdmb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbINWRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 18:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, bobby.prani@gmail.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: membarrier: clean up selftest
has been added to the -mm tree.  Its filename is
     cleanup-membarrier-selftest.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cleanup-membarrier-selftest.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cleanup-membarrier-selftest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
