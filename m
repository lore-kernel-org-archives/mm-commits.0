Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE61A36DA1D
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782750881; cv=none; b=WIg08ZJoEFjQKPnY1Emg0oFbg0ZoXgfPctyRQLONLuH5XHkfsXFlVmvr6TXBFYwpdpOYW25H4A/mDuihjtJKaeNVo/rkztcZ/Yezwt++wGg4Dg5AEYAo6PoXGH2/43quwbQ0SirFiWYE1hcCtUGzaZtuNA8PhyMrJT3D35/jtNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782750881; c=relaxed/simple;
	bh=KZMVZFAHbIq1Tqj7hUFAGhsZ8OjiBEAcqJwQffnGpJs=;
	h=Date:To:From:Subject:Message-Id; b=YqDZpVxs3wTf/KpjqYjY9VKGUtQl2G2OtmWSvR077gVwRJ4IqgtrdsfntBnrAIyDiYIl4AnL1U382ILXBEjXwvYlIWtMOTKr6+Urxtq1/CL/V9AT2Qaa6vM9y2vYbr9Al64p4Z3kY2DEUlHDFeGNiUbfu9e9fzLlaWpPdmaa380=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fLsT12bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fLsT12bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F1F1F000E9;
	Mon, 29 Jun 2026 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782750879;
	bh=R4dfvop54PVEAcE6jLAurDn44XXrF/jZjE/HCJhzkFQ=;
	h=Date:To:From:Subject;
	b=fLsT12biSJX0CDUe+ROHVDeaQN8cepXOAipmStf4bJFdCW+IfwHqavI6vHv3ilJhn
	 L7SnVBS2/GxQssc2YOnHVDycZH/X/OIkoxoecBTrqpP3wDRTpDqaLtBUxz3eezPwRZ
	 ZzRhfCLD/75+3oDP5aU3FO9SlpDC5qQkoxPZyqwI=
Date: Mon, 29 Jun 2026 09:34:39 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,wangxuewen@kylinos.cn,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-annotate-data-race-in-cpu_needs_drain-fix.patch added to mm-new branch
Message-Id: <20260629163439.70F1F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-annotate-data-race-in-cpu_needs_drain-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-annotate-data-race-in-cpu_needs_drain-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-annotate-data-race-in-cpu_needs_drain-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-annotate-data-race-in-cpu_needs_drain-fix
Date: Mon Jun 29 09:26:20 AM PDT 2026

reindent cpu_needs_drain, per David & Lorenzo

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/swap.c~mm-annotate-data-race-in-cpu_needs_drain-fix
+++ a/mm/swap.c
@@ -832,12 +832,12 @@ static bool cpu_needs_drain(unsigned int
 
 	/* Check these in order of likelihood that they're not zero */
 	return data_race(folio_batch_count(&fbatches->lru_add) ||
-		folio_batch_count(&fbatches->lru_move_tail) ||
-		folio_batch_count(&fbatches->lru_deactivate_file) ||
-		folio_batch_count(&fbatches->lru_deactivate) ||
-		folio_batch_count(&fbatches->lru_lazyfree) ||
-		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu)) ||
+			 folio_batch_count(&fbatches->lru_move_tail) ||
+			 folio_batch_count(&fbatches->lru_deactivate_file) ||
+			 folio_batch_count(&fbatches->lru_deactivate) ||
+			 folio_batch_count(&fbatches->lru_lazyfree) ||
+			 folio_batch_count(&fbatches->lru_activate) ||
+			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

