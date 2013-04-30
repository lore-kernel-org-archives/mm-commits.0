From: akpm@linux-foundation.org
Subject: [merged] mm-cris-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:13 -0700
Message-ID: <20130430184513.775055A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:48181 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760969Ab3D3SpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:14 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so75491ves.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cris: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-cris-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/cris: use common help functions to free reserved pages

Use common help functions to free reserved pages.
Also include <asm/sections.h> to avoid local declaration.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/mm/init.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff -puN arch/cris/mm/init.c~mm-cris-use-common-help-functions-to-free-reserved-pages arch/cris/mm/init.c
--- a/arch/cris/mm/init.c~mm-cris-use-common-help-functions-to-free-reserved-pages
+++ a/arch/cris/mm/init.c
@@ -12,12 +12,10 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <asm/tlb.h>
+#include <asm/sections.h>
 
 unsigned long empty_zero_page;
 
-extern char _stext, _edata, _etext; /* From linkerscript */
-extern char __init_begin, __init_end;
-
 void __init
 mem_init(void)
 {
@@ -67,15 +65,5 @@ mem_init(void)
 void 
 free_initmem(void)
 {
-        unsigned long addr;
