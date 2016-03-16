From: akpm@linux-foundation.org
Subject: [merged]
 mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:56:17 -0700
Message-ID: <56e9ba61.dVdvsQrj/yI21Fdg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbcCPT4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, gong.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: pass return code of memory_failure() to userspace
has been removed from the -mm tree.  Its filename was
     mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch
tools-vm-page-typesc-support-swap-entry.patch
tools-vm-page-typesc-avoid-memset-in-walk_pfn-when-count-==-1.patch

