Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103BB36AF6
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 23:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707522919; cv=none; b=FvMe1XEig5dQL4Q4P9chxxcVeWyI5EXEh9i3l43tXSo8Q+Sw/YityBZC0V0+FIl0krjsa+9o+kBsqYbCpdEf5GBXsCRHwbvZThrQ4rPQ3yoJ4q98i6DH8DcRa/IyCZZOIhwuU18zyxBfKPGOF8eGBpimoKK8ytb8brHqzYGBAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707522919; c=relaxed/simple;
	bh=Wtmsrrnjw+DMQnMIii8PVLD9a33n4kY4+ThkSCVdMks=;
	h=Date:To:From:Subject:Message-Id; b=NloWo204yoHBmwXuIusu7FEbvWKRv5ThHdxJkL+L/qvoHzzfOyP2aMSehDdVq3ewgv0dcffQyWXclTK2mQhYmOj6vzl13hDJ4PatRAjkTeRxOjJY8ivyTTaaLs71IaUCR/P+jfqQZeNdqtqVNRBGsX4iwSlQPgYMRoGqxs+jUwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T/DodqmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T/DodqmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC95C433F1;
	Fri,  9 Feb 2024 23:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707522918;
	bh=Wtmsrrnjw+DMQnMIii8PVLD9a33n4kY4+ThkSCVdMks=;
	h=Date:To:From:Subject:From;
	b=T/DodqmAn7EIheQv4phQQzVpC1QDQam2ZilfLSQZAoXdNdDyGekW7EsDAZ+PdEZI/
	 sS9wOJ3kLdWTJjsHv5cDU9wPS3nI90PjF7kaTSxWxc0T2bloq1g60qqnr1zdGsh6Re
	 mgwAUwvwhfsGBp40tzMIqIGZL/Odg/5gyjkPn1a8=
Date: Fri, 09 Feb 2024 15:55:17 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch added to mm-unstable branch
Message-Id: <20240209235518.7EC95C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix
Date: Fri Feb  9 03:51:53 PM PST 2024

fix it for the dropping of "mm/compaction: optimize >0 order folio
compaction with free page split"

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix
+++ a/mm/compaction.c
@@ -1798,7 +1798,7 @@ static struct folio *compaction_alloc(st
 	dst = list_entry(cc->freepages.next, struct folio, lru);
 	list_del(&dst->lru);
 	cc->nr_freepages--;
-	cc->nr_migratepages -= 1 << order;
+	cc->nr_migratepages -= 1 << folio_order(src);
 
 	return dst;
 }
@@ -1814,7 +1814,7 @@ static void compaction_free(struct folio
 
 	list_add(&dst->lru, &cc->freepages);
 	cc->nr_freepages++;
-	cc->nr_migratepages += 1 << order;
+	cc->nr_migratepages += 1 << folio_order(dst);
 }
 
 /* possible outcome of isolate_migratepages */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

