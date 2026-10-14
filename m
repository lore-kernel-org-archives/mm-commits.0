Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA0266576
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 01:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791940188; cv=none; b=J+E4l3yNVYzywKFnz255nHMgqANSdVLxr7iCG9bkHnZEFGTPXE6ZKQFcPLZipgnStJMClMQStbLDNRNPvaioa+vv5hm9J8lj0AmxHVnhn5uvS1WmtYZlmsFVF3BUwCkk72GFNG/WVbkUaWwePvppTr0sxasYR2/tL4UNAEbnVhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791940188; c=relaxed/simple;
	bh=BFQVUz61LRCkhVohpZ9Gp6Ldw72n89cUlstJu00z8mQ=;
	h=Date:To:From:Subject:Message-Id; b=bo/8q1weyPTtfxQYgSn0BRhs1KJGxUpopfI0KLCs2tHGPKOVlzYJVApry4wow7Q8oYCYFq2tOKzrm+f8oQ91GGuimoZRyGTu1iKD5QYXgtopg8x4ts+WJC7/amXWJT3AOYAbVaAucl1xLg5dAXKW32HxZv0mx85/PQk77T49mYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fL/YUMi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fL/YUMi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46B61F00898;
	Wed, 14 Oct 2026 01:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791940186;
	bh=Wx3TQhVYBTlhwonOWxtKxor/iVtWnhwv+XXSLo1QKEg=;
	h=Date:To:From:Subject;
	b=fL/YUMi6+3tZVInqsnMXjfKS8QT5Gk1SBuUJgjT1dwZVSX3GGGJ+IcB7thQ2vIJY+
	 RIWwNovgCkKjds3B4c8VIsnxHkOGE51/UJSk/Knb+YQxfQ1EgR3obgtsEZsyEN7mKR
	 85smZj7R8nVgJjLCf6rtdbm3Ppt0R26dSOhQTxyI=
Date: Tue, 13 Oct 2026 18:09:46 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,BouziguesAlexis@JohnDeere.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-set-mmf_oom_skip-in-exit_mmap.patch added to mm-unstable branch
Message-Id: <20261014010946.D46B61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: nommu: set MMF_OOM_SKIP in exit_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-nommu-set-mmf_oom_skip-in-exit_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-set-mmf_oom_skip-in-exit_mmap.patch

This patch will later appear in the mm-unstable branch at
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
From: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
Subject: mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Date: Tue, 13 Oct 2026 17:56:19 -0500

Commit 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run
concurrently") moved setting MMF_OOM_SKIP from __mmput() into the MMU
exit_mmap(), so it is no longer set when a NOMMU mm is torn down.

As a result, a NOMMU OOM victim that has exited and freed its memory keeps
the OOM killer from selecting another victim until it is reaped.

Set MMF_OOM_SKIP in the NOMMU exit_mmap() once the VMAs are freed, as the
MMU version does.

Link: https://lore.kernel.org/20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com
Fixes: 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")
Signed-off-by: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Michal Hocko <mhocko@suse.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 mm/nommu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/nommu.c~mm-nommu-set-mmf_oom_skip-in-exit_mmap
+++ a/mm/nommu.c
@@ -1555,6 +1555,7 @@ void exit_mmap(struct mm_struct *mm)
 		delete_vma(mm, vma);
 		cond_resched();
 	}
+	mm_flags_set(MMF_OOM_SKIP, mm);
 	__mt_destroy(&mm->mm_mt);
 	mmap_write_unlock(mm);
 }
_

Patches currently in -mm which might be from BouziguesAlexis@JohnDeere.com are

mm-nommu-set-mmf_oom_skip-in-exit_mmap.patch

