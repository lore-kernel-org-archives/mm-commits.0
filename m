From: akpm@linux-foundation.org
Subject: + uml-fix-errno-usage.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:39 -0800
Message-ID: <200703060426.l264Qdt7011760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50215 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933949AbXCFE0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     um: fix errno usage
has been added to the -mm tree.  Its filename is
     uml-fix-errno-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: um: fix errno usage
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid reusing userspace errno twice - it can be cleared by libc code
everywhere (in particular printk() does clear it in my setup).

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/daemon_user.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/um/drivers/daemon_user.c~uml-fix-errno-usage arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-fix-errno-usage
+++ a/arch/um/drivers/daemon_user.c
@@ -56,30 +56,31 @@ static int connect_to_switch(struct daem
 
 	pri->control = socket(AF_UNIX, SOCK_STREAM, 0);
 	if(pri->control < 0){
+		err = -errno;
 		printk("daemon_open : control socket failed, errno = %d\n", 
-		       errno);		
-		return(-errno);
+		       -err);
+		return err;
 	}
 
 	if(connect(pri->control, (struct sockaddr *) ctl_addr, 
 		   sizeof(*ctl_addr)) < 0){
-		printk("daemon_open : control connect failed, errno = %d\n",
-		       errno);
 		err = -errno;
+		printk("daemon_open : control connect failed, errno = %d\n",
+		       -err);
 		goto out;
 	}
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if(fd < 0){
-		printk("daemon_open : data socket failed, errno = %d\n", 
-		       errno);
 		err = -errno;
+		printk("daemon_open : data socket failed, errno = %d\n",
+		       -err);
 		goto out;
 	}
 	if(bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0){
-		printk("daemon_open : data bind failed, errno = %d\n", 
-		       errno);
 		err = -errno;
+		printk("daemon_open : data bind failed, errno = %d\n",
+		       -err);
 		goto out_close;
 	}
 
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
git-gccbug.patch
