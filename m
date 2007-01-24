From: akpm@osdl.org
Subject: + remove-final-reference-to-superfluous-smp_commence.patch added to -mm tree
Date: Wed, 24 Jan 2007 01:20:50 -0800
Message-ID: <200701240920.l0O9Koul013721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59144 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXAXJU7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 04:20:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, mingo@redhat.com


The patch titled
     Remove final reference to superfluous smp_commence()
has been added to the -mm tree.  Its filename is
     remove-final-reference-to-superfluous-smp_commence.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove final reference to superfluous smp_commence()
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the last (and commented out) invocation of the obsolete
smp_commence() call.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/main.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN init/main.c~remove-final-reference-to-superfluous-smp_commence init/main.c
--- a/init/main.c~remove-final-reference-to-superfluous-smp_commence
+++ a/init/main.c
@@ -395,11 +395,6 @@ static void __init smp_init(void)
 	/* Any cleanup work */
 	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
 	smp_cpus_done(max_cpus);
-#if 0
-	/* Get other processors into their bootup holding patterns. */
-
-	smp_commence();
-#endif
 }
 
 #endif
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
