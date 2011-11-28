From: akpm@linux-foundation.org
Subject: + kdump-crashk_res-init-check-for-sys-kernel-kexec_crash_size.patch added to -mm tree
Date: Mon, 28 Nov 2011 14:18:11 -0800
Message-ID: <201111282218.pASMIBsx004703@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:33945 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1WSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 17:18:14 -0500
Received: by qyk15 with SMTP id 15so357293qyk.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 14:18:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, vgoyal@redhat.com, xiyou.wangcong@gmail.com


The patch titled
     Subject: kdump: crashk_res init check for /sys/kernel/kexec_crash_size
has been added to the -mm tree.  Its filename is
     kdump-crashk_res-init-check-for-sys-kernel-kexec_crash_size.patch

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
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: crashk_res init check for /sys/kernel/kexec_crash_size

Currently it is possible to set the crash_size via the sysfs
/sys/kernel/kexec_crash_size even if no crash kernel memory has been
defined with the "crashkernel" parameter.  In this case "crashk_res" is
not initialized and crashk_res.start = crashk_res.end = 0.  Unfortunately
resource_size(&crashk_res) returns 1 in this case.  This breaks the s390
implementation of crash_(un)map_reserved_pages().

To fix the problem the correct "old_size" is now calculated in
crash_shrink_memory().  "old_size is set to "0" if crashk_res is not
initialized.  With this change crash_shrink_memory() will do nothing, when
"crashk_res" is not initialized.  It will return "0" for "echo 0 >
/sys/kernel/kexec_crash_size" and -EINVAL for "echo [not zero] >
/sys/kernel/kexec_crash_size".

In addition to that this patch also simplifies the "ret = -EINVAL" vs. 
"ret = 0" logic as suggested by Simon Horman.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reviewed-by: Dave Young <dyoung@redhat.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/kexec.c~kdump-crashk_res-init-check-for-sys-kernel-kexec_crash_size kernel/kexec.c
--- a/kernel/kexec.c~kdump-crashk_res-init-check-for-sys-kernel-kexec_crash_size
+++ a/kernel/kexec.c
@@ -1129,6 +1129,7 @@ int crash_shrink_memory(unsigned long ne
 {
 	int ret = 0;
 	unsigned long start, end;
+	unsigned long old_size;
 	struct resource *ram_res;
 
 	mutex_lock(&kexec_mutex);
@@ -1139,11 +1140,9 @@ int crash_shrink_memory(unsigned long ne
 	}
 	start = crashk_res.start;
 	end = crashk_res.end;
