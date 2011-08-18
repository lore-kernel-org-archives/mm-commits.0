From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-add-proc_dointvec_unsigned-handler-update.patch removed from -mm tree
Date: Thu, 18 Aug 2011 14:52:36 -0700
Message-ID: <201108182152.p7ILqa83029866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320Ab1HRVwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-add-proc_dointvec_unsigned-handler-update
has been removed from the -mm tree.  Its filename was
     sysctl-add-proc_dointvec_unsigned-handler-update.patch

This patch was dropped because an updated version will be merged

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
@@ -2510,6 +2510,7 @@ int proc_dointvec_unsigned(struct ctl_ta
 {
 	struct do_proc_dointvec_minmax_conv_param param = {
 		.min = &zero,
+		.max = (int *) table->extra2,
 	};
 	return do_proc_dointvec(table, write, buffer, lenp, ppos,
 				do_proc_dointvec_minmax_conv, &param);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

