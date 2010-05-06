From: akpm@linux-foundation.org
Subject: + mm-memcontrol-uninitialised-return-value.patch added to -mm tree
Date: Thu, 06 May 2010 14:24:28 -0700
Message-ID: <201005062124.o46LOSn8014511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab0EFVZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 17:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, nishimura@mxp.nes.nec.co.jp


The patch titled
     mm: memcontrol - uninitialised return value
has been added to the -mm tree.  Its filename is
     mm-memcontrol-uninitialised-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: memcontrol - uninitialised return value
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Only an out of memory error will cause ret to be set.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-uninitialised-return-value mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-uninitialised-return-value
+++ a/mm/memcontrol.c
@@ -3598,7 +3598,7 @@ static int mem_cgroup_usage_unregister_e
 	int type = MEMFILE_TYPE(cft->private);
 	u64 usage;
 	int size = 0;
-	int i, j, ret;
+	int i, j, ret = 0;
 
 	mutex_lock(&memcg->thresholds_lock);
 	if (type == _MEM)
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

linux-next.patch
errh-add-__must_check-to-error-pointer-handlers.patch
hvsi-messed-up-error-checking-getting-state-name.patch
mm-remove-unnecessary-use-of-atomic.patch
mm-memcontrol-uninitialised-return-value.patch

