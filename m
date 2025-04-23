Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551C664D;
	Wed, 23 Apr 2025 00:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745369288; cv=none; b=gosxILFBHY8vcILP7bYBZL/0M4NYMG05hDvlxQk8AoZQr39YC9dQO5KIYcTkDtvNOZJ5SncDkeQumAYtHFCPIVFT0OirzOEs5k9MrDN85gEplsh71e69OJLZDWHBWhBnLuWBbJnqLeDGzyQoJfGAHXoB1cvRfTRy7BTxnMdWRSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745369288; c=relaxed/simple;
	bh=BnK1KIaa1tX+PTtEEI9PjxDZPvof1chc0PoRdLEcir0=;
	h=Date:To:From:Subject:Message-Id; b=cCDhx+VD16/vKrLFuA0pjbJHnJ9lYbc40UeK2ghWhAhDudIMUZmbXba1uC3VSSfce+gh0mlBZySZpEIsV12nG0vNE/gjOaskyG3u3VsINreJKgm+bFbtBuQ6QWCHAjBcwf2JNhocnDUvQf6D4QXwqU0l0DZ9BOzssVGsdnU46i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UhY5IXLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UhY5IXLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2750C4CEE9;
	Wed, 23 Apr 2025 00:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745369287;
	bh=BnK1KIaa1tX+PTtEEI9PjxDZPvof1chc0PoRdLEcir0=;
	h=Date:To:From:Subject:From;
	b=UhY5IXLg7YCyD3sSm2yD1SisQnMGBVVxwPPfhesiCLmlpU+P7dh7a3v8PEZV6khTW
	 rrzoNTAeRnyivNzx8LKwVi2SQpK3RqjtRVatcDwsY3TbiNcgTFhZJZYoT9rBxIc5yV
	 YX+x70L7Ish1/huA21Gmzdr4I5o7A8etPgkXN/5c=
Date: Tue, 22 Apr 2025 17:48:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch removed from -mm tree
Message-Id: <20250423004807.A2750C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix panic in failed foilio allocation
has been removed from the -mm tree.  Its filename was
     v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: fix panic in failed foilio allocation
Date: Fri, 11 Apr 2025 11:31:24 -0500

In the page to order 0 folio conversion series, commits 7e119cff9d0a
("ocfs2: convert w_pages to w_folios") and 9a5e08652dc4 ("ocfs2: use an
array of folios instead of an array of pages") save -ENOMEM in the folio
array upon allocation failure and call the folio array free code.

The folio array free code expects either valid folio pointers or NULL. 
Finding the -ENOMEM will result in a panic.  Fix by NULLing the error
folio entry.

Link: https://lkml.kernel.org/r/c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com
Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
FIxes: 9a5e08652dc4 ("ocfs2: use an array of folios instead of an array of pages")
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    1 +
 fs/ocfs2/aops.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/ocfs2/alloc.c~v2-ocfs2-fix-panic-in-failed-foilio-allocation
+++ a/fs/ocfs2/alloc.c
@@ -6918,6 +6918,7 @@ static int ocfs2_grab_folios(struct inod
 		if (IS_ERR(folios[numfolios])) {
 			ret = PTR_ERR(folios[numfolios]);
 			mlog_errno(ret);
+			folios[numfolios] = NULL;
 			goto out;
 		}
 
--- a/fs/ocfs2/aops.c~v2-ocfs2-fix-panic-in-failed-foilio-allocation
+++ a/fs/ocfs2/aops.c
@@ -1130,6 +1130,7 @@ static int ocfs2_write_cluster(struct ad
 				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 		if (ret < 0) {
 			mlog_errno(ret);
+			wc->w_folios[i] = NULL;
 			goto out;
 		}
 	} else if (clear_unwritten) {
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are

ocfs2-fix-panic-in-failed-foilio-allocation.patch

