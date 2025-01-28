Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB641F5FA
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738027218; cv=none; b=oSX3LJ98XiesbzL4wnuz5M7KNoXJz8G7BlWsgAbhcixEQn28XHw/uoYc1fi/zW4XJugsD2fdNvWldGxPzQtigBttNAZb0R9VIekguvULUySkfDbKkIslyGUR4Tv7oZmMuwZcwzwTlEaKQFCM3Z5a0Ymakyusyvly66N6M7Cxo/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738027218; c=relaxed/simple;
	bh=CR4rp8LjI3VdPYbHe1NIZJjwCElzqtO87xZkvV3+ZxY=;
	h=Date:To:From:Subject:Message-Id; b=cP9Q5wRUoClbsqykAeJSNiIx7f6juYN8jNZ4VXkca8AEOniYrxLU8yC/Lbh7WHQlHkPeItwwkosofjlrZ4zQU80wYUdcLr0EIm6MnucCyoqzpvjCucjlAjsC7g+sWVvx4bjdN6cSLTh6G0wvacH6hCAALepi0iC7Y+5QTUbLewg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZEo5v2dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZEo5v2dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8FCC4CEE0;
	Tue, 28 Jan 2025 01:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738027218;
	bh=CR4rp8LjI3VdPYbHe1NIZJjwCElzqtO87xZkvV3+ZxY=;
	h=Date:To:From:Subject:From;
	b=ZEo5v2dx4pPWxsqqCIPuMWpL+pSvl6pNSqIhixPTElR772gm4Kr9uU1lu0Zzzd5PO
	 ekDyR+MRbXkDCigZhSZ3RNu898/ZGt9wGrzaKn/PtsO+SJdbo8N/iXjoCMAW5RUaVk
	 j4i7wM99aMo2pfwMpVHpwYZvR01AWUTtCefin3ow=
Date: Mon, 27 Jan 2025 17:20:17 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-make-proactive-compaction-high-watermark-configurable-via-sysctl.patch added to mm-unstable branch
Message-Id: <20250128012017.EF8FCC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: make proactive compaction high watermark configurable via sysctl
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-make-proactive-compaction-high-watermark-configurable-via-sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-make-proactive-compaction-high-watermark-configurable-via-sysctl.patch

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
From: Michal Clapinski <mclapinski@google.com>
Subject: mm/compaction: make proactive compaction high watermark configurable via sysctl
Date: Mon, 27 Jan 2025 22:50:20 +0100

Currently, the difference between the high and low watermarks for
proactive compaction is hardcoded to 10.  This hardcoded difference is too
large for free page reporting to work well.

Add a new sysctl, `compaction_proactiveness_leeway`, to control the
difference between the high and low watermarks.

Link: https://lkml.kernel.org/r/20250127215020.4023545-3-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   17 +++++++++++++++++
 mm/compaction.c                         |   12 +++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-compaction-make-proactive-compaction-high-watermark-configurable-via-sysctl
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -27,6 +27,7 @@ Currently, these files are in /proc/sys/
 - admin_reserve_kbytes
 - compact_memory
 - compaction_proactiveness
+- compaction_proactiveness_leeway
 - compact_unevictable_allowed
 - dirty_background_bytes
 - dirty_background_ratio
@@ -133,6 +134,22 @@ proactive compaction is not being effect
 Be careful when setting it to extreme values like 100, as that may
 cause excessive background compaction activity.
 
+compaction_proactiveness_leeway
+===============================
+
+This tunable controls the difference between high and low watermarks for
+proactive compaction. This tunable takes a value in the range [0, 100] with
+a default value of 10. Higher values will result in proactive compaction
+triggering less often but doing more work when it does trigger.
+
+Proactive compaction triggers when fragmentation score (lower is better) gets
+larger than high watermark. Compaction stops when the score gets smaller or
+equal to low watermark (or when no progress is being made).
+The watermarks are calculated as follows:
+
+low_wmark = 100 - compaction_proactiveness;
+high_wmark = low_wmark + compaction_proactiveness_leeway;
+
 compact_unevictable_allowed
 ===========================
 
--- a/mm/compaction.c~mm-compaction-make-proactive-compaction-high-watermark-configurable-via-sysctl
+++ a/mm/compaction.c
@@ -1924,6 +1924,7 @@ static int sysctl_compact_unevictable_al
  * background. It takes values in the range [0, 100].
  */
 static unsigned int __read_mostly sysctl_compaction_proactiveness = 20;
+static unsigned int __read_mostly sysctl_compaction_proactiveness_leeway = 10;
 static int sysctl_extfrag_threshold = 500;
 static int __read_mostly sysctl_compact_memory;
 
@@ -2257,7 +2258,7 @@ static unsigned int fragmentation_score_
 	 * close to 100 (maximum).
 	 */
 	wmark_low = 100U - sysctl_compaction_proactiveness;
-	return low ? wmark_low : min(wmark_low + 10, 100U);
+	return low ? wmark_low : min(wmark_low + sysctl_compaction_proactiveness_leeway, 100U);
 }
 
 static bool should_proactive_compact_node(pg_data_t *pgdat)
@@ -3308,6 +3309,15 @@ static struct ctl_table vm_compaction[]
 		.mode		= 0644,
 		.proc_handler	= compaction_proactiveness_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
+	{
+		.procname	= "compaction_proactiveness_leeway",
+		.data		= &sysctl_compaction_proactiveness_leeway,
+		.maxlen		= sizeof(sysctl_compaction_proactiveness_leeway),
+		.mode		= 0644,
+		.proc_handler	= compaction_proactiveness_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 	{
_

Patches currently in -mm which might be from mclapinski@google.com are

mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch
mm-compaction-make-proactive-compaction-high-watermark-configurable-via-sysctl.patch

