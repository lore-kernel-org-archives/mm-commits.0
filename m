From: akpm@linux-foundation.org
Subject: [merged] dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:41 -0700
Message-ID: <200904141950.n3EJofTX020279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338AbZDNTyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, gnb@sgi.com, greg@kroah.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dynamic debug: resurrect old pr_debug() semantics as pr_devel()
has been removed from the -mm tree.  Its filename was
     dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

