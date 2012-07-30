From: akpm@linux-foundation.org
Subject: + fault-injection-fix-failcmdsh-warning.patch added to -mm tree
Date: Mon, 30 Jul 2012 15:22:35 -0700
Message-ID: <20120730222235.F2F955C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63242 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2G3WWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 18:22:38 -0400
Received: by lbbgp10 with SMTP id gp10so249408lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 15:22:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     Subject: fault-injection: fix failcmd.sh warning
has been added to the -mm tree.  Its filename is
     fault-injection-fix-failcmdsh-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-injection: fix failcmd.sh warning

"fault-injection: add tool to run command with failslab or
fail_page_alloc" added tools/testing/fault-injection/failcmd.sh to make it
easier to inject slab/page allocation failures by fault injection.

failcmd.sh prints the following warning when running with arguments
for command.

	# ./failcmd.sh echo aaa
	failcmd.sh: line 209: [: echo: binary operator expected
	aaa

This warning is caused by an improper check whether at least one
parameter is left after parsing command options.

Fix it by testing the length of $1 instead of $@

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/fault-injection/failcmd.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/fault-injection/failcmd.sh~fault-injection-fix-failcmdsh-warning tools/testing/fault-injection/failcmd.sh
--- a/tools/testing/fault-injection/failcmd.sh~fault-injection-fix-failcmdsh-warning
+++ a/tools/testing/fault-injection/failcmd.sh
@@ -206,7 +206,7 @@ while true; do
 	esac
 done
 
-[ -z "$@" ] && exit 0
+[ -z "$1" ] && exit 0
 
 echo $oom_kill_allocating_task > /proc/sys/vm/oom_kill_allocating_task
 echo $task_filter > $FAULTATTR/task-filter
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
string-introduce-memweight.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
fork-fix-error-handling-in-dup_task.patch
fault-injection-notifier-error-injection.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

