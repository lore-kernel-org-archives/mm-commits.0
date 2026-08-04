Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7BF423768
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816292; cv=none; b=H1sNZFb8CGs4Fnm2ETFPZY7tCJ8y975q8CRlHlhVM89oIjmH5B5eOzJds86UKoaaSjh8jBlCF7zq3FFNdITIGM9UnsHV6wrFwHG1URDAPShiyLagIvLKo8CUqaSGkQc6uOYZEM/IgX60p1rnYK6ZxMOhlfWSA/T3JEPc2eM0D6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816292; c=relaxed/simple;
	bh=0ojwF8HacuF+8OlaulR4xdLFYaCbTfMXXcaTmpNYOX4=;
	h=Date:To:From:Subject:Message-Id; b=hDMTdqTX52oP0tFoDZl5GG+nclavqRg9lHv4btyVZAWJhIH+bHbxHnQSZCr3ff59vJ+GPqNOnuM+4dT5/kRRxy75jmukOlWnoctPB6i05ZQ11jizwz2h2xy2oFd36q32gxiEokjJ01z4P5QCnEMfgnt1cLUMhCieBAcfMCOeNWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ejEpARlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ejEpARlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1E21F00A3A;
	Tue,  4 Aug 2026 04:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816291;
	bh=KuRHMziykwUwUItGMvqniId5Jv7ipAxQKtSneXe8/XQ=;
	h=Date:To:From:Subject;
	b=ejEpARlb6WVCo3aUDyNxckDzN/5mJExYBAKyjn+l8FjqTbysz5a6iDx8UId3QfPZz
	 uU3rB2MTKlBAmzM13//EETtxJTKZ761OCi2Zq14ZHlKB2Sfi9bbx5EzddkXbfbZaKr
	 ARsVXcVK0NFruh/prhzvrp4PcLZxy7F085mRf+pA=
Date: Mon, 03 Aug 2026 21:04:50 -0700
To: mm-commits@vger.kernel.org,include@grrlz.net,ebiederm@xmission.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] signal-change-sys_kill-to-use-send_sig_noinfo.patch removed from -mm tree
Message-Id: <20260804040450.DC1E21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: signal: change sys_kill() to use SEND_SIG_NOINFO
has been removed from the -mm tree.  Its filename was
     signal-change-sys_kill-to-use-send_sig_noinfo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3962,11 +3962,7 @@ static void prepare_kill_siginfo(int sig
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


