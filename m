Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336831E5724
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777028006; cv=none; b=O28BJsHrVMdfCPN0wPzzT4nyaHv+2E2lu2J/TeofQ4n1ExgczliYVAV/PQWpQvVPiRXuBSnrhI6g+Sp85Y0jHo38TgLQi84ONj00juISPqpKvDaGc6qh//FpabnksjlFdAE5pVe6MzmIEHgOtnXkUfHmBDqQxTmkX13o5KBpW7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777028006; c=relaxed/simple;
	bh=b5SQ+hWAOogwUFtfhNJapBphbAF75C6df9VbyE4cBIw=;
	h=Date:To:From:Subject:Message-Id; b=Fe6RgujWzJj4e3NsWHLW3E5n/r3O+ppZOQ5Cz46DQNs/UmMIJSepIE03Mw5qPnylLqfYYhEdSbyzEGDRHLez8kfuhP24a573q/p49ninV0kuuXT9Jo1fI0LYowfNZ10YgasNKCxYQ4/WnD6l0t+2S4n1ERPC81tqjI4IodGcS7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X1VyijKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X1VyijKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E0BC19425;
	Fri, 24 Apr 2026 10:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777028005;
	bh=b5SQ+hWAOogwUFtfhNJapBphbAF75C6df9VbyE4cBIw=;
	h=Date:To:From:Subject:From;
	b=X1VyijKsCmbgStr+RhGHU3l2Zsqf5aSfnmW6opzmfsaUbthpZY94EhlsmxQt8Ri8x
	 wks8Y4XES0ybNmPoC7C8yhOQwO6LP2NmN3aEmx+NnwXRa+tbnfNjmQ5nVUUN/ESK/c
	 zCtHuFb56bnlEPXuF+h6+V25nt0dNDLv81HO8q9Q=
Date: Fri, 24 Apr 2026 03:53:25 -0700
To: mm-commits@vger.kernel.org,jstultz@google.com,adobriyan@gmail.com,me@cherr.cc,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-comm_write-return-value-when-truncated-or-error.patch added to mm-nonmm-unstable branch
Message-Id: <20260424105325.B0E0BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: fix comm_write return value when truncated or error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-fix-comm_write-return-value-when-truncated-or-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-comm_write-return-value-when-truncated-or-error.patch

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
From: "Shengzhuo Wei" <me@cherr.cc>
Subject: proc: fix comm_write return value when truncated or error
Date: Fri, 24 Apr 2026 04:06:21 +0800

When count exceeds TASK_COMM_LEN-1, comm_write() copies at most
TASK_COMM_LEN-1 bytes but returns the original count.  This violates
write(2) semantics, which require returning the number of bytes actually
written.

The count parameter is size_t and should not be repurposed to carry a
negative error code on the same_thread_group() failure path.

Introduce a local len for the truncated length and a separate ssize_t ret
for the return value.

Link: https://lore.kernel.org/20260424-fix_proc_write_return-v1-1-7a793c2aad32@cherr.cc
Fixes: 4614a696bd1c ("procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm")
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Cc: John Stultz <jstultz@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c~proc-fix-comm_write-return-value-when-truncated-or-error
+++ a/fs/proc/base.c
@@ -1727,8 +1727,10 @@ static ssize_t comm_write(struct file *f
 	struct task_struct *p;
 	char buffer[TASK_COMM_LEN] = {};
 	const size_t maxlen = sizeof(buffer) - 1;
+	size_t len = count > maxlen ? maxlen : count;
+	ssize_t ret;
 
-	if (copy_from_user(buffer, buf, count > maxlen ? maxlen : count))
+	if (copy_from_user(buffer, buf, len))
 		return -EFAULT;
 
 	p = get_proc_task(inode);
@@ -1738,13 +1740,14 @@ static ssize_t comm_write(struct file *f
 	if (same_thread_group(current, p)) {
 		set_task_comm(p, buffer);
 		proc_comm_connector(p);
+		ret = len;
+	} else {
+		ret = -EINVAL;
 	}
-	else
-		count = -EINVAL;
 
 	put_task_struct(p);
 
-	return count;
+	return ret;
 }
 
 static int comm_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from me@cherr.cc are

proc-fix-comm_write-return-value-when-truncated-or-error.patch

