From: akpm@linux-foundation.org
Subject: + uml-fix-a-memory-leak-in-the-multicast-driver.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:29 -0800
Message-ID: <200703060426.l264QT0w011743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933944AbXCFE0b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     um: fix a memory leak in the multicast driver
has been added to the -mm tree.  Its filename is
     uml-fix-a-memory-leak-in-the-multicast-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: um: fix a memory leak in the multicast driver
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Memory allocated by mcast_user_init must be freed in the matching mcast_remove.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mcast_user.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/mcast_user.c~uml-fix-a-memory-leak-in-the-multicast-driver arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-fix-a-memory-leak-in-the-multicast-driver
+++ a/arch/um/drivers/mcast_user.c
@@ -50,6 +50,14 @@ static void mcast_user_init(void *data, 
 	pri->dev = dev;
 }
 
+static void mcast_remove(void *data)
+{
+	struct mcast_data *pri = data;
+
+	kfree(pri->mcast_addr);
+	pri->mcast_addr = NULL;
+}
+
 static int mcast_open(void *data)
 {
 	struct mcast_data *pri = data;
@@ -157,7 +165,7 @@ const struct net_user_info mcast_user_in
 	.init		= mcast_user_init,
 	.open		= mcast_open,
 	.close	 	= mcast_close,
-	.remove	 	= NULL,
+	.remove	 	= mcast_remove,
 	.set_mtu	= mcast_set_mtu,
 	.add_address	= NULL,
 	.delete_address = NULL,
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
