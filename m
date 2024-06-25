Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0434C61B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291713; cv=none; b=G+C/nJtVoTcycJjRFopoZe7uuhXi6b462nBX0qpeyjObZI0Qb6ti7KWk7goZfNJGwyWjNJn8Xj1PF16/8p54vWf3r5GuZheMEk2DRo2fIZQRI5kTczzevb0plHRNWlaLrz78pzFM31JS5cTKV42L4FOtTcFseDsottcyn28nPHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291713; c=relaxed/simple;
	bh=2ZuthI8/25+ndfcB8CowEryZB1Wr1OoCVqbMlL5zbYs=;
	h=Date:To:From:Subject:Message-Id; b=j9muGxxTevMOtTOcMrvtD1J+PP9ANLI9uTGdHos4QDikuIN03p9QwEhHjicQLIH+kCur57C3rDFGDgXcmddQUqNyfzH/ezLgPMm4+QGKgbhsYSX7rS9FuAunnNtDLIWTKlXNiBTFMaY55CUDNQzWhD2azPJQ8/rHCVaQqpl9ewg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kFuKi+H3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kFuKi+H3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12390C32782;
	Tue, 25 Jun 2024 05:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291713;
	bh=2ZuthI8/25+ndfcB8CowEryZB1Wr1OoCVqbMlL5zbYs=;
	h=Date:To:From:Subject:From;
	b=kFuKi+H3elly7aFiU8hiwvAx8hLYYG5JzMrCOKcz27AxIvPjjyWYR/KapTUAEwqTL
	 HycyvQVQe/IW3Ar9HpA+fkzDXVY3kFoeiOrcFvqt+yiZMq1NEd2EbCWjxBfu14tihz
	 yBl7YXYfXtZBRW+9nzF8jyIcl1HdBVNL+0Jkw6iI=
Date: Mon, 24 Jun 2024 22:01:52 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-helper-macro-task_pid_nr.patch removed from -mm tree
Message-Id: <20240625050153.12390C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: use helper macro task_pid_nr()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-helper-macro-task_pid_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


