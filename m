Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E9317C9;
	Tue, 17 Sep 2024 07:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726559926; cv=none; b=ZZHf1Otcn1UFeTfJRPP+E6Ym2sq2G1N1Bwiy+Qixd0Pu/1PXmnqyxMP/1CO9IS2ytmU59dYG4dDnCsvpAU/cLNeetLddolN4ta7ni1y3XNXerueO8eVo38wvnOKYNsXuQiSfEqn8ZTiQF0HjVWCePqA1c49e/ujD0vDSN8X7wXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726559926; c=relaxed/simple;
	bh=orsHV9E0EGGP6gcVrHvZUzHixcctY1Aw7voz/ReaRRg=;
	h=Date:To:From:Subject:Message-Id; b=CZZGK0bF/CwZE0fGIory2nNfhPE4W/8kLhjkPyRx1ObKmk4vkWRgt4w6tUzzeGWC2iL4CcVBxLMuaRmNEhalt/LUIk15PW59suyzG9xurY/FZZvac+Gpzz6lp3ZmNtXNYqxd+YB6nRWdPKKZIGsaDQL0NwgJK7P5F8vhORGgm8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rK5gfBot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rK5gfBot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD14C4CEC6;
	Tue, 17 Sep 2024 07:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726559926;
	bh=orsHV9E0EGGP6gcVrHvZUzHixcctY1Aw7voz/ReaRRg=;
	h=Date:To:From:Subject:From;
	b=rK5gfBotARCkl0LVUJ+KIyvbJJxYIhp5Ns678Smy3Xx1KNVd0yNINVKj06U2528sA
	 fLQ7meI6JB/AW0jeAC8Hc76+MA8QT5KDaNv8dU+FbbNIOn93lDyszkxB+fIqXI+HaM
	 dkcEz6f93+2yRPOXwy1EMIihImvBZiAeK1GplhxA=
Date: Tue, 17 Sep 2024 00:58:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway.patch removed from -mm tree
Message-Id: <20240917075845.8BD14C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb.c: fix UAF of vma in hugetlb fault pathway
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/hugetlb.c: fix UAF of vma in hugetlb fault pathway
Date: Sat, 14 Sep 2024 12:41:19 -0700

Syzbot reports a UAF in hugetlb_fault().  This happens because
vmf_anon_prepare() could drop the per-VMA lock and allow the current VMA
to be freed before hugetlb_vma_unlock_read() is called.

We can fix this by using a modified version of vmf_anon_prepare() that
doesn't release the VMA lock on failure, and then release it ourselves
after hugetlb_vma_unlock_read().

Link: https://lkml.kernel.org/r/20240914194243.245-2-vishal.moola@gmail.com
Fixes: 9acad7ba3e25 ("hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()")
Reported-by: syzbot+2dab93857ee95f2eeb08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/00000000000067c20b06219fbc26@google.com/
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-uaf-of-vma-in-hugetlb-fault-pathway
+++ a/mm/hugetlb.c
@@ -6048,7 +6048,7 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	ret = vmf_anon_prepare(vmf);
+	ret = __vmf_anon_prepare(vmf);
 	if (unlikely(ret))
 		goto out_release_all;
 
@@ -6247,7 +6247,7 @@ static vm_fault_t hugetlb_no_page(struct
 		}
 
 		if (!(vma->vm_flags & VM_MAYSHARE)) {
-			ret = vmf_anon_prepare(vmf);
+			ret = __vmf_anon_prepare(vmf);
 			if (unlikely(ret))
 				goto out;
 		}
@@ -6378,6 +6378,14 @@ static vm_fault_t hugetlb_no_page(struct
 	folio_unlock(folio);
 out:
 	hugetlb_vma_unlock_read(vma);
+
+	/*
+	 * We must check to release the per-VMA lock. __vmf_anon_prepare() is
+	 * the only way ret can be set to VM_FAULT_RETRY.
+	 */
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vma);
+
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	return ret;
 
@@ -6599,6 +6607,14 @@ out_ptl:
 	}
 out_mutex:
 	hugetlb_vma_unlock_read(vma);
+
+	/*
+	 * We must check to release the per-VMA lock. __vmf_anon_prepare() in
+	 * hugetlb_wp() is the only way ret can be set to VM_FAULT_RETRY.
+	 */
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vma);
+
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


