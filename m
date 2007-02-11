From: akpm@linux-foundation.org
Subject: - uml-make-two-variables-static.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:37 -0800
Message-ID: <200702112248.l1BMmb99015648@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668AbXBKWsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: make two variables static
has been removed from the -mm tree.  Its filename was
     uml-make-two-variables-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: make two variables static
From: Jeff Dike <jdike@addtoit.com>

Make a couple of variables static.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/port_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/port_kern.c~uml-make-two-variables-static arch/um/drivers/port_kern.c
--- a/arch/um/drivers/port_kern.c~uml-make-two-variables-static
+++ a/arch/um/drivers/port_kern.c
@@ -129,8 +129,8 @@ static int port_accept(struct port_list 
 	return(ret);
 } 
 
-DECLARE_MUTEX(ports_sem);
-struct list_head ports = LIST_HEAD_INIT(ports);
+static DECLARE_MUTEX(ports_sem);
+static struct list_head ports = LIST_HEAD_INIT(ports);
 
 void port_work_proc(struct work_struct *unused)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
