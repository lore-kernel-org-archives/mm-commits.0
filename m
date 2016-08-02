From: akpm@linux-foundation.org
Subject: [merged] fs-befs-remove-useless-befs_error.patch removed from -mm tree
Date: Mon, 01 Aug 2016 17:25:29 -0700
Message-ID: <579fe879.NolAUxBymC0ESUn+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbcHBAZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:25:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: remove useless befs_error
has been removed from the -mm tree.  Its filename was
     fs-befs-remove-useless-befs_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c: remove useless befs_error

Remove befs_error since when kmalloc fails there is a generic out of
memory and stack dump.

Link: http://lkml.kernel.org/r/3de4d388d98bbb570462a5eb8e64623e17fb5d74.1464226521.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-remove-useless-befs_error fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-remove-useless-befs_error
+++ a/fs/befs/linuxvfs.c
@@ -524,7 +524,6 @@ befs_utf2nls(struct super_block *sb, con
 
 	*out = result = kmalloc(maxlen, GFP_NOFS);
 	if (!*out) {
-		befs_error(sb, "%s cannot allocate memory", __func__);
 		*out_len = 0;
 		return -ENOMEM;
 	}
@@ -604,7 +603,6 @@ befs_nls2utf(struct super_block *sb, con
 
 	*out = result = kmalloc(maxlen, GFP_NOFS);
 	if (!*out) {
-		befs_error(sb, "%s cannot allocate memory", __func__);
 		*out_len = 0;
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from salah.triki@acm.org are


