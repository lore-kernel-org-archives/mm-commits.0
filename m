Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A9CC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjGXQnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjGXQnY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A730EE53
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FBBA6126C
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD4CC433C7;
        Mon, 24 Jul 2023 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690217002;
        bh=7HIP9Ot/a1EzTE/5NMWxh18Z+g7jUpg2h8l5bD3e4EE=;
        h=Date:To:From:Subject:From;
        b=mBmdVsnva5Fm6jS9QbdeZUSeVX+2L2OrTvjwu2lyzJgk9dsd4BKL4IcF03lW2zu+i
         4Fio2g92BtSep4ySEsXavOtZMoCnt+nDBtUbvxVd0JWaql+rQH2fYGGgFYa3yHRySG
         3JW7vgMnjJe+lpC5BaxIA1Abnf73lxZE04w3U4AM=
Date:   Mon, 24 Jul 2023 09:43:21 -0700
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org, brauner@kernel.org,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch added to mm-hotfixes-unstable branch
Message-Id: <20230724164322.7AD4CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fix Documentation of noswap and huge mount options
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Link: https://lkml.kernel.org/r/986cb0bf-9780-354-9bb-4bf57aadbab@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Fixes: d0f5a85442d1 ("shmem: update documentation")
Fixes: 2c6efe9cf2d7 ("shmem: add support to ignore swap")
Cc: Christian Brauner <brauner@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
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
+===========  ==============================================================
+huge=never   Do not allocate huge pages.  This is the default.
+huge=always  Attempt to allocate huge page every time a new page is needed.
+huge=within_size Only allocate huge page if it will be fully within i_size.
+             Also respect madvise(2) hints.
+huge=advise  Only allocate huge page if requested with madvise(2).
+===========  ==============================================================
+
+See also Documentation/admin-guide/mm/transhuge.rst, which describes the
+sysfs file /sys/kernel/mm/transparent_hugepage/shmem_enabled: which can
+be used to deny huge pages on all tmpfs mounts in an emergency, or to
+force huge pages on all tmpfs mounts for testing.
 
 tmpfs has a mount option to set the NUMA memory allocation policy for
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch
shmem-minor-fixes-to-splice-read-implementation.patch
mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

