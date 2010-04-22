From: akpm@linux-foundation.org
Subject: + crc32-major-optimization-checkpatch-fixes.patch added to -mm tree
Date: Thu, 22 Apr 2010 14:09:15 -0700
Message-ID: <201004222109.o3ML9F9t011215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756692Ab0DVVJb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 17:09:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Joakim.Tjernlund@transmode.se


The patch titled
     crc32-major-optimization-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     crc32-major-optimization-checkpatch-fixes.patch

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
Subject: crc32-major-optimization-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited before that close square bracket ']'
#30: FILE: lib/crc32.c:54:
+#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255 ] ^ (crc >> 8)

ERROR: Macros with complex values should be enclosed in parenthesis
#30: FILE: lib/crc32.c:54:
+#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255 ] ^ (crc >> 8)

ERROR: space prohibited before that close square bracket ']'
#31: FILE: lib/crc32.c:55:
+#  define DO_CRC4 crc = tab[3][(crc) & 255 ] ^ \

ERROR: space prohibited before that close square bracket ']'
#32: FILE: lib/crc32.c:56:
+		tab[2][(crc >> 8) & 255 ] ^ \

ERROR: space prohibited before that close square bracket ']'
#33: FILE: lib/crc32.c:57:
+		tab[1][(crc >> 16) & 255 ] ^ \

ERROR: space prohibited before that close square bracket ']'
#34: FILE: lib/crc32.c:58:
+		tab[0][(crc >> 24) & 255 ]

ERROR: Macros with complex values should be enclosed in parenthesis
#37: FILE: lib/crc32.c:60:
+#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)

ERROR: space prohibited before that close square bracket ']'
#38: FILE: lib/crc32.c:61:
+#  define DO_CRC4 crc = tab[0][(crc) & 255 ] ^ \

ERROR: space prohibited before that close square bracket ']'
#39: FILE: lib/crc32.c:62:
+		tab[1][(crc >> 8) & 255 ] ^ \

ERROR: space prohibited before that close square bracket ']'
#40: FILE: lib/crc32.c:63:
+		tab[2][(crc >> 16) & 255 ] ^ \

ERROR: space prohibited before that close square bracket ']'
#41: FILE: lib/crc32.c:64:
+		tab[3][(crc >> 24) & 255 ]

ERROR: space required after that ',' (ctx:VxV)
#145: FILE: lib/gen_crc32table.c:67:
+	int i,j;
 	     ^

total: 12 errors, 0 warnings, 148 lines checked

./patches/crc32-major-optimization.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c          |   18 +++++++++---------
 lib/gen_crc32table.c |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN lib/crc32.c~crc32-major-optimization-checkpatch-fixes lib/crc32.c
--- a/lib/crc32.c~crc32-major-optimization-checkpatch-fixes
+++ a/lib/crc32.c
@@ -51,17 +51,17 @@ static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255 ] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255 ] ^ \
-		tab[2][(crc >> 8) & 255 ] ^ \
-		tab[1][(crc >> 16) & 255 ] ^ \
-		tab[0][(crc >> 24) & 255 ]
+#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
+#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
+		tab[2][(crc >> 8) & 255] ^ \
+		tab[1][(crc >> 16) & 255] ^ \
+		tab[0][(crc >> 24) & 255]
 # else
 #  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255 ] ^ \
-		tab[1][(crc >> 8) & 255 ] ^ \
-		tab[2][(crc >> 16) & 255 ] ^ \
-		tab[3][(crc >> 24) & 255 ]
+#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
+		tab[1][(crc >> 8) & 255] ^ \
+		tab[2][(crc >> 16) & 255] ^ \
+		tab[3][(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
diff -puN lib/gen_crc32table.c~crc32-major-optimization-checkpatch-fixes lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~crc32-major-optimization-checkpatch-fixes
+++ a/lib/gen_crc32table.c
@@ -64,7 +64,7 @@ static void crc32init_be(void)
 
 static void output_table(uint32_t table[4][256], int len, char *trans)
 {
-	int i,j;
+	int i, j;
 
 	for (j = 0 ; j < 4; j++) {
 		printf("{");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51-fix.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
jfs-free-sbi-memory-in-error-path.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
hpet-factor-timer-allocate-from-open-fix.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries-checkpatch-fixes.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

