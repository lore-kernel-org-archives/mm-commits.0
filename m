From: akpm@linux-foundation.org
Subject: + kexec-add-further-check-to-crashkernel.patch added to -mm tree
Date: Tue, 13 Mar 2012 12:54:24 -0700
Message-ID: <20120313195424.93FCEA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44718 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2CMTy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 15:54:27 -0400
Received: by bkcjm19 with SMTP id jm19so45983bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 12:54:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenzhong.duan@oracle.com, ebiederm@xmission.com


The patch titled
     Subject: kexec: add further check to crashkernel
has been added to the -mm tree.  Its filename is
     kexec-add-further-check-to-crashkernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kexec: add further check to crashkernel

Patches currently in -mm which might be from zhenzhong.duan@oracle.com are

linux-next.patch
kexec-add-further-check-to-crashkernel.patch

