From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-unneeded-null-check.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 10:55:31 -0800
Message-ID: <5489e8a3.I6cr5aLxYsgoXfs/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaLKSzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded NULL check
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unneeded-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: remove unneeded NULL check

In 1faf289454b9 ("ocfs2_dlm: disallow a domain join if node maps
mismatch") we introduced a new earlier NULL check so this one is not
needed.  Also static checkers complain because we dereference it first and
then check for NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-null-check fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-null-check
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -877,7 +877,7 @@ static int dlm_query_join_handler(struct
 	 * to be put in someone's domain map.
 	 * Also, explicitly disallow joining at certain troublesome
 	 * times (ie. during recovery). */
-	if (dlm && dlm->dlm_state != DLM_CTXT_LEAVING) {
+	if (dlm->dlm_state != DLM_CTXT_LEAVING) {
 		int bit = query->node_idx;
 		spin_lock(&dlm->spinlock);
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

