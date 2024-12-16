Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB8510F4;
	Mon, 16 Dec 2024 05:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327644; cv=none; b=rCylkML5OP5TmxJHF5kAwm0DgoFoZbdV6apuKmwwaE9aNv/ggYQQokMYP3sEyhvC/+NwgwEy15xMo8ypZd5mMoKaEzf06ruzzFiTuWsVIR4U06Nvi6CvlIpl4wLtflTUMw4aB1RJpbcXu5Iqb0OYoAbcAo4I/5Dlfi9PuwTpUVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327644; c=relaxed/simple;
	bh=M1SnyEp0FyzyUk5gjEDkbZ+Hf+f4IWkZeYCNSZ3Xsu8=;
	h=Date:To:From:Subject:Message-Id; b=P/HwqTxlzoHFiRgdccZXI77oJ/PzHIdY0v92YVkrK9huldebwbu/SqIjrU34TpD2qUtOaY9KfsSYe5WyHeG3G0cvI7ln+r0iPbRGf4Pc2aY0BGBvHez6DwkFGsGalCX+wNohOlbmCgUfgE3eQZ2KuMa3BsuYLQnIDU9I5Ks7BKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdRVLNZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdRVLNZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1F1C4CED0;
	Mon, 16 Dec 2024 05:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327643;
	bh=M1SnyEp0FyzyUk5gjEDkbZ+Hf+f4IWkZeYCNSZ3Xsu8=;
	h=Date:To:From:Subject:From;
	b=HdRVLNZEMI85wwQLNgp60RefMsOsON4hAfnNOsq8sGXA1z3feMh7T8YBCq58hBToz
	 vi2FHZLUvNeBEPTgDroqScbxGNqmyK/+yvbZzfdLyG3Qaqsh8zLbBizfjWdfgPDAje
	 QRNxi2ljkEiqWa+gP4/dfUaQzJdAKRN6u6r0K+VM=
Date: Sun, 15 Dec 2024 21:40:42 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-handle-a-symlink-read-error-correctly.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054043.9E1F1C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: handle a symlink read error correctly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-handle-a-symlink-read-error-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-handle-a-symlink-read-error-correctly.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: handle a symlink read error correctly
Date: Thu, 5 Dec 2024 17:16:29 +0000

Patch series "Convert ocfs2 to use folios".

Mark did a conversion of ocfs2 to use folios and sent it to me as a
giant patch for review ;-)

So I've redone it as individual patches, and credited Mark for the patches
where his code is substantially the same.  It's not a bad way to do it;
his patch had some bugs and my patches had some bugs.  Hopefully all our
bugs were different from each other.  And hopefully Mark likes all the
changes I made to his code!


This patch (of 23):

If we can't read the buffer, be sure to unlock the page before returning.

Link: https://lkml.kernel.org/r/20241205171653.3179945-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20241205171653.3179945-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/symlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/symlink.c~ocfs2-handle-a-symlink-read-error-correctly
+++ a/fs/ocfs2/symlink.c
@@ -65,7 +65,7 @@ static int ocfs2_fast_symlink_read_folio
 
 	if (status < 0) {
 		mlog_errno(status);
-		return status;
+		goto out;
 	}
 
 	fe = (struct ocfs2_dinode *) bh->b_data;
@@ -76,9 +76,10 @@ static int ocfs2_fast_symlink_read_folio
 	memcpy(kaddr, link, len + 1);
 	kunmap_atomic(kaddr);
 	SetPageUptodate(page);
+out:
 	unlock_page(page);
 	brelse(bh);
-	return 0;
+	return status;
 }
 
 const struct address_space_operations ocfs2_fast_symlink_aops = {
_

Patches currently in -mm which might be from willy@infradead.org are

vmalloc-fix-accounting-with-i915.patch
mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
ocfs2-handle-a-symlink-read-error-correctly.patch
ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch
ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch
ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch
ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch

