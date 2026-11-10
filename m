Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336777;
	b=KyE7D9PEiSHtOzr6AwuP0e/ihoZi92ia7BDi48s3YkGjqeCGC3IxvoMEI8hnf1GorDSK
	 pDrDK7GcrqeWhMn3sv/JenI8a/a2mithh1mRGdTUdyIrlFxrsT3P88s7dU3hflyCDvf3C
	 RYieC4x0phQJe8HdTY/ayCSrA0G3FQ24W7cqt0YqbT4juQLE4FI7HwTFd7x8av24FOXwF
	 Xu/Dk9KoKluxcafe4T/7iIfXCaYv3Q1oAnrSvO/+XQCnG6Tgxm9/ZbD5lQoYxRzLOmpd4
	 wa9PNVv0kmzbf1Md67FBrKHOfVHMw8+zRA/zeMgx62SM7eXuzsWCgVw0oCB81p1A0KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336777;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FFvy0IV09PTcwAMOuJt3YrshzO2lHxfzaEk04rk0diY=;
	b=rjP5hSJX7RKH9lpTzsFVvLrjWi5gQKPnvzhzbq3QzhawC29X0/0eiGRRB13+q4NROaYG
	 WRR1+mgkbq3l53ttv5+CeSblCyUh/BKr/Tk4l1X0AqTNzLfRqJStJEMjr+lrZZCLNiPCY
	 4JXqVsPrFeTwzhciGr6Yrpf/ApAYeni9T5FQMAdXQ9RPnm46HPUcbhEFJheTpgPjkQYqf
	 8HV7/Dep8XoUQIR8BoE6YA7yk2/NlrZgG8MQY4b7ypOx+17uYqLp+j9TLd1i3nHYB05Ns
	 g8z3b4fTUP3EnKiSeTzs7TGN5kfoLVZNsDQpqqvvFpuklf0T2Afp6F1iewjICeLDRUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Dq6ojMzJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB69606A321
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 18:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Dq6ojMzJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4041F0089F;
	Tue, 10 Nov 2026 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794336776;
	bh=FFvy0IV09PTcwAMOuJt3YrshzO2lHxfzaEk04rk0diY=;
	h=Date:To:From:Subject;
	b=Dq6ojMzJXW+VzHQQkJtF8L+acdMtkwqCLdtvGzW1SN6yjSzvClTFXoDrle49uTjfu
	 14NR3pCLF1BIsOgZiXNZ+giTA2NKUbFpf9wOkCP9xWn2jjLN12bH66P3S5n8VWKq6j
	 8SLwxrIUlHhKE4Q3Z1Hh50H8829NPyNv+Q5SAAKg=
Date: Tue, 10 Nov 2026 10:52:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,work@onurozkan.dev,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tmgross@umich.edu,
	tamird@kernel.org,surenb@google.com,shakeel.butt@linux.dev,
	ryan.roberts@arm.com,rppt@kernel.org,qi.zheng@linux.dev,ojeda@kernel.org,
	nico.pache@linux.dev,mhocko@suse.com,lossin@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,gary@garyguo.net,
	dev.jain@arm.com,david@kernel.org,daniel.almeida@collabora.com,
	dakr@kernel.org,boqun@kernel.org,bjorn3_gh@protonmail.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,aliceryhl@google.com,
	a.hindborg@kernel.org,acourbot@nvidia.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself-from-mm-rust-reviewerships.patch added to mm-hotfixes-unstable branch
Message-Id: <20261110185256.9A4041F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: remove myself from MM rust reviewerships
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-myself-from-mm-rust-reviewerships.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-myself-from-mm-rust-reviewerships.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: remove myself from MM rust reviewerships
Date: Tue, 10 Nov 2026 12:03:09 +0000

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

Therefore, remove myself as a reviewer.

Link: https://lore.kernel.org/20261110-drop-reviewerships-v1-3-07c2f06e8dfa@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Danilo Krummrich <dakr@kernel.org>
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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
---

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
@@ -24652,7 +24651,6 @@ K:	\b(?i:rust)\b
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-remove-myself-from-mm-core-reviewership.patch
maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch
maintainers-remove-myself-from-mm-rust-reviewerships.patch
credits-add-entry-for-thp-maintenance.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-scan-mms-more-efficiently-under-mmap_lock-contention.patch
mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch

