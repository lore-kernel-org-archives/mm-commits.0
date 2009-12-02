From: akpm@linux-foundation.org
Subject: + sysctl_max_map_count-should-be-non-negative.patch added to -mm tree
Date: Wed, 02 Dec 2009 13:01:36 -0800
Message-ID: <200912022101.nB2L1alw003125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbZLBVCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 16:02:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, jengelh@medozas.de, jmorris@namei.org, mingo@elte.hu


The patch titled
     'sysctl_max_map_count' should be non-negative
has been added to the -mm tree.  Its filename is
     sysctl_max_map_count-should-be-non-negative.patch

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
Subject: 'sysctl_max_map_count' should be non-negative
From: Amerigo Wang <amwang@redhat.com>

Jan Engelhardt reported we have this problem:

setting max_map_count to a value large enough results in programs dying at
first try.  This is on 2.6.31.6:

15:59 borg:/proc/sys/vm # echo $[1<<31-1] >max_map_count
15:59 borg:/proc/sys/vm # cat max_map_count
1073741824
15:59 borg:/proc/sys/vm # echo $[1<<31] >max_map_count
15:59 borg:/proc/sys/vm # cat max_map_count
Killed

This is because we have a chance to make 'max_map_count' negative.  but
it's meaningless.  Make it only accept non-negative values.

Reported-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: James Morris <jmorris@namei.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sysctl.c~sysctl_max_map_count-should-be-non-negative kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl_max_map_count-should-be-non-negative
+++ a/kernel/sysctl.c
@@ -1124,6 +1124,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
+		.extra1		= &zero,
 	},
 #else
 	{
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
xtensa-use-generic-sys_pipe.patch
sysctl_max_map_count-should-be-non-negative.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

