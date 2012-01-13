From: akpm@linux-foundation.org
Subject: [merged] selftests-new-very-basic-kernel-selftests-directory.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:08 -0800
Message-ID: <20120113203709.39B8C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:12 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, akpm@linux-foundation.org, hpa@zytor.com, jason.wessel@windriver.com, mingo@elte.hu, mmarek@suse.cz, rostedt@goodmis.org, sam@ravnborg.org, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: new very basic kernel selftests directory
has been removed from the -mm tree.  Its filename was
     selftests-new-very-basic-kernel-selftests-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: selftests: new very basic kernel selftests directory

Bring a new kernel selftests directory in tools/testing/selftests.  To add
a new selftest, create a subdirectory with the sources and a makefile that
creates a target named "run_test" then add the subdirectory name to the
TARGET var in tools/testing/selftests/Makefile and
tools/testing/selftests/run_tests script.

This can help centralizing and maintaining any useful selftest that
developers usually tend to let rust in peace on some random server.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile  |   11 +++++++++++
 tools/testing/selftests/run_tests |    8 ++++++++
 2 files changed, 19 insertions(+)

diff -puN /dev/null tools/testing/selftests/Makefile
--- /dev/null
+++ a/tools/testing/selftests/Makefile
@@ -0,0 +1,11 @@
+TARGETS =
+
+all:
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET; \
+	done;
+
+clean:
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET clean; \
+	done;
diff -puN /dev/null tools/testing/selftests/run_tests
--- /dev/null
+++ a/tools/testing/selftests/run_tests
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+TARGETS=
+
+for TARGET in $TARGETS
+do
+	$TARGET/run_test
+done
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch

