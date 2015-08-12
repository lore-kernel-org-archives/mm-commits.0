From: akpm@linux-foundation.org
Subject: + selftests-vm-add-tests-for-lock-on-fault-fix-2.patch added to
 -mm tree
Date: Wed, 12 Aug 2015 16:33:04 -0700
Message-ID: <55cbd7b0.DcEF+WAAYo+Yxnun%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbbHLXdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 19:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, emunson@akamai.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: ensure the mlock2 syscall number can be found
has been added to the -mm tree.  Its filename is
     selftests-vm-add-tests-for-lock-on-fault-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-tests-for-lock-on-fault-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-tests-for-lock-on-fault-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: selftests: vm: ensure the mlock2 syscall number can be found

Include the syscall.h header to ensure that the mlock2 syscall number is
available. Otherwise the test program will always return ENOSYS from the
mlock2() implementation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Eric B Munson <emunson@akamai.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix-2 tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix-2
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <syscall.h>
 #include <errno.h>
 #include <stdbool.h>
 
_

Patches currently in -mm which might be from treding@nvidia.com are

selftests-vm-add-tests-for-lock-on-fault-fix.patch
selftests-vm-add-tests-for-lock-on-fault-fix-2.patch
selftests-vm-add-tests-for-lock-on-fault-fix-3.patch
linux-next.patch

