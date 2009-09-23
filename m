From: akpm@linux-foundation.org
Subject: [merged] kbuild-echo-the-record_mcount-command.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:44 -0700
Message-ID: <200909232004.n8NK4iYO021883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbZIWUKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: echo the record_mcount command
has been removed from the -mm tree.  Its filename was
     kbuild-echo-the-record_mcount-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: echo the record_mcount command
From: Andi Kleen <andi@firstfloor.org>

I had some problems with record_mcount in the Makefile and it was hard
to track down. Echo it by default to make it easier to diagnose.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.build |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/Makefile.build~kbuild-echo-the-record_mcount-command scripts/Makefile.build
--- a/scripts/Makefile.build~kbuild-echo-the-record_mcount-command
+++ a/scripts/Makefile.build
@@ -216,6 +216,7 @@ define rule_cc_o_c
 	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
 	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
 	$(cmd_modversions)						  \
+	$(call echo-cmd,record_mcount)					  \
 	$(cmd_record_mcount)						  \
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

