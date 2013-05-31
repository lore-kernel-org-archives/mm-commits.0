From: akpm@linux-foundation.org
Subject: + arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch
 added to -mm tree
Date: Fri, 31 May 2013 14:49:03 -0700
Message-ID: <51a91acf.sl6LwZJz04y8eyxA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3EaVtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 17:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, gang.chen@asianux.com

Subject: + arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch added to -mm tree
To: gang.chen@asianux.com,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 14:49:03 -0700


The patch titled
     Subject: arch/frv/kernel/setup.c: use strncmp() instead of memcmp()
has been added to the -mm tree.  Its filename is
     arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: arch/frv/kernel/setup.c: use strncmp() instead of memcmp()

'cmdline' is a NUL terminated string, when its length < 4, memcmp()
will cause memory access out of boundary.

So use strncmp() instead of memcmp().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/frv/kernel/setup.c~arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp
+++ a/arch/frv/kernel/setup.c
@@ -735,7 +735,7 @@ static void __init parse_cmdline_early(c
 		/* "mem=XXX[kKmM]" sets SDRAM size to <mem>, overriding the value we worked
 		 * out from the SDRAM controller mask register
 		 */
-		if (!memcmp(cmdline, "mem=", 4)) {
+		if (!strncmp(cmdline, "mem=", 4)) {
 			unsigned long long mem_size;
 
 			mem_size = memparse(cmdline + 4, &cmdline);
_

Patches currently in -mm which might be from gang.chen@asianux.com are

linux-next.patch
lib-mpi-mpicoderc-looping-issue-need-stop-when-equal-to-zero-found-by-extra_flags=-w.patch
kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
vfs-fix-invalid-ida_remove-call.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch
arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch

