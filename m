From: akpm@linux-foundation.org
Subject: - proc-remove-proc_root-from-drivers-likelyprof.patch removed from -mm tree
Date: Mon, 27 Oct 2008 21:34:51 -0700
Message-ID: <200810280434.m9S4YpJN018488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbYJ1Eex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 00:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: remove proc_root from drivers
has been removed from the -mm tree.  Its filename was
     proc-remove-proc_root-from-drivers-likelyprof.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove proc_root from drivers
From: Alexey Dobriyan <adobriyan@gmail.com>

Remove proc_root export.  Creation and removal works well if parent PDE is
supplied as NULL -- it worked always that way.

So, one useless export removed and consistency added, some drivers created
PDEs with &proc_root as parent but removed them as NULL and so on.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/likely_prof.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/likely_prof.c~proc-remove-proc_root-from-drivers-likelyprof lib/likely_prof.c
--- a/lib/likely_prof.c~proc-remove-proc_root-from-drivers-likelyprof
+++ a/lib/likely_prof.c
@@ -142,8 +142,7 @@ static struct file_operations proc_likel
 static int __init init_likely(void)
 {
 	struct proc_dir_entry *entry =
-		proc_create("likely_prof", 0, &proc_root,
-				&proc_likely_operations);
+		proc_create("likely_prof", 0, NULL, &proc_likely_operations);
 	if (!entry)
 		return 1;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

gitignore-updates.patch
init-do_mounts_mdc-msleep-compile-fix.patch
linux-next.patch
tags-skip-in-filenames.patch
kconfig-add-module_name-shortcut.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
profile-likely-unlikely-macros.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

