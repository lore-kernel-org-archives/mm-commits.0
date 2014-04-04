From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:56 -0700
Message-ID: <533f08e8.3syHYpIksZR5E+yd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaDDTc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, simon.kagstrom@netinsight.net

Subject: [merged] include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch removed from -mm tree
To: simon.kagstrom@netinsight.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:56 -0700


The patch titled
     Subject: include/linux/printk.h: remove double asmlinkage in printk_emit
has been removed from the -mm tree.  Its filename was
     include-linux-printkh-remove-double-asmlinkage-in-printk_emit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Simon Kågström <simon.kagstrom@netinsight.net>
Subject: include/linux/printk.h: remove double asmlinkage in printk_emit

The double asmlinkage was introduced in 7ff9554bb578ba0 ("printk: convert
byte-buffer to variable-length record buffer").

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-remove-double-asmlinkage-in-printk_emit include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-remove-double-asmlinkage-in-printk_emit
+++ a/include/linux/printk.h
@@ -120,9 +120,9 @@ asmlinkage __printf(1, 0)
 int vprintk(const char *fmt, va_list args);
 
 asmlinkage __printf(5, 6) __cold
-asmlinkage int printk_emit(int facility, int level,
-			   const char *dict, size_t dictlen,
-			   const char *fmt, ...);
+int printk_emit(int facility, int level,
+		const char *dict, size_t dictlen,
+		const char *fmt, ...);
 
 asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
_

Patches currently in -mm which might be from simon.kagstrom@netinsight.net are

origin.patch
linux-next.patch

