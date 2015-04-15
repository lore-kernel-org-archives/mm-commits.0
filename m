From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:07:52 -0700
Message-ID: <552eb708.6RXyH7isTUbSfzQh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbbDOTHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: less function calls in ocfs2_convert_inline_data_to_extents() after error detection
has been removed from the -mm tree.  Its filename was
     ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: ocfs2: less function calls in ocfs2_convert_inline_data_to_extents() after error detection

kfree() was called in a few cases by
ocfs2_convert_inline_data_to_extents() during error handling even if the
passed variable "pages" contained a null pointer.

* Return from this implementation directly after failure detection for
  the function call "kcalloc".

* Corresponding details could be improved by the introduction of another
  jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection
+++ a/fs/ocfs2/alloc.c
@@ -6853,13 +6853,13 @@ int ocfs2_convert_inline_data_to_extents
 		if (pages == NULL) {
 			ret = -ENOMEM;
 			mlog_errno(ret);
-			goto out;
+			return ret;
 		}
 
 		ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto free_pages;
 		}
 	}
 
@@ -6991,6 +6991,7 @@ out_commit:
 out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
+free_pages:
 	kfree(pages);
 	return ret;
 }
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

origin.patch
linux-next.patch

