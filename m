From: akpm@linux-foundation.org
Subject: + fix-const-confusion-in-certs-blacklist.patch added to -mm tree
Date: Thu, 21 Dec 2017 16:29:01 -0800
Message-ID: <5a3c51cd.Qe0urXspNKX7gz5a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755184AbdLVA3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Dec 2017 19:29:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: certs/blacklist_nohashes.c: fix const confusion in certs blacklist
has been added to the -mm tree.  Its filename is
     fix-const-confusion-in-certs-blacklist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-const-confusion-in-certs-blacklist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-const-confusion-in-certs-blacklist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: certs/blacklist_nohashes.c: fix const confusion in certs blacklist

const must be marked __initconst, not __initdata.

Link: http://lkml.kernel.org/r/20171222001335.1987-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 certs/blacklist_nohashes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN certs/blacklist_nohashes.c~fix-const-confusion-in-certs-blacklist certs/blacklist_nohashes.c
--- a/certs/blacklist_nohashes.c~fix-const-confusion-in-certs-blacklist
+++ a/certs/blacklist_nohashes.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "blacklist.h"
 
-const char __initdata *const blacklist_hashes[] = {
+const char __initconst *const blacklist_hashes[] = {
 	NULL
 };
_

Patches currently in -mm which might be from ak@linux.intel.com are

fix-const-confusion-in-certs-blacklist.patch

