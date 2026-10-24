Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832546;
	b=SoRKT7Dd9cr6I8cWEjZMYUwmozN/duIiPRA9NITEcRe8ty1Q7PDUG1pzXXgYI/wWAmzP
	 57XZT08ALoLgktWe1DJ5R3uoNLtunkzoGLvpeAKMgtJJspmkmZHkurkKMm6s6oThEnNJb
	 Q978+nfP/P5je1VZ9wer9md/7I12RgcuNImWRNJSx7tkkEUg4orwwJUsHn16EMdZHIaot
	 3KNM85lGTaRhOl9tyVO08VC34rAuuh050DDjrmyh9slkp5RXTw389DInPqEpJOmMpjJlI
	 WLdTt5xAKRY5HOQTRc7lDmWgBjyKWFUYLL837qojdUri9TjFYENXevWwL3kEtf/5WXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832546;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6FVWlHKcb3besqV5jSe/ua12u0jjZBFyPw/5MStChEk=;
	b=wlew4QDjo31fOa+X2IJ8ts9IOGPEdKeXzNnmUBRRL8j74jKK9JwJMsEBBhtUbF2L1go7
	 8iL71MHJbRIFyMghDS6LK3zPpBlDTB+8g/FmMzAdeoKt4V1ezkCHlMv2M2F5ZuJkEpllT
	 SLwPwPBOS3FOei9j/WEzFDPk77xTh18ZTiajS+Y6F2512rVdRJI91YT9tKimEBgZ948r3
	 7yAwhyjNxvM7MoaAfdURJ0J3hmoh86+HuV0MmBr6kSyZ5Q5Hv+oI/JR+4THW8tEbEZ1Aa
	 SdWitDL+jjNnJCwczUanHPuXPCH/2ucqLsKCrFXfowNg3ta+w9/a92tiIN0sgL7St/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yIrWU788;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8D6606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yIrWU788
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352911F01828;
	Sat, 24 Oct 2026 09:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832546;
	bh=6FVWlHKcb3besqV5jSe/ua12u0jjZBFyPw/5MStChEk=;
	h=Date:To:From:Subject;
	b=yIrWU788kYgGGT5+GKeijZ/ksH9hM+EHESXRpHLroghGQcUb2dgk4CyiEGFjwCPLT
	 TtjnLZLfLX7+bnEf4nQFIX2p0fyQYNUJ+edt0TTH0k8pqotLUsmTtCMaIFpqVpt+r/
	 OeIPJoDyCPFoSvo05j3lrOxYvDoNGrPCWmDEMKHY=
Date: Sat, 24 Oct 2026 02:02:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,liam@infradead.org,florian.schmaus@codasip.com,andrewjballance@gmail.com,aliceryhl@google.com,dchar@cslab.ece.ntua.gr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] test_maple_tree-test-maple_range_64-node-in-rcu-mode.patch removed from -mm tree
Message-Id: <20261024090226.352911F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: test_maple_tree: test maple_range_64 node in RCU mode
has been removed from the -mm tree.  Its filename was
     test_maple_tree-test-maple_range_64-node-in-rcu-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Florian Schmaus <florian.schmaus@codasip.com>
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


