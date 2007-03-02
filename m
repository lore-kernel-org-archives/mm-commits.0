From: akpm@linux-foundation.org
Subject: + rcutorture-mark-rcu_torture_init-as-__init.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:22:06 -0800
Message-ID: <200703020122.l221M6x3028601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422678AbXCBBWO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:22:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@freedesktop.org, paulmck@us.ibm.com


The patch titled
     rcutorture: Mark rcu_torture_init as __init
has been added to the -mm tree.  Its filename is
     rcutorture-mark-rcu_torture_init-as-__init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcutorture: Mark rcu_torture_init as __init
From: Josh Triplett <josh@freedesktop.org>

The corresponding rcu_torture_cleanup cannot get marked as __exit, because
rcu_torture_init uses it to clean up if init fails.

Signed-off-by: Josh Triplett <josh@freedesktop.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~rcutorture-mark-rcu_torture_init-as-__init kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-mark-rcu_torture_init-as-__init
+++ a/kernel/rcutorture.c
@@ -933,7 +933,7 @@ rcu_torture_cleanup(void)
 		rcu_torture_print_module_parms("End of test: SUCCESS");
 }
 
-static int
+static int __init
 rcu_torture_init(void)
 {
 	int i;
_

Patches currently in -mm which might be from josh@freedesktop.org are

git-block.patch
rcutorture-mark-rcu_torture_init-as-__init.patch
