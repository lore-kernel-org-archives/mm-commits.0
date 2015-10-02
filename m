From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-remove-kernel-header-include-from-uapi-header.patch removed
 from -mm tree
Date: Fri, 02 Oct 2015 12:36:14 -0700
Message-ID: <560edcae.H4jPmBKt2vvsUyKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbJBTgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.przywara@arm.com, aarcange@redhat.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: remove kernel header include from uapi header
has been removed from the -mm tree.  Its filename was
     userfaultfd-remove-kernel-header-include-from-uapi-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andre Przywara <andre.przywara@arm.com>
Subject: userfaultfd: remove kernel header include from uapi header

As include/uapi/linux/userfaultfd.h is a user visible header file, it
should not include kernel-exclusive header files.

So trying to build the userfaultfd test program from the selftests
directory fails, since it contains a reference to linux/compiler.h.  As it
turns out, that header is not really needed there, so we can simply remove
it to fix that issue.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-remove-kernel-header-include-from-uapi-header include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-remove-kernel-header-include-from-uapi-header
+++ a/include/uapi/linux/userfaultfd.h
@@ -11,8 +11,6 @@
 
 #include <linux/types.h>
 
-#include <linux/compiler.h>
