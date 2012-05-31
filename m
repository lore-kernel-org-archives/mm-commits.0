From: akpm@linux-foundation.org
Subject: [merged] pagemaph-fix-warning-about-possibly-used-before-init-var.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:29 -0700
Message-ID: <20120531191329.8A30FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63035 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2EaTNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:32 -0400
Received: by wgbdt11 with SMTP id dt11so76006wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, daniel.vetter@ffwll.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap.h: fix warning about possibly used before init var
has been removed from the -mm tree.  Its filename was
     pagemaph-fix-warning-about-possibly-used-before-init-var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

origin.patch
linux-next.patch
time-dont-inline-export_symbol-functions.patch
locking-add-kern_cont-when-needed-to-self-test.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
rapidio-add-dma-engine-support-for-rio-data-transfers.patch
rapidio-tsi721-add-dma-engine-support.patch

