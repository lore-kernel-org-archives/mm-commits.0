From: akpm@linux-foundation.org
Subject: - vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:07 -0800
Message-ID: <200801131132.m0DBWlmu009797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbYAMLdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:33:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, rientjes@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     vmcoreinfo: add the array length of "free_list" for filtering free  pages
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmcoreinfo: add the array length of "free_list" for filtering free  pages
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

This patch adds the array length of "free_area.free_list" to the vmcoreinfo
data so that makedumpfile (dump filtering command) can exclude all free pages
in linux-2.6.24.

makedumpfile creates a small dumpfile by excluding unnecessary pages for the
analysis. To distinguish unnecessary pages, makedumpfile gets the vmcoreinfo
data which has the minimum debugging information only for dump filtering.

In 2.6.24-rc1 or later, the free_area.free_list is an array which has one list
for each migrate types instead of a single list. makedumpfile needs the array
length of "free_area.free_list" and the vmcoreinfo data should contain it.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Tested-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kexec.c~vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages kernel/kexec.c
--- a/kernel/kexec.c~vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages
+++ a/kernel/kexec.c
@@ -1404,6 +1404,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(list_head, next);
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
+	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 
 	arch_crash_save_vmcoreinfo();
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

origin.patch
vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch
vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch
vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch
vmcoreinfo-fix-the-configuration-dependencies.patch
vmcoreinfo-fix-the-configuration-dependencies-fix.patch
