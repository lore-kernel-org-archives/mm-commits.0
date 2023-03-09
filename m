Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD52C64EC4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 23:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjCIXTS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Mar 2023 18:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjCIXTJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2023 18:19:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693FC4BEA1
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 15:18:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CE80B82129
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 23:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F5AC4339B;
        Thu,  9 Mar 2023 23:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678403934;
        bh=KaBIcwswUB2BWUn+xQjb+7ZHq+gXDGrWrtoyofAuwhU=;
        h=Date:To:From:Subject:From;
        b=Y15LvG3ZCPppxDfEm/3kev8iqrfMIk5mzxaqC4+K3/b5conA4p8/s1483HIzv6W4o
         Wcse3r4uP7B4IevoDa/YzRuW06NEf7PGjKdlkSJA2v5YvSdbBfccegxoHF4G+II1Y2
         STDfHsslg5F+BELMtI9xbHqEVdb0utf/F6s8j22s=
Date:   Thu, 09 Mar 2023 15:18:54 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, p.raghav@samsung.com, keescook@chromium.org,
        hughd@google.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, a.manzanares@samsung.com, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-update-documentation.patch added to mm-unstable branch
Message-Id: <20230309231854.A5F5AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: update documentation
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-update-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-update-documentation.patch

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
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: shmem: update documentation
Date: Thu, 9 Mar 2023 15:05:44 -0800

Update the docs to reflect a bit better why some folks prefer tmpfs over
ramfs and clarify a bit more about the difference between brd ramdisks.

While at it, add THP docs for tmpfs, both the mount options and the sysfs
file.

Link: https://lkml.kernel.org/r/20230309230545.2930737-6-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
---


--- a/Documentation/filesystems/tmpfs.rst~shmem-update-documentation
+++ a/Documentation/filesystems/tmpfs.rst
@@ -13,14 +13,25 @@ everything stored therein is lost.
 
 tmpfs puts everything into the kernel internal caches and grows and
 shrinks to accommodate the files it contains and is able to swap
-unneeded pages out to swap space. It has maximum size limits which can
-be adjusted on the fly via 'mount -o remount ...'
+unneeded pages out to swap space, and supports THP.
 
-If you compare it to ramfs (which was the template to create tmpfs)
-you gain swapping and limit checking. Another similar thing is the RAM
-disk (/dev/ram*), which simulates a fixed size hard disk in physical
-RAM, where you have to create an ordinary filesystem on top. Ramdisks
-cannot swap and you do not have the possibility to resize them.
+tmpfs extends ramfs with a few userspace configurable options listed and
+explained further below, some of which can be reconfigured dynamically on the
+fly using a remount ('mount -o remount ...') of the filesystem. A tmpfs
+filesystem can be resized but it cannot be resized to a size below its current
+usage. tmpfs also supports POSIX ACLs, and extended attributes for the
+trusted.* and security.* namespaces. ramfs does not use swap and you cannot
+modify any parameter for a ramfs filesystem. The size limit of a ramfs
+filesystem is how much memory you have available, and so care must be taken if
+used so to not run out of memory.
+
+An alternative to tmpfs and ramfs is to use brd to create RAM disks
+(/dev/ram*), which allows you to simulate a block device disk in physical RAM.
+To write data you would just then need to create an regular filesystem on top
+this ramdisk. As with ramfs, brd ramdisks cannot swap. brd ramdisks are also
+configured in size at initialization and you cannot dynamically resize them.
+Contrary to brd ramdisks, tmpfs has its own filesystem, it does not rely on the
+block layer at all.
 
 Since tmpfs lives completely in the page cache and on swap, all tmpfs
 pages will be shown as "Shmem" in /proc/meminfo and "Shared" in
@@ -85,6 +96,36 @@ mount with such options, since it allows
 use up all the memory on the machine; but enhances the scalability of
 that instance in a system with many CPUs making intensive use of it.
 
+tmpfs also supports Transparent Huge Pages which requires a kernel
+configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
+your system (has_transparent_hugepage(), which is architecture specific).
+The mount options for this are:
+
+======  ============================================================
+huge=0  never: disables huge pages for the mount
+huge=1  always: enables huge pages for the mount
+huge=2  within_size: only allocate huge pages if the page will be
+        fully within i_size, also respect fadvise()/madvise() hints.
+huge=3  advise: only allocate huge pages if requested with
+        fadvise()/madvise()
+======  ============================================================
+
+There is a sysfs file which you can also use to control system wide THP
+configuration for all tmpfs mounts, the file is:
+
+/sys/kernel/mm/transparent_hugepage/shmem_enabled
+
+This sysfs file is placed on top of THP sysfs directory and so is registered
+by THP code. It is however only used to control all tmpfs mounts with one
+single knob. Since it controls all tmpfs mounts it should only be used either
+for emergency or testing purposes. The values you can set for shmem_enabled are:
+
+==  ============================================================
+-1  deny: disables huge on shm_mnt and all mounts, for
+    emergency use
+-2  force: enables huge on shm_mnt and all mounts, w/o needing
+    option, for testing
+==  ============================================================
 
 tmpfs has a mount option to set the NUMA memory allocation policy for
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
_

Patches currently in -mm which might be from mcgrof@kernel.org are

shmem-remove-check-for-folio-lock-on-writepage.patch
shmem-set-shmem_writepage-variables-early.patch
shmem-move-reclaim-check-early-on-writepages.patch
shmem-skip-page-split-if-were-not-reclaiming.patch
shmem-update-documentation.patch
shmem-add-support-to-ignore-swap.patch

