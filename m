From: akpm@linux-foundation.org
Subject: +
 mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix.patch
 added to -mm tree
Date: Mon, 28 Aug 2017 15:37:28 -0700
Message-ID: <59a49b28.LEZIVifVuvtGZiUU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1Wh3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Aug 2017 18:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, arnd@arndb.de, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: struct hmm is only use by HMM mirror functionality v2 fix
has been added to the -mm tree.  Its filename is
     mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix-2.patch

