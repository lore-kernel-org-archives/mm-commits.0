Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B662E11C5
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675495; cv=none; b=nT4cOyYQ6JFMlDm2AgTIwlosq/JunvVaoZ3N9M49PapP0Peq+L4YjBJ0vGvINuT7qUozRy1YZynUT1usgqq1fM58azswXYBaSiocp7qR5Of2U/nrdDtlx7cqY2/NoEaRJYpXIYA1ozp6T7V/v9XBlBrW4rhT0j3tB+0tVu+gBIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675495; c=relaxed/simple;
	bh=TbNrCbClR2zopTaNCZHzdgwfmAWwl1OyrBgqElJ7Fb8=;
	h=Date:To:From:Subject:Message-Id; b=cBh9prcjzOEJODBxRI3Wkpw180R5BTxDEG/ULBqymLyj5IIWQ9QF8PHaw1Jnfpbz9pdJ6bfykbhlp15O/iZ/9/0gQp+hSFx8wBTMKKt2/SdhxbHzsAMdhHUZomXU4HMsUN3EgBsr7pcOzLPvIaeF2d41COxHmdH+0znHiCLYnNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t8mNILjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t8mNILjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE28C4CEF1;
	Thu, 20 Nov 2025 21:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675494;
	bh=TbNrCbClR2zopTaNCZHzdgwfmAWwl1OyrBgqElJ7Fb8=;
	h=Date:To:From:Subject:From;
	b=t8mNILjoS2euzsOvgncvVRFhcX66jvesTm5WFLxCFBsicTcLBl7vRcRERB19waYUs
	 csiVn4vcPiYMNbhq3WltHyM47jiTi1SwOSv+SrgvYgB1gkfpDw4WeWYGKKkb1vmFeT
	 xpfgyYuotQ1BHMX9reGJErqItUmwSkojEA9kVJMQ=
Date: Thu, 20 Nov 2025 13:51:33 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20251120215134.9BE28C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch

This patch was dropped because it was folded into panic-sys_info-factor-out-read-and-write-handlers.patch

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

mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

