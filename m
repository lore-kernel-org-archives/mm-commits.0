From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-superc-use-a-bigger-nodestr-in-ocfs2_dismount_volume.patch removed from -mm tree
Date: Wed, 25 Sep 2013 12:05:54 -0700
Message-ID: <52433412.8c31DqVfX628vT5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3IYTFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:05:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [merged] fs-ocfs2-superc-use-a-bigger-nodestr-in-ocfs2_dismount_volume.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:05:54 -0700


The patch titled
     Subject: fs/ocfs2/super.c: use a bigger nodestr in ocfs2_dismount_volume
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-superc-use-a-bigger-nodestr-in-ocfs2_dismount_volume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: fs/ocfs2/super.c: use a bigger nodestr in ocfs2_dismount_volume

While printing 32-bit node numbers, an 8-byte string is not enough. 
Increase the size of the string to 12 chars.

This got left out in 49fa8140e48 ("fs/ocfs2/super.c: Use bigger nodestr to
accomodate 32-bit node numbers").

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/super.c~fs-ocfs2-superc-use-a-bigger-nodestr-in-ocfs2_dismount_volume fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-ocfs2-superc-use-a-bigger-nodestr-in-ocfs2_dismount_volume
+++ a/fs/ocfs2/super.c
@@ -1924,7 +1924,7 @@ static void ocfs2_dismount_volume(struct
 {
 	int tmp, hangup_needed = 0;
 	struct ocfs2_super *osb = NULL;
-	char nodestr[8];
+	char nodestr[12];
 
 	trace_ocfs2_dismount_volume(sb);
 
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch
fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits.patch

