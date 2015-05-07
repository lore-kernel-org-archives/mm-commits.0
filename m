From: akpm@linux-foundation.org
Subject: + tools-vm-fix-page-flags-build.patch added to -mm tree
Date: Thu, 07 May 2015 15:49:22 -0700
Message-ID: <554bebf2.mh0IvAiMBkxdKHHq%akpm__2924.08620375699$1431038981$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbEGWtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2015 18:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm: fix page-flags build
has been added to the -mm tree.  Its filename is
     tools-vm-fix-page-flags-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-fix-page-flags-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-fix-page-flags-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: tools/vm: fix page-flags build

libabikfs.a doesn't exist anymore, so we now need to link with libapi.a.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/Makefile~tools-vm-fix-page-flags-build tools/vm/Makefile
--- a/tools/vm/Makefile~tools-vm-fix-page-flags-build
+++ a/tools/vm/Makefile
@@ -3,7 +3,7 @@
 TARGETS=page-types slabinfo page_owner_sort
 
 LIB_DIR = ../lib/api
-LIBS = $(LIB_DIR)/libapikfs.a
+LIBS = $(LIB_DIR)/libapi.a
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -I../lib/
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
tools-vm-fix-page-flags-build.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
hexdump-make-test-data-really-const.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

