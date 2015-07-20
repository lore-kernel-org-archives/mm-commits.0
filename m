From: akpm@linux-foundation.org
Subject: [merged]
 lib-decompress-set-the-compressor-name-to-null-on-error.patch removed from
 -mm tree
Date: Mon, 20 Jul 2015 11:50:41 -0700
Message-ID: <55ad4301.GrT0r68jFFh/HhdS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbbGTSun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 14:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompress: set the compressor name to NULL on error
has been removed from the -mm tree.  Its filename was
     lib-decompress-set-the-compressor-name-to-null-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: lib/decompress: set the compressor name to NULL on error

Without this we end up using the previous name of the compressor in the
loop in unpack_rootfs.  For example we get errors like "compression method
gzip not configured" even when we have CONFIG_DECOMPRESS_GZIP enabled.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN lib/decompress.c~lib-decompress-set-the-compressor-name-to-null-on-error lib/decompress.c
--- a/lib/decompress.c~lib-decompress-set-the-compressor-name-to-null-on-error
+++ a/lib/decompress.c
@@ -59,8 +59,11 @@ decompress_fn __init decompress_method(c
 {
 	const struct compress_format *cf;
 
-	if (len < 2)
+	if (len < 2) {
+		if (name)
+			*name = NULL;
 		return NULL;	/* Need at least this much... */
+	}
 
 	pr_debug("Compressed data magic: %#.2x %#.2x\n", inbuf[0], inbuf[1]);
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

