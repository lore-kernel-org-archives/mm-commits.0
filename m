From: akpm@linux-foundation.org
Subject: + mm-bug-when-__kmap_atomic_idx-equals-km_type_nr.patch added to
 -mm tree
Date: Mon, 04 Aug 2014 15:48:20 -0700
Message-ID: <53e00db4.sg/v+byA7fMrZCKC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:51696 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHDWsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 18:48:21 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so26212oig.5
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 15:48:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpandya@codeaurora.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: BUG when __kmap_atomic_idx equals KM_TYPE_NR
has been added to the -mm tree.  Its filename is
     mm-bug-when-__kmap_atomic_idx-equals-km_type_nr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bug-when-__kmap_atomic_idx-equals-km_type_nr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bug-when-__kmap_atomic_idx-equals-km_type_nr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chintan Pandya <cpandya@codeaurora.org>
Subject: mm: BUG when __kmap_atomic_idx equals KM_TYPE_NR

__kmap_atomic_idx is per_cpu variable.  Each CPU can use KM_TYPE_NR
entries from FIXMAP i.e.  from 0 to KM_TYPE_NR - 1.  Allowing
__kmap_atomic_idx to over- shoot to KM_TYPE_NR can mess up with next CPU's
0th entry which is a bug.  Hence BUG_ON if __kmap_atomic_idx >=
KM_TYPE_NR.

Fix the off-by-on in this test.

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/highmem.h~mm-bug-when-__kmap_atomic_idx-equals-km_type_nr include/linux/highmem.h
--- a/include/linux/highmem.h~mm-bug-when-__kmap_atomic_idx-equals-km_type_nr
+++ a/include/linux/highmem.h
@@ -93,7 +93,7 @@ static inline int kmap_atomic_idx_push(v
 
 #ifdef CONFIG_DEBUG_HIGHMEM
 	WARN_ON_ONCE(in_irq() && !irqs_disabled());
-	BUG_ON(idx > KM_TYPE_NR);
+	BUG_ON(idx >= KM_TYPE_NR);
 #endif
 	return idx;
 }
_

Patches currently in -mm which might be from cpandya@codeaurora.org are

mm-bug-when-__kmap_atomic_idx-equals-km_type_nr.patch
timer-provide-an-api-for-deferrable-timeout.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch

