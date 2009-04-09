From: akpm@linux-foundation.org
Subject: + gru-support-contexts-with-zero-dsrs-or-cbrs.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:37:34 -0700
Message-ID: <200904092237.n39MbYAo032555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936898AbZDIWjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: support contexts with zero dsrs or cbrs
has been added to the -mm tree.  Its filename is
     gru-support-contexts-with-zero-dsrs-or-cbrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: support contexts with zero dsrs or cbrs
From: Jack Steiner <steiner@sgi.com>

Support alocation of GRU contexts that contain zero DSR or CBR resources. 
Some instructions do not require DSR resources.  Contexts without CBR
resources are useful for diagnostics.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    6 ++----
 drivers/misc/sgi-gru/grumain.c |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~gru-support-contexts-with-zero-dsrs-or-cbrs drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-support-contexts-with-zero-dsrs-or-cbrs
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -135,11 +135,9 @@ static int gru_create_new_context(unsign
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
 		return -EFAULT;
 
-	if (req.data_segment_bytes == 0 ||
-				req.data_segment_bytes > max_user_dsr_bytes)
+	if (req.data_segment_bytes > max_user_dsr_bytes)
 		return -EINVAL;
-	if (!req.control_blocks || !req.maximum_thread_count ||
-				req.control_blocks > max_user_cbrs)
+	if (req.control_blocks > max_user_cbrs || !req.maximum_thread_count)
 		return -EINVAL;
 
 	if (!(req.options & GRU_OPT_MISS_MASK))
diff -puN drivers/misc/sgi-gru/grumain.c~gru-support-contexts-with-zero-dsrs-or-cbrs drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-support-contexts-with-zero-dsrs-or-cbrs
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -150,7 +150,7 @@ static unsigned long reserve_resources(u
 	unsigned long bits = 0;
 	int i;
 
-	do {
+	while (n--) {
 		i = find_first_bit(p, mmax);
 		if (i == mmax)
 			BUG();
@@ -158,7 +158,7 @@ static unsigned long reserve_resources(u
 		__set_bit(i, &bits);
 		if (idx)
 			*idx++ = i;
-	} while (--n);
+	}
 	return bits;
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-update-gru-kernel-self-tests.patch
gru-update-to-rev-09-of-gru-spec.patch

