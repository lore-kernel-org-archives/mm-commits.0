From: akpm@linux-foundation.org
Subject: - applicomc-fix-apparently-broken-code-in-do_ac_read.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:57 -0700
Message-ID: <200810182318.m9INIvA8029385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYJRXTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, jbarnes@virtuousgeek.org, jirislaby@gmail.com, zrakamar@cs.ubc.ca, mm-commits@vger.kernel.org


The patch titled
     applicom.c: fix apparently-broken code in do_ac_read()
has been removed from the -mm tree.  Its filename was
     applicomc-fix-apparently-broken-code-in-do_ac_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: applicom.c: fix apparently-broken code in do_ac_read()
From: Andrew Morton <akpm@linux-foundation.org>

The code sciblles overa local pointer whereas it appears to be trying to
write to the memory at which that pointer points.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11397

Nobody we know can test this change.

Reported-by: Zvonimir Rakamaric <zrakamar@cs.ubc.ca>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/applicom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/applicom.c~applicomc-fix-apparently-broken-code-in-do_ac_read drivers/char/applicom.c
--- a/drivers/char/applicom.c~applicomc-fix-apparently-broken-code-in-do_ac_read
+++ a/drivers/char/applicom.c
@@ -478,7 +478,7 @@ static int do_ac_read(int IndexCard, cha
 		struct st_ram_io *st_loc, struct mailbox *mailbox)
 {
 	void __iomem *from = apbs[IndexCard].RamIO + RAM_TO_PC;
-	unsigned char *to = (unsigned char *)&mailbox;
+	unsigned char *to = (unsigned char *)mailbox;
 #ifdef DEBUG
 	int c;
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

