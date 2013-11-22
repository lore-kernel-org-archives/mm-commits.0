From: akpm@linux-foundation.org
Subject: [to-be-updated]
 framework-for-version-lvb-remove-some-impossible-checks.patch removed from
 -mm tree
Date: Thu, 21 Nov 2013 16:33:52 -0800
Message-ID: <528ea670.mJaIQ3C0XhSVkly1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab3KVAdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 19:33:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, dan.carpenter@oracle.com

Subject: [to-be-updated] framework-for-version-lvb-remove-some-impossible-checks.patch removed from -mm tree
To: dan.carpenter@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 16:33:52 -0800


The patch titled
     Subject: ocfs2: remove some impossible checks
has been removed from the -mm tree.  Its filename was
     framework-for-version-lvb-remove-some-impossible-checks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: remove some impossible checks

pv_major and pv_minor are unsigned char type so these checks are just
noise.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/ocfs2/stack_user.c~framework-for-version-lvb-remove-some-impossible-checks fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~framework-for-version-lvb-remove-some-impossible-checks
+++ a/fs/ocfs2/stack_user.c
@@ -806,11 +806,7 @@ static int lvb_to_version(char *lvb, str
 		&ocfs2_user_plugin.sp_max_proto;
 
 	memcpy(&pv, lvb, sizeof(struct ocfs2_protocol_version));
-	if ((pv.pv_major == LONG_MIN) || (pv.pv_major == LONG_MAX) ||
-	    (pv.pv_major > (u8)-1) || (pv.pv_major < 1))
-		return -ERANGE;
-	if ((pv.pv_minor == LONG_MIN) || (pv.pv_minor == LONG_MAX) ||
-	    (pv.pv_minor > (u8)-1) || (pv.pv_minor < 0))
+	if (pv.pv_major < 1)
 		return -ERANGE;
 	if ((pv.pv_major != max->pv_major) ||
 	    (pv.pv_minor > max->pv_minor))
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
linux-next.patch

