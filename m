From: akpm@osdl.org
Subject: + sysctl-remove-insert_at_head-from-register_sysctl-fix.patch added to -mm tree
Date: Fri, 26 Jan 2007 12:54:19 -0800
Message-ID: <200701262054.l0QKsJI7026254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbXAZUyW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 15:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, ebiederm@xmission.com


The patch titled
     sysctl-remove-insert_at_head-from-register_sysctl fix
has been added to the -mm tree.  Its filename is
     sysctl-remove-insert_at_head-from-register_sysctl-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl-remove-insert_at_head-from-register_sysctl fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

kernel/sched.c: In function 'init_sched_domain_sysctl':
kernel/sched.c:5465: error: too many arguments to function 'register_sysctl_table'

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sysctl-remove-insert_at_head-from-register_sysctl-fix kernel/sched.c
--- a/kernel/sched.c~sysctl-remove-insert_at_head-from-register_sysctl-fix
+++ a/kernel/sched.c
@@ -5462,7 +5462,7 @@ static void init_sched_domain_sysctl(voi
 		entry->mode = 0755;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
-	sd_sysctl_header = register_sysctl_table(sd_ctl_root, 0);
+	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
 }
 #else
 static void init_sched_domain_sysctl(void)
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

drivers-scsi-pcmcia-nsp_csh-removal-of-old.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
touchkit-ps-2-touchscreen-driver.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
