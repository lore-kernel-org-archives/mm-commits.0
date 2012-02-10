From: akpm@linux-foundation.org
Subject: + pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch added to -mm tree
Date: Thu, 09 Feb 2012 16:28:08 -0800
Message-ID: <20120210002809.11E86A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40787 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BJA2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 19:28:09 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so258292yen.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 16:28:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: pagemap: document KPF_THP and make page-types aware of it
has been added to the -mm tree.  Its filename is
     pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: pagemap: document KPF_THP and make page-types aware of it

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
mm-introduce-pmd_to_pte_t.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

