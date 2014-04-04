From: akpm@linux-foundation.org
Subject: [merged] lib-devresc-fix-some-sparse-warnings.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:33:42 -0700
Message-ID: <533f0916.eY+yxe6jjei/uSGt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaDDTdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, gregkh@linuxfoundation.org, rostedt@goodmis.org

Subject: [merged] lib-devresc-fix-some-sparse-warnings.patch removed from -mm tree
To: rostedt@goodmis.org,gregkh@linuxfoundation.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:42 -0700


The patch titled
     Subject: lib/devres.c: fix some sparse warnings
has been removed from the -mm tree.  Its filename was
     lib-devresc-fix-some-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: lib/devres.c: fix some sparse warnings

Having a discussion about sparse warnings in the kernel, and that we
should clean them up, I decided to pick a random file to do so.  This
happened to be devres.c which gives the following warnings:

  CHECK   lib/devres.c
lib/devres.c:83:9: warning: cast removes address space of expression
lib/devres.c:117:31: warning: incorrect type in return expression (different address spaces)
lib/devres.c:117:31:    expected void [noderef] <asn:2>*
lib/devres.c:117:31:    got void *
lib/devres.c:125:31: warning: incorrect type in return expression (different address spaces)
lib/devres.c:125:31:    expected void [noderef] <asn:2>*
lib/devres.c:125:31:    got void *
lib/devres.c:136:26: warning: incorrect type in assignment (different address spaces)
lib/devres.c:136:26:    expected void [noderef] <asn:2>*[assigned] dest_ptr
lib/devres.c:136:26:    got void *
lib/devres.c:226:9: warning: cast removes address space of expression

Mostly it's just the use of typecasting to void * without adding __force,
or returning ERR_PTR(-ESOMEERR) without typecasting to a __iomem type.

I added a helper macro IOMEM_ERR_PTR() that does the typecast to make the
code a little nicer than adding ugly typecasts to the code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN lib/devres.c~lib-devresc-fix-some-sparse-warnings lib/devres.c
--- a/lib/devres.c~lib-devresc-fix-some-sparse-warnings
+++ a/lib/devres.c
@@ -81,11 +81,13 @@ EXPORT_SYMBOL(devm_ioremap_nocache);
 void devm_iounmap(struct device *dev, void __iomem *addr)
 {
 	WARN_ON(devres_destroy(dev, devm_ioremap_release, devm_ioremap_match,
-			       (void *)addr));
+			       (__force void *)addr));
 	iounmap(addr);
 }
 EXPORT_SYMBOL(devm_iounmap);
 
+#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
+
 /**
  * devm_ioremap_resource() - check, request region, and ioremap resource
  * @dev: generic device to handle the resource for
@@ -114,7 +116,7 @@ void __iomem *devm_ioremap_resource(stru
 
 	if (!res || resource_type(res) != IORESOURCE_MEM) {
 		dev_err(dev, "invalid resource\n");
-		return ERR_PTR(-EINVAL);
+		return IOMEM_ERR_PTR(-EINVAL);
 	}
 
 	size = resource_size(res);
@@ -122,7 +124,7 @@ void __iomem *devm_ioremap_resource(stru
 
 	if (!devm_request_mem_region(dev, res->start, size, name)) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
-		return ERR_PTR(-EBUSY);
+		return IOMEM_ERR_PTR(-EBUSY);
 	}
 
 	if (res->flags & IORESOURCE_CACHEABLE)
@@ -133,7 +135,7 @@ void __iomem *devm_ioremap_resource(stru
 	if (!dest_ptr) {
 		dev_err(dev, "ioremap failed for resource %pR\n", res);
 		devm_release_mem_region(dev, res->start, size);
-		dest_ptr = ERR_PTR(-ENOMEM);
+		dest_ptr = IOMEM_ERR_PTR(-ENOMEM);
 	}
 
 	return dest_ptr;
@@ -224,7 +226,7 @@ void devm_ioport_unmap(struct device *de
 {
 	ioport_unmap(addr);
 	WARN_ON(devres_destroy(dev, devm_ioport_map_release,
-			       devm_ioport_map_match, (void *)addr));
+			       devm_ioport_map_match, (__force void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
 #endif /* CONFIG_HAS_IOPORT */
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
exec-kill-bprm-tcomm-simplify-the-basename-logic.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch

