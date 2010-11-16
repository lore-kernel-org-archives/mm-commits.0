From: akpm@linux-foundation.org
Subject: + kernel-sysctlc-fix-build-failure-with-config_printk.patch added to -mm tree
Date: Tue, 16 Nov 2010 12:51:54 -0800
Message-ID: <201011162051.oAGKpsdY006962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757493Ab0KPUwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 15:52:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, eparis@redhat.com


The patch titled
     kernel/sysctl.c: fix build failure with !CONFIG_PRINTK
has been added to the -mm tree.  Its filename is
     kernel-sysctlc-fix-build-failure-with-config_printk.patch

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
Subject: kernel/sysctl.c: fix build failure with !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~kernel-sysctlc-fix-build-failure-with-config_printk kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-fix-build-failure-with-config_printk
+++ a/kernel/sysctl.c
@@ -702,7 +702,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
-#endif
 	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
@@ -712,6 +711,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
_

Patches currently in -mm which might be from joe@perches.com are

kernel-sysctlc-fix-build-failure-with-config_printk.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

