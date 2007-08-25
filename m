From: akpm@linux-foundation.org
Subject: - kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:43:13 -0700
Message-ID: <200708250343.l7P3hDRa028715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbXHYDnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: reiser4: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.h~kmalloc-memset-conversion-to-kzalloc fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~kmalloc-memset-conversion-to-kzalloc
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -86,10 +86,9 @@ static inline int alloc_ts(struct tfm_st
 	assert("edward-931", stm);
 	assert("edward-932", *stm == NULL);
 
-	*stm = kmalloc(sizeof **stm, reiser4_ctx_gfp_mask_get());
-	if (*stm == NULL)
+	*stm = kzalloc(sizeof(**stm), reiser4_ctx_gfp_mask_get());
+	if (!*stm)
 		return -ENOMEM;
-	memset(*stm, 0, sizeof **stm);
 	return 0;
 }
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
request_irq-fix-debug_shirq-handling-re-2623-rc2-mm1-rtl8139-inconsistent-lock-state.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
git-v9fs.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
