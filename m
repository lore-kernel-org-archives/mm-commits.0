From: akpm@linux-foundation.org
Subject: - kprobes-make-kprobesymbol_name-const.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:39 -0700
Message-ID: <200705090246.l492kdRS008885@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934142AbXEICqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: Make kprobe.symbol_name const
has been removed from the -mm tree.  Its filename was
     kprobes-make-kprobesymbol_name-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kprobes: Make kprobe.symbol_name const
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Kprobes doesn't scribble the kprobe.symbol_name field.  Its only set by the
module when registering the probe.  Modules that exercise good hygiene
using the "const" qualifier will see warnings...

	warning: assignment discards qualifiers from pointer target type

Make struct kprobe.symbol_name const char *

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kprobes.h~kprobes-make-kprobesymbol_name-const include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-make-kprobesymbol_name-const
+++ a/include/linux/kprobes.h
@@ -78,7 +78,7 @@ struct kprobe {
 	kprobe_opcode_t *addr;
 
 	/* Allow user to indicate symbol name of the probe point */
-	char *symbol_name;
+	const char *symbol_name;
 
 	/* Offset into the symbol */
 	unsigned int offset;
_

Patches currently in -mm which might be from ananth@in.ibm.com are

origin.patch
