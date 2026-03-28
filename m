Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83890331A65
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671892; cv=none; b=nQX3uZRw/pdbpcQVOIDMmuKL29ZPKdyNaJZvPjWOcngmxDWS8wlaeYkeQzZYoALyQSN5uPzcIMvwk65P9ik4rXxzIBxo8HZIgg5U1g8Ht2c7ZDuiswGCbVlvjL7R95XSyztw5HczcBvzTIHwSyZgce7stzC1A1XrHvhuxqptLjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671892; c=relaxed/simple;
	bh=Dx45oHURwHYggrIGUFTlFD5aEUc1970yDBIkCOIXnog=;
	h=Date:To:From:Subject:Message-Id; b=TLDpDW9HpgBUYGuYYTzr5x/1wYZAg/nzckrZJVXKBcKy+3eNU/pz5jr9z9uf38Ia8KP3P/Ge3S9/qMdZDoFwKfXq/ci5KC+Njp2lmPkK+bapBRHhFkMF6ki3iSOxsYkTIH682OEU7OUjZiUm+VewrtdQURv68xErDCVU1k6Pvdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PktCDb2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PktCDb2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A96C4CEF7;
	Sat, 28 Mar 2026 04:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671892;
	bh=Dx45oHURwHYggrIGUFTlFD5aEUc1970yDBIkCOIXnog=;
	h=Date:To:From:Subject:From;
	b=PktCDb2e2n9YOz4wPpwAnZMDweRvukcA0E+yf87bWmHKP9JSwxs7YBHjh1wn0l9S9
	 mnoZH+2cv6LgbtQY++0Nr0W/y2MNvvYGLs8GL6RDLLWZX9QnLrY9CrrGv77N3bRqkZ
	 baBawNNponiE797lWknKW8LnjRIIq2ouFambUWqY=
Date: Fri, 27 Mar 2026 21:24:51 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,ljs@kernel.org,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,akpm@linux-foundation.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch removed from -mm tree
Message-Id: <20260328042452.13A96C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: replace simple_strtoul with kstrtoul in coredump_filter_setup
has been removed from the -mm tree.  Its filename was
     fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
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
@@ -1014,13 +1014,14 @@ free_tsk:
 
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
 
@@ -1106,7 +1107,7 @@ static struct mm_struct *mm_init(struct
 		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
 	} else {
-		__mm_flags_overwrite_word(mm, default_dump_filter);
+		__mm_flags_overwrite_word(mm, coredump_filter);
 		mm->def_flags = 0;
 	}
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


