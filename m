From: akpm@linux-foundation.org
Subject: + mm-printk-introduce-new-format-string-for-flags-fix.patch added to -mm tree
Date: Mon, 01 Feb 2016 14:31:21 -0800
Message-ID: <56afdcb9.jmHTrQV9IIR28/zn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbcBAWbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 17:31:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, heiko.carstens@de.ibm.com, linux@roeck-us.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-printk-introduce-new-format-string-for-flags-fix
has been added to the -mm tree.  Its filename is
     mm-printk-introduce-new-format-string-for-flags-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-printk-introduce-new-format-string-for-flags-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-printk-introduce-new-format-string-for-flags-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-printk-introduce-new-format-string-for-flags-fix

Due to rebasing mistake, mmdebug.h keeps including tracepoint.h, causing
header dependency issues on some arches.
Remove the include, and related declarations of flags arrays, which reside
in mm/internal.h and lib/vsprintf.c already includes that header.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags-fix include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags-fix
+++ a/include/linux/mmdebug.h
@@ -3,17 +3,11 @@
 
 #include <linux/bug.h>
 #include <linux/stringify.h>
-#include <linux/types.h>
-#include <linux/tracepoint.h>
 
 struct page;
 struct vm_area_struct;
 struct mm_struct;
 
-extern const struct trace_print_flags pageflag_names[];
-extern const struct trace_print_flags vmaflag_names[];
-extern const struct trace_print_flags gfpflag_names[];
