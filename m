From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-meminit-inline-some-helper-functions-fix2.patch removed from -mm tree
Date: Tue, 30 Jun 2015 14:47:53 -0700
Message-ID: <55930e89.qoe6vCmWo69rO5xi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbbF3Vrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-inline-some-helper-functions-fix2
has been removed from the -mm tree.  Its filename was
     mm-meminit-inline-some-helper-functions-fix2.patch

This patch was dropped because it was folded into mm-meminit-inline-some-helper-functions.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-meminit-inline-some-helper-functions-fix2

mm/page_alloc.c: In function `deferred_init_memmap':
mm/page_alloc.c:1135:4: error: implicit declaration of function `meminit_pfn_in_nid' [-Werror=implicit-function-declaration]
    if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
    ^

because randconfig decided to disable CONFIG_NODES_SPAN_OTHER_NODES.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix2
+++ a/mm/page_alloc.c
@@ -943,6 +943,11 @@ static inline bool __meminit early_pfn_i
 {
 	return true;
 }
+static inline bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
+					struct mminit_pfnnid_cache *state)
+{
+	return true;
+}
 #endif
 
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-meminit-inline-some-helper-functions.patch

