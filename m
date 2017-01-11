From: akpm@linux-foundation.org
Subject: [merged] lib-kconfigdebug-fix-frv-build-failure.patch removed
 from -mm tree
Date: Wed, 11 Jan 2017 14:28:06 -0800
Message-ID: <5876b176.ZvsMRWawc0x8VC+p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933559AbdAKW2h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, ak@linux.intel.com, dhowells@redhat.com, fengguang.wu@intel.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: fix frv build failure
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-fix-frv-build-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: lib/Kconfig.debug: fix frv build failure

The build of frv allmodconfig was failing with the errors like:
/tmp/cc0JSPc3.s: Assembler messages:
/tmp/cc0JSPc3.s:1839: Error: symbol `.LSLT0' is already defined
/tmp/cc0JSPc3.s:1842: Error: symbol `.LASLTP0' is already defined
/tmp/cc0JSPc3.s:1969: Error: symbol `.LELTP0' is already defined
/tmp/cc0JSPc3.s:1970: Error: symbol `.LELT0' is already defined

Commit: 866ced950bcd ("kbuild: Support split debug info v4") introduced
splitting the debug info and keeping that in a separate file.
Somehow, the frv-linux gcc did not like that and I am guessing that
instead of splitting it started copying. The first report about this
is at: https://lists.01.org/pipermail/kbuild-all/2015-July/010527.html.

I will try and see if this can work with frv and if still fails I will
open a bug report with gcc. But meanwhile this is the easiest option
to solve build failure of frv.

Fixes: 866ced950bcd ("kbuild: Support split debug info v4")
Link: http://lkml.kernel.org/r/1482062348-5352-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-fix-frv-build-failure lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-frv-build-failure
+++ a/lib/Kconfig.debug
@@ -164,7 +164,7 @@ config DEBUG_INFO_REDUCED
 
 config DEBUG_INFO_SPLIT
 	bool "Produce split debuginfo in .dwo files"
-	depends on DEBUG_INFO
+	depends on DEBUG_INFO && !FRV
 	help
 	  Generate debug info into separate .dwo files. This significantly
 	  reduces the build directory size for builds with DEBUG_INFO,
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


