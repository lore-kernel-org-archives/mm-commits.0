From: akpm@linux-foundation.org
Subject: [merged] selftests-add-a-simple-doc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:18:10 -0800
Message-ID: <20130228201810.A82EC31C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:41568 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3B1USL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:18:11 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so245479qea.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:18:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jk@ozlabs.org, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add a simple doc
has been removed from the -mm tree.  Its filename was
     selftests-add-a-simple-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeremy Kerr <jk@ozlabs.org>
Subject: selftests: add a simple doc

This change adds a little documentation to the tests under
tools/testing/selftests/, based on akpm's explanation.

[akpm@linux-foundation.org: move from Documentation to tools/testing/selftests/README.txt]
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/README.txt |   43 +++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN /dev/null tools/testing/selftests/README.txt
--- /dev/null
+++ a/tools/testing/selftests/README.txt
@@ -0,0 +1,43 @@
+Linux Kernel Selftests
+
+The kernel contains a set of "self tests" under the tools/testing/selftests/
+directory. These are intended to be small unit tests to exercise individual
+code paths in the kernel.
+
+Running the selftests
+=====================
+
+To build the tests:
+
+  $ make -C tools/testing/selftests
+
+
+To run the tests:
+
+  $ make -C tools/testing/selftests run_tests
+
+- note that some tests will require root privileges.
+
+
+To run only tests targetted for a single subsystem:
+
+  $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
+
+See the top-level tools/testing/selftests/Makefile for the list of all possible
+targets.
+
+
+Contributing new tests
+======================
+
+In general, the rules for for selftests are
+
+ * Do as much as you can if you're not root;
+
+ * Don't take too long;
+
+ * Don't break the build on any architecture, and
+
+ * Don't cause the top-level "make run_tests" to fail if your feature is
+   unconfigured.
+
_

Patches currently in -mm which might be from jk@ozlabs.org are

origin.patch

