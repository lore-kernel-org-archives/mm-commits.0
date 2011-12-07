From: akpm@linux-foundation.org
Subject: + selftests-new-very-basic-kernel-selftests-directory.patch added to -mm tree
Date: Wed, 07 Dec 2011 15:32:34 -0800
Message-ID: <201112072332.pB7NWZlm018074@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:59019 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1LGXcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 18:32:39 -0500
Received: by qcsg15 with SMTP id g15so138201qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 15:32:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, akpm@linux-foundation.org, hpa@zytor.com, jason.wessel@windriver.com, mingo@elte.hu, mmarek@suse.cz, rostedt@goodmis.org, sam@ravnborg.org, tglx@linutronix.de, will.deacon@arm.com


The patch titled
     Subject: selftests: new very basic kernel selftests directory
has been added to the -mm tree.  Its filename is
     selftests-new-very-basic-kernel-selftests-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: selftests: new very basic kernel selftests directory

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

