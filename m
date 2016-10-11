From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch removed
 from -mm tree
Date: Tue, 11 Oct 2016 13:40:35 -0700
Message-ID: <57fd4e43.xmt3Qsb9Fz7yHKwG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbcJKUkg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix
has been removed from the -mm tree.  Its filename was
     fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch

This patch was dropped because it was folded into fs-use-mapping_set_error-instead-of-opencoded-set_bit.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix

Be honest about afs_write_back_from_locked_page()'s conversion from -ENXIO
to -EIO.

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/write.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix fs/afs/write.c
--- a/fs/afs/write.c~fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix
+++ a/fs/afs/write.c
@@ -408,7 +408,7 @@ no_more:
 		case -ENOMEDIUM:
 		case -ENXIO:
 			afs_kill_pages(wb->vnode, true, first, last);
-			mapping_set_error(wb->vnode->vfs_inode.i_mapping, -ENXIO);
+			mapping_set_error(wb->vnode->vfs_inode.i_mapping, -EIO);
 			break;
 		case -EACCES:
 		case -EPERM:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-use-mapping_set_error-instead-of-opencoded-set_bit.patch

