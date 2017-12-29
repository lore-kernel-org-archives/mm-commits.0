From: akpm@linux-foundation.org
Subject: + kasan-added-functions-for-unpoisoning-stack-variables-fix.patch added to -mm tree
Date: Thu, 28 Dec 2017 17:35:36 -0800
Message-ID: <5a459be8.Tguz9stXAToUvDJ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754018AbdL2Bfh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 20:35:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: __asan_set_shadow_00 can be static
has been added to the -mm tree.  Its filename is
     kasan-added-functions-for-unpoisoning-stack-variables-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-added-functions-for-unpoisoning-stack-variables-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-added-functions-for-unpoisoning-stack-variables-fix.patch

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
Subject: kasan: __asan_set_shadow_00 can be static

Link: http://lkml.kernel.org/r/20171223125943.GA74341@lkp-ib03
Fixes: 1749be8333b7 ("kasan: add functions for unpoisoning stack variables")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-added-functions-for-unpoisoning-stack-variables-fix mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-added-functions-for-unpoisoning-stack-variables-fix
+++ a/mm/kasan/kasan.c
@@ -778,12 +778,12 @@ EXPORT_SYMBOL(__asan_allocas_unpoison);
 	}								\
 	EXPORT_SYMBOL(__asan_set_shadow_##byte)
 
-DEFINE_ASAN_SET_SHADOW(00);
-DEFINE_ASAN_SET_SHADOW(f1);
-DEFINE_ASAN_SET_SHADOW(f2);
-DEFINE_ASAN_SET_SHADOW(f3);
-DEFINE_ASAN_SET_SHADOW(f5);
-DEFINE_ASAN_SET_SHADOW(f8);
+static DEFINE_ASAN_SET_SHADOW(00);
+static DEFINE_ASAN_SET_SHADOW(f1);
+static DEFINE_ASAN_SET_SHADOW(f2);
+static DEFINE_ASAN_SET_SHADOW(f3);
+static DEFINE_ASAN_SET_SHADOW(f5);
+static DEFINE_ASAN_SET_SHADOW(f8);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 static int __meminit kasan_mem_notifier(struct notifier_block *nb,
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

kasan-added-functions-for-unpoisoning-stack-variables-fix.patch

