From: akpm@osdl.org
Subject: + uml-make-two-variables-static.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:56:23 -0800
Message-ID: <200701022256.l02MuN9c032716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41339 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965033AbXABW4h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:56:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: make two variables static
has been added to the -mm tree.  Its filename is
     uml-make-two-variables-static.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: make two variables static
From: Jeff Dike <jdike@addtoit.com>

Make a couple of variables static.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/port_kern.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
