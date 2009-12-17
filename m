From: akpm@linux-foundation.org
Subject: + kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch.patch added to -mm tree
Date: Wed, 16 Dec 2009 22:26:09 -0800
Message-ID: <200912170626.nBH6Q91M011106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761937AbZLQG03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 01:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com


The patch titled
     kernel/sysctl.c: fix the incomplete part of sysctl_max_map_count-should-be-non-negative.patch
has been added to the -mm tree.  Its filename is
     kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch.patch

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
Subject: kernel/sysctl.c: fix the incomplete part of sysctl_max_map_count-should-be-non-negative.patch
From: WANG Cong <amwang@redhat.com>

It is a mistake that we used 'proc_dointvec', it should be
'proc_dointvec_minmax', as in the original patch.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch
+++ a/kernel/sysctl.c
@@ -1131,7 +1131,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 #else
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
kernel-sysctlc-fix-the-incomplete-part-of-sysctl_max_map_count-should-be-non-negativepatch.patch
linux-next.patch
xtensa-use-generic-sys_pipe.patch

