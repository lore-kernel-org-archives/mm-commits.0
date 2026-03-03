Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A0038423A
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772575852; cv=none; b=PZZPJJyRV2Gq3czGKo2RxiUk7dgZs/DOkJwfamWdZ9IJaCg9GqPZgsjkMcF4du8tKNh+RlNxRM0zvJ9FDRNFRPJ7s390qDxNjZ0b6Nd2HyCDXlbPc/EFXom8xUiSuKPSwfEKqR9Ykfvw1OPJn+Pj/8AsRqn237H/0EHRaAnJ+a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772575852; c=relaxed/simple;
	bh=G+e2BknP8p8Hw7DoYtfu756VQtBesnX5xbVwjEbZv7Q=;
	h=Date:To:From:Subject:Message-Id; b=GcCx00U0jfRaN1xv212o/9jceyl/hBd/k2n7Wf2tACSL4DEKYvtqqmbC2ez8Eo4QUpEBXcm0UJSCnfW2xbtSzSFiCj1HuO9wXFb4dbYlYw9zw8XSRKux+lD9izLnruanZYYRWdf8gRkH0SAMS8f/EIEOWV7vOX78uo7M0qqxtOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=en7Pcoye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="en7Pcoye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0096FC116C6;
	Tue,  3 Mar 2026 22:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772575852;
	bh=G+e2BknP8p8Hw7DoYtfu756VQtBesnX5xbVwjEbZv7Q=;
	h=Date:To:From:Subject:From;
	b=en7PcoyetoGbW7orcxDrQCMBsOa1CZUXNWK8LX8NpYAbyxl6E8uzA6zaieqhYRoTe
	 4PiHdlCpA+U3nBmsViAdzwqE5eZrddHhLemYwnm8X+HzGDbwjeWWOXjIthsKiozGCO
	 8Wv0/FR60Vvf7M8XwDc/s+Cw4MIFmk7/52qUs5Nc=
Date: Tue, 03 Mar 2026 14:10:51 -0800
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,atomlin@atomlin.com,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-increment-the-global-counter-immediately.patch added to mm-nonmm-unstable branch
Message-Id: <20260303221052.0096FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: increment the global counter immediately
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-increment-the-global-counter-immediately.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-increment-the-global-counter-immediately.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: hung_task: increment the global counter immediately
Date: Tue, 3 Mar 2026 15:30:31 -0500

A recent change allowed to reset the global counter of hung tasks using
the sysctl interface.  A potential race with the regular check has been
solved by updating the global counter only once at the end of the check.

However, the hung task check can take a significant amount of time,
particularly when task information is being dumped to slow serial
consoles.  Some users monitor this global counter to trigger immediate
migration of critical containers.  Delaying the increment until the full
check completes postpones these high-priority rescue operations.

Update the global counter as soon as a hung task is detected.  Since the
value is read asynchronously, a relaxed atomic operation is sufficient.

Link: https://lkml.kernel.org/r/20260303203031.4097316-4-atomlin@atomlin.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/r/f239e00f-4282-408d-b172-0f9885f4b01b@linux.dev
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/kernel/hung_task.c~hung_task-increment-the-global-counter-immediately
+++ a/kernel/hung_task.c
@@ -302,16 +302,11 @@ static void check_hung_uninterruptible_t
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
 	struct task_struct *g, *t;
-	unsigned long total_count, this_round_count;
+	unsigned long this_round_count;
 	int need_warning = sysctl_hung_task_warnings;
 	unsigned long si_mask = hung_task_si_mask;
 
 	/*
-	 * The counter might get reset. Remember the initial value.
-	 * Acquire prevents reordering task checks before this point.
-	 */
-	total_count = atomic_long_read_acquire(&sysctl_hung_task_detect_count);
-	/*
 	 * If the system crashed already then all bets are off,
 	 * do not report extra hung tasks:
 	 */
@@ -330,6 +325,13 @@ static void check_hung_uninterruptible_t
 		}
 
 		if (task_is_hung(t, timeout)) {
+			/*
+			 * Increment the global counter so that userspace could
+			 * start migrating tasks ASAP. But count the current
+			 * round separately because userspace could reset
+			 * the global counter at any time.
+			 */
+			atomic_long_inc(&sysctl_hung_task_detect_count);
 			this_round_count++;
 			hung_task_info(t, timeout, this_round_count);
 		}
@@ -340,15 +342,6 @@ static void check_hung_uninterruptible_t
 	if (!this_round_count)
 		return;
 
-	/*
-	 * Do not count this round when the global counter has been reset
-	 * during this check. Release ensures we see all hang details
-	 * recorded during the scan.
-	 */
-	atomic_long_cmpxchg_release(&sysctl_hung_task_detect_count,
-				    total_count, total_count +
-				    this_round_count);
-
 	if (need_warning || hung_task_call_panic) {
 		si_mask |= SYS_INFO_LOCKS;
 
_

Patches currently in -mm which might be from pmladek@suse.com are

hung_task-increment-the-global-counter-immediately.patch

