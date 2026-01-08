Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F3126F471
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767898943; cv=none; b=dyjjbiv2rKXLBIIgFZPc+VL1qc8oPmnSimZ0YT4KvANdjwS92zc5ANNiD4N4UcHcEo3rhIv9C/KWMobQz851lupRe1nfY4bcir1E31Ag1uQYEwVZF9mX2hyQO2/Q1oFEIAHJLDISR5pJU9ZwrMTPB9YnNEugmSwVSAHUGFMcknA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767898943; c=relaxed/simple;
	bh=LFfCJawFoq/8chuPEGl5dKyz4lgJdM3SquNbVKbmzeg=;
	h=Date:To:From:Subject:Message-Id; b=L1U4cgAf4DZAssV3pO9tsZtjSLycRFtaBBslgkwaz9kKt66MPSX6/3aiWsfQH6QlE+J73DxV50PVQ9q7nSOOE8s4LWt/ZLhDVaUM8oAubVatXRqd6lDvDv08fNtZCsCfW+m5ZMr3mLDHWbAP5tSABACz/IqLs/52ZM2MBtDKrPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RN4xUnR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RN4xUnR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB3AC116C6;
	Thu,  8 Jan 2026 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767898943;
	bh=LFfCJawFoq/8chuPEGl5dKyz4lgJdM3SquNbVKbmzeg=;
	h=Date:To:From:Subject:From;
	b=RN4xUnR+Y7uCcZo11QfN7B7LgnpSrd+DlRaw2+F4wzo5pg18xiuOnjVdRKrXTDKJh
	 0aA1QcyeHv8qRFq3XfrUTY2pgtNCCLK6gaym3rNswh4nzv4R9OJwHW0UwYckmwseQb
	 zG5brLHBCaIBOvs0kV3Aq1qRRp1Z/IdUAEbyfMRI=
Date: Thu, 08 Jan 2026 11:02:22 -0800
To: mm-commits@vger.kernel.org,jonathan.cameron@huawei.com,akinobu.mita@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch added to mm-new branch
Message-Id: <20260108190223.4BB3AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix
Date: Thu Jan  8 11:01:07 AM PST 2026

include linux/notifier.h, per Jonathan

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_emulation.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/numa_emulation.c~mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix
+++ a/mm/numa_emulation.c
@@ -9,6 +9,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/module.h>
 #include <linux/node.h>
+#include <linux/notifier.h>
 #include <linux/numa_memblks.h>
 #include <asm/numa.h>
 #include <acpi/acpi_numa.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch

