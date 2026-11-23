Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415091;
	b=FEH36cdj2cRPgv8hPg91R2DnN07almgYtomeYnRYsafpnvY2iD5IC4FYRvx0A0mfF0ju
	 t9ooBw6sy5ZqXJRoLNwxdOVslCW4/tYOH/xSK/Fy1rIYhIkVrXyCHwxOjmTILqw1tofg3
	 xpVzU5s1dTqsYhWlp97bfRo7/vIApCI0OS5S4Zfipyyma+qT8H2rx606hZvrHjP8DCzYt
	 6zjSs/b1Wf4gqXuUljr1CPAUMKhezQndVaiBYloh+gltTLrGIRXU5H29ZYDNYLinntMsQ
	 Olz9AszBGpJ0aegJfH/w9lsTiRUsAElGAea4ozRaYmUchWBuC0zO3Xgd9IetC5NT/eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415091;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=JVXduJk1QASGFB9FLnRCaaqq4ZLd4kLr/Z08WpNtlP4=;
	b=cmkJKC4AJ0dpuw7VWPUyyPks/ueUq58NmWhFxi4xQKRuD/L56Yf7jICJ1F1ZTZ7KGY89
	 m1vvhP0tBDVsG4OoS4xntpTp9pSrwfb+6rjaaI1SrfYDF613a3UTG5QO5PoxHdpStui94
	 cUSHM77mZppzsHmNwuidRPFQABGX4KPlHl2R3b+EYXr1/rnsdhiN4xv32Fo8btfuTk45e
	 1f1L6DNddrQELRQzmQCqpV4rOGNQoCqStuVraFVGFOO/S2SQeq5sNJDXkoIIiUPyNqEx8
	 Q0HTB0yREA42SUuTCF40eF08Lzcy2/tuzvslDEAjLB3l9OPqRp9or0dBH6DzEJsT/nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pBcLlSLf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07A0606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pBcLlSLf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601811F000E1;
	Mon, 23 Nov 2026 06:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415091;
	bh=JVXduJk1QASGFB9FLnRCaaqq4ZLd4kLr/Z08WpNtlP4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=pBcLlSLfGHltDSmrACmTAzA1Q8M13RcT1GIuAK7mKDWuOlOSsgA6N+iICKsSkeJE+
	 XgzM4blMxdWwZl3fZAD/tsQn88KQXz1cxpaSi9s1QzTT+AbQgKEMsYNP8n9LfodgaV
	 OX3wLL89BIjR20E8bwn/DDkkXJLegas/9mBky2VY=
Date: Sun, 22 Nov 2026 22:24:50 -0800
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
In-Reply-To: <20261110-drop-reviewerships-v1-1-07c2f06e8dfa@kernel.org>
References: <20261110-drop-reviewerships-v1-1-07c2f06e8dfa@kernel.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-myself-from-mm-core-reviewership.patch removed from -mm tree
Message-Id: <20261123062451.601811F000E1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: remove myself from MM core reviewership
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-from-mm-core-reviewership.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: remove myself from MM core reviewership
Date: Tue, 10 Nov 2026 12:03:07 +0000

Patch series "MAINTAINERS: remove my reviewerships, add CREDITS entry for
THP".

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

I have separated the patches into areas maintained by David, Andrew, and
Alice + Danilo, so each can take the patches relevant to the subsystems,
for convenience.

Apologies for doing this, but given the current trends I'd like to do
something to make my inbox a little more manageable :)

Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
appointment as co-maintainer there, I have no fear of needing to step in
there, and so would like to record my time in that role.


This patch (of 4):

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

Therefore, remove myself as a reviewer.

Link: https://lore.kernel.org/20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org
Link: https://patch.msgid.link/20261110-drop-reviewerships-v1-1-07c2f06e8dfa@kernel.org
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

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-mm-core-reviewership
+++ a/MAINTAINERS
@@ -17504,7 +17504,6 @@ F:	mm/balloon.c
 
 MEMORY MANAGEMENT - CORE
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch

