From: akpm@linux-foundation.org
Subject: + sysctl-add-proc_dointvec_unsigned-handler-update.patch added to -mm tree
Date: Wed, 08 Jun 2011 13:45:58 -0700
Message-ID: <201106082045.p58Kjwmd027729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab1FHUq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2011 16:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, adobriyan@gmail.com, ebiederm@xmission.com


The patch titled
     sysctl-add-proc_dointvec_unsigned-handler-update
has been added to the -mm tree.  Its filename is
     sysctl-add-proc_dointvec_unsigned-handler-update.patch

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
Subject: sysctl-add-proc_dointvec_unsigned-handler-update
From: Dave Young <hidave.darkstar@gmail.com>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler-update kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler-update
+++ a/kernel/sysctl.c
@@ -2515,6 +2515,7 @@ int proc_dointvec_unsigned(struct ctl_ta
 {
 	struct do_proc_dointvec_minmax_conv_param param = {
 		.min = &zero,
+		.max = (int *) table->extra2,
 	};
 	return do_proc_dointvec(table, write, buffer, lenp, ppos,
 				do_proc_dointvec_minmax_conv, &param);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

sysctl-add-proc_dointvec_bool-handler.patch
sysctl-use-proc_dointvec_bool-where-appropriate.patch
sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-add-proc_dointvec_unsigned-handler-update.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

