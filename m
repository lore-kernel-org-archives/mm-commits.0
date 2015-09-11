From: akpm@linux-foundation.org
Subject: + mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch
 added to -mm tree
Date: Fri, 11 Sep 2015 14:27:07 -0700
Message-ID: <55f3472b.sdTra+vDtttSQqdf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbIKV1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: rename kasan_enabled() to kasan_report_enabled()
has been added to the -mm tree.  Its filename is
     mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/kasan: rename kasan_enabled() to kasan_report_enabled()

The function only disable/enable reporting.  In the later patch we will be
adding a kasan early enable/disable.  Rename kasan_enabled to properly
reflect its function.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    2 +-
 mm/kasan/report.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.h~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled
+++ a/mm/kasan/kasan.h
@@ -63,7 +63,7 @@ static inline const void *kasan_shadow_t
 		<< KASAN_SHADOW_SCALE_SHIFT);
 }
 
-static inline bool kasan_enabled(void)
+static inline bool kasan_report_enabled(void)
 {
 	return !current->kasan_depth;
 }
diff -puN mm/kasan/report.c~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled
+++ a/mm/kasan/report.c
@@ -220,7 +220,7 @@ void kasan_report(unsigned long addr, si
 {
 	struct kasan_access_info info;
 
-	if (likely(!kasan_enabled()))
+	if (likely(!kasan_report_enabled()))
 		return;
 
 	info.access_addr = (void *)addr;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch
mm-kasan-module_vaddr-is-not-available-on-all-archs.patch
mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch
mm-kasan-prevent-deadlock-in-kasan-reporting.patch

