From: akpm@linux-foundation.org
Subject: - add-weak-for-creating-weak-asm-labels.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:34 -0700
Message-ID: <200710230647.l9N6lY5w004293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbXJWG4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, hpa@zytor.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     add WEAK() for creating weak asm labels
has been removed from the -mm tree.  Its filename was
     add-weak-for-creating-weak-asm-labels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add WEAK() for creating weak asm labels
From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/linkage.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/linkage.h~add-weak-for-creating-weak-asm-labels include/linux/linkage.h
--- a/include/linux/linkage.h~add-weak-for-creating-weak-asm-labels
+++ a/include/linux/linkage.h
@@ -34,6 +34,12 @@
   name:
 #endif
 
+#ifndef WEAK
+#define WEAK(name)	   \
+	.weak name;	   \
+	name:
+#endif
+
 #define KPROBE_ENTRY(name) \
   .pushsection .kprobes.text, "ax"; \
   ENTRY(name)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
reiser4.patch
