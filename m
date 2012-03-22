From: akpm@linux-foundation.org
Subject: [merged] pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:06 -0700
Message-ID: <20120322201806.87D00A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46778 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2CVUSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:07 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so402092vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: document KPF_THP and make page-types aware of it
has been removed from the -mm tree.  Its filename was
     pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagemap: document KPF_THP and make page-types aware of it

page-types, which is a common user of pagemap, gets aware of thp with this
patch.  This helps system admins and kernel hackers know about how thp
works.  Here is a sample output of page-types over a thp:

  $ page-types -p <pid> --raw --list

  voffset offset  len     flags
  ...
  7f9d40200       3f8400  1       ___U_lA____Ma_bH______t____________
  7f9d40201       3f8401  1ff     ________________T_____t____________

               flags      page-count       MB  symbolic-flags                     long-symbolic-flags
  0x0000000000410000             511        1  ________________T_____t____________        compound_tail,thp
  0x000000000040d868               1        0  ___U_lA____Ma_bH______t____________        uptodate,lru,active,mmap,anonymous,swapbacked,compound_head,thp

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    2 ++
 Documentation/vm/pagemap.txt  |    4 ++++
 2 files changed, 6 insertions(+)

diff -puN Documentation/vm/page-types.c~pagemap-document-kpf_thp-and-make-page-types-aware-of-it Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~pagemap-document-kpf_thp-and-make-page-types-aware-of-it
+++ a/Documentation/vm/page-types.c
@@ -98,6 +98,7 @@
 #define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
 #define KPF_KSM			21
+#define KPF_THP			22
 
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
@@ -147,6 +148,7 @@ static const char *page_flag_names[] = {
 	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
 	[KPF_KSM]		= "x:ksm",
+	[KPF_THP]		= "t:thp",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
diff -puN Documentation/vm/pagemap.txt~pagemap-document-kpf_thp-and-make-page-types-aware-of-it Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-document-kpf_thp-and-make-page-types-aware-of-it
+++ a/Documentation/vm/pagemap.txt
@@ -60,6 +60,7 @@ There are three components to pagemap:
     19. HWPOISON
     20. NOPAGE
     21. KSM
+    22. THP
 
 Short descriptions to the page flags:
 
@@ -97,6 +98,9 @@ Short descriptions to the page flags:
 21. KSM
     identical memory pages dynamically shared between one or more processes
 
+22. THP
+    contiguous pages which construct transparent hugepages
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
linux-next.patch

