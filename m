From: akpm@linux-foundation.org
Subject: +
 mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch added to
 -mm tree
Date: Tue, 26 Jan 2016 15:28:10 -0800
Message-ID: <56a8010a.1iJZXQ+lUHabiYtB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbcAZX2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 18:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, gong.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: pass return code of memory_failure() to userspace
has been added to the -mm tree.  Its filename is
     mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/madvise: pass return code of memory_failure() to userspace

Currently the return value of memory_failure() is not passed to userspace
when madvise(MADV_HWPOISON) is used.  This is inconvenient for test
programs that want to know the result of error handling.  So let's return
it to the caller as we already do in the MADV_SOFT_OFFLINE case.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/madvise.c~mm-madvise-pass-return-code-of-memory_failure-to-userspace mm/madvise.c
--- a/mm/madvise.c~mm-madvise-pass-return-code-of-memory_failure-to-userspace
+++ a/mm/madvise.c
@@ -555,8 +555,9 @@ static int madvise_hwpoison(int bhv, uns
 		}
 		pr_info("Injecting memory failure for page %#lx at %#lx\n",
 		       page_to_pfn(p), start);
-		/* Ignore return value for now */
-		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
+		ret = memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
+		if (ret)
+			return ret;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch

