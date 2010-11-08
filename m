From: akpm@linux-foundation.org
Subject: [merged] kernel-relayc-relay_alloc_page_array-use-vzalloc.patch removed from -mm tree
Date: Mon, 08 Nov 2010 12:01:32 -0800
Message-ID: <201011082003.oA8K3eWD005379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753964Ab0KHUEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 15:04:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, karim@opersys.com, lethal@linux-sh.org, mathieu.desnoyers@polymtl.ca, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kernel/relay.c: relay_alloc_page_array() use vzalloc()
has been removed from the -mm tree.  Its filename was
     kernel-relayc-relay_alloc_page_array-use-vzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/relay.c: relay_alloc_page_array() use vzalloc()
From: Jesper Juhl <jj@chaosbits.net>

We can optimize kernel/relay.c::relay_alloc_page_array() slightly by using
vzalloc. The patch makes these changes:

 - use vzalloc instead of vmalloc+memset.
 - remove redundant local variable 'array'.
 - declare local 'pa_size' as const.

Cuts down nicely on both source and object-code size.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Cc: Karim Yaghmour <karim@opersys.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN kernel/relay.c~kernel-relayc-relay_alloc_page_array-use-vzalloc kernel/relay.c
--- a/kernel/relay.c~kernel-relayc-relay_alloc_page_array-use-vzalloc
+++ a/kernel/relay.c
@@ -70,17 +70,10 @@ static const struct vm_operations_struct
  */
 static struct page **relay_alloc_page_array(unsigned int n_pages)
 {
-	struct page **array;
-	size_t pa_size = n_pages * sizeof(struct page *);
