From: akpm@osdl.org
Subject: + fix-for-crash-in-adummy_init.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:38:06 -0800
Message-ID: <200701022138.l02Lc6tI030558@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34636 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbXABVi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, chas@cmf.nrl.navy.mil, mingo@elte.hu


The patch titled
     fix for crash in adummy_init()
has been added to the -mm tree.  Its filename is
     fix-for-crash-in-adummy_init.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix for crash in adummy_init()
From: Daniel Walker <dwalker@mvista.com>

This was reported by Ingo Molnar here,

http://lkml.org/lkml/2006/12/18/119

The problem is that adummy_init() depends on atm_init() , but adummy_init()
is called first.

So I put atm_init() into subsys_initcall which seems appropriate, and it
will still get module_init() if it becomes a module.

Interesting to note that you could crash your system here if you just load
the modules in the wrong order.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/atm/common.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN net/atm/common.c~fix-for-crash-in-adummy_init net/atm/common.c
--- a/net/atm/common.c~fix-for-crash-in-adummy_init
+++ a/net/atm/common.c
@@ -816,7 +816,8 @@ static void __exit atm_exit(void)
 	proto_unregister(&vcc_proto);
 }
 
-module_init(atm_init);
+subsys_initcall(atm_init);
+
 module_exit(atm_exit);
 
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dwalker@mvista.com are

fix-for-crash-in-adummy_init.patch
panic-on-slim-selinux.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
