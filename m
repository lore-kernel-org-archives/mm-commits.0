From: akpm@linux-foundation.org
Subject: + proc-pid-pagemap-document-in-documentation-filesystems-proctxt.patch added to -mm tree
Date: Mon, 20 Sep 2010 15:29:09 -0700
Message-ID: <201009202221.o8KMLVPG017712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab0ITWVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 18:21:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, rguenther@suse.de


The patch titled
     /proc/pid/pagemap: document in Documentation/filesystems/proc.txt
has been added to the -mm tree.  Its filename is
     proc-pid-pagemap-document-in-documentation-filesystems-proctxt.patch

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
Subject: /proc/pid/pagemap: document in Documentation/filesystems/proc.txt
From: Nikanth Karthikesan <knikanth@suse.de>

Document /proc/pid/pagemap in Documentation/filesystems/proc.txt

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Richard Guenther <rguenther@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-pid-pagemap-document-in-documentation-filesystems-proctxt Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-pid-pagemap-document-in-documentation-filesystems-proctxt
+++ a/Documentation/filesystems/proc.txt
@@ -136,6 +136,7 @@ Table 1-1: Process specific entries in /
  statm		Process memory status information
  status		Process status in human readable form
  wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
 		each mapping
@@ -404,6 +405,9 @@ To clear the bits for the file mapped pa
     > echo 3 > /proc/PID/clear_refs
 Any other value written to /proc/PID/clear_refs will have no effect.
 
+The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
+using /proc/kpageflags and number of times a page is mapped using
+/proc/kpagecount. For detailed explanation, see Documentation/vm/pagemap.txt.
 
 1.2 Kernel data
 ---------------
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.patch
proc-pid-pagemap-document-in-documentation-filesystems-proctxt.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.patch
mm-smaps-export-mlock-information.patch

