Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2C1321F5F
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 19:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782674319; cv=none; b=uCD+F9j7TPQNjGxBps/6F3SkQZPrhgUSf1ym/i1PkztRt8s1Mb4pz3+V7INr/OHsHlzQ0X4qLuEpQv1nMrvsHsQi+VpZCXKNDpQXmjMm6ZuPpd/8spP7QOevpiT85SvmfQbsc6f6LK9FTFSLTSDEDCUIElg3gbTikKug66sTaik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782674319; c=relaxed/simple;
	bh=gLOyjyTBIPtvYWp79oq5MrNSJcJvZKzzL67jqkYL7vE=;
	h=Date:To:From:Subject:Message-Id; b=r1ErX/1FSV8v+s3ZeRJrsN0KEsGSg6QSbOOgGuv6tHuxYvurYdn0isb0bO8/vQRc9uw6M4XuQ+kDqtXlzAZKQPnhSN6mE1BNwXG7XvU+du7lhm0Aq9fFsyN69mfMW5JV6Eis0SrvZx5wSAckxwgdHSNDum0LBVC5XH5KYeCYyDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584101F000E9;
	Sun, 28 Jun 2026 19:18:30 +0000 (UTC)
Date: Sun, 28 Jun 2026 12:17:59 -0700
To: mm-commits@vger.kernel.org,include@grrlz.net,ebiederm@xmission.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-change-sys_kill-to-use-send_sig_noinfo.patch added to mm-nonmm-unstable branch
Message-Id: <20260628191830.584101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal: change sys_kill() to use SEND_SIG_NOINFO
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-change-sys_kill-to-use-send_sig_noinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-change-sys_kill-to-use-send_sig_noinfo.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: change sys_kill() to use SEND_SIG_NOINFO
Date: Fri, 26 Jun 2026 17:33:08 +0200

prepare_kill_siginfo(PIDTYPE_TGID) fills si_code = SI_USER and sets
si_pid/si_uid in the sender's namespace.  Then send_signal_locked()
translates si_pid/si_uid to the target's namespace.

SEND_SIG_NOINFO exists precisely for the case when si_code == SI_USER
and si_pid/si_uid are the sender's ids; this is exactly what sys_kill()
does via prepare_kill_siginfo(PIDTYPE_TGID).  Change sys_kill() to use
it directly.

SEND_SIG_NOINFO produces the same result: si_code = SI_USER, and
__send_signal_locked() computes si_pid/si_uid directly in the target's
namespace.  The force computation is also the same: both check if the
sender is visible in the target's pid namespace.

This is just a cleanup and microoptimization (especially with [1]),
this skips the has_si_pid_and_uid() block in send_signal_locked() and
offloads the namespace translation logic to
__send_signal_locked(SEND_SIG_NOINFO) which uses the simpler
computations.

NOTE: As a "side effect" this also fixes the kill(pid < 0, sig) case
where send_signal_locked() rewrites si_pid/si_uid in the shared
siginfo, corrupting it for subsequent recipients.  But for other group
senders like __kill_pgrp_info() we still need the fix from Bradley
Morgan [1] who found this problem.

TODO: kill prepare_kill_siginfo() and change other users to use
SEND_SIG_NOINFO too.  This needs trivial changes in
__send_signal_locked() and TP_STORE_SIGINFO().

Link: https://lore.kernel.org/aj6btAZqYuv59a8w@redhat.com
Link: https://lore.kernel.org/all/20260622164029.11474-1-include@grrlz.net/ [1]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/signal.c~signal-change-sys_kill-to-use-send_sig_noinfo
+++ a/kernel/signal.c
@@ -3954,11 +3954,7 @@ static void prepare_kill_siginfo(int sig
  */
 SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 {
-	struct kernel_siginfo info;
-
-	prepare_kill_siginfo(sig, &info, PIDTYPE_TGID);
-
-	return kill_something_info(sig, &info, pid);
+	return kill_something_info(sig, SEND_SIG_NOINFO, pid);
 }
 
 /*
_

Patches currently in -mm which might be from oleg@redhat.com are

signal-change-sys_kill-to-use-send_sig_noinfo.patch

