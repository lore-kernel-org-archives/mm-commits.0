From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-one-function-call-less-in-ocfs2_init_slot_info-after-error-detection.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:00 -0700
Message-ID: <552eb710.W6ai4megqTb45MfF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbbDOTIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: one function call less in ocfs2_init_slot_info() after error detection
has been removed from the -mm tree.  Its filename was
     ocfs2-one-function-call-less-in-ocfs2_init_slot_info-after-error-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: ocfs2: one function call less in ocfs2_init_slot_info() after error detection

__ocfs2_free_slot_info() was called by ocfs2_init_slot_info() even if a
call of the kzalloc() function failed.

Return from this implementation directly after corresponding
exception handling.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/slot_map.c~ocfs2-one-function-call-less-in-ocfs2_init_slot_info-after-error-detection fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-one-function-call-less-in-ocfs2_init_slot_info-after-error-detection
+++ a/fs/ocfs2/slot_map.c
@@ -427,7 +427,7 @@ int ocfs2_init_slot_info(struct ocfs2_su
 	if (!si) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		return status;
 	}
 
 	si->si_extended = ocfs2_uses_extended_slot_map(osb);
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

origin.patch
linux-next.patch

