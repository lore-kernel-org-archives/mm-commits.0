From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix.patch removed from -mm tree
Date: Thu, 20 Aug 2015 14:37:17 -0700
Message-ID: <55d6488d./1itqgB8jTlb+zF9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbHTVhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Aug 2015 17:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status=
-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix.patc=
h

This patch was dropped because it is obsolete

------------------------------------------------------
=46rom: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: J=F6rn Engel <joern@logfs.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 +-
 mm/hugetlb.c                       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetl=
bpages-field-to-proc-pid-status-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpag=
es-field-to-proc-pid-status-fix
+++ a/Documentation/filesystems/proc.txt
@@ -174,7 +174,7 @@ read the file /proc/PID/status:
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
-  HugetlbPages:          0 kB (0x2048kB)
+  HugetlbPages:          0 kB (0*2048kB)
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
diff -puN mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-p=
id-status-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-s=
tatus-fix
+++ a/mm/hugetlb.c
@@ -2807,7 +2807,7 @@ void hugetlb_report_usage(struct seq_fil
 		if (i > 0)
 			seq_puts(m, " ");
=20
-		seq_printf(m, "%ldx%dkB",
+		seq_printf(m, "%ld*%dkB",
 			atomic_long_read(&mm->hugetlb_usage.count[i]),
 			huge_page_size(&hstates[i]) >> 10);
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com =
are

mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-3.patch
mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch
mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
