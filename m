From: akpm@linux-foundation.org
Subject: - reiser4-fix-freeze-and-corruption.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:05:10 -0800
Message-ID: <200703060205.l2625AEJ008877@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965737AbXCFCFO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:05:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: fix filesystem freeze and corruption
has been removed from the -mm tree.  Its filename was
     reiser4-fix-freeze-and-corruption.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4: fix filesystem freeze and corruption
From: Vladimir Saveliev <vs@namesys.com>

remove_suid may open a transaction in reiser4 which is to be restarted
before entering into main write loop.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-freeze-and-corruption fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-freeze-and-corruption
+++ a/fs/reiser4/plugin/file/file.c
@@ -2170,6 +2170,8 @@ ssize_t write_unix_file(struct file *fil
 		reiser4_exit_context(ctx);
 		return result;
 	}
+	/* remove_suid might create a transaction */
+	reiser4_txn_restart(ctx);
 
 	uf_info = unix_file_inode_data(inode);
 
_

Patches currently in -mm which might be from vs@namesys.com are

reiser4.patch
reiser4-fix-freeze-and-corruption.patch
