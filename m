From: akpm@linux-foundation.org
Subject: + iucv-fix-compilation-on-s390-up.patch added to -mm tree
Date: Sat, 07 Apr 2007 15:25:43 -0700
Message-ID: <200704072225.l37MPhuJ011291@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35120 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965990AbXDGW0O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 18:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, davem@davemloft.net, heiko.carstens@de.ibm.com


The patch titled
     iucv: fix compilation on s390-up
has been added to the -mm tree.  Its filename is
     iucv-fix-compilation-on-s390-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iucv: fix compilation on s390-up
From: Alexey Dobriyan <adobriyan@gmail.com>

  CC [M]  net/iucv/iucv.o
net/iucv/iucv.c: In function 'iucv_init':
net/iucv/iucv.c:1556: error: 'iucv_cpu_notifier' undeclared (first use in this function)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/iucv/iucv.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN net/iucv/iucv.c~iucv-fix-compilation-on-s390-up net/iucv/iucv.c
--- a/net/iucv/iucv.c~iucv-fix-compilation-on-s390-up
+++ a/net/iucv/iucv.c
@@ -519,7 +519,6 @@ static void iucv_disable(void)
 	kfree(iucv_path_table);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 				     unsigned long action, void *hcpu)
 {
@@ -565,7 +564,6 @@ static int __cpuinit iucv_cpu_notify(str
 static struct notifier_block iucv_cpu_notifier = {
 	.notifier_call = iucv_cpu_notify,
 };
-#endif
 
 /**
  * iucv_sever_pathid
_

Patches currently in -mm which might be from adobriyan@gmail.com are

iucv-fix-compilation-on-s390-up.patch
git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
git-watchdog.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
i386-schedh-inclusion-from-moduleh-is-baack.patch
