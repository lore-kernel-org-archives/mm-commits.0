From: akpm@linux-foundation.org
Subject: [failures] page-owner-tracking-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 06 Apr 2009 21:20:01 -0700
Message-ID: <200904070420.n374K1Xt031868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbZDGEVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 00:21:03 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n374K1mb004616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 6 Apr 2009 21:20:35 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     page-owner-tracking-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     page-owner-tracking-checkpatch-fixes.patch

This patch was dropped because it had testing failures

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
 1 file changed, 5 insertions(+), 5 deletions(-)

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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
nilfs2-segment-buffer.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
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
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

