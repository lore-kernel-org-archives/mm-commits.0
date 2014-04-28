From: akpm@linux-foundation.org
Subject: + mm-memblockc-use-pfn_down.patch added to -mm tree
Date: Mon, 28 Apr 2014 14:48:17 -0700
Message-ID: <535ecca1.BNNZbe3qtXsQFDRB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaD1VsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Apr 2014 17:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + mm-memblockc-use-pfn_down.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 14:48:17 -0700


The patch titled
     Subject: mm/memblock.c: use PFN_DOWN
has been added to the -mm tree.  Its filename is
     mm-memblockc-use-pfn_down.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-use-pfn_down.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-use-pfn_down.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/memblock.c: use PFN_DOWN

Replace ((x) >> PAGE_SHIFT) with the pfn macro.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-use-pfn_down mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-use-pfn_down
+++ a/mm/memblock.c
@@ -1342,9 +1342,8 @@ int __init_memblock memblock_search_pfn_
 	if (mid == -1)
 		return -1;
 
-	*start_pfn = type->regions[mid].base >> PAGE_SHIFT;
-	*end_pfn = (type->regions[mid].base + type->regions[mid].size)
-			>> PAGE_SHIFT;
+	*start_pfn = PFN_DOWN(type->regions[mid].base);
+	*end_pfn = PFN_DOWN(type->regions[mid].base + type->regions[mid].size);
 
 	return type->regions[mid].nid;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

