Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0BC3CA498
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775239182; cv=none; b=DU9aRkEFCYwFd93atPayI6slBnr59n/gkXxYUuAuMwEvFq9CNKspLUCwaEDpjgpEE8Ji2ke7BRB6vDcaywneBKCVDh3NSMRTiWUl2qAt1hnTvY82uxfTeYhJX0qYQMZdoywvHijpyqkyMJlMWG6iFyJmG2kZZfZbk/PNZfUPm9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775239182; c=relaxed/simple;
	bh=QOFkYtpXjaE4NLWQ3g2JODTzrbieiF+b1p4QWCMxF5M=;
	h=Date:To:From:Subject:Message-Id; b=N5IFp2tms848tHkik4ZOLP44n/qZC0aqjVINjV3n9rsH3PdgPH2ygvLP/2RJK2QEe4sENIZGGFzwQehy89JHcbl+zwEl2Kplmf3QkUu7ZMXz9T5EycfK+vOzlnXOUk7eLb5IlWQ+f1wAHmXfgAsvbHc5SFgDzdYN4FxAF+05YgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pha8SnE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pha8SnE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ABFC4CEF7;
	Fri,  3 Apr 2026 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775239182;
	bh=QOFkYtpXjaE4NLWQ3g2JODTzrbieiF+b1p4QWCMxF5M=;
	h=Date:To:From:Subject:From;
	b=pha8SnE/Qj93mAU8tnbF+o9Ek0l0LuaEQLxbprS6nRd/E9AFgFiXYWx/DahMZb27l
	 ULfAukijtqBBejF7VzM7smlARnxkdm+KgAdK48bS2lv+P9P99QuiMUKhwieyqxqXmJ
	 /zdVezdvhepPbi3JlVTkj5p6VvtMyXILnvTG0gEA=
Date: Fri, 03 Apr 2026 10:59:41 -0700
To: mm-commits@vger.kernel.org,Kartikey406@gmail.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch removed from -mm tree
Message-Id: <20260403175942.43ABFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel-fork-validate-exit_signal-in-kernel_clone-fix
has been removed from the -mm tree.  Its filename was
     kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

This patch was dropped because it was folded into kernel-fork-validate-exit_signal-in-kernel_clone.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel-fork-validate-exit_signal-in-kernel_clone-fix
Date: Thu, 19 Mar 2026 18:16:49 +0100

the comment above kernel_clone() should be updated

Link: https://lkml.kernel.org/r/abwvgU17W8wuW2-J@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-kernel_clone-fix
+++ a/kernel/fork.c
@@ -2611,8 +2611,6 @@ struct task_struct *create_io_thread(int
  *
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
- *
- * args->exit_signal is expected to be checked for sanity by the caller.
  */
 pid_t kernel_clone(struct kernel_clone_args *args)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

kernel-fork-validate-exit_signal-in-kernel_clone.patch

