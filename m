From: akpm@linux-foundation.org
Subject: +
 ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:21:21 -0800
Message-ID: <54ebb5f1.VsXwgWi7h5LwNXHC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbBWXVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:21:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: less function calls in ocfs2_convert_inline_data_to_extents() after error detection
has been added to the -mm tree.  Its filename is
     ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-deletion-of-unnecessary-checks-before-three-function-calls.patch
ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch
ocfs2-less-function-calls-in-ocfs2_figure_merge_contig_type-after-error-detection.patch
ocfs2-one-function-call-less-in-ocfs2_merge_rec_left-after-error-detection.patch
ocfs2-one-function-call-less-in-ocfs2_merge_rec_right-after-error-detection.patch
ocfs2-one-function-call-less-in-ocfs2_init_slot_info-after-error-detection.patch
ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch
linux-next.patch

