From: akpm@linux-foundation.org
Subject: - tags-skip-in-filenames.patch removed from -mm tree
Date: Wed, 03 Dec 2008 13:33:25 -0800
Message-ID: <200812032133.mB3LXPUQ032717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950AbYLCVdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 16:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     tags: skip ./ in filenames
has been removed from the -mm tree.  Its filename was
     tags-skip-in-filenames.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tags: skip ./ in filenames
From: Alexey Dobriyan <adobriyan@gmail.com>

This drives size of tags file from 68.9 MB down to 67.7 MB.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~tags-skip-in-filenames Makefile
--- a/Makefile~tags-skip-in-filenames
+++ a/Makefile
@@ -1456,7 +1456,7 @@ define find-sources
 	       -name $1 -print; \
 	  find $(__srctree) $(RCS_FIND_IGNORE) \
 	       \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
-	       -name $1 -print; \
+	       -name $1 -print | sed -e 's#^./##'; \
 	  )
 endef
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
tags-skip-in-filenames.patch
kconfig-add-module_name-shortcut.patch
tags-link-from-config_x-to-config-x-as-well.patch
proc-move-inode-comment-text-file-to-source-file.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
remove-remaining-unwinder-code.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

