Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DEC1925BC
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011072; cv=none; b=AspZWWg59GKGN2jPrRgbWcHogoRwXObcekYPMQtX1zABBHdhLhPrT4bsZ1g2KE0M26+KvW9rUCJNhHQC5ojj5nOxGevxf7uXJ+JscvD1/mAnQxSZy+Wh0IxwhijU9Q9FX7Q5bA4sE+cAUknqNYYqPrEU4lwKRtDxbaRcxPyGdig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011072; c=relaxed/simple;
	bh=7Berr0gIKPYYA+7Gkj/Y7+Ly/qMGFlXQrP3ihBwT7Ao=;
	h=Date:To:From:Subject:Message-Id; b=Xt/dcZz/7mMzFdtdem/iEeTPcH7p7CvZhEDkw9Z3KEjpao9xM/SsmTOHTCvoZhZUTZrZHkgCQC3zHYluCY7eExMpRCndaGXZzbAE7sONt1UZBON69DHfiJYpONGJ/UMQiTq26vtU8EqutlVQvYTMnYg5xEaZ2QTSVi90pnZC9kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wlOUkeuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wlOUkeuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FBDC4CEE4;
	Mon, 12 May 2025 00:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011071;
	bh=7Berr0gIKPYYA+7Gkj/Y7+Ly/qMGFlXQrP3ihBwT7Ao=;
	h=Date:To:From:Subject:From;
	b=wlOUkeuS5QgtDhfuw1b3x4rTe03FLQu4EJ/1N7h4dEd+bwuOXwnJPMWmmG23iRxVY
	 4JOJtjvCfVLHvuvY/1UsBUPLOlpBtT+KGfkBD5J8z1KQu0nsbagIVg4b52neEZQ209
	 2wuSN2rKQGew9y/Qpij4uTt5/N1c1vEQsA9Y9CIs=
Date: Sun, 11 May 2025 17:51:11 -0700
To: mm-commits@vger.kernel.org,hch@infradead.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-switch-to-for_each_vmap_node-helper.patch removed from -mm tree
Message-Id: <20250512005111.C8FBDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: switch to for_each_vmap_node() helper
has been removed from the -mm tree.  Its filename was
     vmalloc-switch-to-for_each_vmap_node-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: switch to for_each_vmap_node() helper
Date: Tue, 8 Apr 2025 17:15:48 +0200

There are places which can be updated easily to use the helper to iterate
over all vmap-nodes.  This is what this patch does.

The aim is to improve readability and simplify the code.

[akpm@linux-foundation.org: fix build warning]
Link: https://lkml.kernel.org/r/20250408151549.77937-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

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
 
@@ -4963,11 +4962,8 @@ static void show_purge_info(struct seq_f
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
@@ -4983,11 +4979,8 @@ static int vmalloc_info_show(struct seq_
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
@@ -5108,7 +5101,7 @@ static void __init vmap_init_free_space(
 static void vmap_init_nodes(void)
 {
 	struct vmap_node *vn;
-	int i, n;
+	int i;
 
 #if BITS_PER_LONG == 64
 	/*
@@ -5125,7 +5118,7 @@ static void vmap_init_nodes(void)
 	 * set of cores. Therefore a per-domain purging is supposed to
 	 * be added as well as a per-domain balancing.
 	 */
-	n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
+	int n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
 
 	if (n > 1) {
 		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT | __GFP_NOWARN);
@@ -5140,8 +5133,7 @@ static void vmap_init_nodes(void)
 	}
 #endif
 
-	for (n = 0; n < nr_vmap_nodes; n++) {
-		vn = &vmap_nodes[n];
+	for_each_vmap_node(vn) {
 		vn->busy.root = RB_ROOT;
 		INIT_LIST_HEAD(&vn->busy.head);
 		spin_lock_init(&vn->busy.lock);
@@ -5162,15 +5154,13 @@ static void vmap_init_nodes(void)
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
@@ -5179,10 +5169,10 @@ vmap_node_shrink_count(struct shrinker *
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

maintainers-add-myself-as-vmalloc-co-maintainer.patch

