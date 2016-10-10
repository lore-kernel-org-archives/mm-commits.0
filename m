From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-add-test-for-mlock-when-areas-are-intersected.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:44:45 -0700
Message-ID: <57fc19dd.zax2mbTAhzKzrjum%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbcJJWoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.guo.simon@gmail.com, emunson@akamai.com, geert@linux-m68k.org, kirill.shutemov@linux.intel.com, klimov.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, shuah@kernel.org, treding@nvidia.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add test for mlock() when areas are intersected
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-test-for-mlock-when-areas-are-intersected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Simon Guo <wei.guo.simon@gmail.com>
Subject: selftests/vm: add test for mlock() when areas are intersected

This patch adds mlock() test for multiple invocation on the same address
area, and verify it doesn't mess the rlimit mlock limitation.

Link: http://lkml.kernel.org/r/1472554781-9835-5-git-send-email-wei.guo.simon@gmail.com
Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Simon Guo <wei.guo.simon@gmail.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore             |    1 
 tools/testing/selftests/vm/Makefile               |    4 
 tools/testing/selftests/vm/mlock-intersect-test.c |   76 ++++++++++++
 3 files changed, 81 insertions(+)

diff -puN tools/testing/selftests/vm/.gitignore~selftests-vm-add-test-for-mlock-when-areas-are-intersected tools/testing/selftests/vm/.gitignore
--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-test-for-mlock-when-areas-are-intersected
+++ a/tools/testing/selftests/vm/.gitignore
@@ -7,3 +7,4 @@ mlock2-tests
 on-fault-limit
 transhuge-stress
 userfaultfd
+mlock-intersect-test
diff -puN tools/testing/selftests/vm/Makefile~selftests-vm-add-test-for-mlock-when-areas-are-intersected tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-test-for-mlock-when-areas-are-intersected
+++ a/tools/testing/selftests/vm/Makefile
@@ -10,6 +10,7 @@ BINARIES += on-fault-limit
 BINARIES += thuge-gen
 BINARIES += transhuge-stress
 BINARIES += userfaultfd
+BINARIES += mlock-intersect-test
 
 all: $(BINARIES)
 %: %.c
@@ -17,6 +18,9 @@ all: $(BINARIES)
 userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
 	$(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
 
+mlock-intersect-test: mlock-intersect-test.c
+	$(CC) $(CFLAGS) -o $@ $< -lcap
+
 ../../../../usr/include/linux/kernel.h:
 	make -C ../../../.. headers_install
 
diff -puN /dev/null tools/testing/selftests/vm/mlock-intersect-test.c
--- /dev/null
+++ a/tools/testing/selftests/vm/mlock-intersect-test.c
@@ -0,0 +1,76 @@
+/*
+ * It tests the duplicate mlock result:
+ * - the ulimit of lock page is 64k
+ * - allocate address area 64k starting from p
+ * - mlock   [p -- p + 30k]
+ * - Then mlock address  [ p -- p + 40k ]
+ *
+ * It should succeed since totally we locked
+ * 40k < 64k limitation.
+ *
+ * It should not be run with CAP_IPC_LOCK.
+ */
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/resource.h>
+#include <sys/capability.h>
+#include <sys/mman.h>
+#include "mlock2.h"
+
+int main(int argc, char **argv)
+{
+	struct rlimit new;
+	char *p = NULL;
+	cap_t cap = cap_init();
+	int i;
+
+	/* drop capabilities including CAP_IPC_LOCK */
+	if (cap_set_proc(cap))
+		return -1;
+
+	/* set mlock limits to 64k */
+	new.rlim_cur = 65536;
+	new.rlim_max = 65536;
+	setrlimit(RLIMIT_MEMLOCK, &new);
+
+	/* test VM_LOCK */
+	p = malloc(1024 * 64);
+	if (mlock(p, 1024 * 30)) {
+		printf("mlock() 30k return failure.\n");
+		return -1;
+	}
+	for (i = 0; i < 10; i++) {
+		if (mlock(p, 1024 * 40)) {
+			printf("mlock() #%d 40k returns failure.\n", i);
+			return -1;
+		}
+	}
+	for (i = 0; i < 10; i++) {
+		if (mlock2_(p, 1024 * 40, MLOCK_ONFAULT)) {
+			printf("mlock2_() #%d 40k returns failure.\n", i);
+			return -1;
+		}
+	}
+	free(p);
+
+	/* Test VM_LOCKONFAULT */
+	p = malloc(1024 * 64);
+	if (mlock2_(p, 1024 * 30, MLOCK_ONFAULT)) {
+		printf("mlock2_() 30k return failure.\n");
+		return -1;
+	}
+	for (i = 0; i < 10; i++) {
+		if (mlock2_(p, 1024 * 40, MLOCK_ONFAULT)) {
+			printf("mlock2_() #%d 40k returns failure.\n", i);
+			return -1;
+		}
+	}
+	for (i = 0; i < 10; i++) {
+		if (mlock(p, 1024 * 40)) {
+			printf("mlock() #%d 40k returns failure.\n", i);
+			return -1;
+		}
+	}
+	return 0;
+}
_

Patches currently in -mm which might be from wei.guo.simon@gmail.com are


