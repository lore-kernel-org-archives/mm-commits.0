From: akpm@linux-foundation.org
Subject: + alpha-fix-compile-errors-in-dma-mapping-commonh.patch added to -mm tree
Date: Mon, 15 Mar 2010 13:11:01 -0700
Message-ID: <201003152011.o2FKB1Sr020034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936641Ab0COULR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mcree@orcon.net.nz


The patch titled
     alpha: fix compile errors in dma-mapping-common.h
has been added to the -mm tree.  Its filename is
     alpha-fix-compile-errors-in-dma-mapping-commonh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix compile errors in dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Commit c186caca3dbe7f44da624cb4f9d78e1b1dfb13b8 ("dma-mapping: alpha: use
include/linux/pci-dma-compat.h ") leads to the following errors with
CONFIG_ALPHA_{TSUNAMI, TITAN, RAWHIDE, MARVEL}:

include/asm-generic/dma-mapping-common.h: In function `dma_map_sg_attrs':
include/asm-generic/dma-mapping-common.h:49: error: implicit declaration of function `for_each_sg'
include/asm-generic/dma-mapping-common.h:50: error: syntax error before "kmemcheck_mark_initialized"

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/core_marvel.h  |    1 -
 arch/alpha/include/asm/core_mcpcia.h  |    1 -
 arch/alpha/include/asm/core_titan.h   |    1 -
 arch/alpha/include/asm/core_tsunami.h |    1 -
 4 files changed, 4 deletions(-)

diff -puN arch/alpha/include/asm/core_marvel.h~alpha-fix-compile-errors-in-dma-mapping-commonh arch/alpha/include/asm/core_marvel.h
--- a/arch/alpha/include/asm/core_marvel.h~alpha-fix-compile-errors-in-dma-mapping-commonh
+++ a/arch/alpha/include/asm/core_marvel.h
@@ -12,7 +12,6 @@
 #define __ALPHA_MARVEL__H__
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/spinlock.h>
 
 #include <asm/compiler.h>
diff -puN arch/alpha/include/asm/core_mcpcia.h~alpha-fix-compile-errors-in-dma-mapping-commonh arch/alpha/include/asm/core_mcpcia.h
--- a/arch/alpha/include/asm/core_mcpcia.h~alpha-fix-compile-errors-in-dma-mapping-commonh
+++ a/arch/alpha/include/asm/core_mcpcia.h
@@ -6,7 +6,6 @@
 #define MCPCIA_ONE_HAE_WINDOW 1
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <asm/compiler.h>
 
 /*
diff -puN arch/alpha/include/asm/core_titan.h~alpha-fix-compile-errors-in-dma-mapping-commonh arch/alpha/include/asm/core_titan.h
--- a/arch/alpha/include/asm/core_titan.h~alpha-fix-compile-errors-in-dma-mapping-commonh
+++ a/arch/alpha/include/asm/core_titan.h
@@ -2,7 +2,6 @@
 #define __ALPHA_TITAN__H__
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <asm/compiler.h>
 
 /*
diff -puN arch/alpha/include/asm/core_tsunami.h~alpha-fix-compile-errors-in-dma-mapping-commonh arch/alpha/include/asm/core_tsunami.h
--- a/arch/alpha/include/asm/core_tsunami.h~alpha-fix-compile-errors-in-dma-mapping-commonh
+++ a/arch/alpha/include/asm/core_tsunami.h
@@ -2,7 +2,6 @@
 #define __ALPHA_TSUNAMI__H__
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <asm/compiler.h>
 
 /*
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
alpha-fix-compile-errors-in-dma-mapping-commonh.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

