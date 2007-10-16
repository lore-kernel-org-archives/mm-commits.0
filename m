From: akpm@linux-foundation.org
Subject: - uml-more-idiomatic-parameter-parsing.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:34 -0700
Message-ID: <200710162038.l9GKcYqp015460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935793AbXJPVH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: more idiomatic parameter parsing
has been removed from the -mm tree.  Its filename was
     uml-more-idiomatic-parameter-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: more idiomatic parameter parsing
From: Jeff Dike <jdike@addtoit.com>

Make mconsole parameter parsing slightly more idiomatic.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-more-idiomatic-parameter-parsing arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-more-idiomatic-parameter-parsing
+++ a/arch/um/drivers/mconsole_kern.c
@@ -878,7 +878,7 @@ void unlock_notify(void)
 
 __initcall(create_proc_mconsole);
 
-#define NOTIFY "=notify:"
+#define NOTIFY "notify:"
 
 static int mconsole_setup(char *str)
 {
@@ -890,7 +890,7 @@ static int mconsole_setup(char *str)
 	return 1;
 }
 
-__setup("mconsole", mconsole_setup);
+__setup("mconsole=", mconsole_setup);
 
 __uml_help(mconsole_setup,
 "mconsole=notify:<socket>\n"
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
