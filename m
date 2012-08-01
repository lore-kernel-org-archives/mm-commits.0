From: akpm@linux-foundation.org
Subject: [merged] fault-injection-fix-failcmdsh-warning.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:12 -0700
Message-ID: <20120801201114.5749F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53805 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAULQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:16 -0400
Received: by lbbgp10 with SMTP id gp10so47289lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: fix failcmd.sh warning
has been removed from the -mm tree.  Its filename was
     fault-injection-fix-failcmdsh-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

