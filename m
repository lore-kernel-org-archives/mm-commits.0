From: akpm@linux-foundation.org
Subject: + selftests-add-a-simple-doc.patch added to -mm tree
Date: Tue, 12 Feb 2013 15:57:04 -0800
Message-ID: <20130212235705.5FF2B5A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35974 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab3BLX5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 18:57:06 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so75975vbi.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 15:57:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, dyoung@redhat.com


The patch titled
     Subject: selftests: add a simple doc
has been added to the -mm tree.  Its filename is
     selftests-add-a-simple-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeremy Kerr <jk@ozlabs.org>
Subject: selftests: add a simple doc

This change adds a little documentation to the tests under
tools/testing/selftests/, based on akpm's explanation.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/selftests.txt |   43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN /dev/null Documentation/selftests.txt
--- /dev/null
+++ a/Documentation/selftests.txt
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

selftests-add-tests-for-efivarfs.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
selftests-efivarfs-add-empty-file-creation-test.patch
selftests-efivarfs-add-create-read-test.patch
selftests-add-a-simple-doc.patch
selftests-add-a-simple-doc-fix.patch

