From: akpm@linux-foundation.org
Subject: + selftests-userfaultfd-fix-compiler-warnings-on-32-bit.patch
 added to -mm tree
Date: Tue, 08 Sep 2015 12:45:05 -0700
Message-ID: <55ef3ac1.DdCbXfywzPmuw4VE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbbIHTpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 15:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, aarcange@redhat.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/userfaultfd: fix compiler warnings on 32-bit
has been added to the -mm tree.  Its filename is
     selftests-userfaultfd-fix-compiler-warnings-on-32-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-userfaultfd-fix-compiler-warnings-on-32-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-userfaultfd-fix-compiler-warnings-on-32-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: selftests/userfaultfd: fix compiler warnings on 32-bit

On 32-bit:

    userfaultfd.c: In function 'locking_thread':
    userfaultfd.c:152: warning: left shift count >= width of type
    userfaultfd.c: In function 'uffd_poll_thread':
    userfaultfd.c:295: warning: cast to pointer from integer of different size
    userfaultfd.c: In function 'uffd_read_thread':
    userfaultfd.c:332: warning: cast to pointer from integer of different size

Fix the shift warning by splitting the shift in two parts, and the
integer/pointer warnigns by adding intermediate casts to "unsigned long".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~selftests-userfaultfd-fix-compiler-warnings-on-32-bit tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-userfaultfd-fix-compiler-warnings-on-32-bit
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -147,7 +147,8 @@ static void *locking_thread(void *arg)
 			if (sizeof(page_nr) > sizeof(rand_nr)) {
 				if (random_r(&rand, &rand_nr))
 					fprintf(stderr, "random_r 2 error\n"), exit(1);
-				page_nr |= ((unsigned long) rand_nr) << 32;
+				page_nr |= (((unsigned long) rand_nr) << 16) <<
+					   16;
 			}
 		} else
 			page_nr += 1;
@@ -290,7 +291,8 @@ static void *uffd_poll_thread(void *arg)
 				msg.event), exit(1);
 		if (msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE)
 			fprintf(stderr, "unexpected write fault\n"), exit(1);
-		offset = (char *)msg.arg.pagefault.address - area_dst;
+		offset = (char *)(unsigned long)msg.arg.pagefault.address -
+			 area_dst;
 		offset &= ~(page_size-1);
 		if (copy_page(offset))
 			userfaults++;
@@ -327,7 +329,8 @@ static void *uffd_read_thread(void *arg)
 		if (bounces & BOUNCE_VERIFY &&
 		    msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE)
 			fprintf(stderr, "unexpected write fault\n"), exit(1);
-		offset = (char *)msg.arg.pagefault.address - area_dst;
+		offset = (char *)(unsigned long)msg.arg.pagefault.address -
+			 area_dst;
 		offset &= ~(page_size-1);
 		if (copy_page(offset))
 			(*this_cpu_userfaults)++;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

selftests-userfaultfd-fix-compiler-warnings-on-32-bit.patch

