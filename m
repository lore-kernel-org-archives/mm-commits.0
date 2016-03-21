From: akpm@linux-foundation.org
Subject: [merged]
 tools-vm-page-typesc-avoid-memset-in-walk_pfn-when-count-==-1.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:20 -0700
Message-ID: <56f04014.Cy1cgl85SmRsG/Ox%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713AbcCUT4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, koct9i@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: avoid memset() in walk_pfn() when count == 1
has been removed from the -mm tree.  Its filename was
     tools-vm-page-typesc-avoid-memset-in-walk_pfn-when-count-==-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: tools/vm/page-types.c: avoid memset() in walk_pfn() when count == 1

I found that page-types is very slow and my testing shows many timeout
errors.  Here's an example with a simple program allocating 1000 thps.

  $ time ./page-types -p $(pgrep -f test_alloc)
  ...
  real    0m17.201s
  user    0m16.889s
  sys     0m0.312s

Most of time is spent in memset().  Currently memset() clears over whole
buffer for every walk_pfn() call, which is inefficient when walk_pfn() is
called from walk_vma(), because in that case walk_pfn() is called for each
pfn.  So this patch limits the zero initialization only for the first
element.

  $ time ./page-types.patched -p $(pgrep -f test_alloc)
  ...
  real    0m0.182s
  user    0m0.046s
  sys     0m0.135s

Fixes: 954e95584579 ("tools/vm/page-types.c: add memory cgroup dumping and filtering")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Suggested-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-avoid-memset-in-walk_pfn-when-count-==-1 tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-avoid-memset-in-walk_pfn-when-count-==-1
+++ a/tools/vm/page-types.c
@@ -633,7 +633,15 @@ static void walk_pfn(unsigned long voffs
 	unsigned long pages;
 	unsigned long i;
 
-	memset(cgi, 0, sizeof cgi);
+	/*
+	 * kpagecgroup_read() reads only if kpagecgroup were opened, but
+	 * /proc/kpagecgroup might even not exist, so it's better to fill
+	 * them with zeros here.
+	 */
+	if (count == 1)
+		cgi[0] = 0;
+	else
+		memset(cgi, 0, sizeof cgi);
 
 	while (count) {
 		batch = min_t(unsigned long, count, KPAGEFLAGS_BATCH);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


