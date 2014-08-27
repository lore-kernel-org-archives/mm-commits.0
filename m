From: akpm@linux-foundation.org
Subject: +
 not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch added
 to -mm tree
Date: Wed, 27 Aug 2014 13:28:50 -0700
Message-ID: <53fe3f82.IRxcQf540cA42fSY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:40950 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856AbaH0U2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 16:28:51 -0400
Received: by mail-qg0-f73.google.com with SMTP id i50so95433qgf.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 13:28:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, paul.gortmaker@windriver.com, qiuxishi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: don't add modules range to kcore if it's equal to vmcore range
has been added to the -mm tree.  Its filename is
     not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: fs/proc/kcore.c: don't add modules range to kcore if it's equal to vmcore range

On some ARCHs modules range is eauql to vmalloc range. E.g on i686

	"#define MODULES_VADDR   VMALLOC_START"
	"#define MODULES_END     VMALLOC_END"

This will cause 2 duplicate program segments in /proc/kcore, and no flag
to indicate they are different.  This is confusing.  And usually people
who need check the elf header or read the content of kcore will check
memory ranges.  Two program segments which are the same are unnecessary.

So check if the modules range is equal to vmalloc range.  If so, just skip
adding the modules range.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range fs/proc/kcore.c
--- a/fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range
+++ a/fs/proc/kcore.c
@@ -610,8 +610,11 @@ static void __init proc_kcore_text_init(
 struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
+	if ( (MODULES_VADDR != VMALLOC_START) &&
+		(MODULES_END != VMALLOC_END) ) {
+		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
 			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	}
 }
 #else
 static void __init add_modules_range(void)
_

Patches currently in -mm which might be from bhe@redhat.com are

not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch

