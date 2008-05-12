From: akpm@linux-foundation.org
Subject: + cgroups-fix-compile-warning.patch added to -mm tree
Date: Mon, 12 May 2008 16:58:45 -0700
Message-ID: <200805122358.m4CNwjZ0015577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950AbYELX73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mt-ml@gmx.de, menage@google.com, mingo@elte.hu


The patch titled
     cgroups: fix compile warning
has been added to the -mm tree.  Its filename is
     cgroups-fix-compile-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix compile warning
From: Mirco Tischler <mt-ml@gmx.de>

Return type of cpu_rt_runtime_write() should be int instead of ssize_t.

Signed-off-by: Mirco Tischler <mt-ml@gmx.de>
Acked-by: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~cgroups-fix-compile-warning kernel/sched.c
--- a/kernel/sched.c~cgroups-fix-compile-warning
+++ a/kernel/sched.c
@@ -9042,7 +9042,7 @@ static u64 cpu_shares_read_u64(struct cg
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
 				s64 val)
 {
 	return sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
_

Patches currently in -mm which might be from mt-ml@gmx.de are

cgroups-fix-compile-warning.patch

