Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4282204F7F
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729286631; cv=none; b=iH+H1tr9Fpa+Xo4TmS6dqzAzQrb0j3ZsIGdQiwhp21j6iEHSDAZDo0VX/H4b2LeStiO3+78fj/A2FZ8h1VTAan6ISH50fu/jCgtkpaSNDQ+3RmHT1woUIb2aST8JEAFeARG27bKoaFj0geMJUQMlfdzFKDl1yulKF9ZIcu7+55g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729286631; c=relaxed/simple;
	bh=pPls2VB1rOe29nvZycKiod62GCh8VxQ9L9X4KF89vi4=;
	h=Date:To:From:Subject:Message-Id; b=lsKtmh4UKyGIrA0O8yl9PM+iu43JrFOUH0J394vRpCe4wSPoEHXhoDtDLsLJwUIGGdVtvzPRJVP5kwW+pmyds1sBgK0Q1S3VMwq6gngM86XpMwdLF0+JHBkvpx/GkP1lXIh9ePVW+efjqeED8FtgTFWwWseq95B1sSGNU9F7TLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MHIp72Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MHIp72Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398F0C4CEC3;
	Fri, 18 Oct 2024 21:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729286631;
	bh=pPls2VB1rOe29nvZycKiod62GCh8VxQ9L9X4KF89vi4=;
	h=Date:To:From:Subject:From;
	b=MHIp72XmRZMqJzP9wgCuT6hKMpyRIWB8RHtCIrdhiXiFVmJJJ6NyfS/HMDtFQtdxV
	 TGrYtbfZk09SroEJi8PdtafxVCnz1p4ZGAZHn4/TcUUN3JkU1wCzTr2CSY+df+GVFw
	 /Q52sCxziOF5sE3x+jtki2gWDo02qR/JjMxW/9AM=
Date: Fri, 18 Oct 2024 14:23:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usama.anjum@collabora.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kaixa@kiloview.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-has_isolate_pageblock.patch added to mm-unstable branch
Message-Id: <20241018212351.398F0C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused has_isolate_pageblock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unused-has_isolate_pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-has_isolate_pageblock.patch

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
From: Luoxi Li <kaixa@kiloview.com>
Subject: mm: remove unused has_isolate_pageblock
Date: Fri, 18 Oct 2024 17:22:35 +0800

has_isolate_pageblock() has been unused since commit 55612e80e722 ("mm:
page_alloc: close migratetype race between freeing and stealing")

Remove it.

Link: https://lkml.kernel.org/r/20241018092235.2764859-1-kaixa@kiloview.com
Signed-off-by: Luoxi Li <kaixa@kiloview.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/page-isolation.h~mm-remove-unused-has_isolate_pageblock
+++ a/include/linux/page-isolation.h
@@ -3,10 +3,6 @@
 #define __LINUX_PAGEISOLATION_H
 
 #ifdef CONFIG_MEMORY_ISOLATION
-static inline bool has_isolate_pageblock(struct zone *zone)
-{
-	return zone->nr_isolate_pageblock;
-}
 static inline bool is_migrate_isolate_page(struct page *page)
 {
 	return get_pageblock_migratetype(page) == MIGRATE_ISOLATE;
@@ -16,10 +12,6 @@ static inline bool is_migrate_isolate(in
 	return migratetype == MIGRATE_ISOLATE;
 }
 #else
-static inline bool has_isolate_pageblock(struct zone *zone)
-{
-	return false;
-}
 static inline bool is_migrate_isolate_page(struct page *page)
 {
 	return false;
_

Patches currently in -mm which might be from kaixa@kiloview.com are

mm-remove-unused-has_isolate_pageblock.patch

