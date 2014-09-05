From: akpm@linux-foundation.org
Subject: + memfd_test-add-missing-argument-to-printf.patch added to -mm
 tree
Date: Fri, 05 Sep 2014 16:47:15 -0700
Message-ID: <540a4b83.SA/u8csEU77BIWJX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIEXrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 19:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, dh.herrmann@gmail.com, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memfd_test: add missing argument to printf()
has been added to the -mm tree.  Its filename is
     memfd_test-add-missing-argument-to-printf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memfd_test-add-missing-argument-to-printf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memfd_test-add-missing-argument-to-printf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: memfd_test: add missing argument to printf()

Add a missing path argument buf to printf().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/memfd/memfd_test.c~memfd_test-add-missing-argument-to-printf tools/testing/selftests/memfd/memfd_test.c
--- a/tools/testing/selftests/memfd/memfd_test.c~memfd_test-add-missing-argument-to-printf
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -205,7 +205,7 @@ static void mfd_fail_open(int fd, int fl
 	sprintf(buf, "/proc/self/fd/%d", fd);
 	r = open(buf, flags, mode);
 	if (r >= 0) {
-		printf("open(%s) didn't fail as expected\n");
+		printf("open(%s) didn't fail as expected\n", buf);
 		abort();
 	}
 }
_

Patches currently in -mm which might be from bobby.prani@gmail.com are

memfd_test-add-missing-argument-to-printf.patch
memfd_test-make-it-work-on-32-bit-systems.patch
linux-next.patch

