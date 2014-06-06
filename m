From: akpm@linux-foundation.org
Subject: [folded-merged]
 sysctl-allow-for-strict-write-position-handling-fix-2.patch removed from
 -mm tree
Date: Fri, 06 Jun 2014 14:07:15 -0700
Message-ID: <53922d83.2dbMCYMeUMLEAWuX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFVHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org, akpm@linux-foundation.org

Subject: [folded-merged] sysctl-allow-for-strict-write-position-handling-fix-2.patch removed from -mm tree
To: akpm@linux-foundation.org,keescook@chromium.org,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:07:15 -0700


The patch titled
     Subject: sysctl-allow-for-strict-write-position-handling-fix-2
has been removed from the -mm tree.  Its filename was
     sysctl-allow-for-strict-write-position-handling-fix-2.patch

This patch was dropped because it was folded into sysctl-allow-for-strict-write-position-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-allow-for-strict-write-position-handling-fix-2

fix build

kernel/sysctl.c: In function 'warn_sysctl_write':
kernel/sysctl.c:1786: error: 'struct task_struct' has no member named 'task_comm'

Cc: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling-fix-2 kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling-fix-2
+++ a/kernel/sysctl.c
@@ -1784,7 +1784,7 @@ static int _proc_do_string(char *data, i
 static void warn_sysctl_write(struct ctl_table *table)
 {
 	pr_warn("%s wrote to %s when file position was not 0!\n",
-		current->task_comm, table->procname);
+		current->comm, table->procname);
 	pr_warn("This will not be supported in the future.\n");
 	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
sysctl-allow-for-strict-write-position-handling.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

