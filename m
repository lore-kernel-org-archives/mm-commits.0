Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3AC1EBFE5
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725399088; cv=none; b=ujx1817Yt9oN9Zz1eyw0H7WYdS63gZbRvPmtfeTELBbrfzVgQURaDqSPPJLLM5yHctMCmwywocB4mvLCQ0grQQiEpkfXvftrc+2IXXmDJug17aqsAVYD7CK0dBL0/wSCNCFupYUPB4uwRGrbkiQC6y4Lw6AC1H2xmiUXW7cixgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725399088; c=relaxed/simple;
	bh=C5+vPM/ARktsxo8/ibSdP1IA+EYsDUMoUpOhjyp75IY=;
	h=Date:To:From:Subject:Message-Id; b=XDG/Shbo75DdjE4kYTumItLG7U6+TvvNQVMzYa6S0U7aFolaId8AACwkK+YhqUXIOEiTqAa6P5w45Fillzpg8DS2+OP+AG9KcogsoUhJ7EJrm2O62ycTA47q2aV+cTn22AXDICD8AnJqojcAHiKtDWiEJNvX809Fl/3DNH2InAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rl1BDWXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rl1BDWXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1432C4CEC4;
	Tue,  3 Sep 2024 21:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725399088;
	bh=C5+vPM/ARktsxo8/ibSdP1IA+EYsDUMoUpOhjyp75IY=;
	h=Date:To:From:Subject:From;
	b=Rl1BDWXVX5/yLg8VnaCPrtyR4LxXHXelPxvrWMgr0NL959WeZ0KVtJCaLrir1gio5
	 L0eGmdO6te47tAqV1O25uHerOEtnD7DLQF470n5weVuojN8A2pPndzh8hr3K6AKf4Z
	 LWJPoABbLHofwCCzqQcF16WlHPX9ZTV8XjV4flaE=
Date: Tue, 03 Sep 2024 14:31:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,pengfei.xu@intel.com,paulmck@kernel.org,olsajiri@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch added to mm-unstable branch
Message-Id: <20240903213127.E1432C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix off-by-one error in vms_abort_munmap_vmas()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: fix off-by-one error in vms_abort_munmap_vmas()
Date: Tue, 3 Sep 2024 13:20:34 +0100

Maple tree ranges have an inclusive end, VMAs do not, so we must subtract
one from the VMA-specific end value when using a mas_...() function.

We failed to do so in vms_abort_munmap_vmas() which resulted in a store
overlapping the intended range by one byte, and thus corrupting the maple
tree.

Fix this by subtracting one from vms->end() passed into mas_set_range().

Link: https://lkml.kernel.org/r/52ee7eb3-955c-4ade-b5f0-28fed8ba3d0b@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Closes: https://lkml.kernel.org/r/ZtZ9euGTU9T0PWDA@xpf.sh.intel.com
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Pengfei Xu <pengfei.xu@intel.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.h~mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix
+++ a/mm/vma.h
@@ -187,7 +187,7 @@ static inline void vms_abort_munmap_vmas
 	 * not symmetrical and state data has been lost.  Resort to the old
 	 * failure method of leaving a gap where the MAP_FIXED mapping failed.
 	 */
-	mas_set_range(mas, vms->start, vms->end);
+	mas_set_range(mas, vms->start, vms->end - 1);
 	if (unlikely(mas_store_gfp(mas, NULL, GFP_KERNEL))) {
 		pr_warn_once("%s: (%d) Unable to abort munmap() operation\n",
 			     current->comm, current->pid);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

