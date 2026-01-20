Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBE6423179
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 16:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768926926; cv=none; b=HOQ4MY2LrCyI8KeIq4DBnscdBj9Ccv7Q63opuaPuye/6mw6//58CWQAX6l6cGmhgCKkbp9m+v0QyO4CNafGq8DFBcfCVGHsp637JLRCYgAKJlnejRIdj5yuNxZSxzg/vTDxQsIZTfWxYqv2himzkJlID2fFM5wNmodJbtmQp8qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768926926; c=relaxed/simple;
	bh=UxXBh4RyaGK3/EHEEazxeTO6u/KDVbPLb+aB/dOqjjs=;
	h=Date:To:From:Subject:Message-Id; b=mwH4w3cQpqFMsvKfsMRP8//RBz8ITJB3j8Ytjyq2yzP057AzX6otpIf1rPhOfX9nZfvDWlsJRJNrgyQ4SflbHxHEHRWynGdWYRari8olrqp3dfTzdoc7BZQGBTcPbIXo/HFj7szbl6PwkbrpdciVZFslldzY5lia2iQGetGL/2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcFW+8Rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcFW+8Rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56854C16AAE;
	Tue, 20 Jan 2026 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768926926;
	bh=UxXBh4RyaGK3/EHEEazxeTO6u/KDVbPLb+aB/dOqjjs=;
	h=Date:To:From:Subject:From;
	b=LcFW+8RwzfcAzYSOHzedLeCIbT8M2ZxRy/olupBH8tTHcFuVUKBmruNPsSGomQCG8
	 BY34Nh9fr5I58J/dTbiJ2P+4nujctEI0nXBhb05/+y4CLb2Iu35BxRIK5hsjZWu9XK
	 TFQv7uULzTI/cKWN/zBgfhOn19cbt9K6f3SX7QnQ=
Date: Tue, 20 Jan 2026 08:35:25 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc-fix.patch added to mm-unstable branch
Message-Id: <20260120163526.56854C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: mm/balloon_compaction: move internal helpers to balloon_compaction.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: fixup: mm/balloon_compaction: move internal helpers to balloon_compaction.c
Date: Tue, 20 Jan 2026 07:37:39 +0100

Move balloon_page_device() under CONFIG_BALLOON_COMPACTION.

Link: https://lkml.kernel.org/r/27f0adf1-54c1-4d99-8b7f-fd45574e7f41@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601201338.4muFmFHV-lkp@intel.com/
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/balloon_compaction.c~mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc-fix
+++ a/mm/balloon_compaction.c
@@ -17,11 +17,6 @@
  */
 static DEFINE_SPINLOCK(balloon_pages_lock);
 
-static struct balloon_dev_info *balloon_page_device(struct page *page)
-{
-	return (struct balloon_dev_info *)page_private(page);
-}
-
 /*
  * balloon_page_insert - insert a page into the balloon's page list and make
  *			 the page->private assignment accordingly.
@@ -232,6 +227,10 @@ struct page *balloon_page_dequeue(struct
 EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 
 #ifdef CONFIG_BALLOON_COMPACTION
+static struct balloon_dev_info *balloon_page_device(struct page *page)
+{
+	return (struct balloon_dev_info *)page_private(page);
+}
 
 static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch
vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating.patch
vmw_balloon-remove-vmballoon_compaction_init.patch
powerpc-pseries-cmm-remove-cmm_balloon_compaction_init.patch
mm-balloon_compaction-improve-comments-for-warn_on_onceb_dev_info.patch
mm-balloon_compaction-centralize-basic-page-migration-handling.patch
mm-balloon_compaction-centralize-adjust_managed_page_count-handling.patch
vmw_balloon-stop-using-the-balloon_dev_info-lock.patch
mm-balloon_compaction-use-a-device-independent-balloon-list-lock.patch
mm-balloon_compaction-remove-dependency-on-page-lock.patch
mm-balloon_compaction-make-balloon_mops-static.patch
mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh.patch
drivers-virtio-virtio_balloon-stop-using-balloon_page_push-pop.patch
mm-balloon_compaction-remove-balloon_page_push-pop.patch
mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc.patch
mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc.patch
mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc-fix.patch
mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held.patch
mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc.patch
mm-balloon_compaction-remove-extern-from-functions.patch
mm-vmscan-drop-inclusion-of-balloon_compactionh.patch
mm-rename-balloon_compactionch-to-balloonch.patch
mm-kconfig-make-balloon_compaction-depend-on-migration.patch
mm-rename-config_balloon_compaction-to-config_balloon_migration.patch
mm-rename-config_memory_balloon-config_balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon.patch

