Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024FB23D7
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 00:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730249703; cv=none; b=X2jHTLHKEhueBl1M5HvarvnNE+qRc6eE8JcwhuqzwmNi6LzClnEhBbfRG4nec7iOXvVnK+xa5S1bX/KN2eb47QrZWfX4Hv8MYKE18nj5ZyLVoz5vUSdoq9BJAO0uLzYBAR39zioIhvCdvdmYvVYUN3msOal/nik0Ty0njEuCrNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730249703; c=relaxed/simple;
	bh=6EhVAH47zWctqERMurG2v9Ql2FSDPny+WZ9pYcsJQaA=;
	h=Date:To:From:Subject:Message-Id; b=E8o4dK/YFtAkAaef3qiHXgQ7pWxOBotmcsF8oh3BM7/6zNJZ0H8y7iu9pvK/5nZi+xiBNosKqBadCmKO4cBOzpwkLD5aDhrhVAN1PCcIVTPs+va0qUUvNKiMxMlgP1/t1myaf6S6CNCMbvQyaFIydndoRoS3sTeAIvWOajVivq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1hX1RuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1hX1RuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B67EC4CECD;
	Wed, 30 Oct 2024 00:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730249702;
	bh=6EhVAH47zWctqERMurG2v9Ql2FSDPny+WZ9pYcsJQaA=;
	h=Date:To:From:Subject:From;
	b=Z1hX1RuWQiEJXBcp4OKQ6VRHnj5rH05htM7AZ6jdTSr7guXbr/kOyzU1MEORCvJ5P
	 Mlr04RKDKbWbrr6umYiPqloiMRAJkkgSYlMtUItvel3KHnR7XY0DVH9RSzmVpomsBU
	 6nf8BYAj8MSxjK8oeStpcSHooYWp2iG7W8hlcQ54=
Date: Tue, 29 Oct 2024 17:55:01 -0700
To: mm-commits@vger.kernel.org,jonathan.cameron@huawei.com,david@redhat.com,dave@stgolabs.net,dave.jiang@intel.com,dan.j.williams@intel.com,bhe@redhat.com,bhelgaas@google.com,apopple@nvidia.com,andriy.shevchenko@linux.intel.com,alison.schofield@intel.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects.patch added to mm-nonmm-unstable branch
Message-Id: <20241030005502.6B67EC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: avoid unnecessary resource tree walking in __region_intersects()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: resource: avoid unnecessary resource tree walking in __region_intersects()
Date: Tue, 29 Oct 2024 20:27:35 +0800

Currently, if __region_intersects() finds any overlapped but unmatched
resource, it walks the descendant resource tree to check for overlapped
and matched descendant resources using for_each_resource().  However, in
current kernel, for_each_resource() iterates not only the descendant tree,
but also subsequent sibling trees in certain scenarios.  While this
doesn't introduce bugs, it makes code hard to be understood and
potentially inefficient.

So, the patch revises next_resource() and for_each_resource() and makes
for_each_resource() traverse the subtree under the specified subtree root
only.  Test shows that this avoids unnecessary resource tree walking in
__region_intersects().

For the example resource tree as follows,

  X
  |
  A----D----E
  |
  B--C

if 'A' is the overlapped but unmatched resource, original kernel
iterates 'B', 'C', 'D', 'E' when it walks the descendant tree.  While
the patched kernel iterates only 'B', 'C'.

Thanks David Hildenbrand for providing a good resource tree example.

Link: https://lkml.kernel.org/r/20241029122735.79164-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/kernel/resource.c~resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects
+++ a/kernel/resource.c
@@ -50,17 +50,35 @@ EXPORT_SYMBOL(iomem_resource);
 
 static DEFINE_RWLOCK(resource_lock);
 
-static struct resource *next_resource(struct resource *p, bool skip_children)
+/*
+ * Return the next node of @p in pre-order tree traversal.  If
+ * @skip_children is true, skip the descendant nodes of @p in
+ * traversal.  If @p is a descendant of @subtree_root, only traverse
+ * the subtree under @subtree_root.
+ */
+static struct resource *next_resource(struct resource *p, bool skip_children,
+				      struct resource *subtree_root)
 {
 	if (!skip_children && p->child)
 		return p->child;
-	while (!p->sibling && p->parent)
+	while (!p->sibling && p->parent) {
 		p = p->parent;
+		if (p == subtree_root)
+			return NULL;
+	}
 	return p->sibling;
 }
 
+/*
+ * Traverse the resource subtree under @_root in pre-order, excluding
+ * @_root itself.
+ *
+ * NOTE: '__p' is introduced to avoid shadowing '_p' outside of loop.
+ * And it is referenced to avoid unused variable warning.
+ */
 #define for_each_resource(_root, _p, _skip_children) \
-	for ((_p) = (_root)->child; (_p); (_p) = next_resource(_p, _skip_children))
+	for (typeof(_root) __root = (_root), __p = _p = __root->child;	\
+	     __p && _p; _p = next_resource(_p, _skip_children, __root))
 
 #ifdef CONFIG_PROC_FS
 
@@ -88,7 +106,7 @@ static void *r_next(struct seq_file *m,
 
 	(*pos)++;
 
-	return (void *)next_resource(p, false);
+	return (void *)next_resource(p, false, NULL);
 }
 
 static void r_stop(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from ying.huang@intel.com are

resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects.patch

