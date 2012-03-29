From: akpm@linux-foundation.org
Subject: [merged] kexec-add-further-check-to-crashkernel.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:48 -0700
Message-ID: <20120329191348.5CBBCA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41279 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab2C2TNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:50 -0400
Received: by wibhj13 with SMTP id hj13so21845wib.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhong.duan@oracle.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add further check to crashkernel
has been removed from the -mm tree.  Its filename was
     kexec-add-further-check-to-crashkernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: kexec: add further check to crashkernel

When using crashkernel=2M-256M, the kernel doesn't give any warning.  This
is misleading sometimes.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/kexec.c~kexec-add-further-check-to-crashkernel kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-further-check-to-crashkernel
+++ a/kernel/kexec.c
@@ -1359,6 +1359,10 @@ static int __init parse_crashkernel_simp
 
 	if (*cur == '@')
 		*crash_base = memparse(cur+1, &cur);
+	else if (*cur != ' ' && *cur != '\0') {
+		pr_warning("crashkernel: unrecognized char\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from zhenzhong.duan@oracle.com are

origin.patch

