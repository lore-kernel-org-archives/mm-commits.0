From: akpm@linux-foundation.org
Subject: +
 mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch added to -mm tree
Date: Thu, 23 Jan 2014 12:55:27 -0800
Message-ID: <52e181bf.SIsAWxFtcoF8YOor%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaAWUz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 15:55:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, rientjes@google.com

Subject: + mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch added to -mm tree
To: rientjes@google.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 12:55:27 -0800


The patch titled
     Subject: mm, compaction: ignore pageblock skip when manually invoking compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: ignore pageblock skip when manually invoking compaction

The cached pageblock hint should be ignored when triggering compaction
through /proc/sys/vm/compact_memory so all eligible memory is isolated. 
Manually invoking compaction is known to be expensive, there's no need to
skip pageblocks based on heuristics (mainly for debugging).

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/compaction.c~mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction
+++ a/mm/compaction.c
@@ -1180,6 +1180,7 @@ static void compact_node(int nid)
 	struct compact_control cc = {
 		.order = -1,
 		.sync = true,
+		.ignore_skip_hint = true,
 	};
 
 	__compact_pgdat(NODE_DATA(nid), &cc);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-nobootmem-free_all_bootmem-again-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
uapi-convert-u64-to-__u64-in-exported-headers.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
linux-next.patch

