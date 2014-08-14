From: akpm@linux-foundation.org
Subject: + earlyprintk-re-enable-earlyprintk-calling-early_param.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 13:35:20 -0700
Message-ID: <53ed1d88.pZixlw0UsplPszNj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:34909 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaHNUfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 16:35:21 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so460752pde.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 13:35:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keun-o.park@windriver.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, oleg@redhat.com, peterz@infradead.org, prarit@redhat.com, rafael.j.wysocki@intel.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: earlyprintk: re-enable earlyprintk calling early_param
has been added to the -mm tree.  Its filename is
     earlyprintk-re-enable-earlyprintk-calling-early_param.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/earlyprintk-re-enable-earlyprintk-calling-early_param.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/earlyprintk-re-enable-earlyprintk-calling-early_param.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sahara <keun-o.park@windriver.com>
Subject: earlyprintk: re-enable earlyprintk calling early_param

Although there are many obs_kernel_param and its names are earlyprintk and
also EARLY_PRINTK is also enabled, we could not see the early_printk
output properly until now.  This patch considers earlycon as well as
earlyprintk.

Signed-off-by: Sahara <keun-o.park@windriver.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/main.c~earlyprintk-re-enable-earlyprintk-calling-early_param init/main.c
--- a/init/main.c~earlyprintk-re-enable-earlyprintk-calling-early_param
+++ a/init/main.c
@@ -426,7 +426,8 @@ static int __init do_early_param(char *p
 	for (p = __setup_start; p < __setup_end; p++) {
 		if ((p->early && parameq(param, p->str)) ||
 		    (strcmp(param, "console") == 0 &&
-		     strcmp(p->str, "earlycon") == 0)
+		     ((strcmp(p->str, "earlycon") == 0) ||
+		     (strcmp(p->str, "earlyprintk") == 0)))
 		) {
 			if (p->setup_func(val) != 0)
 				pr_warn("Malformed early option '%s'\n", param);
_

Patches currently in -mm which might be from keun-o.park@windriver.com are

earlyprintk-re-enable-earlyprintk-calling-early_param.patch

