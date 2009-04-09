From: akpm@linux-foundation.org
Subject: + dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel.patch added to -mm tree
Date: Thu, 09 Apr 2009 14:48:24 -0700
Message-ID: <200904092148.n39LmPjN011547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757352AbZDIVvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, gnb@sgi.com, greg@kroah.com, jbaron@redhat.com


The patch titled
     dynamic debug: resurrect old pr_debug() semantics as pr_devel()
has been added to the -mm tree.  Its filename is
     dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dynamic debug: resurrect old pr_debug() semantics as pr_devel()
From: Michael Ellerman <michael@ellerman.id.au>

pr_debug() used to produce zero code unless DEBUG was #defined.  This is
now no longer the case in practice[1].

There are places where it's useful to have debugging printks, but we don't
want them to generate any code in production kernels.

So add a new macro, pr_devel(), for _devel_opment, to provide the old
semantics, ie.  if the programmer doesn't explicitly enable debugging, no
code is produced.

[1]: You can turn CONFIG_DYNAMIC_DEBUG off, but it's enabled in at least
     one distro kernel, so it's not really a solution.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Greg Banks <gnb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/kernel.h~dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel include/linux/kernel.h
--- a/include/linux/kernel.h~dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel
+++ a/include/linux/kernel.h
@@ -377,6 +377,15 @@ static inline char *pack_hex_byte(char *
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+/* pr_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug(fmt, ...) \
_

Patches currently in -mm which might be from michael@ellerman.id.au are

linux-next.patch
dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel.patch

