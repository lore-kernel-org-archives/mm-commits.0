From: akpm@linux-foundation.org
Subject: [merged] lib-stringc-check-for-kmalloc-failure.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:42:34 -0700
Message-ID: <20170911194234.toHbNcKiH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdIKTmf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhelgaas@google.com, dan.carpenter@oracle.com, danielmicay@gmail.com, heikki.krogerus@linux.intel.com, keescook@chromium.org, mawilcox@microsoft.com, mchehab@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: lib/string.c: check for kmalloc() failure
has been removed from the -mm tree.  Its filename was
     lib-stringc-check-for-kmalloc-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/string.c: check for kmalloc() failure

This is mostly to keep the number of static checker warnings down so we
can spot new bugs instead of them being drowned in noise.  This function
doesn't return normal kernel error codes but instead the return value is
used to display exactly which memory failed.  I chose -1 as hopefully
that's a helpful thing to print.

Link: http://lkml.kernel.org/r/20170817115420.uikisjvfmtrqkzjn@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kees Cook <keescook@chromium.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN lib/string.c~lib-stringc-check-for-kmalloc-failure lib/string.c
--- a/lib/string.c~lib-stringc-check-for-kmalloc-failure
+++ a/lib/string.c
@@ -1059,7 +1059,11 @@ EXPORT_SYMBOL(fortify_panic);
 static __init int memset16_selftest(void)
 {
 	unsigned i, j, k;
-	u16 v, *p = kmalloc(256 * 2 * 2, GFP_KERNEL);
+	u16 v, *p;
+
+	p = kmalloc(256 * 2 * 2, GFP_KERNEL);
+	if (!p)
+		return -1;
 
 	for (i = 0; i < 256; i++) {
 		for (j = 0; j < 256; j++) {
@@ -1091,7 +1095,11 @@ fail:
 static __init int memset32_selftest(void)
 {
 	unsigned i, j, k;
-	u32 v, *p = kmalloc(256 * 2 * 4, GFP_KERNEL);
+	u32 v, *p;
+
+	p = kmalloc(256 * 2 * 4, GFP_KERNEL);
+	if (!p)
+		return -1;
 
 	for (i = 0; i < 256; i++) {
 		for (j = 0; j < 256; j++) {
@@ -1123,7 +1131,11 @@ fail:
 static __init int memset64_selftest(void)
 {
 	unsigned i, j, k;
-	u64 v, *p = kmalloc(256 * 2 * 8, GFP_KERNEL);
+	u64 v, *p;
+
+	p = kmalloc(256 * 2 * 8, GFP_KERNEL);
+	if (!p)
+		return -1;
 
 	for (i = 0; i < 256; i++) {
 		for (j = 0; j < 256; j++) {
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


