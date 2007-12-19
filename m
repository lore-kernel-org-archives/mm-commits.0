From: akpm@linux-foundation.org
Subject: - iget-stop-isofs-from-using-read_inode-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2007 17:16:38 -0800
Message-ID: <200712190116.lBJ1GcOj031543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbXLSBRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 20:17:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, Valdis.Kletnieks@vt.edu, dhowells@redhat.com, hch@lst.de, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     iget-stop-isofs-from-using-read_inode fix
has been removed from the -mm tree.  Its filename was
     iget-stop-isofs-from-using-read_inode-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: iget-stop-isofs-from-using-read_inode fix
From: Dave Young <hidave.darkstar@gmail.com>

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix fs/isofs/inode.c
--- a/fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix
+++ a/fs/isofs/inode.c
@@ -1414,7 +1414,7 @@ struct inode *isofs_iget(struct super_bl
 		ret = isofs_read_inode(inode);
 		if (ret < 0) {
 			iget_failed(inode);
-			inode = ERR_PTR(ret);
+			return NULL;
 		} else {
 			unlock_new_inode(inode);
 		}
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
pktcdvd-add-kobject_put-when-kobject-register-fails.patch
git-cpufreq.patch
bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
git-wireless.patch
iget-stop-isofs-from-using-read_inode-fix.patch
