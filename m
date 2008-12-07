From: akpm@linux-foundation.org
Subject: - tags-link-from-config_x-to-config-x-as-well.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:00:38 -0800
Message-ID: <200812070000.mB700c4M018444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbYLGAAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:00:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tags: link from CONFIG_x to 'config x' as well
has been removed from the -mm tree.  Its filename was
     tags-link-from-config_x-to-config-x-as-well.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tags: link from CONFIG_x to 'config x' as well
From: Alexey Dobriyan <adobriyan@gmail.com>

Inability to jump from CONFIG_ symbol in source to symbol definition in
Kconfig is very, very annoying. You'll jump to useless entry in autoconf.h,
if it exists at all.

No more.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Makefile~tags-link-from-config_x-to-config-x-as-well Makefile
--- a/Makefile~tags-link-from-config_x-to-config-x-as-well
+++ a/Makefile
@@ -1482,6 +1482,10 @@ define xtags
 		--langdef=kconfig \
 		--language-force=kconfig \
 		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
+	    $(all-kconfigs) | xargs $1 -a \
+		--langdef=kconfig \
+		--language-force=kconfig \
+		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/CONFIG_\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--langdef=dotconfig \
 		--language-force=dotconfig \
@@ -1490,6 +1494,8 @@ define xtags
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
 		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'; \
+	    $(all-kconfigs) | xargs $1 -a \
+		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/CONFIG_\3/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
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

