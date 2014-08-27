From: akpm@linux-foundation.org
Subject: [to-be-updated]
 earlyprintk-re-enable-earlyprintk-calling-early_param.patch removed from
 -mm tree
Date: Wed, 27 Aug 2014 13:11:47 -0700
Message-ID: <53fe3b83.oWLKOcm3ZE1baPsS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:45503 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaH0ULx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 16:11:53 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so91146qcz.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 13:11:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keun-o.park@windriver.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, oleg@redhat.com, peterz@infradead.org, prarit@redhat.com, rafael.j.wysocki@intel.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: earlyprintk: re-enable earlyprintk calling early_param
has been removed from the -mm tree.  Its filename was
     earlyprintk-re-enable-earlyprintk-calling-early_param.patch

This patch was dropped because an updated version will be merged

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


