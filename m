From: akpm@linux-foundation.org
Subject: + xfs-needs-list_sort.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:12:05 -0800
Message-ID: <201003042112.o24LC5o8030096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932330Ab0CDVMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:12:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, aelder@sgi.com, david@fromorbit.com


The patch titled
     xfs: needs LIST_SORT
has been added to the -mm tree.  Its filename is
     xfs-needs-list_sort.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: needs LIST_SORT
From: Randy Dunlap <randy.dunlap@oracle.com>

xfs uses list_sort (library function), so it needs to select it.
Fixes these build errors:
fs/xfs/linux-2.6/xfs_buf.c:1918: undefined reference to `list_sort'
fs/xfs/linux-2.6/xfs_buf.c:1996: undefined reference to `list_sort'
fs/xfs/linux-2.6/xfs_buf.c:1950: undefined reference to `list_sort'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/xfs/Kconfig~xfs-needs-list_sort fs/xfs/Kconfig
--- a/fs/xfs/Kconfig~xfs-needs-list_sort
+++ a/fs/xfs/Kconfig
@@ -2,6 +2,7 @@ config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
 	select EXPORTFS
+	select LIST_SORT
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
i2c-fix-xiic-build-error.patch
xfs-needs-list_sort.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

