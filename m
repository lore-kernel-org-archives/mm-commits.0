From: akpm@linux-foundation.org
Subject: [merged] fs-pstore-ramc-fix-up-section-annotations.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:21:42 -0800
Message-ID: <20121126222143.16B36100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45525 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2KZWVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:21:44 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so1383026yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:21:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hare@suse.de, cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pstore/ram.c: fix up section annotations
has been removed from the -mm tree.  Its filename was
     fs-pstore-ramc-fix-up-section-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hannes Reinecke <hare@suse.de>
Subject: fs/pstore/ram.c: fix up section annotations

The compiler complained about missing section annotations.  Fix it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/ram.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/pstore/ram.c~fs-pstore-ramc-fix-up-section-annotations fs/pstore/ram.c
--- a/fs/pstore/ram.c~fs-pstore-ramc-fix-up-section-annotations
+++ a/fs/pstore/ram.c
@@ -286,8 +286,9 @@ static void ramoops_free_przs(struct ram
 	kfree(cxt->przs);
 }
 
-static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
-			      phys_addr_t *paddr, size_t dump_mem_sz)
+static int __devinit ramoops_init_przs(struct device *dev,
+				       struct ramoops_context *cxt,
+				       phys_addr_t *paddr, size_t dump_mem_sz)
 {
 	int err = -ENOMEM;
 	int i;
@@ -325,9 +326,10 @@ fail_prz:
 	return err;
 }
 
-static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
-			    struct persistent_ram_zone **prz,
-			    phys_addr_t *paddr, size_t sz, u32 sig)
+static int __devinit ramoops_init_prz(struct device *dev,
+				      struct ramoops_context *cxt,
+				      struct persistent_ram_zone **prz,
+				      phys_addr_t *paddr, size_t sz, u32 sig)
 {
 	if (!sz)
 		return 0;
_

Patches currently in -mm which might be from hare@suse.de are

linux-next.patch

