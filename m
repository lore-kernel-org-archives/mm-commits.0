Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE66160783
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742227; cv=none; b=bt6ynFvS1wEGey9eh6O4RYtrcJylbR2GM2uW298RchERFKmDiig9aewyCF4X5oVllqShO46xx8rP6q42J21a+ahFVodu0vPROX7vCHN+5yaVbOi6b4AOhdHuFmEl7Pwm3G68kQOvdzcayd/WvJZ+6hGDlV/QW6iiTFaKlzcNl3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742227; c=relaxed/simple;
	bh=NZZW2XaTTpHi16k4+NLr9D8XOgIyAgNAOhocQkxqDNU=;
	h=Date:To:From:Subject:Message-Id; b=SD0bouJJOYtyawB5BYxbGfJlF0JMcczY1TwXFZT8ngeSbbcs3VI4/Bv4KuMWLFznSti+fGJv9lVcrzoIve8Um2nd0eR0f+kKs1bMhac2EbRRuvj7HyCeJ/MQyzUQ6Momjgx1OxxoScThpDyJxBFR4bjMtDMkGJThBCAOosK8Jek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NaQp59By; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NaQp59By"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06A7C4CED6;
	Mon, 13 Jan 2025 04:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742227;
	bh=NZZW2XaTTpHi16k4+NLr9D8XOgIyAgNAOhocQkxqDNU=;
	h=Date:To:From:Subject:From;
	b=NaQp59BydyM5M/Pl9suTD53zHbOOPeJ2Xs0xh2Un1YkxoZYBnB25j1cqrEPsWSJSb
	 J5M3CR8tlP/jBrS76uOwQUhN7fbQAmHtXJK6w146M/ibmKMMCXIOJXh6NxIfS3Wv+Z
	 a4Lrs1aFlkbZTu6U3mKeryf4Qv/5SB6PRiytMGDg=
Date: Sun, 12 Jan 2025 20:23:46 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch removed from -mm tree
Message-Id: <20250113042346.E06A7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove ocfs2_start_walk_page_trans() prototype
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: remove ocfs2_start_walk_page_trans() prototype
Date: Thu, 5 Dec 2024 17:16:49 +0000

This function no longer exists.

Link: https://lkml.kernel.org/r/20241205171653.3179945-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/ocfs2/aops.h~ocfs2-remove-ocfs2_start_walk_page_trans-prototype
+++ a/fs/ocfs2/aops.h
@@ -8,11 +8,6 @@
 
 #include <linux/fs.h>
 
-handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
-							 struct page *page,
-							 unsigned from,
-							 unsigned to);
-
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
_

Patches currently in -mm which might be from willy@infradead.org are

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
mm-remove-pagetranstail.patch

