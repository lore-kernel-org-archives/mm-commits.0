From: akpm@linux-foundation.org
Subject: + kprobes-make-kprobesymbol_name-const.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:53:25 -0800
Message-ID: <200703151853.l2FIrRY7023412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbXCOSxg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:53:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com, jkenisto@us.ibm.com


The patch titled
     Kprobes: Make kprobe.symbol_name const
has been added to the -mm tree.  Its filename is
     kprobes-make-kprobesymbol_name-const.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kprobes-make-kprobesymbol_name-const.patch
