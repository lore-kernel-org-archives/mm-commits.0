Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C72156F53;
	Mon, 13 Jan 2025 04:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742204; cv=none; b=WewAVa8M+OxN+JTImrwR/JszCmXK2LQGmri7miUc2KgD36wh14pT4dWn8ezGGqxzxAuQpiSaIzJf4uzzKs6a/81PUBxOTdxPGl0+co5ighqMHUACF/20AP532P2Fu+JrAD12JknFyPuRH6GP2XYFYB3UKOemWA/gGsbH2I4B53Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742204; c=relaxed/simple;
	bh=NgueuWBQacS1tChhi5qBiVeEnYq8VYhERXD3ULCHYb0=;
	h=Date:To:From:Subject:Message-Id; b=jn7h8ZKgu32V8eDek1oljJqNlxxajbySl2RxiSvPRG/cblRgMEazjpdyFgL9iMZPY7N3OAuAij3WIHVelhAtETkZI5z2ke4wpYoHmXNhMmCcNVhMG+ViRRzKbGq8l5sXKi4AsdAR1tSrq/EXhc31UDPfe7Q0TU3u6n3BO+nxRhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yTU8M+vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yTU8M+vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABD8C4CED6;
	Mon, 13 Jan 2025 04:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742204;
	bh=NgueuWBQacS1tChhi5qBiVeEnYq8VYhERXD3ULCHYb0=;
	h=Date:To:From:Subject:From;
	b=yTU8M+vtdF7bnMgONE68B6tc6hCBvDnz0/Aj1PH6SLyk7XS8L7sm4wNaOABtSV0Qu
	 ZIu2HMpHATP3gf3AXZjFbZ7Ns/+7UNmsstubTUvW1zrsnsKo3/iN3I4Hh2DFiRW5wj
	 GwpHXYH6HtniXKj55M9j+oNmR/dAcjVFyCV+bl38=
Date: Sun, 12 Jan 2025 20:23:23 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-handle-a-symlink-read-error-correctly.patch removed from -mm tree
Message-Id: <20250113042324.6ABD8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: handle a symlink read error correctly
has been removed from the -mm tree.  Its filename was
     ocfs2-handle-a-symlink-read-error-correctly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

