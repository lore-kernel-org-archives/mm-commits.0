Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6FE6E5E5
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 19:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628946; cv=none; b=gmpY9zkJfmpE7FOsclPdyIh7WucoA0AxiCAYVdekpYLeXlkFLFm9qmi8lcGzwxnrjb1+UmJpevElnIOsg+2kU1iLRSz64SKlmjYotEsobkdoJDO0BP8nblq4N0ze6p75nZnRYui9x6OoUZ2w5H89Oen0nVK6KykmPiHKx4mu890=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628946; c=relaxed/simple;
	bh=78eQgAnn90iNuF0zvX5v6d0JgIVXnwE1qXCIq6j8ZOs=;
	h=Date:To:From:Subject:Message-Id; b=LEJGHhuP/kK3t9RyPQcxsK65gR5J5w1zNDvvGR4GKlxnVrLu2Vl8nZNUkYzwmqyAwb7tfCys6UqeHNiCefww8FeFnNJkSiTN3fXWFSvmqvH5DqxxLbIztG61WbZkSShlamWKdsCNqiytdSIt/IKUd8d+yBU2UgrfENtVS5Ugcds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=15PRuXkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="15PRuXkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB533C433C7;
	Thu, 22 Feb 2024 19:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708628945;
	bh=78eQgAnn90iNuF0zvX5v6d0JgIVXnwE1qXCIq6j8ZOs=;
	h=Date:To:From:Subject:From;
	b=15PRuXkvqqefQwzBMlXxV82DouMCe7Z762DdxPycNpK+/ChurpRQcIH2ZB2bzDJHk
	 rgRksCwJwmFL4kuWjw1iLjKjF3Nzds3cE6XOqtT+SuvgbEV51E3qG8fHXANER2Hba5
	 LjL7bMmCjSbAnFxFnx5NpTs6lBrS/ZbcnnxiLcGA=
Date: Thu, 22 Feb 2024 11:09:05 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,gang.li@linux.dev,david@redhat.com,adobriyan@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-parallelize-1g-hugetlb-initialization-fix.patch added to mm-unstable branch
Message-Id: <20240222190905.DB533C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb-parallelize-1g-hugetlb-initialization-fix
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-parallelize-1g-hugetlb-initialization-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-parallelize-1g-hugetlb-initialization-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-parallelize-1g-hugetlb-initialization-fix
Date: Thu Feb 22 10:34:41 AM PST 2024

s/initialied/initialized/, per Alexey

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gang Li <gang.li@linux.dev>
Cc: Gang Li <ligang.bdlg@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-parallelize-1g-hugetlb-initialization-fix
+++ a/mm/hugetlb.c
@@ -3625,7 +3625,7 @@ static unsigned long __init hugetlb_page
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long allocated;
-	static bool initialied __initdata;
+	static bool initialized __initdata;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3634,12 +3634,12 @@ static void __init hugetlb_hstate_alloc_
 	}
 
 	/* hugetlb_hstate_alloc_pages will be called many times, initialize huge_boot_pages once */
-	if (!initialied) {
+	if (!initialized) {
 		int i = 0;
 
 		for (i = 0; i < MAX_NUMNODES; i++)
 			INIT_LIST_HEAD(&huge_boot_pages[i]);
-		initialied = true;
+		initialized = true;
 	}
 
 	/* do node specific alloc */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

