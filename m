Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533791;
	b=UIUKR41/f/1o6hklgWCCGSbpIidajo8GZiJMg7yYNdq9Q8vXUoEblPIoNBfABAl17lmE
	 EiNBBkaUvnsGhpBRt7nw5wgCVdstCjJwJ1dLGkn5CBKpFI6BZXGsUWkS0EGVZZyUdpe/4
	 xyRct5hR3GRtiWT2ltX8SOQ5BOTQaXKHzr/HlSWg93pmGM5md3OXeTM3hHWvt4n/N4vAm
	 5GNnDDIH+5vuuM0fjqKm9X36q5FPJ9/vE5woDLmILKzwJwCywuPU/8gDjj+rf92V+ndPb
	 mInvZWD82xH7X/sdtK1Zi2xIoeVJXC/g8XdwBQJ/S/XLudGNP2Yyq0uCiKxnnC73O7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533791;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=aIwAdP5UHbS8tDUKw8l17DYmdKNL9SnfxUBki7PGmEk=;
	b=CaAeD2MWrCmSptvwt2bpmR5CW/3Qkqe14B9VW7wPdKzVTUAUZbxOKgf5AbzMz0DP74hV
	 Go3uHtLNGw0FF/9LVzwgDFVrj/lGOKrc4tS4VCk7uoWTOel5LrLdrP+zTG0aW6nq3lbTZ
	 oE/yMcxl/fPFfc/YazbHt9e2c0PWh6mYuxIvykE1qKHqXyhuPNevfv4WpHL/kpuZ6BlLL
	 V+imTbXW8+YGbs/8dOzra27nobMyrhU+XquLEiiSP3ZAUbEsBb3luMqZgBdK+qRn51zDl
	 FkGY4Z1v88zYJ9zsbq+0gzXj4X0sL9Cmu5fgc4Te2Ge61GAi2+0AcaZIjnSWiywL8BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u1YLoOz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F201606A332
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u1YLoOz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F4F1F000CA;
	Tue, 20 Oct 2026 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792533791;
	bh=aIwAdP5UHbS8tDUKw8l17DYmdKNL9SnfxUBki7PGmEk=;
	h=Date:To:From:Subject;
	b=u1YLoOz8ejROrCCO/NqVJVu3V6up2L/iC6Dl1p3haM8gGA5ncXh84k3Hip3vs9pnF
	 68d3NFkEIxc1D1P5wsdONuiKkgvn0/w4UgKePzbbPTlK2ZvgDdYcUZCdpU6DUOshmE
	 M/9CaJQ8DhDp5CVx0jkUf7shBTU0V/k6xuBDJuf4=
Date: Tue, 20 Oct 2026 15:03:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,dchar@cslab.ece.ntua.gr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_maple_tree-test-maple_range_64-node-in-rcu-mode.patch added to mm-unstable branch
Message-Id: <20261020220310.D7F4F1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: test_maple_tree: test maple_range_64 node in RCU mode
has been added to the -mm mm-unstable branch.  Its filename is
     test_maple_tree-test-maple_range_64-node-in-rcu-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_maple_tree-test-maple_range_64-node-in-rcu-mode.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Subject: test_maple_tree: test maple_range_64 node in RCU mode
Date: Mon, 05 Oct 2026 12:47:28 +0000

This commit adds a test that builds two maple_range_64 trees in RCU
mode.  The first tree has a root that is a full maple_range_64 node and
ensures that the destruction under RCU does not misinterpret the last
slot as metadata. 226 insertions produce such a root on a 64-bit build.

The second tree is a height 3 tree whose root holds 15 child pointers
and metadata in its last slot, so every slot is non-zero and ensures
that the destruction under RCU does not descend into the metadata slot.
3166 insertions produce such a tree on a 64-bit build.

Link: https://lore.kernel.org/20261005-fix-maple-tree-range64-rcu-v3-2-ebe7fb278e20@cslab.ece.ntua.gr
Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 lib/test_maple_tree.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/lib/test_maple_tree.c~test_maple_tree-test-maple_range_64-node-in-rcu-mode
+++ a/lib/test_maple_tree.c
@@ -3710,6 +3710,36 @@ static noinline void __init alloc_cyclic
 	MT_BUG_ON(mt, ret != 1);
 }
 
+static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
+{
+	unsigned long i;
+	unsigned long nr_entries = 226; /* Build a full maple_range_64 root node */
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+
+	for (i = 0; i < nr_entries; i++) {
+		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
+						      xa_mk_value(i)));
+	}
+
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	nr_entries = 3166; /* Height 3. Root has 15 children + metadata */
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+
+	for (i = 0; i < nr_entries; i++) {
+		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
+						      xa_mk_value(i)));
+	}
+
+	mtree_destroy(mt);
+	rcu_barrier();
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -3999,6 +4029,8 @@ static int __init maple_tree_seed(void)
 	alloc_cyclic_testing(&tree);
 	mtree_destroy(&tree);
 
+	check_range64_in_rcu(&tree);
+
 
 #if defined(BENCH)
 skip:
_

Patches currently in -mm which might be from dchar@cslab.ece.ntua.gr are

maple_tree-fix-maple_range_64-crashes-in-rcu-mode.patch
test_maple_tree-test-maple_range_64-node-in-rcu-mode.patch

