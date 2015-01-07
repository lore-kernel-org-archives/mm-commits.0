From: akpm@linux-foundation.org
Subject: + mm-change-meminfo-cached-calculation.patch added to -mm tree
Date: Tue, 06 Jan 2015 16:44:02 -0800
Message-ID: <54ac8152.rMlY81ZDkRnOelK8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbbAGAoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:44:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yalin.Wang@sonymobile.com, hughd@google.com, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/meminfo: exclude shmem from "Cached"
has been added to the -mm tree.  Its filename is
     mm-change-meminfo-cached-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-meminfo-cached-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-meminfo-cached-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: /proc/meminfo: exclude shmem from "Cached"

Subtract sharedram (shmem) from "Cached".  sharedram can only be swapped
into swap partitions so it should be treated as swap pages, not as cached
pages.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/meminfo.c~mm-change-meminfo-cached-calculation fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-change-meminfo-cached-calculation
+++ a/fs/proc/meminfo.c
@@ -45,7 +45,7 @@ static int meminfo_proc_show(struct seq_
 	committed = percpu_counter_read_positive(&vm_committed_as);
 
 	cached = global_page_state(NR_FILE_PAGES) -
-			total_swapcache_pages() - i.bufferram;
+			total_swapcache_pages() - i.bufferram - i.sharedram;
 	if (cached < 0)
 		cached = 0;
 
_

Patches currently in -mm which might be from Yalin.Wang@sonymobile.com are

mm-add-vm_bug_on_page-for-page_mapcount.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-change-meminfo-cached-calculation.patch
mm-change-meminfo-cached-calculation-fix.patch
linux-next.patch

