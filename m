From: akpm@linux-foundation.org
Subject: + ia64-define-ioremap_uc.patch added to -mm tree
Date: Tue, 15 Mar 2016 15:12:55 -0700
Message-ID: <56e888e7.dNxJpkZEsuKtMQcS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbcCOWM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 18:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, fengguang.wu@intel.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: define ioremap_uc()
has been added to the -mm tree.  Its filename is
     ia64-define-ioremap_uc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-define-ioremap_uc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-define-ioremap_uc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: ia64: define ioremap_uc()

All architectures now need ioremap_uc(), ia64 seems defines this already
through its ioremap_nocache() and it already ensures it *only* uses UC.

This is needed since v4.3 to complete an allyesconfig compile on ia64,
there were others archs that needed this, and this one seems to have
fallen through the cracks.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/include/asm/io.h~ia64-define-ioremap_uc arch/ia64/include/asm/io.h
--- a/arch/ia64/include/asm/io.h~ia64-define-ioremap_uc
+++ a/arch/ia64/include/asm/io.h
@@ -433,6 +433,7 @@ static inline void __iomem * ioremap_cac
 	return ioremap(phys_addr, size);
 }
 #define ioremap_cache ioremap_cache
+#define ioremap_uc ioremap_nocache
 
 
 /*
_

Patches currently in -mm which might be from mcgrof@kernel.org are

ia64-define-ioremap_uc.patch

