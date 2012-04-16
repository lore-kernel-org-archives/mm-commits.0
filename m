From: akpm@linux-foundation.org
Subject: + pagemaph-fix-warning-about-possibly-used-before-init-var.patch added to -mm tree
Date: Mon, 16 Apr 2012 14:50:58 -0700
Message-ID: <20120416215058.6F869A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57738 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2DPVvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 17:51:00 -0400
Received: by qcsp5 with SMTP id p5so659757qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 14:50:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.gortmaker@windriver.com, daniel.vetter@ffwll.ch


The patch titled
     Subject: pagemap.h: fix warning about possibly used before init var
has been added to the -mm tree.  Its filename is
     pagemaph-fix-warning-about-possibly-used-before-init-var.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: pagemap.h: fix warning about possibly used before init var

Commit f56f821feb7b36223f309e0ec05986bb137ce418 (linux-next)

    "mm: extend prefault helpers to fault in more than PAGE_SIZE"

added in the new functions:

	fault_in_multipages_writeable
	fault_in_multipages_readable

However, we currently see:

  include/linux/pagemap.h:492: warning: 'ret' may be used uninitialized in this function
  include/linux/pagemap.h:492: note: 'ret' was declared here

Unlike a lot of gcc nags, this one appears somewhat legit.  i.e.  passing
in an invalid negative value of "size" does make it look like all the
conditionals in there would be bypassed and the uninitialized value would
be returned.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/pagemap.h~pagemaph-fix-warning-about-possibly-used-before-init-var include/linux/pagemap.h
--- a/include/linux/pagemap.h~pagemaph-fix-warning-about-possibly-used-before-init-var
+++ a/include/linux/pagemap.h
@@ -460,11 +460,11 @@ static inline int fault_in_pages_readabl
  */
 static inline int fault_in_multipages_writeable(char __user *uaddr, int size)
 {
-	int ret;
+	int ret = 0;
 	char __user *end = uaddr + size - 1;
 
 	if (unlikely(size == 0))
-		return 0;
+		return ret;
 
 	/*
 	 * Writing zeroes into userspace here is OK, because we know that if
@@ -489,11 +489,11 @@ static inline int fault_in_multipages_re
 					       int size)
 {
 	volatile char c;
-	int ret;
+	int ret = 0;
 	const char __user *end = uaddr + size - 1;
 
 	if (unlikely(size == 0))
-		return 0;
+		return ret;
 
 	while (uaddr <= end) {
 		ret = __get_user(c, uaddr);
_
Subject: Subject: pagemap.h: fix warning about possibly used before init var

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

linux-next.patch
pagemaph-fix-warning-about-possibly-used-before-init-var.patch
rapidio-add-dma-engine-support-for-rio-data-transfers.patch
rapidio-tsi721-add-dma-engine-support.patch

