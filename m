Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B2C76C6D
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708450551; cv=none; b=HH7s003wcyhKo4MYmzfGVlwrFRcc0vZmXamcjf0H+9q2GkGdX95zJ7GuL8fTQnANU+ypFjnBRfJOnMA5WF9LBGqSec4nrqeioHMsHprdLu6tOmFSxZcWxCYDzYvWjtzEPi/eKEkgUbLKdj2zED3VbvTL3fqV8fm6XYGnvc7aZ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708450551; c=relaxed/simple;
	bh=QmBkd//x3L90cm72ov1FVQAT35IRDLdTHj2oz4ROTv4=;
	h=Date:To:From:Subject:Message-Id; b=dhYLT6GjORF03DRdKHDPWMgyGRCiCIFc3Qk5epZQCJ2uiCIrefW37OKIHWUyKekKDtLL5XUDynZRbv3Znmx10Gskq0kj6CVRk7/+exmrdBGoPtn3pqaG9qlxdDOEFZEJkXJFP+83QW0xr4hMm44QSNqJ/Y/JfenmP+sY7im14kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uEPy18um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uEPy18um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD8AC433F1;
	Tue, 20 Feb 2024 17:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708450550;
	bh=QmBkd//x3L90cm72ov1FVQAT35IRDLdTHj2oz4ROTv4=;
	h=Date:To:From:Subject:From;
	b=uEPy18umrRZcMsbMz+Vf1oogbWtGRT0oJJweBp0WNR5oDdsDvR6Q+yTb3mJXlrslg
	 5Ttq7k4mg9h/RKuXT9QFU9we/5SuN4bez7CpenFRH72Qn4YtyunEmVHvV3g9VQkYhg
	 cKjvDCcxX+vg86oVdQVU7f4VaDkU/ewW8f5bglfo=
Date: Tue, 20 Feb 2024 09:35:50 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch removed from -mm tree
Message-Id: <20240220173550.CBD8AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch

This patch was dropped because it was folded into mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

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
+	cc->nr_migratepages--;
 
 	return dst;
 }
@@ -1814,7 +1814,7 @@ static void compaction_free(struct folio
 
 	list_add(&dst->lru, &cc->freepages);
 	cc->nr_freepages++;
-	cc->nr_migratepages += 1 << order;
+	cc->nr_migratepages++;
 }
 
 /* possible outcome of isolate_migratepages */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

