From: akpm@linux-foundation.org
Subject: + mm-memblock-if-nr_new-is-0-just-return.patch added to -mm tree
Date: Tue, 12 Jan 2016 14:42:33 -0800
Message-ID: <56958159.SYRzuVHkEpQuGSFR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbcALWme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jan 2016 17:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nimisolo@gmail.com, kuleshovmail@gmail.com, mgorman@suse.de, penberg@kernel.org, tangchen@cn.fujitsu.com, tony.luck@intel.com, weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c:memblock_add_range(): if nr_new is 0 just return
has been added to the -mm tree.  Its filename is
     mm-memblock-if-nr_new-is-0-just-return.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-if-nr_new-is-0-just-return.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-if-nr_new-is-0-just-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: nimisolo <nimisolo@gmail.com>
Subject: mm/memblock.c:memblock_add_range(): if nr_new is 0 just return

If nr_new is 0 which means there's no region would be added, so just
return to the caller.

Signed-off-by: nimisolo <nimisolo@gmail.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memblock.c~mm-memblock-if-nr_new-is-0-just-return mm/memblock.c
--- a/mm/memblock.c~mm-memblock-if-nr_new-is-0-just-return
+++ a/mm/memblock.c
@@ -585,6 +585,9 @@ repeat:
 					       nid, flags);
 	}
 
+	if (!nr_new)
+		return 0;
+
 	/*
 	 * If this was the first round, resize array and repeat for actual
 	 * insertions; otherwise, merge and return.
_

Patches currently in -mm which might be from nimisolo@gmail.com are

mm-memblock-if-nr_new-is-0-just-return.patch

