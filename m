From: akpm@linux-foundation.org
Subject: - fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:47 -0700
Message-ID: <200710212347.l9LNllUH000676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57371 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXJUXs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/plugin/inode_ops_rename.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/plugin/inode_ops_rename.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/plugin/inode_ops_rename.c | 28474 -> 28344 (-130 bytes)
 fs/reiser4/plugin/inode_ops_rename.o | 142600 -> 142476 (-124 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/inode_ops_rename.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/reiser4/plugin/inode_ops_rename.c~fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc fs/reiser4/plugin/inode_ops_rename.c
--- a/fs/reiser4/plugin/inode_ops_rename.c~fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/reiser4/plugin/inode_ops_rename.c
@@ -392,16 +392,14 @@ int reiser4_rename_common(struct inode *
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	old_entry = kmalloc(3 * sizeof(*old_entry) + 2 * sizeof(*new_lh) +
+	old_entry = kzalloc(3 * sizeof(*old_entry) + 2 * sizeof(*new_lh) +
 			    sizeof(*dotdot_name) + sizeof(*dataonstack),
 			    reiser4_ctx_gfp_mask_get());
-	if (old_entry == NULL) {
+	if (!old_entry) {
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
 		return RETERR(-ENOMEM);
 	}
-	memset(old_entry, 0, 3 * sizeof(*old_entry) + 2 * sizeof(*new_lh) +
-	       sizeof(*dotdot_name) + sizeof(*dataonstack));
 
 	new_entry = old_entry + 1;
 	dotdot_entry = old_entry + 2;
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
reiser4.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
