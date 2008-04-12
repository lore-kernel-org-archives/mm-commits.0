From: akpm@linux-foundation.org
Subject: + cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch added to -mm tree
Date: Fri, 11 Apr 2008 21:31:40 -0700
Message-ID: <200804120431.m3C4Ve1I019519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbYDLEcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 00:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl


The patch titled
     someone mucked around with the cgroup api; this should fix it:
has been added to the -mm tree.  Its filename is
     cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch

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
Subject: someone mucked around with the cgroup api; this should fix it:
From: Peter Zijlstra <peterz@infradead.org>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix kernel/sched.c
--- a/kernel/sched.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix
+++ a/kernel/sched.c
@@ -8325,8 +8325,8 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "rt_period_us",
-		.read_uint = cpu_rt_period_read_uint,
-		.write_uint = cpu_rt_period_write_uint,
+		.read_u64 = cpu_rt_period_read_uint,
+		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
 };
_

Patches currently in -mm which might be from peterz@infradead.org are

smaps-account-swap-entries.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch
ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch

