Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39881798F;
	Tue, 15 Apr 2025 00:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744678596; cv=none; b=luZICPU91qEXB4w/VkJH0rsx95o1IIa1WhNvUP2ibFZknB64NisvOyk0kKn9ur25kv4Sn0Le5esrI56KKE93yYYbkbgWpYHIA44iUbVF24euvuv1hHVlB1AUJHmo5KBxxOc3F7h7M35yaVvX9HftK6GKJOhPw1Pnh0TE/QjRq4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744678596; c=relaxed/simple;
	bh=/Wc6oQUod1c2d6lmQ9OJETs0bul6yPCDW7rKDnqzlvQ=;
	h=Date:To:From:Subject:Message-Id; b=kve9Gr+TKEQBFScjdmMzn0mQ0hf/o9iAlA4c7rgXObGxY67sGsbeQjnqluRanUOEM8KTBwFaikVmAfTHGlVnHtR9m/+Fo/N8T60H6OLU9/3KAS48pu8OPLYaTFXJPSeP70Yd/i9TU/tg5hWckd988heAxXoWlIJcaFfopB1rO4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SpJ/LxEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SpJ/LxEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D730C4CEE2;
	Tue, 15 Apr 2025 00:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744678595;
	bh=/Wc6oQUod1c2d6lmQ9OJETs0bul6yPCDW7rKDnqzlvQ=;
	h=Date:To:From:Subject:From;
	b=SpJ/LxEZvEAJEztIIdMvCYY9Pc4fGDhWHoiJS5o3GGKhGRXDDJNH2ElqSmxMFZv/6
	 hceQTp3aI0KGEVr5bheNK9r2SL8YLF1TFlOjFKX8IN0oR/IqhYdwb4/n0ic7Es//9/
	 EOu/paeg782Bbm0ESFZIUNwhqKOTYP67dGIx217c=
Date: Mon, 14 Apr 2025 17:56:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20250415005635.0D730C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix panic in failed foilio allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

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
@@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(s
 			if (IS_ERR(wc->w_folios[i])) {
 				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
+				wc->w_folios[i] = NULL;
 				goto out;
 			}
 		}
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are

v2-ocfs2-fix-panic-in-failed-foilio-allocation.patch

