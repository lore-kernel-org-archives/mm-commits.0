Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498F415D5B6
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742229; cv=none; b=h3qOYGR0dJg9iyV/Z8DhKGnuRbDMAMempkiU5EzlgdfzPQc2MjJEjFnFwt8w6ldjoUZsTuatdWDt8UxkvCrMUYhgg9AO5cmcPzSqyK0vBg7ZvQWf3H+G0ExbK6MQwzm6h9um/Joxf96LkFpOvUZrTYWhJuOjnmUEeT5pDvd02fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742229; c=relaxed/simple;
	bh=j1ZUkTBNiaZbo6FzDp1TlynaEJp73bTFbdQLWMe0IRc=;
	h=Date:To:From:Subject:Message-Id; b=ezRrJ2XsYUl1og8Uft4NwAkuLoRb1w7SLlUaOiy+3CymRAHiaHu3SrzAEqaa4iGvxzbObLyLEaP6f5utnIN+4zh3YvEHE02yvWUhb4Qkd6KlTdBu8tvjtS+kwnvRoJM3cdqudoSZVf071wTyGv3E/PgQCtZGYsXXanQuAeLRYKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qH6xd5pZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qH6xd5pZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AE7C4CED6;
	Mon, 13 Jan 2025 04:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742229;
	bh=j1ZUkTBNiaZbo6FzDp1TlynaEJp73bTFbdQLWMe0IRc=;
	h=Date:To:From:Subject:From;
	b=qH6xd5pZ5rSqKN783A8nLyYPGgsRTmmE7aca1EUB8X/CnhDznDzThor2gzLLWF47n
	 r4+X6V/93zEqXrYgH/A5Pt+JjDgK6D81PfN9kyZqENQ5CTN9ag6T//+3DORRRGv3z3
	 XOjYPwhRl0WEqYhhtMpCE5wlYvDvUqC//iDzxF70=
Date: Sun, 12 Jan 2025 20:23:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch removed from -mm tree
Message-Id: <20250113042349.21AE7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: support large folios in ocfs2_write_zero_page()
has been removed from the -mm tree.  Its filename was
     ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: support large folios in ocfs2_write_zero_page()
Date: Thu, 5 Dec 2024 17:16:51 +0000

Remove assumptions that a folio is PAGE_SIZE.

Link: https://lkml.kernel.org/r/20241205171653.3179945-24-willy@infradead.org
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-support-large-folios-in-ocfs2_write_zero_page
+++ a/fs/ocfs2/file.c
@@ -782,11 +782,11 @@ static int ocfs2_write_zero_page(struct
 		goto out_commit_trans;
 	}
 
-	/* Get the offsets within the page that we want to zero */
-	zero_from = abs_from & (PAGE_SIZE - 1);
-	zero_to = abs_to & (PAGE_SIZE - 1);
+	/* Get the offsets within the folio that we want to zero */
+	zero_from = offset_in_folio(folio, abs_from);
+	zero_to = offset_in_folio(folio, abs_to);
 	if (!zero_to)
-		zero_to = PAGE_SIZE;
+		zero_to = folio_size(folio);
 
 	trace_ocfs2_write_zero_page(
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


