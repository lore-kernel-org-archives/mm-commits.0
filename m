Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4337A23716B
	for <mm-commits@vger.kernel.org>; Tue,  8 Apr 2025 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744127162; cv=none; b=iTcG7edcX5zO3Mj0AnuKtUWQHDAi4FfoAnGbFbzyhNB97mEBpXAvyEzRlCenAYjFkY7Iu90vZ+6jYZogiwJFNAO0wkmOwLNIBJemt0pKfcPifhEROrvKE+++6OhPpEUzuyfkf42ByIkgIlcyTFmoKpwvVyIgG3fdOdphHOKdmLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744127162; c=relaxed/simple;
	bh=wVcnMg9Bu7S5mypB6CZTQZbOMOYtgfDqmdWk4B6qw2Q=;
	h=Date:To:From:Subject:Message-Id; b=QE39WpbmzZ/qUP5sEWab/IEZnQUUNRY69F1NQzx5Q4ioHda+8/5dEYuTHrwc/dLRrfFBi9FHAivIp7ZncVUNgY+tvGRcKoaBKNt6BRUJYEa/S1aNLD+DqGG7T65cbWXgfvjAv25OIRA0rJAGaljEQzERvD4scmctNxMfEBqG8Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jtxKFReS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jtxKFReS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1830C4CEE9;
	Tue,  8 Apr 2025 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744127161;
	bh=wVcnMg9Bu7S5mypB6CZTQZbOMOYtgfDqmdWk4B6qw2Q=;
	h=Date:To:From:Subject:From;
	b=jtxKFReSuZdtT1FpTvjFHDIeywO526quNDaECF5oCGfOoMCe+36MY6IocPn4g745x
	 lFEEjQGp6jyP3BwfdiMJwu08MH8475Z9KnmWpI5uLE9Rqi9Rf7HuAkbmdTUTw6ekJs
	 5gpGCFQVRxfPspyHA7IQ+y/UXsq8f6oqCDD02v7c=
Date: Tue, 08 Apr 2025 08:46:01 -0700
To: mm-commits@vger.kernel.org,hch@infradead.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-switch-to-for_each_vmap_node-helper.patch added to mm-new branch
Message-Id: <20250408154601.A1830C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: switch to for_each_vmap_node() helper
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-switch-to-for_each_vmap_node-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-switch-to-for_each_vmap_node-helper.patch

This patch will later appear in the mm-new branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: switch to for_each_vmap_node() helper
Date: Tue, 8 Apr 2025 17:15:48 +0200

There are places which can be updated easily to use the helper to iterate
over all vmap-nodes.  This is what this patch does.

The aim is to improve readability and simplify the code.

Link: https://lkml.kernel.org/r/20250408151549.77937-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/mm/vmalloc.c~vmalloc-switch-to-for_each_vmap_node-helper
+++ a/mm/vmalloc.c
@@ -1061,12 +1061,11 @@ find_vmap_area_exceed_addr_lock(unsigned
 {
 	unsigned long va_start_lowest;
 	struct vmap_node *vn;
-	int i;
 
 repeat:
-	for (i = 0, va_start_lowest = 0; i < nr_vmap_nodes; i++) {
-		vn = &vmap_nodes[i];
+	va_start_lowest = 0;
 
+	for_each_vmap_node(vn) {
 		spin_lock(&vn->busy.lock);
 		*va = __find_vmap_area_exceed_addr(addr, &vn->busy.root);
 
@@ -4946,11 +4945,8 @@ static void show_purge_info(struct seq_f
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
-	int i;
-
-	for (i = 0; i < nr_vmap_nodes; i++) {
-		vn = &vmap_nodes[i];
 
+	for_each_vmap_node(vn) {
 		spin_lock(&vn->lazy.lock);
 		list_for_each_entry(va, &vn->lazy.head, list) {
 			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
@@ -4966,11 +4962,8 @@ static int vmalloc_info_show(struct seq_
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	struct vm_struct *v;
-	int i;
-
-	for (i = 0; i < nr_vmap_nodes; i++) {
-		vn = &vmap_nodes[i];
 
+	for_each_vmap_node(vn) {
 		spin_lock(&vn->busy.lock);
 		list_for_each_entry(va, &vn->busy.head, list) {
 			if (!va->vm) {
@@ -5123,8 +5116,7 @@ static void vmap_init_nodes(void)
 	}
 #endif
 
-	for (n = 0; n < nr_vmap_nodes; n++) {
-		vn = &vmap_nodes[n];
+	for_each_vmap_node(vn) {
 		vn->busy.root = RB_ROOT;
 		INIT_LIST_HEAD(&vn->busy.head);
 		spin_lock_init(&vn->busy.lock);
@@ -5145,15 +5137,13 @@ static void vmap_init_nodes(void)
 static unsigned long
 vmap_node_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	unsigned long count;
+	unsigned long count = 0;
 	struct vmap_node *vn;
-	int i, j;
-
-	for (count = 0, i = 0; i < nr_vmap_nodes; i++) {
-		vn = &vmap_nodes[i];
+	int i;
 
-		for (j = 0; j < MAX_VA_SIZE_PAGES; j++)
-			count += READ_ONCE(vn->pool[j].len);
+	for_each_vmap_node(vn) {
+		for (i = 0; i < MAX_VA_SIZE_PAGES; i++)
+			count += READ_ONCE(vn->pool[i].len);
 	}
 
 	return count ? count : SHRINK_EMPTY;
@@ -5162,10 +5152,10 @@ vmap_node_shrink_count(struct shrinker *
 static unsigned long
 vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	int i;
+	struct vmap_node *vn;
 
-	for (i = 0; i < nr_vmap_nodes; i++)
-		decay_va_pool_node(&vmap_nodes[i], true);
+	for_each_vmap_node(vn)
+		decay_va_pool_node(vn, true);
 
 	return SHRINK_STOP;
 }
_

Patches currently in -mm which might be from urezki@gmail.com are

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch

