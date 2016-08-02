From: akpm@linux-foundation.org
Subject: [patch 109/111] init/Kconfig: add clarification for out-of-tree
 modules
Date: Tue, 02 Aug 2016 14:07:27 -0700
Message-ID: <57a10b8f.gRQGdBNBLaYy+A1F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbcHBVXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, mmarek@suse.cz, rusty@rustcorp.com.au, valdis.kletnieks@vt.edu

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
