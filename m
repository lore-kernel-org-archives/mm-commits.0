From: akpm@linux-foundation.org
Subject: + userfaultfd-remove-kernel-header-include-from-uapi-header.patch added to -mm tree
Date: Tue, 22 Sep 2015 11:43:48 -0700
Message-ID: <5601a164.jHDYcbn5iCoKn4Tc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044AbbIVSnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 14:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.przywara@arm.com, aarcange@redhat.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: remove kernel header include from uapi header
has been added to the -mm tree.  Its filename is
     userfaultfd-remove-kernel-header-include-from-uapi-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-remove-kernel-header-include-from-uapi-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-remove-kernel-header-include-from-uapi-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
