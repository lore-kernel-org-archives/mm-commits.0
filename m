Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D091547F5
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741904994; cv=none; b=KA3Rvs/6N5xXz6HLSfwTkLwXhrqaAGgguNsrOEJIBKMW41ZUMfFmKH9+oLM5RSVm55UqSbRKB28jDombTbB3DzGh+G7hbr3qxnsdGzIvJWWgQgkl+0EnCAT3qELw5euIBObBlvYI+hvZIpeF4AwR3ClctFQMqMGc1Hw8g7jWvGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741904994; c=relaxed/simple;
	bh=f0rGmsx9+2VlUmiV/XB3T5rmdhLY+I+LHdpL50DRATo=;
	h=Date:To:From:Subject:Message-Id; b=VvirkuKWIbnR3r2ycNo6VBdQ025J/YL4thEUeoZU8Th95A9xMfAnvSMOOLfvm/HHBM/zHB0tZZiPFKgqdixM3QpU+mamkB/qFAHR4ySN4z5f6lGLS+N3WuTfsi3S+9GFcvImoEkp8rYry+ShRgUIjUZ5NJTslgyjAzI1V2uUBtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/BmXqDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/BmXqDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E360BC4CEDD;
	Thu, 13 Mar 2025 22:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741904994;
	bh=f0rGmsx9+2VlUmiV/XB3T5rmdhLY+I+LHdpL50DRATo=;
	h=Date:To:From:Subject:From;
	b=D/BmXqDBbGHZL288GCNW/YlCnYVx51NrXWUHbtnUwMPaMdvVvSAdv+Wf2kvQLZ1oV
	 Upl5KMC/yLfEV4zV16SUSXPv7bV34phLDkYKe+akC/q2u1C7fdDTBA3Whvvc0StOHC
	 WY8x7Jd4/pDefzWBIZGERg33dDcQtGfp6/J/LTgk=
Date: Thu, 13 Mar 2025 15:29:53 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,joel.granados@kernel.org,ioworker0@gmail.com,boqun.feng@gmail.com,anna.schumaker@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250313222953.E360BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix
Date: Thu Mar 13 03:28:05 PM PDT 2025

implement debug_show_blocker() in C rather than in CPP

Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/hung_task.c~hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix
+++ a/kernel/hung_task.c
@@ -125,7 +125,9 @@ static void debug_show_blocker(struct ta
 	}
 }
 #else
-#define debug_show_blocker(t)	do {} while (0)
+static inline void debug_show_blocker(struct task_struct *task)
+{
+}
 #endif
 
 static void check_hung_task(struct task_struct *t, unsigned long timeout)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

