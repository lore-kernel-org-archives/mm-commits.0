From: akpm@linux-foundation.org
Subject: + x86-mm-support-huge-kva-mappings-on-x86-fix.patch added to -mm
 tree
Date: Wed, 11 Mar 2015 13:06:17 -0700
Message-ID: <5500a039.YJnAnjm6V8AMZs70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbCKUGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 16:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: ioremap_pud_capable can be static
has been added to the -mm tree.  Its filename is
     x86-mm-support-huge-kva-mappings-on-x86-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-support-huge-kva-mappings-on-x86-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-support-huge-kva-mappings-on-x86-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: kbuild test robot <fengguang.wu@intel.com>
Subject: x86, mm: ioremap_pud_capable can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ioremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/ioremap.c~x86-mm-support-huge-kva-mappings-on-x86-fix lib/ioremap.c
--- a/lib/ioremap.c~x86-mm-support-huge-kva-mappings-on-x86-fix
+++ a/lib/ioremap.c
@@ -14,9 +14,9 @@
 #include <asm/pgtable.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-int __read_mostly ioremap_pud_capable;
-int __read_mostly ioremap_pmd_capable;
-int __read_mostly ioremap_huge_disabled;
+static int __read_mostly ioremap_pud_capable;
+static int __read_mostly ioremap_pmd_capable;
+static int __read_mostly ioremap_huge_disabled;
 
 static int __init set_nohugeiomap(char *str)
 {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
x86-mm-support-huge-kva-mappings-on-x86-fix.patch
mm-support-madvisemadv_free-fix.patch
sparc-add-pmd_-for-thp-fix.patch
rtc-ds1685-remove-owner-assignment-from-platform_driver.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

