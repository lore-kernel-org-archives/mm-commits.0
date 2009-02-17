From: akpm@linux-foundation.org
Subject: [merged] tags-fix-config-symbols-generation.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:08:45 -0800
Message-ID: <200902172008.n1HK8jFi001099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbZBQUJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     tags: fix config symbols generation
has been removed from the -mm tree.  Its filename was
     tags-fix-config-symbols-generation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tags: fix config symbols generation
From: Alexey Dobriyan <adobriyan@gmail.com>

commit 4f628248a578585472e19e4cba2c604643af8c6c aka "kbuild: reintroduce
ALLSOURCE_ARCHS support for tags/cscope" breaks tags generation for
Kconfig symbols.

Steps to reproduce:

	make tags
	vi -t PROC_FS

It should jump to 'config PROC_FS' line.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/tags.sh~tags-fix-config-symbols-generation scripts/tags.sh
--- a/scripts/tags.sh~tags-fix-config-symbols-generation
+++ a/scripts/tags.sh
@@ -76,7 +76,10 @@ all_sources()
 
 all_kconfigs()
 {
-	find_sources $ALLSOURCE_ARCHS 'Kconfig*'
+	for arch in $ALLSOURCE_ARCHS; do
+		find_sources $arch 'Kconfig*'
+	done
+	find_other_sources 'Kconfig*'
 }
 
 all_defconfigs()
_

Patches currently in -mm which might be from adobriyan@gmail.com are

vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread.patch
seq_file-properly-cope-with-pread-fix.patch
linux-next.patch
sm501-fix-section-mismatches.patch
fs-proc-task_mmuc-fix-sparse-warnings.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
eeepc-should-depend-on-input.patch
xtensa-fix-compilation-somewhat.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

