Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502721A9F83
	for <mm-commits@vger.kernel.org>; Mon, 16 Feb 2026 23:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771284056; cv=none; b=OZ44w0kSdAwdk0DJJN5gogdxkf3QJIzaWGq4BR9zRcdjlRAMWGB5dfx8QVabB/SN3hl5BlltPNZ+dvIIYn9P3QLYPvQeCNU6+HOVstzWPmGI4cFxgkLkAemxTfCZMB7Ym4DJRL+XiH1Q+mpVCU7Uhvr4UtTwbd5sWA3/k1Q+3ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771284056; c=relaxed/simple;
	bh=cfuUvc/oIOg15lg/Le6HcFV6P8VfCsIOm2sy+TUtF58=;
	h=Date:To:From:Subject:Message-Id; b=rC2/7uu8ADN0MnUa31GRGssDTIw3p17WETdG8PBwV/vl8+7Yp8B/x+O8BeJcdxQfV4b+Gci7EgUqIv/qqmRIe/ZR8GTi2g09eC/8hnpCQgieF9aj0oXifyP4n0Ypi78H8iEWYEzH04+cWvQgWhKvpRpLrcDLhsd+xT44x/1L2GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EvITxY2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EvITxY2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7756C116C6;
	Mon, 16 Feb 2026 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771284055;
	bh=cfuUvc/oIOg15lg/Le6HcFV6P8VfCsIOm2sy+TUtF58=;
	h=Date:To:From:Subject:From;
	b=EvITxY2vQ+EWwX3iDoO/Rfu2e3INkXW4lDAhVSnk1HWMGy4bzUgYtlKnV6W1fX+gY
	 3Ux8jGZ2/QquHM6KD6zdSgQJX3npg9ZKjsYd80hy23f4SRNhMKVtWP3cGdJq+mwZcm
	 VTEqBMPo4lwM33DTZ1L8+P4eKQn8LXsPetgXdRpE=
Date: Mon, 16 Feb 2026 15:20:55 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,brauner@kernel.org,jaime.saguillo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-array-drop-stale-fixme-about-rcu-in-task_sig.patch added to mm-nonmm-unstable branch
Message-Id: <20260216232055.C7756C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: array: drop stale FIXME about RCU in task_sig()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-array-drop-stale-fixme-about-rcu-in-task_sig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-array-drop-stale-fixme-about-rcu-in-task_sig.patch

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
From: Jaime Saguillo Revilla <jaime.saguillo@gmail.com>
Subject: proc: array: drop stale FIXME about RCU in task_sig()
Date: Sun, 15 Feb 2026 12:45:11 +0000

task_sig() already wraps the SigQ rlimit read in an explicit RCU read-side
critical section.  Drop the stale FIXME comment and keep using
task_ucounts() for the ucounts access.

No functional change.

Link: https://lkml.kernel.org/r/20260215124511.14227-1-jaime.saguillo@gmail.com
Signed-off-by: Jaime Saguillo Revilla <jaime.saguillo@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c~proc-array-drop-stale-fixme-about-rcu-in-task_sig
+++ a/fs/proc/array.c
@@ -280,7 +280,7 @@ static inline void task_sig(struct seq_f
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = get_nr_threads(p);
-		rcu_read_lock();  /* FIXME: is this correct? */
+		rcu_read_lock();
 		qsize = get_rlimit_value(task_ucounts(p), UCOUNT_RLIMIT_SIGPENDING);
 		rcu_read_unlock();
 		qlim = task_rlimit(p, RLIMIT_SIGPENDING);
_

Patches currently in -mm which might be from jaime.saguillo@gmail.com are

proc-array-drop-stale-fixme-about-rcu-in-task_sig.patch

