From: akpm@linux-foundation.org
Subject: [merged] scripts-kernel-doc-fix-fatal-error-on-function-prototype.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:24 -0400
Message-ID: <201003261937.o2QJbNhQ016603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab0CZTh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scripts/kernel-doc: fix fatal error on function prototype
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-fix-fatal-error-on-function-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/kernel-doc: fix fatal error on function prototype
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix a fatal error in scripts/kernel-doc when a function signature uses
__init_or_module (just ignore that string):

Error(drivers/base/platform.c:568): cannot understand prototype: 'struct platform_device * __init_or_module platform_create_bundle(struct platform_driver *driver, int (*probe)(struct platform_device *), struct resource *res, unsigned int n_res, const void *data, size_t size) '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/kernel-doc~scripts-kernel-doc-fix-fatal-error-on-function-prototype scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-fix-fatal-error-on-function-prototype
+++ a/scripts/kernel-doc
@@ -1730,6 +1730,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/__init +//;
+    $prototype =~ s/__init_or_module +//;
     $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

