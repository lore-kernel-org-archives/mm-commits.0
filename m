Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336779;
	b=5V0DGkwbkbu+9lKMaRFu3g6AXs0a7sNXglOS+ShCmZD493J20+u8Q0eeu21LKfWDrLP7
	 /TQCSn2UrBpFzCX8bVMxL+4cW2gZK+F8uVeQznjIBxyFvcjXtzOaHa/J7Zxt+pl/VKdtp
	 FACRgyCQsGBaOq182nRmTrMJQyajT/URqv9XOOKdaFnRe2bAymSqVPgCvjPRrUs3APHMx
	 B1CCMyGwEzYcD5ZZKhgF1inJMQ6YDTgnCcv8BiJ//fjyUHc+3qi4N7jjshuoWowqUESoT
	 q+Y8xEsB8zuk9uKLv8RWezXWvC0bCgQm5JzXw1/f1wt+OQORMlRYN91umO4QyAJpswg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336779;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3cQHLNCYQrEuFduTCAneanlU/jHnnzNxEQyU9+I/94c=;
	b=oGICqxHaYIXBD7n5UlRuxiw763pYDvrmc/PKqvd+/9i7gXRNuDqSbW6gFEKaUKNMs/Y+
	 kzNe8Ju7IgD4L54+7eqtFc+Dlbna3IwcO8OX2qKfjaLPKoWvdFF365VvRlE7BmhIdHJ+w
	 exOei2UgB/DylMFvA0PFj92f0FNUQr2LBVWhNQ3jrxYNvoUECzchbMGq3mNWqvkuKi2nL
	 allNZ2ZVwQUt/EclOQAxGW5u2im196Y9NCm0RtXBpjrTl63rW9nueFsYo1o2lOS5IVF6O
	 c3GSPBq5j+PHUDVZ2eM82uzjbp78IHnqIcP42YmU5mfBR05a5VHZDyJFD47oPKJBVCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=K79fJ9HR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5D606A320
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 18:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=K79fJ9HR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D853D1F0089F;
	Tue, 10 Nov 2026 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794336779;
	bh=3cQHLNCYQrEuFduTCAneanlU/jHnnzNxEQyU9+I/94c=;
	h=Date:To:From:Subject;
	b=K79fJ9HRoJlteDpk2UyRIexDlQ3WTAXSaWov1QjJmH/EerVEMvlkORaYC6Bhwm4HT
	 8GuL2HYDxnIh694oM8cbxJvWRe0SaosO0uwNBLq3qO7bM+3o0jXZdvdh/1khJgGAlg
	 wXaT/UanXZK7g+Mvy2tQELWemdo0IIxEusscmeNs=
Date: Tue, 10 Nov 2026 10:52:58 -0800
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
Subject: + credits-add-entry-for-thp-maintenance.patch added to mm-hotfixes-unstable branch
Message-Id: <20261110185258.D853D1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: CREDITS: add entry for THP maintenance
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     credits-add-entry-for-thp-maintenance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/credits-add-entry-for-thp-maintenance.patch

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
Subject: CREDITS: add entry for THP maintenance
Date: Tue, 10 Nov 2026 12:03:10 +0000

Given my workload and current areas of focus, I think it's unlikely I will
return to THP, so add a CREDITS entry to reflect my time as co-maintainer
there.

With Zi being appointed as an absolutely worthy successor as THP
co-maintainer I am confident in its success, and this additionally makes me
feel that it is unnecessary for me to return (for the best possible
reasons!)

Link: https://lore.kernel.org/20261110-drop-reviewerships-v1-4-07c2f06e8dfa@kernel.org
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

 CREDITS |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/CREDITS~credits-add-entry-for-thp-maintenance
+++ a/CREDITS
@@ -3939,6 +3939,12 @@ D: mandocs and mandocs_install build tar
 S: (Email me and ask)
 S: Australia
 
+N: Lorenzo Stoakes
+E: ljs@kernel.org
+W: https://ljs.io
+D: THP co-maintainer
+S: UK
+
 N: Henrik Storner
 E: storner@image.dk
 W: http://www.image.dk/~storner/
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

