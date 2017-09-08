From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix.patch
 removed from -mm tree
Date: Fri, 08 Sep 2017 15:58:36 -0700
Message-ID: <59b3209c.yuA9ZeIhcUHkOtCF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752999AbdIHW6h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 18:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, arnd@arndb.de, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: struct hmm is only use by HMM mirror functionality v2 fix
has been removed from the -mm tree.  Its filename was
     mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix.patch

This patch was dropped because it was folded into mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm/hmm: struct hmm is only use by HMM mirror functionality v2 fix

fix build (arm multi_v7_defconfig)

Link: http://lkml.kernel.org/r/20170828181849.323ab81b@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/hmm.h~mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix
+++ a/include/linux/hmm.h
@@ -514,5 +514,8 @@ static inline void hmm_mm_init(struct mm
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
 
 
+#else /* IS_ENABLED(CONFIG_HMM) */
+static inline void hmm_mm_destroy(struct mm_struct *mm) {}
+static inline void hmm_mm_init(struct mm_struct *mm) {}
 #endif /* IS_ENABLED(CONFIG_HMM) */
 #endif /* LINUX_HMM_H */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch

