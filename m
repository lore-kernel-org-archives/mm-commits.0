From: akpm@linux-foundation.org
Subject: + proc-remove-proc_root-from-drivers-likelyprof.patch added to -mm tree
Date: Tue, 01 Apr 2008 17:47:13 -0700
Message-ID: <200804020047.m320lDB6021896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516AbYDBArQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 20:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: remove proc_root from drivers
has been added to the -mm tree.  Its filename is
     proc-remove-proc_root-from-drivers-likelyprof.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

tags-add-menuconfig-symbols-as-well.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

