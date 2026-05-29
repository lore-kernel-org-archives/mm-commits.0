Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EAD371D05
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028758; cv=none; b=OVlA1V3PQgBaA0XCVfXf9uRj/v33gEVT+3AGCLV6HgNfb9Ox0n2JywdcDaf48OmSfacYmNhsNNGkx+dOz+16Uf1LuABmAH69OvfCxXSMWNTnG3hb+w0z+OVqDwnjuM1rPX0x+JqtGy1zCXWQkpFO9Ocg53Vt0FQhmfdcNFvw7GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028758; c=relaxed/simple;
	bh=I620dFvhFqUFGtYox4SY7jpf9VnI3DX4X25aS64ZEuQ=;
	h=Date:To:From:Subject:Message-Id; b=TzdHSLkORE/a59bJ7CGZJoDJv3SV62XUf5i7owCzubTS0U8/9o6TKgTUURHEXkvrZQrH8aL12uxQyS1+rhpAU9uOS+uUi5aWFNFYgovzgbrN42nmFHW4I1lz0YaonePm+VKPfXXjqbkWzJCeVEGJorpzU6fYnlIPZTne8FUWC4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WBhY925z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WBhY925z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA1A1F00893;
	Fri, 29 May 2026 04:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028756;
	bh=EHFwTtsugVzHEgndFWF8ch/rJrfWETBDGnVaCBsWcf0=;
	h=Date:To:From:Subject;
	b=WBhY925zM0Fe7XiI0WeD36NVjwu6mX1BXzaUtTqWXW1O85thGOWEVYoMq8X3COr2R
	 N3MrulZK2E1H9RRIqVYkiZnKJc6AvKY3vShPXnRhARz7PPrSm2s1gs+rtT3hlzsBsc
	 OJVlzXHLFs2ITf1VdPV+1HlxcB/hXJ4h9bBkAibo=
Date: Thu, 28 May 2026 21:25:56 -0700
To: mm-commits@vger.kernel.org,vmalik@redhat.com,rdunlap@infradead.org,peterz@infradead.org,mathieu.desnoyers@efficios.com,chleroy@kernel.org,arnd@arndb.de,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch removed from -mm tree
Message-Id: <20260529042556.BDA1A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: uaccess: use INLINE_COPY_TO_USER to guard copy_to_user()
has been removed from the -mm tree.  Its filename was
     rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: rust: uaccess: use INLINE_COPY_TO_USER to guard copy_to_user()
Date: Fri, 24 Apr 2026 22:08:55 -0400

Patch series "uaccess: unify inline vs outline copy_{from,to}_user()
selection", v2.

The kernel allows arches to select between inline and outline
implementations of the copy_{from,to}_user() by defining individual
INLINE_COPY_FROM_USER and INLINE_COPY_TO_USER, correspondingly.  However,
all arches enable or disable them always together.

Without the real use-case for one helper being inlined while the other
outlined, having independent controls is excessive and error prone.

The first patch of the series fixes rust/uaccess coppy_to_user() wrapper
guarded with INLINE_COPY_FROM_USER.  The 2nd patch switches codebase to
the unified INLINE_COPY_USER.  And the last patch cleans up ifdefery in
the include/linux/uaccess.h


This patch (of 3):

The copy_to_user() rust helper is only needed when the main kernel inlines
the function.  It is controlled by INLINE_COPY_TO_USER, but the rust
helper is protected with INLINE_COPY_FROM_USER.

Fix that.

Link: https://lore.kernel.org/20260425020857.356850-1-ynorov@nvidia.com
Link: https://lore.kernel.org/20260425020857.356850-2-ynorov@nvidia.com
Fixes: d99dc586ca7c7 ("uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST")
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reported-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Closes: https://lore.kernel.org/all/746c9c50-20c4-4dc9-a539-bf1310ff9414@kernel.org/
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Viktor Malik <vmalik@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers/uaccess.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/rust/helpers/uaccess.c~rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user
+++ a/rust/helpers/uaccess.c
@@ -20,7 +20,9 @@ unsigned long rust_helper__copy_from_use
 {
 	return _inline_copy_from_user(to, from, n);
 }
+#endif
 
+#ifdef INLINE_COPY_TO_USER
 __rust_helper
 unsigned long rust_helper__copy_to_user(void __user *to, const void *from, unsigned long n)
 {
_

Patches currently in -mm which might be from ynorov@nvidia.com are


