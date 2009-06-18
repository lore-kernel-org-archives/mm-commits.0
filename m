From: akpm@linux-foundation.org
Subject: [merged] utsns-extract-creeate_uts_ns.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:34 -0700
Message-ID: <200906182247.n5IMlYvd006658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807AbZFRW5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     utsns: extract creeate_uts_ns()
has been removed from the -mm tree.  Its filename was
     utsns-extract-creeate_uts_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: utsns: extract creeate_uts_ns()
From: Alexey Dobriyan <adobriyan@gmail.com>

create_uts_ns() will be used by C/R to create fresh uts_ns.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/utsname.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN kernel/utsname.c~utsns-extract-creeate_uts_ns kernel/utsname.c
--- a/kernel/utsname.c~utsns-extract-creeate_uts_ns
+++ a/kernel/utsname.c
@@ -15,6 +15,16 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
+static struct uts_namespace *create_uts_ns(void)
+{
+	struct uts_namespace *uts_ns;
+
+	uts_ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
+	if (uts_ns)
+		kref_init(&uts_ns->kref);
+	return uts_ns;
+}
+
 /*
  * Clone a new ns copying an original utsname, setting refcount to 1
  * @old_ns: namespace to clone
@@ -24,14 +34,13 @@ static struct uts_namespace *clone_uts_n
 {
 	struct uts_namespace *ns;
 
-	ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
+	ns = create_uts_ns();
 	if (!ns)
 		return ERR_PTR(-ENOMEM);
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
 	up_read(&uts_sem);
-	kref_init(&ns->kref);
 	return ns;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
procfs-provide-stack-information-for-threads-v08.patch

