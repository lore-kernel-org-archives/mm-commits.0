From: akpm@linux-foundation.org
Subject: + kernel-gcov-fsc-use-pr_warn.patch added to -mm tree
Date: Wed, 18 Sep 2013 14:30:34 -0700
Message-ID: <523a1b7a.sG7kOgo0qPMAI6b8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3IRVaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, peter.oberparleiter@de.ibm.com, keescook@chromium.org, jstancek@redhat.com, fhrbata@redhat.com, arnd@arndb.de, agospoda@redhat.com, akpm@linux-foundation.org

Subject: + kernel-gcov-fsc-use-pr_warn.patch added to -mm tree
To: akpm@linux-foundation.org,agospoda@redhat.com,arnd@arndb.de,fhrbata@redhat.com,jstancek@redhat.com,keescook@chromium.org,peter.oberparleiter@de.ibm.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:30:34 -0700


The patch titled
     Subject: kernel/gcov/fs.c: use pr_warn()
has been added to the -mm tree.  Its filename is
     kernel-gcov-fsc-use-pr_warn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-gcov-fsc-use-pr_warn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-gcov-fsc-use-pr_warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/gcov/fs.c: use pr_warn()

pr_warning() is deprecated in favor of pr_warn()

Cc: Andy Gospodarek <agospoda@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~kernel-gcov-fsc-use-pr_warn include/asm-generic/vmlinux.lds.h
diff -puN kernel/module.c~kernel-gcov-fsc-use-pr_warn kernel/module.c
diff -puN kernel/gcov/fs.c~kernel-gcov-fsc-use-pr_warn kernel/gcov/fs.c
--- a/kernel/gcov/fs.c~kernel-gcov-fsc-use-pr_warn
+++ a/kernel/gcov/fs.c
@@ -75,7 +75,7 @@ static int __init gcov_persist_setup(cha
 	unsigned long val;
 
 	if (kstrtoul(str, 0, &val)) {
-		pr_warning("invalid gcov_persist parameter '%s'\n", str);
+		pr_warn("invalid gcov_persist parameter '%s'\n", str);
 		return 0;
 	}
 	gcov_persist = val;
@@ -451,7 +451,7 @@ static struct gcov_node *new_node(struct
 	} else
 		node->dentry = debugfs_create_dir(node->name, parent->dentry);
 	if (!node->dentry) {
-		pr_warning("could not create file\n");
+		pr_warn("could not create file\n");
 		kfree(node);
 		return NULL;
 	}
@@ -464,7 +464,7 @@ static struct gcov_node *new_node(struct
 
 err_nomem:
 	kfree(node);
-	pr_warning("out of memory\n");
+	pr_warn("out of memory\n");
 	return NULL;
 }
 
@@ -631,8 +631,8 @@ static void add_info(struct gcov_node *n
 	 */
 	loaded_info = kcalloc(num + 1, sizeof(struct gcov_info *), GFP_KERNEL);
 	if (!loaded_info) {
-		pr_warning("could not add '%s' (out of memory)\n",
-			   gcov_info_filename(info));
+		pr_warn("could not add '%s' (out of memory)\n",
+			gcov_info_filename(info));
 		return;
 	}
 	memcpy(loaded_info, node->loaded_info,
@@ -645,9 +645,9 @@ static void add_info(struct gcov_node *n
 		 * data set replaces the copy of the last one.
 		 */
 		if (!gcov_info_is_compatible(node->unloaded_info, info)) {
-			pr_warning("discarding saved data for %s "
-				   "(incompatible version)\n",
-				   gcov_info_filename(info));
+			pr_warn("discarding saved data for %s "
+				"(incompatible version)\n",
+				gcov_info_filename(info));
 			gcov_info_free(node->unloaded_info);
 			node->unloaded_info = NULL;
 		}
@@ -657,8 +657,8 @@ static void add_info(struct gcov_node *n
 		 * The initial one takes precedence.
 		 */
 		if (!gcov_info_is_compatible(node->loaded_info[0], info)) {
-			pr_warning("could not add '%s' (incompatible "
-				   "version)\n", gcov_info_filename(info));
+			pr_warn("could not add '%s' (incompatible "
+				"version)\n", gcov_info_filename(info));
 			kfree(loaded_info);
 			return;
 		}
@@ -693,9 +693,9 @@ static void save_info(struct gcov_node *
 	else {
 		node->unloaded_info = gcov_info_dup(info);
 		if (!node->unloaded_info) {
-			pr_warning("could not save data for '%s' "
-				   "(out of memory)\n",
-				   gcov_info_filename(info));
+			pr_warn("could not save data for '%s' "
+				"(out of memory)\n",
+				gcov_info_filename(info));
 		}
 	}
 }
@@ -710,8 +710,8 @@ static void remove_info(struct gcov_node
 
 	i = get_info_index(node, info);
 	if (i < 0) {
-		pr_warning("could not remove '%s' (not found)\n",
-			   gcov_info_filename(info));
+		pr_warn("could not remove '%s' (not found)\n",
+			gcov_info_filename(info));
 		return;
 	}
 	if (gcov_persist)
@@ -750,8 +750,8 @@ void gcov_event(enum gcov_action action,
 		if (node)
 			remove_info(node, info);
 		else {
-			pr_warning("could not remove '%s' (not found)\n",
-				   gcov_info_filename(info));
+			pr_warn("could not remove '%s' (not found)\n",
+				gcov_info_filename(info));
 		}
 		break;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

