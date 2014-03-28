From: akpm@linux-foundation.org
Subject: + kmemleak-change-some-global-variables-to-int-v4.patch added to
 -mm tree
Date: Fri, 28 Mar 2014 13:22:45 -0700
Message-ID: <5335da15.OvrOO0FEIy4Xdipl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaC1UWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 16:22:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: + kmemleak-change-some-global-variables-to-int-v4.patch added to -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 13:22:45 -0700


The patch titled
     Subject: kmemleak-change-some-global-variables-to-int-v4
has been added to the -mm tree.  Its filename is
     kmemleak-change-some-global-variables-to-int-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-change-some-global-variables-to-int-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-change-some-global-variables-to-int-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak-change-some-global-variables-to-int-v4

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-change-some-global-variables-to-int-v4 mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-change-some-global-variables-to-int-v4
+++ a/mm/kmemleak.c
@@ -1630,7 +1630,7 @@ static ssize_t kmemleak_write(struct fil
 		return ret;
 
 	if (strncmp(buf, "clear", 5) == 0) {
-		if (atomic_read(&kmemleak_enabled))
+		if (kmemleak_enabled)
 			kmemleak_clear();
 		else
 			__kmemleak_do_cleanup();
_

Patches currently in -mm which might be from lizefan@huawei.com are

kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4.patch
kmemleak-remove-redundant-code.patch
kmemleak-change-some-global-variables-to-int.patch
kmemleak-change-some-global-variables-to-int-v4.patch
kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch
linux-next.patch

