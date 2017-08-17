From: akpm@linux-foundation.org
Subject: + lib-stringc-check-for-kmalloc-failure.patch added to -mm tree
Date: Thu, 17 Aug 2017 12:55:44 -0700
Message-ID: <5995f4c0.hwMekBdN912PDiEz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbdHQTzp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 15:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, bhelgaas@google.com, danielmicay@gmail.com, heikki.krogerus@linux.intel.com, keescook@chromium.org, mawilcox@microsoft.com, mchehab@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: check for kmalloc() failure
has been added to the -mm tree.  Its filename is
     lib-stringc-check-for-kmalloc-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-stringc-check-for-kmalloc-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-stringc-check-for-kmalloc-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1058,7 +1058,11 @@ EXPORT_SYMBOL(fortify_overflow);
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
@@ -1090,7 +1094,11 @@ fail:
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
@@ -1122,7 +1130,11 @@ fail:
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

lib-stringc-check-for-kmalloc-failure.patch
test_kmod-remove-paranoid-uint_max-check-on-uint-range-processing.patch
test_kmod-flip-int-checks-to-be-consistent.patch

