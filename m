Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2042192F1;
	Thu,  8 May 2025 06:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686449; cv=none; b=HvMbTy+uo9UiskXVsEqlkfCC3UpF+cyjbtVsbu3H9ufGcYCvy8By/ScK2v29cCdcETrOThAdqljFUSq+So11hleCU9nJB6NZsMecE10Kx7rvFGKNMT6rygpy/zekGe/PQhuQ4MtHvSJEX/tQhFaCxpNJed48KQnqWf/hJ6Mo+Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686449; c=relaxed/simple;
	bh=wCe6ccNBV1utS5m+mi8Pk3sGYFqdlSf4Iq2vDBDKUpQ=;
	h=Date:To:From:Subject:Message-Id; b=UAo39ZfE+6I7g5HJ3puWqiFcH9SHQR18x8/T7tjavVXLW4P7TqJspkXXh2BSN8O9XuTEKgQoyvQzTP1cpuWm4B/haJp5/6hNn2EMU3FRMx629emYunpKJZkQlpggEXjwKXWpOfbwG28qA9F4rJzUyTvEXEmQbyhZzQYfGkqzfzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pdumCHtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pdumCHtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495D0C4CEEB;
	Thu,  8 May 2025 06:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686448;
	bh=wCe6ccNBV1utS5m+mi8Pk3sGYFqdlSf4Iq2vDBDKUpQ=;
	h=Date:To:From:Subject:From;
	b=pdumCHtXK2NDj2ywzz3oAopTuES/q/vcySVkWyxoFchXV79qGOLPJjv2/8tr4jRTi
	 6mglAQz9600qD8ShsMiUznAGFYNu91T6MCacSOUVWET35dBNolL4ixYPY0OTr/b3PK
	 GuEfLQ7dBMqeXGaW4bTbjYljL1hFnb1l/rp+7e/A=
Date: Wed, 07 May 2025 23:40:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,nathan@kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch removed from -mm tree
Message-Id: <20250508064048.495D0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix panic in failed foilio allocation
has been removed from the -mm tree.  Its filename was
     v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: fix panic in failed foilio allocation
Date: Fri, 11 Apr 2025 11:31:24 -0500

commit 7e119cff9d0a ("ocfs2: convert w_pages to w_folios") and commit
9a5e08652dc4b ("ocfs2: use an array of folios instead of an array of
pages") save -ENOMEM in the folio array upon allocation failure and call
the folio array free code.

The folio array free code expects either valid folio pointers or NULL. 
Finding the -ENOMEM will result in a panic.  Fix by NULLing the error
folio entry.

Link: https://lkml.kernel.org/r/c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com
Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
Fixes: 9a5e08652dc4b ("ocfs2: use an array of folios instead of an array of pages")
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/alloc.c~v2-ocfs2-fix-panic-in-failed-foilio-allocation
+++ a/fs/ocfs2/alloc.c
@@ -6918,6 +6918,7 @@ static int ocfs2_grab_folios(struct inod
 		if (IS_ERR(folios[numfolios])) {
 			ret = PTR_ERR(folios[numfolios]);
 			mlog_errno(ret);
+			folios[numfolios] = NULL;
 			goto out;
 		}
 
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


