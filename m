Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415095;
	b=BXyQFoMwggAZjiekFWTLcJzja0NrVNX3o6s3agUaLV6AlBgbWE0LBcCv2mKS5E3UMi9u
	 xICXG9x4q26xIRQaMg6Hf3jKvhRali0sg0BKjxb0PTt3VGZotn9aF6ME2fFHwZ6xE6lnY
	 HSY+aYgx8kfbHVfSXOhyNN3dcW2lD8FSjIlTvuKDZzTBstQCCMs535jUZP5Hn6Z859WlK
	 krTUrzeaTpi7Doa9C4RjEXfRxecIdAqyEENepViFokJFw04qfjB74d8Rdf9QGnkeMbwVE
	 KfhPJ0SQfcbfterYE7ha1NFgsqO54JJyuCW28GblTxE0ZDZ4Xt4emRsj+ZUzAR/cnNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415095;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=cc6JKW7iNt0oHmPujhkz1wEGUkxBOSquMhUxzkVkwBY=;
	b=M8pZSqlEvjle2nbgyQqAqxmIao9votT1F85UBJmkEUzVYcRZ/WImABP6JiMkWEkbSJh2
	 fEtP+5ZjUVG3WakvTGSurLStwl+T0DY3HlpagkzglzBTig+sqbut9Cxtix/O7py63OUMA
	 Ior8MezkbBBS1YzCwyTKn82PdBhvLT7zTJLfwc100WbHY6q0FB/lBewrQ7ukBRTAMmj8N
	 OBhICqKxyBzfyBUmZ3UaL8/f7GTO4J4o3dmB6Xfw7YwJV7GtssnzLbMvjtdPyiWz8aEHx
	 48dXc5Rlv1wFouSXWTKQVCeTQlBQDzRQCNeMfcenZ3DSt8R2eUzyeRrR5AgwkXncDYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MW4NLkiU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D60606A335
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MW4NLkiU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E941A1F000CA;
	Mon, 23 Nov 2026 06:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415095;
	bh=cc6JKW7iNt0oHmPujhkz1wEGUkxBOSquMhUxzkVkwBY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=MW4NLkiUHwzSjupgBApJOZDCQdoApa9BbTgzyUBIKUB5yIQBtq0UK+24RRBcQFZY0
	 snddSTuH18AlSNxiFa+weigx2dvPTmC4yifCvY/4a8uhqaWeLJakktg1iP5l2QMyVJ
	 hucvaTkvJn7Oh9PrNdw9l0tpK4ovYF3T8h73wcyQ=
Date: Sun, 22 Nov 2026 22:24:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,work@onurozkan.dev,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tmgross@umich.edu,
	tamird@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,
	ryan.roberts@arm.com,rppt@kernel.org,qi.zheng@linux.dev,ojeda@kernel.org,
	nico.pache@linux.dev,mhocko@suse.com,lossin@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,gary@garyguo.net,
	dev.jain@arm.com,david@kernel.org,daniel.almeida@collabora.com,
	dakr@kernel.org,boqun@kernel.org,bjorn3_gh@protonmail.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,aliceryhl@google.com,
	a.hindborg@kernel.org,acourbot@nvidia.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261110-drop-reviewerships-v1-3-07c2f06e8dfa@kernel.org>
References: <20261110-drop-reviewerships-v1-3-07c2f06e8dfa@kernel.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-myself-from-mm-rust-reviewerships.patch removed from -mm tree
Message-Id: <20261123062454.E941A1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: remove myself from MM rust reviewerships
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-from-mm-rust-reviewerships.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: remove myself from MM rust reviewerships
Date: Tue, 10 Nov 2026 12:03:09 +0000

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

Therefore, remove myself as a reviewer.

Link: https://patch.msgid.link/20261110-drop-reviewerships-v1-3-07c2f06e8dfa@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Benno Lossin <lossin@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Tamir Duberstein <tamird@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Onur Özkan <work@onurozkan.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-mm-rust-reviewerships
+++ a/MAINTAINERS
@@ -17957,7 +17957,6 @@ F:	tools/testing/selftests/mm/uffd-*.[ch
 
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
@@ -24658,7 +24657,6 @@ K:	\b(?i:rust)\b
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch

