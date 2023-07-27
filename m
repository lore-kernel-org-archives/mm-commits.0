Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839C0EB64DD
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjG0UHx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjG0UHv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ADC1FEC
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 13:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8AD261F2D
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 20:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFBFC433C7;
        Thu, 27 Jul 2023 20:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488461;
        bh=LgeaxtG3kQo8+Y9W5jmgkP347V+RokEdh+QSfzlokzk=;
        h=Date:To:From:Subject:From;
        b=ddrs9dzV+3GN3kUZzSNAao/t19taSkp7utFABjXodlyxNLDwiE/kDvWSJsjVFUnqj
         sXy8qKDF5+znVOwIA0C4uHdrodQh05L55A5aIqGQ7adG8MUH/EwoSuDDycJ3BeoTIW
         qfooPm69cbHJpF3pqFneGT2Cac4wK5I++xgpuo98=
Date:   Thu, 27 Jul 2023 13:07:40 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        mcgrof@kernel.org, brauner@kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch removed from -mm tree
Message-Id: <20230727200741.3EFBFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tmpfs: fix Documentation of noswap and huge mount options
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: fix Documentation of noswap and huge mount options
Date: Sun, 23 Jul 2023 13:55:00 -0700 (PDT)

The noswap mount option is surely not one of the three options for sizing:
move its description down.

The huge= mount option does not accept numeric values: those are just in
an internal enum.  Delete those numbers, and follow the manpage text more
closely (but there's not yet any fadvise() or fcntl() which applies here).

/sys/kernel/mm/transparent_hugepage/shmem_enabled is hard to describe, and
barely relevant to mounting a tmpfs: just refer to transhuge.rst (while
still using the words deny and force, to help as informal reminders).

[rdunlap@infradead.org: fixup Docs table for huge mount options]
  Link: https://lkml.kernel.org/r/20230725052333.26857-1-rdunlap@infradead.org
Link: https://lkml.kernel.org/r/986cb0bf-9780-354-9bb-4bf57aadbab@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: d0f5a85442d1 ("shmem: update documentation")
Fixes: 2c6efe9cf2d7 ("shmem: add support to ignore swap")
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org> 
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.rst |   47 +++++++++++---------------
 1 file changed, 20 insertions(+), 27 deletions(-)

--- a/Documentation/filesystems/tmpfs.rst~tmpfs-fix-documentation-of-noswap-and-huge-mount-options
+++ a/Documentation/filesystems/tmpfs.rst
@@ -84,8 +84,6 @@ nr_inodes  The maximum number of inodes
            is half of the number of your physical RAM pages, or (on a
            machine with highmem) the number of lowmem RAM pages,
            whichever is the lower.
-noswap     Disables swap. Remounts must respect the original settings.
-           By default swap is enabled.
 =========  ============================================================
 
 These parameters accept a suffix k, m or g for kilo, mega and giga and
@@ -99,36 +97,31 @@ mount with such options, since it allows
 use up all the memory on the machine; but enhances the scalability of
 that instance in a system with many CPUs making intensive use of it.
 
+tmpfs blocks may be swapped out, when there is a shortage of memory.
+tmpfs has a mount option to disable its use of swap:
+
+======  ===========================================================
+noswap  Disables swap. Remounts must respect the original settings.
+        By default swap is enabled.
+======  ===========================================================
+
 tmpfs also supports Transparent Huge Pages which requires a kernel
 configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
 your system (has_transparent_hugepage(), which is architecture specific).
 The mount options for this are:
 
-======  ============================================================
-huge=0  never: disables huge pages for the mount
-huge=1  always: enables huge pages for the mount
-huge=2  within_size: only allocate huge pages if the page will be
-        fully within i_size, also respect fadvise()/madvise() hints.
-huge=3  advise: only allocate huge pages if requested with
-        fadvise()/madvise()
-======  ============================================================
-
-There is a sysfs file which you can also use to control system wide THP
-configuration for all tmpfs mounts, the file is:
-
-/sys/kernel/mm/transparent_hugepage/shmem_enabled
-
-This sysfs file is placed on top of THP sysfs directory and so is registered
-by THP code. It is however only used to control all tmpfs mounts with one
-single knob. Since it controls all tmpfs mounts it should only be used either
-for emergency or testing purposes. The values you can set for shmem_enabled are:
-
-==  ============================================================
--1  deny: disables huge on shm_mnt and all mounts, for
-    emergency use
--2  force: enables huge on shm_mnt and all mounts, w/o needing
-    option, for testing
-==  ============================================================
+================ ==============================================================
+huge=never       Do not allocate huge pages.  This is the default.
+huge=always      Attempt to allocate huge page every time a new page is needed.
+huge=within_size Only allocate huge page if it will be fully within i_size.
+                 Also respect madvise(2) hints.
+huge=advise      Only allocate huge page if requested with madvise(2).
+================ ==============================================================
+
+See also Documentation/admin-guide/mm/transhuge.rst, which describes the
+sysfs file /sys/kernel/mm/transparent_hugepage/shmem_enabled: which can
+be used to deny huge pages on all tmpfs mounts in an emergency, or to
+force huge pages on all tmpfs mounts for testing.
 
 tmpfs has a mount option to set the NUMA memory allocation policy for
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
_

Patches currently in -mm which might be from hughd@google.com are

mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock-fix.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
s390-add-pte_free_defer-for-pgtables-sharing-page-fix.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

