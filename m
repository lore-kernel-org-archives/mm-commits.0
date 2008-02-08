From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-for-vunmap-function-prototype.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:01:51 -0800
Message-ID: <200802080801.m1881WiO013971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbYBHIBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:01:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: fix for vunmap function prototype
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-for-vunmap-function-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: fix for vunmap function prototype
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc function prototype parsing which was exposed by vunmap() by
allowing more than one '*' before the function name.

Error(linux-2.6.24-mm1//mm/vmalloc.c:438): cannot understand prototype: 'struct page **vunmap(const void *addr) '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-for-vunmap-function-prototype scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-for-vunmap-function-prototype
+++ a/scripts/kernel-doc
@@ -1654,7 +1654,7 @@ sub dump_function($$) {
 	$prototype =~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
-	$prototype =~ m/^(\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
+	$prototype =~ m/^(\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
