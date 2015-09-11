From: akpm@linux-foundation.org
Subject: [folded-merged]
 selftests-vm-add-tests-for-lock-on-fault-fix-3.patch removed from -mm tree
Date: Fri, 11 Sep 2015 15:00:33 -0700
Message-ID: <55f34f01.QmabtSNr/iRm+4qX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbbIKWAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, emunson@akamai.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: use the right arguments for main()
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-tests-for-lock-on-fault-fix-3.patch

This patch was dropped because it was folded into selftests-vm-add-tests-for-lock-on-fault.patch

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
Cc: Eric B Munson <emunson@akamai.com>
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

userfaultfd-selftest-fix.patch
selftests-vm-add-tests-for-lock-on-fault.patch

