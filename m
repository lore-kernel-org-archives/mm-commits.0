From: akpm@linux-foundation.org
Subject: [merged] proc-fix-reported-unit-for-rlimit_cpu.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:33 -0700
Message-ID: <200909231956.n8NJuXMn005104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbZIWT76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees.cook@canonical.com, nhorman@tuxdriver.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: fix reported unit for RLIMIT_CPU
has been removed from the -mm tree.  Its filename was
     proc-fix-reported-unit-for-rlimit_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix reported unit for RLIMIT_CPU
From: Kees Cook <kees.cook@canonical.com>

/proc/$pid/limits should show RLIMIT_CPU as seconds, which is the unit
used in kernel/posix-cpu-timers.c:

        unsigned long psecs = cputime_to_secs(ptime);
        ...
        if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
                ...
                __group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-fix-reported-unit-for-rlimit_cpu fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-reported-unit-for-rlimit_cpu
+++ a/fs/proc/base.c
@@ -458,7 +458,7 @@ struct limit_names {
 };
 
 static const struct limit_names lnames[RLIM_NLIMITS] = {
-	[RLIMIT_CPU] = {"Max cpu time", "ms"},
+	[RLIMIT_CPU] = {"Max cpu time", "seconds"},
 	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
 	[RLIMIT_DATA] = {"Max data size", "bytes"},
 	[RLIMIT_STACK] = {"Max stack size", "bytes"},
_

Patches currently in -mm which might be from kees.cook@canonical.com are

origin.patch

