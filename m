From: akpm@linux-foundation.org
Subject: - kernel-doc-allow-space-after-__attribute__.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:16 -0800
Message-ID: <200703020506.l2256Gos000780@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422672AbXCBFGU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: allow space after __attribute__
has been removed from the -mm tree.  Its filename was
     kernel-doc-allow-space-after-__attribute__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: allow space after __attribute__
From: Randy Dunlap <randy.dunlap@oracle.com>

Allow space(s) between "__attribute__" and "((blah))" so that
kernel-doc does not complain like:

Warning(/tester/linsrc/linux-2.6.20-git15//kernel/timer.c:939): No description found for parameter 'read_persistent_clock(void'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-allow-space-after-__attribute__ scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-allow-space-after-__attribute__
+++ a/scripts/kernel-doc
@@ -1547,7 +1547,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/^#define\s+//; #ak added
-    $prototype =~ s/__attribute__ \(\([a-z,]*\)\)//;
+    $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
     # Yes, this truly is vile.  We are looking for:
     # 1. Return type (may be nothing if we're looking at a macro)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
phy-layer-add-kernel-doc-docbook.patch
fusion-kernel-doc-warning-fixes.patch
scripts-kernel-doc-whitespace-cleanup.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
