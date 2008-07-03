From: akpm@linux-foundation.org
Subject: + mm-switch-node-meminfo-active-inactive-pages-to-kbytes.patch added to -mm tree
Date: Thu, 03 Jul 2008 15:42:40 -0700
Message-ID: <200807032242.m63Mge0E031140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974AbYGCWmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 18:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.blackwood@ccur.com, stable@kernel.org


The patch titled
     mm: switch node meminfo Active & Inactive pages to Kbytes
has been added to the -mm tree.  Its filename is
     mm-switch-node-meminfo-active-inactive-pages-to-kbytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: switch node meminfo Active & Inactive pages to Kbytes
From: John Blackwood <john.blackwood@ccur.com>

There is a bug in the output of /sys/devices/system/node/node[n]/meminfo
where the Active and Inactive values are in pages instead of Kbytes.

Looks like this occurred back in 2.6.20 when the code was changed
over to use node_page_state().

Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/node.c~mm-switch-node-meminfo-active-inactive-pages-to-kbytes drivers/base/node.c
--- a/drivers/base/node.c~mm-switch-node-meminfo-active-inactive-pages-to-kbytes
+++ a/drivers/base/node.c
@@ -84,8 +84,8 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
-		       nid, node_page_state(nid, NR_ACTIVE),
-		       nid, node_page_state(nid, NR_INACTIVE),
+		       nid, K(node_page_state(nid, NR_ACTIVE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE)),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
_

Patches currently in -mm which might be from john.blackwood@ccur.com are

mm-switch-node-meminfo-active-inactive-pages-to-kbytes.patch

