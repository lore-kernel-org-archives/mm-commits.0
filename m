From: akpm@linux-foundation.org
Subject: + page-owner-tracking-checkpatch-fixes.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:22:48 -0700
Message-ID: <200903312322.n2VNMm0Y006708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764404AbZCaXXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:23:33 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2VNMnUj012959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2009 16:23:30 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     page-owner-tracking-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     page-owner-tracking-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-owner-tracking-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing statements should be on next line
#214: FILE: Documentation/page_owner.c:39:
+		if (*curr == EOF) return -1;
+		if (*curr == EOF) return -1;
ERROR: space required before the open parenthesis '('
#286: FILE: Documentation/page_owner.c:111:
+	for(;;) {

ERROR: spaces required around that '=' (ctx:VxV)
#305: FILE: Documentation/page_owner.c:130:
+	for (i=count=0;i<list_size;i++) {
 	      ^

ERROR: spaces required around that '=' (ctx:VxV)
#305: FILE: Documentation/page_owner.c:130:
+	for (i=count=0;i<list_size;i++) {
 	            ^

ERROR: space required after that ';' (ctx:VxV)
#305: FILE: Documentation/page_owner.c:130:
+	for (i=count=0;i<list_size;i++) {
 	              ^

ERROR: spaces required around that '<' (ctx:VxV)
#305: FILE: Documentation/page_owner.c:130:
+	for (i=count=0;i<list_size;i++) {
 	                ^

ERROR: space required after that ';' (ctx:VxV)
#305: FILE: Documentation/page_owner.c:130:
+	for (i=count=0;i<list_size;i++) {
 	                          ^

ERROR: spaces required around that '=' (ctx:VxV)
#315: FILE: Documentation/page_owner.c:140:
+	for (i=0;i<count;i++) {
 	      ^

ERROR: space required after that ';' (ctx:VxV)
#315: FILE: Documentation/page_owner.c:140:
+	for (i=0;i<count;i++) {
 	        ^

ERROR: spaces required around that '<' (ctx:VxV)
#315: FILE: Documentation/page_owner.c:140:
+	for (i=0;i<count;i++) {
 	          ^

ERROR: space required after that ';' (ctx:VxV)
#315: FILE: Documentation/page_owner.c:140:
+	for (i=0;i<count;i++) {
 	                ^

WARNING: braces {} are not necessary for single statement blocks
#315: FILE: Documentation/page_owner.c:140:
+	for (i=0;i<count;i++) {
+		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
+	}

total: 11 errors, 1 warnings, 380 lines checked

./patches/page-owner-tracking.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |   10 +++++-----
 vmstat.c                   |    0 
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/page_owner.c~page-owner-tracking-checkpatch-fixes Documentation/page_owner.c
--- a/Documentation/page_owner.c~page-owner-tracking-checkpatch-fixes
+++ a/Documentation/page_owner.c
@@ -36,7 +36,8 @@ int read_block(char *buf, FILE *fin)
 
 	for (;;) {
 		*curr = getc(fin);
-		if (*curr == EOF) return -1;
+		if (*curr == EOF)
+			return -1;
 
 		ret++;
 		if (*curr == '\n' && hit == 1)
@@ -108,7 +109,7 @@ int main(int argc, char **argv)
 
 	list = malloc(max_size * sizeof(*list));
 
-	for(;;) {
+	for ( ; ; ) {
 		ret = read_block(buf, fin);
 		if (ret < 0)
 			break;
@@ -127,7 +128,7 @@ int main(int argc, char **argv)
 
 	printf("culling\n");
 
-	for (i=count=0;i<list_size;i++) {
+	for (i = count = 0; i < list_size; i++) {
 		if (count == 0 ||
 		    strcmp(list2[count-1].txt, list[i].txt) != 0)
 			list2[count++] = list[i];
@@ -137,8 +138,7 @@ int main(int argc, char **argv)
 
 	qsort(list2, count, sizeof(list[0]), compare_num);
 
-	for (i=0;i<count;i++) {
+	for (i = 0; i < count; i++)
 		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
-	}
 	return 0;
 }
diff -puN fs/proc/Makefile~page-owner-tracking-checkpatch-fixes fs/proc/Makefile
diff -puN include/linux/mm_types.h~page-owner-tracking-checkpatch-fixes include/linux/mm_types.h
diff -puN lib/Kconfig.debug~page-owner-tracking-checkpatch-fixes lib/Kconfig.debug
diff -puN mm/page_alloc.c~page-owner-tracking-checkpatch-fixes mm/page_alloc.c
diff -puN mm/vmstat.c~page-owner-tracking-checkpatch-fixes mm/vmstat.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page_fault-retry-with-nopage_retry.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage.patch
alpha-convert-u64-to-unsigned-long-long.patch
ubd-stop-defintining-major_nr.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi.patch
rtc-test-before-subtraction-on-unsigned.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo.patch
cirrusfb-fix-clock-doubling.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
simplify-copy_thread-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch

