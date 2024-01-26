Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84275125DB
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255681; cv=none; b=mZWN/mAsvqho+piFHpvCHo9wDdDpBiXv277Bp3or5jQdzwX0jv8rxCf8yJkHUc1rsX0knx+Iyz3nwWDyCD6VuzwcLDyAa0NW2i8hl96bUJgfBbityWBNdcEn6VZA7fE11h+FN5G2qv0l87yesVWWH2BysJL0UM1VzCU3eEMEGyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255681; c=relaxed/simple;
	bh=4w9AlhAebqzuwwF5zQfiFy583+mz1W28zCGbCG/u+Jk=;
	h=Date:To:From:Subject:Message-Id; b=Gta+m30Vs9w4qkwOhrZrZLZ7u74L8uExQ5iDEfVdo6FSSNDxavfdWzU7upZTXi/511NMOIBKNJBdpIwti5nGtY4GWQ/FvgqiioeeatmH0Ajd5H4JtOOXa4+h4/K/PBkLXon4tMMY8C7hdPCQnHviBsRDVSXX/Vwoq0xQZ/tPhDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xgo3oCnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xgo3oCnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A70BC433C7;
	Fri, 26 Jan 2024 07:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255681;
	bh=4w9AlhAebqzuwwF5zQfiFy583+mz1W28zCGbCG/u+Jk=;
	h=Date:To:From:Subject:From;
	b=Xgo3oCnTsrfmev/+Ipgnr8LEr4N2WYPCZIp3vBty2CdLbI45Lz2+s/XTawAxUk6L2
	 KKGGJv7SeZ69ILYiav/zWSM4/wP7hJZlLBPW64d2xrd50q+QPg3ztZMaf3ykuFz/gY
	 L3HVZX05FF8tL8/BTLckgKV3wsSO+iCis1z6scpI=
Date: Thu, 25 Jan 2024 23:54:37 -0800
To: mm-commits@vger.kernel.org,wangjiexun@tinylab.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20240126075440.8A70BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: don't forget to leave lazy MMU mode in madvise_cold_or_pageout_pte_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mm/madvise: don't forget to leave lazy MMU mode in madvise_cold_or_pageout_pte_range()
Date: Fri, 26 Jan 2024 12:25:48 +0900

We need to leave lazy MMU mode before unlocking.

Link: https://lkml.kernel.org/r/20240126032608.355899-1-senozhatsky@chromium.org
Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jiexun Wang <wangjiexun@tinylab.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range
+++ a/mm/madvise.c
@@ -429,6 +429,7 @@ restart:
 		if (++batch_count == SWAP_CLUSTER_MAX) {
 			batch_count = 0;
 			if (need_resched()) {
+				arch_leave_lazy_mmu_mode();
 				pte_unmap_unlock(start_pte, ptl);
 				cond_resched();
 				goto restart;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

mm-madvise-dont-forget-to-leave-lazy-mmu-mode-in-madvise_cold_or_pageout_pte_range.patch

