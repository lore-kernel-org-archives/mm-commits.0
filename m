Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5B9481B1
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782491820; cv=none; b=X3lcx/XYIr9/Fr2RhIyJ8Z3MZ1CGVoDIEejR+wu7kONoTInWJi/h+Rg66GOCBXhiMOjoZBv3Wyf1Qt1wx31kBRTA/4iLPx5970A5H/Yj+VOSlsnQIJEljV6zqCx04kVw4/JZHkxefZCKphOdwkrJNT7erRP5MPdTfRbVr/+CjP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782491820; c=relaxed/simple;
	bh=Vv5uPzYTueNwgog8Gi77V2QnVlYYI/58xeds8jw+KNM=;
	h=Date:To:From:Subject:Message-Id; b=clpoklLhv5qpyUDfPTHccJ/L8wsL0jvNNXva3VfRxA9smRViTJURS7KNfhExpM7SYDFf+USfFtONeGv4uMA03IE/dAxZyYPEyPBR4g6UYN9pmTakaFJmCVZfJ0gGrLig/3g4rzeaVkbuZUZVsNkrb6kMtDuNUrzI1iVoRmCBK5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Il6fPZlI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Il6fPZlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1EA1F000E9;
	Fri, 26 Jun 2026 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782491818;
	bh=VN39Ag1APFXNoU58LJAD19j7E5gLiUCi1Ldtr48V/CY=;
	h=Date:To:From:Subject;
	b=Il6fPZlIc+9uwIWBYDRrLa1C1TpzW6QPUmVNbr5IbSmrfsCSdd1Fz9If+hzt4YOsQ
	 zinVVgofyCFMTd04eRQbNamjt2gp1iOnAFqou5WkTorD8eUHpffCSOk+ZvsYWe4z5O
	 uEkPjOhq923urjR3Fmlusz5hrfQjY5WKvwC56+lk=
Date: Fri, 26 Jun 2026 09:36:58 -0700
To: mm-commits@vger.kernel.org,include@grrlz.net,ebiederm@xmission.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-change-sys_kill-to-use-send_sig_noinfo.patch added to mm-nonmm-unstable branch
Message-Id: <20260626163658.AA1EA1F000E9@smtp.kernel.org>
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

SEND_SIG_NOINFO produces the same result: si_code = SI_USER, and
__send_signal_locked() computes si_pid/si_uid directly in the target's
namespace.  The force computation is also the same: both check if the
sender is visible in the target's pid namespace.

Note: this also fixes the kill(-1, sig) case where send_signal_locked()
rewrites si_pid/si_uid in the shared siginfo, corrupting it for subsequent
recipients.  But for other group senders like __kill_pgrp_info() we still
need the fix from Bradley Morgan [1] who found this problem.

TODO: kill prepare_kill_siginfo() and change other users to use
SEND_SIG_NOINFO too.  This needs trivial changes in __send_signal_locked()
and TP_STORE_SIGINFO().

Link: https://lore.kernel.org/aj6btAZqYuv59a8w@redhat.com
Link: https://lore.kernel.org/all/20260622164029.11474-1-include@grrlz.net/ [1]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Bradley Morgan <include@grrlz.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/signal.c~signal-change-sys_kill-to-use-send_sig_noinfo
+++ a/kernel/signal.c
@@ -3950,11 +3950,7 @@ static void prepare_kill_siginfo(int sig
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

