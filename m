From: akpm@linux-foundation.org
Subject: + init-kconfig-add-clarification-for-out-of-tree-modules.patch
 added to -mm tree
Date: Fri, 29 Jul 2016 16:04:21 -0700
Message-ID: <579be0f5.F4+ijeE2bRV6ob3r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcG2XEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 19:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Valdis.Kletnieks@vt.edu, mmarek@suse.cz, rusty@rustcorp.com.au, valdis.kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: add clarification for out-of-tree modules
has been added to the -mm tree.  Its filename is
     init-kconfig-add-clarification-for-out-of-tree-modules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-kconfig-add-clarification-for-out-of-tree-modules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-kconfig-add-clarification-for-out-of-tree-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: init/Kconfig: add clarification for out-of-tree modules

It doesn't trim just symbols that are totally unused in-tree - it trims
the symbols unused by any in-tree modules actually built.  If you've done
a 'make localmodconfig' and only build a hundred or so modules, it's
pretty likely that your out-of-tree module will come up lacking
something...

Hopefully this will save the next guy from a Homer Simpson "D'oh!" moment.

Link: http://lkml.kernel.org/r/10177.1469787292@turing-police.cc.vt.edu
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~init-kconfig-add-clarification-for-out-of-tree-modules init/Kconfig
--- a/init/Kconfig~init-kconfig-add-clarification-for-out-of-tree-modules
+++ a/init/Kconfig
@@ -2080,7 +2080,7 @@ config TRIM_UNUSED_KSYMS
 	  (especially when using LTO) for optimizing the code and reducing
 	  binary size.  This might have some security advantages as well.
 
-	  If unsure say N.
+	  If unsure, or if you need to build out-of-tree modules, say N.
 
 endif # MODULES
 
_

Patches currently in -mm which might be from Valdis.Kletnieks@vt.edu are

init-kconfig-add-clarification-for-out-of-tree-modules.patch

