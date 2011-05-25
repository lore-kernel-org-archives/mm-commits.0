From: akpm@linux-foundation.org
Subject: [merged] um-remove-sighup-handler.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:56 -0700
Message-ID: <201105252029.p4PKTK7L014832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130Ab1EYU3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: remove SIGHUP handler
has been removed from the -mm tree.  Its filename was
     um-remove-sighup-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: remove SIGHUP handler
From: Richard Weinberger <richard@nod.at>

The UML kernel ignores SIGHUP anyway.  This handler is in vain.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/um/os-Linux/main.c~um-remove-sighup-handler arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~um-remove-sighup-handler
+++ a/arch/um/os-Linux/main.c
@@ -142,7 +142,6 @@ int __init main(int argc, char **argv, c
 	 */
 	install_fatal_handler(SIGINT);
 	install_fatal_handler(SIGTERM);
-	install_fatal_handler(SIGHUP);
 
 	scan_elf_aux(envp);
 
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch

