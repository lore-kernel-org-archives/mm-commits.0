Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FEBEEA6
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729735930; cv=none; b=tA2jtSUobc1YsNI5Dqls0p41S7SNrN4ggkhxF1Ga1fpNvDGpEuit3p5pUlv2ghCGjn/39g/Agik+dnmDYbEdqG6dJiak+7m+pV6/AQqBmiJxYT++Mm4+h0DUXbmZjUWdJZDgzPbgaUsGiCOzqCG27F8n/+a9cFJBkssNRSww4Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729735930; c=relaxed/simple;
	bh=PDofAnLzCaDpKHMoWRPUPRb1UM7iUdU1uS88ZSvUIys=;
	h=Date:To:From:Subject:Message-Id; b=A5NoZsuTrukwRNnnSyvRISjYO5afj99dN9Ju4/BqawSWzLT7cMGofPf0xlTgFsC0d7CCRMpK3J/BvGFthfy0n1SzzPiFH8r3JJ0fMl7UtYMqhNx6uz8NAgeUFrpqLwXjV7TPvltlJjjx8Qemmwxk6YX4QZyOQPLUt0PGph66q8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RdSU5wsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RdSU5wsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D365EC4CEC6;
	Thu, 24 Oct 2024 02:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729735929;
	bh=PDofAnLzCaDpKHMoWRPUPRb1UM7iUdU1uS88ZSvUIys=;
	h=Date:To:From:Subject:From;
	b=RdSU5wsJ1HrjeGa/ovkiP7VSsA/q12nps4C7eEkjFvFHxUdI2xBtrsD5szkz84xEd
	 bOlcCvkJ4nJzJDT/XDs1qi/rbXuB+tIGbPYnD1TZ2ieinQFVtdkHbixl0ZeDKhwH5L
	 0t8McHos/LS/TOThJapCbkbYBDGfv/amkq/QZUW0=
Date: Wed, 23 Oct 2024 19:12:09 -0700
To: mm-commits@vger.kernel.org,jonathan.cameron@huawei.com,david@redhat.com,dave@stgolabs.net,dave.jiang@intel.com,dan.j.williams@intel.com,bhe@redhat.com,bhelgaas@google.com,apopple@nvidia.com,andriy.shevchenko@linux.intel.com,alison.schofield@intel.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects.patch added to mm-nonmm-unstable branch
Message-Id: <20241024021209.D365EC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: Avoid unnecessary resource tree walking in __region_intersects()
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
Subject: resource: Avoid unnecessary resource tree walking in __region_intersects()
Date: Tue, 22 Oct 2024 13:38:35 +0800

Currently, if __region_intersects() finds any overlapped but unmatched
resource, it walks the descendant resource tree to check for
overlapped and matched descendant resources.  This is achieved using
for_each_resource(), which iterates not only the descendant tree, but
also subsequent sibling trees in certain scenarios.  While this
doesn't introduce bugs, it makes code hard to be understood and
potentially inefficient.

So, the patch renames next_resource() to __next_resource(), and makes
it possible to only traverse the subtree under the specified resource.
Test shows that this avoids unnecessary resource tree walking in
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

It appears even better to revise for_each_resource() to traverse the
resource subtree under "_root" only.  But that will cause "_root" to
be evaluated twice, which I don't find a good way to eliminate.

Thanks David Hildenbrand for providing a good resource tree example.

Link: https://lkml.kernel.org/r/20241022053835.217703-1-ying.huang@intel.com
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

 kernel/resource.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/kernel/resource.c~resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects
+++ a/kernel/resource.c
@@ -50,15 +50,34 @@ EXPORT_SYMBOL(iomem_resource);
 
 static DEFINE_RWLOCK(resource_lock);
 
-static struct resource *next_resource(struct resource *p, bool skip_children)
+/*
+ * Return the next node of @p in pre-order tree traversal.  If
+ * @skip_children is true, skip the descendant nodes of @p in
+ * traversal.  If @p is a descendant of @subtree_root, only traverse
+ * the subtree under @subtree_root.
+ */
+static struct resource *__next_resource(struct resource *p, bool skip_children,
+					struct resource *subtree_root)
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
 
+static struct resource *next_resource(struct resource *p, bool skip_children)
+{
+	return __next_resource(p, skip_children, NULL);
+}
+
+/*
+ * Traverse the whole resource tree with @_root as root in pre-order.
+ * NOTE: @_root should be the topmost node, that is, @_root->parent == NULL.
+ */
 #define for_each_resource(_root, _p, _skip_children) \
 	for ((_p) = (_root)->child; (_p); (_p) = next_resource(_p, _skip_children))
 
@@ -566,7 +585,8 @@ static int __region_intersects(struct re
 		 * |-- "System RAM" --||-- "CXL Window 0a" --|
 		 */
 		covered = false;
-		for_each_resource(p, dp, false) {
+		/* Traverse the subtree under 'p'. */
+		for (dp = p->child; dp; dp = __next_resource(dp, false, p)) {
 			if (!resource_overlaps(dp, &res))
 				continue;
 			if (is_type_match(dp, flags, desc)) {
_

Patches currently in -mm which might be from ying.huang@intel.com are

resource-remove-dependency-on-sparsemem-from-get_free_region.patch
resource-avoid-unnecessary-resource-tree-walking-in-__region_intersects.patch

