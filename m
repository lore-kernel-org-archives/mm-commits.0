Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312BC2DCC04
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 19:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769627680; cv=none; b=Nn7GRQYG9yepHjKnDDjhnCH2Hw9Zso7lqbaVzH93u5NXShHJ6EO4J8tlAmUGb10oGZPdA2ddp7V6wdpYlTrhv5gWtmJfESiZdT5HOBzzOHSjN8LNivA3831H0n26LZjbwF/jyNHhTmxjDnj6leywIBuFVugj+QHl4xxaIqXWJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769627680; c=relaxed/simple;
	bh=mZRDszmarf8D+E/JnYYAUDo+blxKGMB2qwCJkX8qZl4=;
	h=Date:To:From:Subject:Message-Id; b=LizmcHwWA4kfPTbLO8J+e0EhkyaVs1fa4bMptafV3jSK0PZrC1uXuc5yefxlLJyK0E6AmM5LNN8jwbe70WQHnt+csjeBSapRTOrLLs5whXxPSaAmCqeHIb0ogAzngSkiCDz3VV+5H1txZcbY7GVf7trASNasqtnKD6CjDLcbfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXihCAmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXihCAmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C79C4CEF7;
	Wed, 28 Jan 2026 19:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769627679;
	bh=mZRDszmarf8D+E/JnYYAUDo+blxKGMB2qwCJkX8qZl4=;
	h=Date:To:From:Subject:From;
	b=qXihCAmmVX/APbkJunxgnNT6sTjWsz5LxGaBlMXZ8qoCQRIFus2ys6aoWFgp623fI
	 apFapFhiK9LhRiFg88AnHhxYYiB9JBCclrO64jTnohNoVaUT4IVVgDM5YOYWpb2Mto
	 XaOW/CzZY7xhsuuURj39LZQCeocYPJ/Yl25hWcXU=
Date: Wed, 28 Jan 2026 11:14:39 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,ruippan@tencent.com,oleg@redhat.com,mjguzik@gmail.com,mingo@kernel.org,lorenzo.stoakes@oracle.com,david@kernel.org,alexjlzheng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat.patch added to mm-nonmm-unstable branch
Message-Id: <20260128191439.99C79C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: procfs: fix missing RCU protection when reading real_parent in do_task_stat()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat.patch

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
From: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: procfs: fix missing RCU protection when reading real_parent in do_task_stat()
Date: Wed, 28 Jan 2026 16:30:07 +0800

When reading /proc/[pid]/stat, do_task_stat() accesses task->real_parent
without proper RCU protection, which leads to:

  cpu 0                               cpu 1
  -----                               -----
  do_task_stat
    var = task->real_parent
                                      release_task
                                        call_rcu(delayed_put_task_struct)
    task_tgid_nr_ns(var)
      rcu_read_lock   <--- Too late to protect task->real_parent!
      task_pid_ptr    <--- UAF!
      rcu_read_unlock

This patch uses task_ppid_nr_ns() instead of task_tgid_nr_ns() to add
proper RCU protection for accessing task->real_parent.

Link: https://lkml.kernel.org/r/20260128083007.3173016-1-alexjlzheng@tencent.com
Fixes: 06fffb1267c9 ("do_task_stat: don't take rcu_read_lock()")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: ruippan <ruippan@tencent.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c~procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat
+++ a/fs/proc/array.c
@@ -529,7 +529,7 @@ static int do_task_stat(struct seq_file
 		}
 
 		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		ppid = task_ppid_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
_

Patches currently in -mm which might be from alexjlzheng@tencent.com are

procfs-fix-missing-rcu-protection-when-reading-real_parent-in-do_task_stat.patch

