Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D611C8287E
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218900; cv=none; b=m/NvzhCoV5IPjhQVXiKe3DFt1mWLR2e+/sNjv47D6gEfFm1JOv/VnbZ37jg8xqy/69PEEU3o0yCXMzwFDXvNXJDlYm3f5XmpUmrpJCZsNdmwixa9B8wV8na3IKXoA3UBiuE94TWrV9WxhBDi7OWwfA8uF3KScui+b5leOTxO/w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218900; c=relaxed/simple;
	bh=tREGqGnIlM7qieYaKxCBQU2m/R0vczNVr7gPLkxpRbA=;
	h=Date:To:From:Subject:Message-Id; b=GBEIssf4rL2sGgqGHdDsDh1p+49Zz2/tPGWuqpX0dPbAVVrdpVO3brWcdU0wxn9L30ljKK3OfC/bEAL//WfbA7f1rqE7+6nB43L1z6gEM+Py8xT2o1hEei48MCOkzqychC+9BxKs6fKaC88IacOjmJkw3EYz1ZU4/IQsKmiOTi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=faxrMY60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="faxrMY60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E3DC116B1;
	Wed, 12 Jun 2024 19:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218900;
	bh=tREGqGnIlM7qieYaKxCBQU2m/R0vczNVr7gPLkxpRbA=;
	h=Date:To:From:Subject:From;
	b=faxrMY60tsVnuIt3OVE8uBkzo8AyXZGSp3XwlYOkI/Wfm0C2z+8nuJYksg7YTlawJ
	 5e2to5I6567cD36xFO0LMTVhn1OltijlFsFA2Jub99PABMED3tHrVQ1HgOONvEz08P
	 BVrwbHGc9mC51uCisdg7ksU5f5VKkNg01cva4G4Q=
Date: Wed, 12 Jun 2024 12:01:40 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-helper-macro-task_pid_nr.patch added to mm-unstable branch
Message-Id: <20240612190140.A1E3DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: use helper macro task_pid_nr()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-use-helper-macro-task_pid_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-helper-macro-task_pid_nr.patch

This patch will later appear in the mm-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: use helper macro task_pid_nr()
Date: Wed, 12 Jun 2024 15:18:30 +0800

Use helper macro task_pid_nr() to get the pid of a task.  No functional
change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-helper-macro-task_pid_nr
+++ a/mm/memory-failure.c
@@ -343,7 +343,7 @@ static int kill_proc(struct to_kill *tk,
 	int ret = 0;
 
 	pr_err("%#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
-			pfn, t->comm, t->pid);
+			pfn, t->comm, task_pid_nr(t));
 
 	if ((flags & MF_ACTION_REQUIRED) && (t == current))
 		ret = force_sig_mceerr(BUS_MCEERR_AR,
@@ -361,7 +361,7 @@ static int kill_proc(struct to_kill *tk,
 				      addr_lsb, t);
 	if (ret < 0)
 		pr_info("Error sending signal to %s:%d: %d\n",
-			t->comm, t->pid, ret);
+			t->comm, task_pid_nr(t), ret);
 	return ret;
 }
 
@@ -523,7 +523,7 @@ static void kill_procs(struct list_head
 		if (forcekill) {
 			if (tk->addr == -EFAULT) {
 				pr_err("%#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
-				       pfn, tk->tsk->comm, tk->tsk->pid);
+				       pfn, tk->tsk->comm, task_pid_nr(tk->tsk));
 				do_send_sig_info(SIGKILL, SEND_SIG_PRIV,
 						 tk->tsk, PIDTYPE_PID);
 			}
@@ -536,7 +536,7 @@ static void kill_procs(struct list_head
 			 */
 			else if (kill_proc(tk, pfn, flags) < 0)
 				pr_err("%#lx: Cannot send advisory machine check signal to %s:%d\n",
-				       pfn, tk->tsk->comm, tk->tsk->pid);
+				       pfn, tk->tsk->comm, task_pid_nr(tk->tsk));
 		}
 		list_del(&tk->nd);
 		put_task_struct(tk->tsk);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

