From: akpm@linux-foundation.org
Subject: + mm-memoryc-remove-unused-code-from-do_wp_page.patch added to -mm tree
Date: Tue, 11 Dec 2012 13:36:56 -0800
Message-ID: <20121211213658.447F4100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53065 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2LKVhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 16:37:01 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so526622qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 13:37:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dingel@linux.vnet.ibm.com


The patch titled
     Subject: mm/memory.c: remove unused code from do_wp_page()
has been added to the -mm tree.  Its filename is
     mm-memoryc-remove-unused-code-from-do_wp_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: mm/memory.c: remove unused code from do_wp_page()

page_mkwrite is initalized with zero and only set once, from that point
exists no way to get to the oom or oom_free_new labels.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memory.c~mm-memoryc-remove-unused-code-from-do_wp_page mm/memory.c
--- a/mm/memory.c~mm-memoryc-remove-unused-code-from-do_wp_page
+++ a/mm/memory.c
@@ -2781,10 +2781,6 @@ oom_free_new:
 	page_cache_release(new_page);
 oom:
 	if (old_page) {
-		if (page_mkwrite) {
-			unlock_page(old_page);
-			page_cache_release(old_page);
-		}
 		page_cache_release(old_page);
 	}
 	return VM_FAULT_OOM;
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are

mm-memoryc-remove-unused-code-from-do_wp_page.patch
mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch

