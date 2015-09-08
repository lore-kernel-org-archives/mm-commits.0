From: akpm@linux-foundation.org
Subject: [merged] clear-the-rest-of-the-buffers-on-error.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:02:28 -0700
Message-ID: <55ef22b4.wj0ipEIT88SB9+nQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbbIHSC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.de, jlbec@evilplan.org, mfasheh@suse.de, rgoldwyn@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clear the rest of the buffers on error
has been removed from the -mm tree.  Its filename was
     clear-the-rest-of-the-buffers-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: clear the rest of the buffers on error

In case a validation fails, clear the rest of the buffers and return the
error to the calling function.

This also facilitates bubbling up the error originating from ocfs2_error
to calling functions.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/ocfs2/buffer_head_io.c~clear-the-rest-of-the-buffers-on-error fs/ocfs2/buffer_head_io.c
--- a/fs/ocfs2/buffer_head_io.c~clear-the-rest-of-the-buffers-on-error
+++ a/fs/ocfs2/buffer_head_io.c
@@ -316,6 +316,12 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 		bh = bhs[i];
 
 		if (!(flags & OCFS2_BH_READAHEAD)) {
+			if (status) {
+				/* Clear the rest of the buffers on error */
+				put_bh(bh);
+				bhs[i] = NULL;
+				continue;
+			}
 			/* We know this can't have changed as we hold the
 			 * owner sem. Avoid doing any work on the bh if the
 			 * journal has it. */
_

Patches currently in -mm which might be from rgoldwyn@suse.de are


