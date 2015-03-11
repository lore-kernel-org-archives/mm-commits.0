From: akpm@linux-foundation.org
Subject: [merged]
 staging-rtl8192x-remove-use-of-seq_printf-return-value.patch removed from
 -mm tree
Date: Wed, 11 Mar 2015 12:17:47 -0700
Message-ID: <550094db.Pc+oHJA8ZHVu8KY3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbCKTRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 15:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: rtl8192x: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     staging-rtl8192x-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: rtl8192x: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192e/rtllib_module.c              |    4 +++-
 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/staging/rtl8192e/rtllib_module.c~staging-rtl8192x-remove-use-of-seq_printf-return-value drivers/staging/rtl8192e/rtllib_module.c
--- a/drivers/staging/rtl8192e/rtllib_module.c~staging-rtl8192x-remove-use-of-seq_printf-return-value
+++ a/drivers/staging/rtl8192e/rtllib_module.c
@@ -207,7 +207,9 @@ static struct proc_dir_entry *rtllib_pro
 
 static int show_debug_level(struct seq_file *m, void *v)
 {
-	return seq_printf(m, "0x%08X\n", rtllib_debug_level);
+	seq_printf(m, "0x%08X\n", rtllib_debug_level);
+
+	return 0;
 }
 
 static ssize_t write_debug_level(struct file *file, const char __user *buffer,
diff -puN drivers/staging/rtl8192u/ieee80211/ieee80211_module.c~staging-rtl8192x-remove-use-of-seq_printf-return-value drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c~staging-rtl8192x-remove-use-of-seq_printf-return-value
+++ a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -245,7 +245,9 @@ static struct proc_dir_entry *ieee80211_
 
 static int show_debug_level(struct seq_file *m, void *v)
 {
-	return seq_printf(m, "0x%08X\n", ieee80211_debug_level);
+	seq_printf(m, "0x%08X\n", ieee80211_debug_level);
+
+	return 0;
 }
 
 static ssize_t write_debug_level(struct file *file, const char __user *buffer,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

