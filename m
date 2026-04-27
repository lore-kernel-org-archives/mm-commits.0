Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286A6344DAB
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305512; cv=none; b=jygeVW6pTyEA90ralWdjjsr4ml0ZkdxIEBbQJNiuhua1cVWoE5jOwexohaDmxvTcszJpaSsxv7BsN6/6zdSP52Rpw2FqoIPznBdu+/AQVMlKJV6yVAdDnzlBlmtirVDTJIBtrZ/ciTEY0geN0JQ5UhE6aI4rZynM5ToJ1g/nO7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305512; c=relaxed/simple;
	bh=a4TkSCCRyeYNh4lSITF5YzJcJS0p7F2aAs4MDl9pnJ8=;
	h=Date:To:From:Subject:Message-Id; b=SHRSiOL0mhS4cXDoMvwsJ45rR0t8r8ddbhtAg57gzbOSZr2SDuyOBrW9gf0IIq9HicOdgG6jTbcmdNDEDQi1a4JrQyKjYOntd2c6uUI01hwGBUfwempt3hpQSqh4LYJrEfh1hxPLinPDptw3vcGtE9T9BbjUtS7mFO8c0VwkekU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fr/cECxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fr/cECxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC59C2BCB4;
	Mon, 27 Apr 2026 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777305512;
	bh=a4TkSCCRyeYNh4lSITF5YzJcJS0p7F2aAs4MDl9pnJ8=;
	h=Date:To:From:Subject:From;
	b=fr/cECxW6LAqMDhuj/3FSpMGsNfLuYXIFUHG/htLJng2GI6RNf83jlzKoihGrQnJj
	 45wne+JEXDOLCfiEzHdh3mDDCnmVxMW+mvaENZB8WPi0HqyMmQpn94p3KRC01Q++wB
	 KXV6nsBMwvqNorYw2WSJNttc5Mdhl+E27qzCz81E=
Date: Mon, 27 Apr 2026 08:58:31 -0700
To: mm-commits@vger.kernel.org,vmalik@redhat.com,rdunlap@infradead.org,peterz@infradead.org,mathieu.desnoyers@efficios.com,chleroy@kernel.org,arnd@arndb.de,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch added to mm-nonmm-unstable branch
Message-Id: <20260427155831.DBC59C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: uaccess: use INLINE_COPY_TO_USER to guard copy_to_user()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

rust-uaccess-use-inline_copy_to_user-to-guard-copy_to_user.patch
uaccess-unify-inline-vs-outline-copy_fromto_user-selection.patch
uaccess-minimize-inline_copy_user-related-ifdefery.patch

