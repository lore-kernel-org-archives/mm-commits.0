Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB7719E7D1
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880588; cv=none; b=YMzsZZbUSGloGo8ZuEvorMwxctrRTlPjjC3VzfVeWupgaDmlF2XyNZ4/BiaD1HllkDrpc4UHDQ5y0MAGQ3PYr3+SBCKPArQXfkyX1Ac/RX+27vY8ZSloenEp6MYZ9LyQnfTwBgIuuc/1r6m0VF9LIuyoQBdz/XVJoifXDmcH3Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880588; c=relaxed/simple;
	bh=BjnglNCMgeuK9IR2ZIlAJ3i3uWGGo5tG6v8qfk1KjGk=;
	h=Date:To:From:Subject:Message-Id; b=CTouJkUX3Xi9zIvFzszrxYRyEusrCnHlsfPAodu1GiR1/2nV86tv2/qs8qkd7WmayZQGK//lAXXhAR5C3fZL5Oeii5XySBoNG1K3aqnbLRL2S4+Qm4IgWhyuIxCl5C9/nCLsBvk8gghnZalOxnFV8rBxt+HDHyTl2tvxE/HFJzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yqP+TDLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yqP+TDLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DC3C4CEF1;
	Fri, 31 Oct 2025 03:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761880588;
	bh=BjnglNCMgeuK9IR2ZIlAJ3i3uWGGo5tG6v8qfk1KjGk=;
	h=Date:To:From:Subject:From;
	b=yqP+TDLOz68lo/Fx6L+BDKTw7PCqw7AsIDEeSCrqcDlD7V7VHzsBtsHmpZFENn+eZ
	 DogtZOoxUgUBcFEMYv/kJgYs77I0/vf3FV5lhVxh4Q+8z1f4wscnMTFu+aRtZSytH2
	 g/csapINaPUeKYvrkPpteUS0B/wNjrPJnbDaHags=
Date: Thu, 30 Oct 2025 20:16:27 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20251031031628.26DC3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes
Date: Thu Oct 30 08:14:21 PM PDT 2025

WARNING: struct ctl_table should normally be const
#24: FILE: lib/sys_info.c:46:
+static int sys_info_write_handler(struct ctl_table *table,

WARNING: struct ctl_table should normally be const
#43: FILE: lib/sys_info.c:65:
+static int sys_info_read_handler(struct ctl_table *table,

total: 0 errors, 2 warnings, 99 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/panic-sys_info-factor-out-read-and-write-handlers.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes
+++ a/lib/sys_info.c
@@ -43,7 +43,7 @@ unsigned long sys_info_parse_param(char
 
 #ifdef CONFIG_SYSCTL
 
-static int sys_info_write_handler(struct ctl_table *table,
+static int sys_info_write_handler(const struct ctl_table *table,
 				  void *buffer, size_t *lenp, loff_t *ppos,
 				  unsigned long *si_bits_global)
 {
@@ -62,7 +62,7 @@ static int sys_info_write_handler(struct
 	return 0;
 }
 
-static int sys_info_read_handler(struct ctl_table *table,
+static int sys_info_read_handler(const struct ctl_table *table,
 				 void *buffer, size_t *lenp, loff_t *ppos,
 				 unsigned long *si_bits_global)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch

