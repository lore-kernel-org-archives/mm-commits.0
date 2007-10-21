From: akpm@linux-foundation.org
Subject: - reiser4-fix-for-new-aops-patches.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:09 -0700
Message-ID: <200710212347.l9LNl9vH000643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbXJUXrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix for new aops patches
has been removed from the -mm tree.  Its filename was
     reiser4-fix-for-new-aops-patches.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix for new aops patches
From: Nick Piggin <npiggin@suse.de>

Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |   26 ++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-for-new-aops-patches fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-for-new-aops-patches
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -7,7 +7,6 @@
 
 #include <linux/quotaops.h>
 #include <linux/swap.h>
-#include "../../../../mm/filemap.h"
 
 static inline reiser4_extent *ext_by_offset(const znode *node, int offset)
 {
@@ -937,6 +936,31 @@ static int write_extent_reserve_space(st
 	return reiser4_grab_space(count, 0 /* flags */);
 }
 
+/*
+ * filemap_copy_from_user no longer exists in generic code, because it
+ * is deadlocky (copying from user while holding the page lock is bad).
+ * As a temporary fix for reiser4, just define it here.
+ */
+static inline size_t
+filemap_copy_from_user(struct page *page, unsigned long offset,
+			const char __user *buf, unsigned bytes)
+{
+	char *kaddr;
+	int left;
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	left = __copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	if (left != 0) {
+		/* Do it the slow way */
+		kaddr = kmap(page);
+		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
+		kunmap(page);
+	}
+	return bytes - left;
+}
+
 /**
  * reiser4_write_extent - write method of extent item plugin
  * @file: file to write to
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4.patch
reiser4-fix-for-new-aops-patches.patch
