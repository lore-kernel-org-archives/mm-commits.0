From: akpm@linux-foundation.org
Subject: [merged] perf-fix-read-buffer-overflow.patch removed from -mm tree
Date: Thu, 06 Aug 2009 13:31:34 -0700
Message-ID: <200908062031.n76KVYNQ004881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755792AbZHFUkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 16:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     perf: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     perf-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: perf: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/quote.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/perf/builtin-report.c~perf-fix-read-buffer-overflow tools/perf/builtin-report.c
--- a/tools/perf/builtin-report.c~perf-fix-read-buffer-overflow
+++ a/tools/perf/builtin-report.c
@@ -252,7 +252,7 @@ static int strcommon(const char *pathnam
 {
 	int n = 0;
 
-	while (pathname[n] == cwd[n] && n < cwdlen)
+	while (n < cwdlen && pathname[n] == cwd[n])
 		++n;
 
 	return n;
diff -puN tools/perf/util/quote.c~perf-fix-read-buffer-overflow tools/perf/util/quote.c
--- a/tools/perf/util/quote.c~perf-fix-read-buffer-overflow
+++ a/tools/perf/util/quote.c
@@ -318,7 +318,7 @@ char *quote_path_relative(const char *in
 		strbuf_addch(out, '"');
 	if (prefix) {
 		int off = 0;
-		while (prefix[off] && off < len && prefix[off] == in[off])
+		while (off < len && prefix[off] && prefix[off] == in[off])
 			if (prefix[off] == '/') {
 				prefix += off + 1;
 				in += off + 1;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-fsl-booke-read-buffer-overflow.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
hid-fix-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
kvm-fix-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
slram-read-buffer-overflow-cleanup.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow-fix.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
usb-gadget-read-buffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

