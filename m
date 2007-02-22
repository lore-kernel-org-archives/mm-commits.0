From: akpm@linux-foundation.org
Subject: + kernel-doc-allow-space-after-__attribute__.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:33:34 -0800
Message-ID: <200702220033.l1M0XYn9031366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965131AbXBVAdi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: allow space after __attribute__
has been added to the -mm tree.  Its filename is
     kernel-doc-allow-space-after-__attribute__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

kernel-doc-allow-space-after-__attribute__.patch
kernel-doc-fixes-for-2620-git15-non-drivers.patch
fusion-kernel-doc-warning-fixes.patch
git-drm.patch
git-libata-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
x86-dont-probe-for-ddc-on-vbe12.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
