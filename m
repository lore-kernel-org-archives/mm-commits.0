From: akpm@linux-foundation.org
Subject: - ecryptfs-replace-magic-numbers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:10 -0700
Message-ID: <200710162041.l9GKfA4H015765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965256AbXJPU6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: replace magic numbers
has been removed from the -mm tree.  Its filename was
     ecryptfs-replace-magic-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: replace magic numbers
From: Michael Halcrow <mhalcrow@us.ibm.com>

Replace some magic numbers with sizeof() equivalents.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-replace-magic-numbers fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-replace-magic-numbers
+++ a/fs/ecryptfs/crypto.c
@@ -1426,10 +1426,10 @@ static int parse_header_metadata(struct 
 	u32 header_extent_size;
 	u16 num_header_extents_at_front;
 
-	memcpy(&header_extent_size, virt, 4);
+	memcpy(&header_extent_size, virt, sizeof(u32));
 	header_extent_size = be32_to_cpu(header_extent_size);
-	virt += 4;
-	memcpy(&num_header_extents_at_front, virt, 2);
+	virt += sizeof(u32);
+	memcpy(&num_header_extents_at_front, virt, sizeof(u16));
 	num_header_extents_at_front = be16_to_cpu(num_header_extents_at_front);
 	crypt_stat->num_header_extents_at_front =
 		(int)num_header_extents_at_front;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
