Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDAA3E7145;
	Thu, 13 Aug 2026 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660968; cv=none; b=pS2cJHlWKLVSZ9R8zuDSHUObux/h3mQcNk5tJQaznvvIpN99+hWwU3opdAYdEAjMMgeh5Dq85jqbzJQtfC/gtMtNnueGzKSPUeNw65xzC8BgS63otQrKkmvixW/7AzgdE8o4v5innvrHjo+edzV+0JHbHyshJeaI69mX2pocVHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660968; c=relaxed/simple;
	bh=yrFhSQkriE8j1b7E4wqilZY+cCwwOrryiL0/RtTaDUw=;
	h=Date:To:From:Subject:Message-Id; b=Hm58Tb6JBQ4aLiLBcHA4E/PDDn0ug3UAomgG08EW+aFHAhAQcagZ7pXH06bP0YCjKED7C4Eh4epvA0x1oj30S2Ct/H1Ion+rxl1hzuFylOF1siBHfGzlrlU/YcTGzXz608rzbp6h6GTa6YCrWuATyFMncI4Lh3h6LpEqgB5Zs88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uvwMVUYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uvwMVUYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823681F000E9;
	Thu, 13 Aug 2026 22:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660966;
	bh=CWfVmX4P/9txZIAYz+FBfkaU3KpB6L/j7pn6Hf6b+kk=;
	h=Date:To:From:Subject;
	b=uvwMVUYTrW1sJ7TC8v55yGcbUdc4UTDD04MQMVsVvMnLXjHWUwD64L+5RtZUDxntN
	 NWPFXAduthpHP7PQTW0RqppPacu6OpSITdp/DDMqvbszz7bHb0NROxitnsFA5Gffxh
	 SatH6JPDSBcWEfU9IY10xGCqBdJt3pPG9Ci+I1As=
Date: Thu, 13 Aug 2026 15:42:46 -0700
To: mm-commits@vger.kernel.org,yabinc@google.com,stable@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,gprocida@google.com,edumazet@google.com,ajordanr@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mark-list_add-and-__list_add-as-__always_inline.patch removed from -mm tree
Message-Id: <20260813224246.823681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/list.h: mark list_add and __list_add as __always_inline
has been removed from the -mm tree.  Its filename was
     mark-list_add-and-__list_add-as-__always_inline.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jordan R Abrahams-Whitehead <ajordanr@google.com>
Subject: include/linux/list.h: mark list_add and __list_add as __always_inline
Date: Fri, 31 Jul 2026 20:15:19 +0000

This commit resolves an issue where modpost section verification fails due
to section mismatches between list_add and its callers.

At present, list_add (and its internal __list_add) are called from both
.text and .init code sections.  Since inlining can vary per call site,
list_add can be 4 different states:

  list_add in text with arguments to non-.init.data values
  list_add in init with arguments to static .init.data values
  list_add in init with arguments to non-.init.data values
  list_add in text with arguments to static .init.data values

It is last instance that ends up causing the section mismatch caused by
constant propagation of the address of static libs inside the `dir_add` as
seen below (with the dir_list being defined statically in initramfs.c,
resting in .init.data).

  WARNING: modpost: vmlinux.o: section mismatch in reference: __list_add
  (section: .text.unlikely.) -> dir_list (section: .init.data)

Because of these section matching requirements, semantically, __list_add
and list_add MUST be inlined.  This will then ensure callers inside .init
will receive a list_add that exists and refers to only .init data, and
list_add code in .text sections will only refer to non-init data.

This issue manifests predominently in AutoFDO with clang, which is very
hesitant to inline cold functions such as list_add even when marked
`inline`.  Marking them as `__always_inline` therefore matches the
existing semantic constraints imposed by modpost's section mismatch
checks.

Link: https://lore.kernel.org/20260731-always-inline-list-add-v1-1-d29f54ce5477@google.com
Link: https://lore.kernel.org/all/CANn89iJVQe=wedLheJmjZjOTJsWHijT0jZs=iRxKssJZbjAxHw@mail.gmail.com/
Signed-off-by: Jordan R Abrahams-Whitehead <ajordanr@google.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Giuliano Procida <gprocida@google.com>
Reported-by: Yabin Cui <yabinc@google.com>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2173
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/include/linux/list.h~mark-list_add-and-__list_add-as-__always_inline
+++ a/include/linux/list.h
@@ -150,10 +150,13 @@ static inline bool __list_del_entry_vali
  *
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
+ *
+ * Must be inlined to ensure it can be safely called
+ * with initdata arguments.
  */
-static inline void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next)
+static __always_inline void __list_add(struct list_head *new,
+				       struct list_head *prev,
+				       struct list_head *next)
 {
 	if (!__list_add_valid(new, prev, next))
 		return;
@@ -171,8 +174,12 @@ static inline void __list_add(struct lis
  *
  * Insert a new entry after the specified head.
  * This is good for implementing stacks.
+ *
+ * Must be inlined to ensure it can be safely called
+ * with initdata arguments.
  */
-static inline void list_add(struct list_head *new, struct list_head *head)
+static __always_inline void list_add(struct list_head *new,
+				     struct list_head *head)
 {
 	__list_add(new, head, head->next);
 }
_

Patches currently in -mm which might be from ajordanr@google.com are


