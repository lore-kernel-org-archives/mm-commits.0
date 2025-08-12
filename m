Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6B22D3A9D
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962487; cv=none; b=GBnYW/aJRLaAkj7tVjNXiTvJqH/UJNab5PcOt78SpxHSxabqCsWf3of/OtzxP+6Dx74eGnHt5JFiDzIZ91U+brqnuphEqY9d81zDyQUXSfQgkjEY0Vdgrk7j4gu50LCJaFDdch9ObGiZs6+1Xcij+KLNeaCT6SstQLKEwqIEB+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962487; c=relaxed/simple;
	bh=hjl2bulDhQcwET4JoqEscyb/VYqqUYsnUnbSuV5LnpI=;
	h=Date:To:From:Subject:Message-Id; b=ZCRgPxJbNbuiQBGxzVPFf4f4ivpRr3d5HjqqCGfNa+EgaW8knEj5iQrH7y0FUytIR+hX3WrlnqiQRAN4c7NTjzwpmfcCfBPYq1AZls2WfvEEGSdUIguXbSw4sjInbnfIbcdRMzgZtk7svCcZfysX5zNY8+tsqirBhwWtwWECLxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cdLibtxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cdLibtxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2DAC4CEF5;
	Tue, 12 Aug 2025 01:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754962487;
	bh=hjl2bulDhQcwET4JoqEscyb/VYqqUYsnUnbSuV5LnpI=;
	h=Date:To:From:Subject:From;
	b=cdLibtxdxsNFp1enzWAUTFjMDDLN8ThtqER1ZOoXis3vOBDn2f7lxS7piZ8VwAy6r
	 1wf0NVgRiagsAg95+QXtck56lDtijizVv4P3dRsr+9KRKpP2Yoj0o73Bd8jEYfwXrE
	 BpsanFXVnMV5hVknVobb0m1YnktbF7fiy7gt2his=
Date: Mon, 11 Aug 2025 18:34:46 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,mjguzik@gmail.com,gaoxiang17@xiaomi.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-introduce-task_ppid_vnr.patch added to mm-nonmm-unstable branch
Message-Id: <20250812013446.EB2DAC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: introduce task_ppid_vnr()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-introduce-task_ppid_vnr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-introduce-task_ppid_vnr.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: pid: introduce task_ppid_vnr()
Date: Sun, 10 Aug 2025 19:36:10 +0200

For consistency with other task_xid_vnr() helpers.

Link: https://lkml.kernel.org/r/20250810173610.GA19995@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pidfs.c          |    2 +-
 include/linux/pid.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/pidfs.c~pid-introduce-task_ppid_vnr
+++ a/fs/pidfs.c
@@ -397,7 +397,7 @@ static long pidfd_info(struct file *file
 	 * the fields are set correctly, or return ESRCH to avoid providing
 	 * incomplete information. */
 
-	kinfo.ppid = task_ppid_nr_ns(task, NULL);
+	kinfo.ppid = task_ppid_vnr(task);
 	kinfo.tgid = task_tgid_vnr(task);
 	kinfo.pid = task_pid_vnr(task);
 	kinfo.mask |= PIDFD_INFO_PID;
--- a/include/linux/pid.h~pid-introduce-task_ppid_vnr
+++ a/include/linux/pid.h
@@ -310,6 +310,11 @@ static inline pid_t task_ppid_nr_ns(cons
 	return pid;
 }
 
+static inline pid_t task_ppid_vnr(const struct task_struct *tsk)
+{
+	return task_ppid_nr_ns(tsk, NULL);
+}
+
 static inline pid_t task_ppid_nr(const struct task_struct *tsk)
 {
 	return task_ppid_nr_ns(tsk, &init_pid_ns);
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
pid-introduce-task_ppid_vnr.patch
pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
pid-change-task_state-to-use-task_ppid_nr_ns.patch

