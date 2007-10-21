From: akpm@linux-foundation.org
Subject: - reiser4-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:37 -0700
Message-ID: <200710212347.l9LNlbjM000670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbXJUXsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     reiser4-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-kmalloc-memset-conversion-to-kzalloc fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -98,10 +98,9 @@ static inline int alloc_ts(struct tfm_st
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
reiser4.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
