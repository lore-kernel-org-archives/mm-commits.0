From: akpm@linux-foundation.org
Subject: + lib-vsprintf-optimised-put_dec-function-fix.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:23:37 -0800
Message-ID: <201102242223.p1OMNbZH030273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399Ab1BXWXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mina86@mina86.com


The patch titled
     lib-vsprintf-optimised-put_dec-function-fix
has been added to the -mm tree.  Its filename is
     lib-vsprintf-optimised-put_dec-function-fix.patch

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
Subject: lib-vsprintf-optimised-put_dec-function-fix
From: Andrew Morton <akpm@linux-foundation.org>

fiddle with whitespace

Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimised-put_dec-function-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimised-put_dec-function-fix
+++ a/lib/vsprintf.c
@@ -322,13 +322,13 @@ static noinline_for_stack char *put_dec_
 	 * See <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
 	 */
 
-	q      = (r * 0x199a) >> 16;
+	q = (r * 0x199a) >> 16;
 	*buf++ = (r - 10 * q)  + '0';
 
-	r      = (q * 0xcd) >> 11;
+	r = (q * 0xcd) >> 11;
 	*buf++ = (q - 10 * r)  + '0';
 
-	q      = (r * 0xcd) >> 11;
+	q = (r * 0xcd) >> 11;
 	*buf++ = (r - 10 * q) + '0';
 
 	*buf++ = q + '0';
@@ -348,15 +348,15 @@ static noinline_for_stack char *put_dec_
 	if (q > 9999)
 		return put_dec_full5(buf, q);
 
-	r      = (q * 0x199a) >> 16;
+	r = (q * 0x199a) >> 16;
 	*buf++ = (q - 10 * r)  + '0';
 
 	if (r) {
-		q   = (r * 0xcd) >> 11;
+		q = (r * 0xcd) >> 11;
 		*buf++ = (r - 10 * q)  + '0';
 
 		if (q) {
-			r      = (q * 0xcd) >> 11;
+			r = (q * 0xcd) >> 11;
 			*buf++ = (q - 10 * r)  + '0';
 
 			if (r)
@@ -391,13 +391,13 @@ char *put_dec_full4(char *buf, unsigned 
 {
 	unsigned r;
 
-	r      = (q * 0xcccd) >> 19;
+	r = (q * 0xcccd) >> 19;
 	*buf++ = (q - 10 * r) + '0';
 
-	q      = (r * 0x199a) >> 16;
+	q = (r * 0x199a) >> 16;
 	*buf++ = (r - 10 * q)  + '0';
 
-	r      = (q * 0xcd) >> 11;
+	r = (q * 0xcd) >> 11;
 	*buf++ = (q - 10 * r)  + '0';
 
 	*buf++ = r + '0';
@@ -414,11 +414,11 @@ char *put_dec_8bit(char *buf, unsigned q
 {
 	unsigned r;
 
-	r      = (q * 0xcd) >> 11;
+	r = (q * 0xcd) >> 11;
 	*buf++ = (q - 10 * r) + '0';
 
 	if (r) {
-		q      = (r * 0xd) >> 7;
+		q = (r * 0xd) >> 7;
 		*buf++ = (r - 10 * q)  + '0';
 
 		if (q)
@@ -445,25 +445,25 @@ char *put_dec(char *buf, unsigned long l
 		return buf;
 	}
 
-	d1  = (n >> 16) & 0xFFFF;
-	d2  = (n >> 32) & 0xFFFF;
-	d3  = (n >> 48) & 0xFFFF;
+	d1 = (n >> 16) & 0xFFFF;
+	d2 = (n >> 32) & 0xFFFF;
+	d3 = (n >> 48) & 0xFFFF;
 
-	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+	q  = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
 
-	q   = q / 10000;
+	q  = q / 10000;
 	buf = put_dec_full4(buf, q % 10000);
 
-	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
-	q   = d1 / 10000;
+	d1 = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+	q  = d1 / 10000;
 	buf = put_dec_full4(buf, d1 % 10000);
 
-	d2  = q + 4749 * d3 + 42 * d2;
-	q   = d2 / 10000;
+	d2 = q + 4749 * d3 + 42 * d2;
+	q  = d2 / 10000;
 	buf = put_dec_full4(buf, d2 % 10000);
 
-	d3  = q + 281 * d3;
-	q   = d3 / 10000;
+	d3 = q + 281 * d3;
+	q  = d3 / 10000;
 	buf = put_dec_full4(buf, d3 % 10000);
 
 	buf = put_dec_full4(buf, q);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

