Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E6238DFCD
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806980; cv=none; b=rTDVF0/QNxsEmndz2UcrVJCQoV2lUwHkuyaR7Evz737Fqw76vAKOSuh3WIhfMRbbrccNLji5iLa86qxS81R137wXlC9/nrx91toVJWlXQ9hafqtWhYbsZ/XMBaBA1jiY+Lc0j7RqpN9ufWqz30f15EcSEffHxc1cke+bs2fMyzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806980; c=relaxed/simple;
	bh=E2l8hZMpM6vHAsU+4pEtXIEXvF00u67jwjK65GR+tWY=;
	h=Date:To:From:Subject:Message-Id; b=LFoFIotJyFgtr7TOmodq8Zmid/UfhjX6OtSWIsp8EFtN0DPmkH66JXzZilWrSoirc/9tgqZsbr4cyfCGlKO+4Fz/bBESofS/92UiA2Ayi389dZHZpZGq7dRsbNQYpVnaqp5cUeGtxA1ScxipQ3poBa94UUPPK8fVISjNTWMnics=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yvvHwTti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yvvHwTti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFCFC4CEF1;
	Wed,  7 Jan 2026 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806979;
	bh=E2l8hZMpM6vHAsU+4pEtXIEXvF00u67jwjK65GR+tWY=;
	h=Date:To:From:Subject:From;
	b=yvvHwTtiV+IVVhdk+h9Td/zNcfFdpWOnABNK9qhttcjt/fmCcuKPlmsXHbxbuM+bv
	 duHYjmDypxZ5WkovQtHMSs64DKl5LLEALmVuCKSxKbjFJzMUyAup5F+Q45WlahhFcD
	 wa13oV6LjLW/fg7q+PP6p2BLuxRVW/xVeQi9Z9wg=
Date: Wed, 07 Jan 2026 09:29:38 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,jqqlijiazi@gmail.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,mingzhu.wang@transsion.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm.patch added to mm-nonmm-unstable branch
Message-Id: <20260107172938.DCFCFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/fork: update obsolete use_mm references to kthread_use_mm
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm.patch

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
From: mingzhu.wang(王明珠) <mingzhu.wang@transsion.com>
Subject: kernel/fork: update obsolete use_mm references to kthread_use_mm
Date: Wed, 7 Jan 2026 08:15:32 +0000

The comment for get_task_mm() in kernel/fork.c incorrectly references the
deprecated function `use_mm()`, which has been renamed to
`kthread_use_mm()` in kernel/kthread.c.

This patch updates the documentation to reflect the current function
names, ensuring accuracy when developers refer to the kernel thread memory
context API.

No functional changes were introduced.

Link: https://lkml.kernel.org/r/KUZPR04MB8965F954108B4DD7E8FFDB2B8F84A@KUZPR04MB8965.apcprd04.prod.outlook.com
Signed-off-by: mingzhu.wang <mingzhu.wang@transsion.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiazi Li <jqqlijiazi@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm
+++ a/kernel/fork.c
@@ -1360,7 +1360,7 @@ struct file *get_task_exe_file(struct ta
  * @task: The task.
  *
  * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
- * this kernel workthread has transiently adopted a user mm with use_mm,
+ * this kernel workthread has transiently adopted a user mm with kthread_use_mm,
  * to do its AIO) is not set and if so returns a reference to it, after
  * bumping up the use count.  User must release the mm via mmput()
  * after use.  Typically used by /proc and ptrace.
_

Patches currently in -mm which might be from mingzhu.wang@transsion.com are

kernel-fork-update-obsolete-use_mm-references-to-kthread_use_mm.patch

