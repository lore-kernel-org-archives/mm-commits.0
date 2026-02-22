Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2A12D1303
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771791186; cv=none; b=NzDOtz6eLtT2hpnuTQmIq49Zl0eoTX1nvVMzkbPo/xUMgbSH3WuZe/DRSrpWNj3UJsYZXHxrW13M5mFSLHNkuggz/NIFqYjlqodGCKAdPsWDuqoYE83wlrHwWec48mzc6Tzg7yftwY1sxk4TORVolI5ILjUkvPcJihEXSFKhAok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771791186; c=relaxed/simple;
	bh=IVuQhGoVWfVm5mOb13mpxTbwiBbq8VBd3UcG4iO9ybE=;
	h=Date:To:From:Subject:Message-Id; b=e1JB5LbAKpyKu4wd6b77vyY7OrpsswgssE1hgVclUC9wPiqttajGCTQfzICZlrJgEQWrbZMBZq6D5HSQ68Gd7D4CYDfm7J3S0Jbo8aMEYvlZEwBmPdG+U6EqfLhEUCHD5BdpvSPenvZdpCO+hDNkAtkH/sr1omNZxfIAnS86RVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Oaqw3LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Oaqw3LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61AAC116D0;
	Sun, 22 Feb 2026 20:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771791186;
	bh=IVuQhGoVWfVm5mOb13mpxTbwiBbq8VBd3UcG4iO9ybE=;
	h=Date:To:From:Subject:From;
	b=2Oaqw3LLv0FSiHYYSZC4LYBZFpMW97W9u6dG8Ad3owMkVm5JXLijDBMf7wHbQJ8AX
	 qcOa9COn5PTdkwrGbxwj2xtbfIWp6iO4D+Dww98nJMwgXfuu5dRq5BBUZF2d0j5SUQ
	 gRRy9x2WOTAa/xu1VTAioTMSu2bo8tDl9BsIqpDI=
Date: Sun, 22 Feb 2026 12:13:05 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch added to mm-nonmm-unstable branch
Message-Id: <20260222201305.E61AAC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: replace simple_strtoul with kstrtoul in coredump_filter_setup
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: fork: replace simple_strtoul with kstrtoul in coredump_filter_setup
Date: Mon, 15 Dec 2025 15:21:52 +0100

Replace simple_strtoul() with the recommended kstrtoul() for parsing the
'coredump_filter=' boot parameter.

Check the return value of kstrtoul() and reject invalid values.  This adds
error handling while preserving behavior for existing values, and removes
use of the deprecated simple_strtoul() helper.  The current code silently
sets 'default_dump_filter = 0' if parsing fails, instead of leaving the
default value (MMF_DUMP_FILTER_DEFAULT) unchanged.

Rename the static variable 'default_dump_filter' to 'coredump_filter'
since it does not necessarily contain the default value and the current
name can be misleading.

Link: https://lkml.kernel.org/r/20251215142152.4082-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

 kernel/fork.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/fork.c~fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup
+++ a/kernel/fork.c
@@ -1016,13 +1016,14 @@ free_tsk:
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(mmlist_lock);
 
-static unsigned long default_dump_filter = MMF_DUMP_FILTER_DEFAULT;
+static unsigned long coredump_filter = MMF_DUMP_FILTER_DEFAULT;
 
 static int __init coredump_filter_setup(char *s)
 {
-	default_dump_filter =
-		(simple_strtoul(s, NULL, 0) << MMF_DUMP_FILTER_SHIFT) &
-		MMF_DUMP_FILTER_MASK;
+	if (kstrtoul(s, 0, &coredump_filter))
+		return 0;
+	coredump_filter <<= MMF_DUMP_FILTER_SHIFT;
+	coredump_filter &= MMF_DUMP_FILTER_MASK;
 	return 1;
 }
 
@@ -1108,7 +1109,7 @@ static struct mm_struct *mm_init(struct
 		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
 	} else {
-		__mm_flags_overwrite_word(mm, default_dump_filter);
+		__mm_flags_overwrite_word(mm, coredump_filter);
 		mm->def_flags = 0;
 	}
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch

