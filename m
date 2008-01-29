From: akpm@linux-foundation.org
Subject: - ps3-checkpatch-drivers-ps3-ps3-vuartc.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:31 -0800
Message-ID: <200801290150.m0T1oVUO027574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbYA2B50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:57:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mm-commits@vger.kernel.org


The patch titled
     ps3: checkpatch drivers/ps3/ps3-vuart.c
has been removed from the -mm tree.  Its filename was
     ps3-checkpatch-drivers-ps3-ps3-vuartc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ps3: checkpatch drivers/ps3/ps3-vuart.c
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3-vuart.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/ps3/ps3-vuart.c~ps3-checkpatch-drivers-ps3-ps3-vuartc drivers/ps3/ps3-vuart.c
--- a/drivers/ps3/ps3-vuart.c~ps3-checkpatch-drivers-ps3-ps3-vuartc
+++ a/drivers/ps3/ps3-vuart.c
@@ -108,18 +108,18 @@ static struct ps3_vuart_port_priv *to_po
 struct ports_bmp {
 	u64 status;
 	u64 unused[3];
-} __attribute__ ((aligned (32)));
+} __attribute__((aligned(32)));
 
 #define dump_ports_bmp(_b) _dump_ports_bmp(_b, __func__, __LINE__)
 static void __maybe_unused _dump_ports_bmp(
-	const struct ports_bmp* bmp, const char* func, int line)
+	const struct ports_bmp *bmp, const char *func, int line)
 {
 	pr_debug("%s:%d: ports_bmp: %016lxh\n", func, line, bmp->status);
 }
 
 #define dump_port_params(_b) _dump_port_params(_b, __func__, __LINE__)
 static void __maybe_unused _dump_port_params(unsigned int port_number,
-	const char* func, int line)
+	const char *func, int line)
 {
 #if defined(DEBUG)
 	static const char *strings[] = {
@@ -363,7 +363,7 @@ int ps3_vuart_disable_interrupt_disconne
  */
 
 static int ps3_vuart_raw_write(struct ps3_system_bus_device *dev,
-	const void* buf, unsigned int bytes, unsigned long *bytes_written)
+	const void *buf, unsigned int bytes, unsigned long *bytes_written)
 {
 	int result;
 	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
@@ -431,7 +431,7 @@ void ps3_vuart_clear_rx_bytes(struct ps3
 	int result;
 	struct ps3_vuart_port_priv *priv = to_port_priv(dev);
 	u64 bytes_waiting;
-	void* tmp;
+	void *tmp;
 
 	result = ps3_vuart_get_rx_bytes_waiting(dev, &bytes_waiting);
 
@@ -526,9 +526,8 @@ int ps3_vuart_write(struct ps3_system_bu
 
 	lb = kmalloc(sizeof(struct list_buffer) + bytes, GFP_KERNEL);
 
-	if (!lb) {
+	if (!lb)
 		return -ENOMEM;
-	}
 
 	memcpy(lb->data, buf, bytes);
 	lb->head = lb->data;
@@ -926,9 +925,8 @@ static int ps3_vuart_bus_interrupt_get(v
 
 	BUG_ON(vuart_bus_priv.use_count > 2);
 
-	if (vuart_bus_priv.use_count != 1) {
+	if (vuart_bus_priv.use_count != 1)
 		return 0;
-	}
 
 	BUG_ON(vuart_bus_priv.bmp);
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-kbuild.patch
git-x86.patch
ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
ps3-use-symbolic-names-for-video-modes.patch
ps3fb-kill-ps3fb_full_mode_bit.patch
ps3fb-inline-macros-that-are-used-only-once.patch
ps3fb-kill-ps3fb_res.patch
ps3fb-make-frame-buffer-offsets-unsigned-int.patch
ps3fb-add-support-for-configurable-black-borders.patch
ps3fb-reorganize-modedb-handling.patch
ps3fb-round-up-video-modes.patch
ps3fb-cleanup-sweep.patch
ps3fb-fix-modedb-typos.patch
