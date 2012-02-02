From: akpm@linux-foundation.org
Subject: [merged] sysctl-fix-memset-parameters-in-setup_sysctl_set.patch removed from -mm tree
Date: Thu, 02 Feb 2012 12:11:26 -0800
Message-ID: <20120202201126.5CB93A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37649 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2BBUL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 15:11:28 -0500
Received: by eaae13 with SMTP id e13so59313eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 12:11:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: fix memset parameters in setup_sysctl_set()
has been removed from the -mm tree.  Its filename was
     sysctl-fix-memset-parameters-in-setup_sysctl_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: sysctl: fix memset parameters in setup_sysctl_set()

The current code is a nop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-fix-memset-parameters-in-setup_sysctl_set fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-fix-memset-parameters-in-setup_sysctl_set
+++ a/fs/proc/proc_sysctl.c
@@ -1547,7 +1547,7 @@ void setup_sysctl_set(struct ctl_table_s
 	struct ctl_table_root *root,
 	int (*is_seen)(struct ctl_table_set *))
 {
-	memset(set, sizeof(*set), 0);
+	memset(set, 0, sizeof(*set));
 	set->is_seen = is_seen;
 	init_header(&set->dir.header, root, set, NULL, root_table);
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch

