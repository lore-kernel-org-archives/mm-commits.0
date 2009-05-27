From: akpm@linux-foundation.org
Subject: + use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch added to -mm tree
Date: Tue, 26 May 2009 19:01:41 -0700
Message-ID: <200905270201.n4R21f2E016377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbZE0CB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 22:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, mingo@elte.hu, pavel@ucw.cz


The patch titled
     clean up printk_once of get_cpu_vendor
has been added to the -mm tree.  Its filename is
     use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch

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
Subject: clean up printk_once of get_cpu_vendor
From: Minchan Kim <minchan.kim@gmail.com>

It remove unnecessary variable and change two static variable
with one.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor
+++ a/arch/x86/kernel/cpu/common.c
@@ -486,7 +486,6 @@ out:
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
-	static int printed;
 	int i;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
@@ -504,8 +503,8 @@ static void __cpuinit get_cpu_vendor(str
 	}
 
 	printk_once(KERN_ERR
-		    "CPU: vendor_id '%s' unknown, using generic init.\n", v);
-	printk_once(KERN_ERR "CPU: Your system may be unstable.\n");
+			"CPU: vendor_id '%s' unknown, using generic init.\n" \
+			"CPU: Your system may be unstable.\n", v);
 
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
use-printk_once-in-several-places.patch
use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch

