From: akpm@linux-foundation.org
Subject: - move-memory_read_from_buffer-from-fsh-to-stringh.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:19:56 -0700
Message-ID: <200807242319.m6ONJueK010290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbYGXXVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, James.Bottomley@hansenpartnership.com, geert@linux-m68k.org, lenb@kernel.org, robert.moore@intel.com, rui.zhang@intel.com, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     move memory_read_from_buffer() from fs.h to string.h
has been removed from the -mm tree.  Its filename was
     move-memory_read_from_buffer-from-fsh-to-stringh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move memory_read_from_buffer() from fs.h to string.h
From: Akinobu Mita <akinobu.mita@gmail.com>

James Bottomley warns that inclusion of linux/fs.h in a low level
driver was always a danger signal.  This patch moves
memory_read_from_buffer() from fs.h to string.h and fixes includes in
existing memory_read_from_buffer() users.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/system.c       |    1 +
 drivers/zorro/zorro-sysfs.c |    1 -
 include/linux/fs.h          |    2 --
 include/linux/string.h      |    3 +++
 4 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/system.c~move-memory_read_from_buffer-from-fsh-to-stringh drivers/acpi/system.c
--- a/drivers/acpi/system.c~move-memory_read_from_buffer-from-fsh-to-stringh
+++ a/drivers/acpi/system.c
@@ -26,6 +26,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/string.h>
 #include <asm/uaccess.h>
 
 #include <acpi/acpi_drivers.h>
diff -puN drivers/zorro/zorro-sysfs.c~move-memory_read_from_buffer-from-fsh-to-stringh drivers/zorro/zorro-sysfs.c
--- a/drivers/zorro/zorro-sysfs.c~move-memory_read_from_buffer-from-fsh-to-stringh
+++ a/drivers/zorro/zorro-sysfs.c
@@ -15,7 +15,6 @@
 #include <linux/zorro.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/fs.h>
 
 #include "zorro.h"
 
diff -puN include/linux/fs.h~move-memory_read_from_buffer-from-fsh-to-stringh include/linux/fs.h
--- a/include/linux/fs.h~move-memory_read_from_buffer-from-fsh-to-stringh
+++ a/include/linux/fs.h
@@ -2006,8 +2006,6 @@ extern void simple_release_fs(struct vfs
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
-			const void *from, size_t available);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
diff -puN include/linux/string.h~move-memory_read_from_buffer-from-fsh-to-stringh include/linux/string.h
--- a/include/linux/string.h~move-memory_read_from_buffer-from-fsh-to-stringh
+++ a/include/linux/string.h
@@ -111,5 +111,8 @@ extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
 
+extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+			const void *from, size_t available);
+
 #endif
 #endif /* _LINUX_STRING_H_ */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

