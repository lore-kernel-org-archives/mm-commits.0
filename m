From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-allow-for-more-than-one-data-extent-when-creating-xattr.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:23 -0700
Message-ID: <533f084f.nDiAN/eUR+LJrPhU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaDDTaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, tariq.x.saeed@oracle.com

Subject: [merged] ocfs2-allow-for-more-than-one-data-extent-when-creating-xattr.patch removed from -mm tree
To: tariq.x.saeed@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:23 -0700


The patch titled
     Subject: ocfs2: allow for more than one data extent when creating xattr
has been removed from the -mm tree.  Its filename was
     ocfs2-allow-for-more-than-one-data-extent-when-creating-xattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: allow for more than one data extent when creating xattr

Orabug: 18108070

ocfs2_xattr_extend_allocation() hits panic when creating xattr during data
extent alloc phase.  The problem occurs if due to local alloc
fragmentation, clusters are spread over multiple extents.  In this case
ocfs2_add_clusters_in_btree() finds no space to store more than one extent
record and therefore fails returning RESTART_META.  The situation is
anticipated for xattr update case but not xattr create case.  This fix
simply ports that code to create case.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-allow-for-more-than-one-data-extent-when-creating-xattr fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-allow-for-more-than-one-data-extent-when-creating-xattr
+++ a/fs/ocfs2/xattr.c
@@ -3200,8 +3200,15 @@ meta_guess:
 			clusters_add += 1;
 		}
 	} else {
-		meta_add += 1;
 		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
+			struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
+			meta_add += ocfs2_extend_meta_needed(el);
+			credits += ocfs2_calc_extend_credits(inode->i_sb,
+							     el);
+		} else {
+			meta_add += 1;
+		}
 	}
 out:
 	if (clusters_need)
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

origin.patch
ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

