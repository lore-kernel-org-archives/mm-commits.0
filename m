From: akpm@linux-foundation.org
Subject: + clear-the-rest-of-the-buffers-on-error.patch added to -mm tree
Date: Tue, 03 Mar 2015 14:07:32 -0800
Message-ID: <54f630a4.qE4Gj7YxB/dtz+k4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbbCCWHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.de, jlbec@evilplan.org, mfasheh@suse.com, rgoldwyn@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clear the rest of the buffers on error
has been added to the -mm tree.  Its filename is
     clear-the-rest-of-the-buffers-on-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clear-the-rest-of-the-buffers-on-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clear-the-rest-of-the-buffers-on-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: clear the rest of the buffers on error

In case a validation fails, clear the rest of the buffers and return the
error to the calling function.

This also facilitates bubbling up the error originating from ocfs2_error
to calling functions.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
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

add-errors=continue.patch
acknowledge-return-value-of-ocfs2_error.patch
clear-the-rest-of-the-buffers-on-error.patch

