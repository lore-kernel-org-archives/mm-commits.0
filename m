From: akpm@linux-foundation.org
Subject: + selftests-vm-add-tests-for-lock-on-fault-fix-3.patch added to
 -mm tree
Date: Wed, 12 Aug 2015 16:33:38 -0700
Message-ID: <55cbd7d2.pvwiBPUdjNtbV6yj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbHLXdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 19:33:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, emunson@akamai.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: use the right arguments for main()
has been added to the -mm tree.  Its filename is
     selftests-vm-add-tests-for-lock-on-fault-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-tests-for-lock-on-fault-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-tests-for-lock-on-fault-fix-3.patch

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
Subject: selftests: vm: use the right arguments for main()

The prototype for the main() function is:

	int main(int argc, char **argv);

but the mlock2-tests test program lists the arguments in the wrong
order. It gets away with this because the arguments are never used. Fix
it nevertheless to keep recent versions of GCC from complaining.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Eric B Munson <emunson@akamai.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix-3 tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix-3
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -643,7 +643,7 @@ static int test_mlockall(int (test_funct
 	return ret;
 }
 
-int main(char **argv, int argc)
+int main(int argc, char **argv)
 {
 	int ret = 0;
 	ret += test_mlock_lock();
_

Patches currently in -mm which might be from treding@nvidia.com are

selftests-vm-add-tests-for-lock-on-fault-fix.patch
selftests-vm-add-tests-for-lock-on-fault-fix-2.patch
selftests-vm-add-tests-for-lock-on-fault-fix-3.patch
linux-next.patch

