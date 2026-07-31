Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0FE489880;
	Fri, 31 Jul 2026 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785532922; cv=none; b=hinv/WHFVpamBK63DLvt2PlQWWjuf75cw9lTXulljQIPBvYfF8H46mc2uJrKlyeSRuSnnAF2oAwWCZdXVmuBwlGIu/rOwxTwKzILvxFYHhAQ3dH2HNQFrcti0pgwUlDMw5i33H7iIgw40uxwiH2jawmORV1jJl7V37zGcMWkicU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785532922; c=relaxed/simple;
	bh=fKmR/dKG+JJMOO480BFdLJODYIKZ7bF+5Qad4bprTP8=;
	h=Date:To:From:Subject:Message-Id; b=Ac3SdesnuyrLgynjYjpRexMq6PcIQWu1mv1X6PWwAyW6RCH2MqN5GdCYVUtIMRAWVuM+4hXBLQm4sYGaTnX9V0rX9O4GnJI/ibIPsX10apVDGG4+OGZQT+zwp0EZp06JFKdTTRtObVgSPZFwY4NIu22CUdNFOXS/HqHovr7M+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EV80WCl6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EV80WCl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E679B1F00AC4;
	Fri, 31 Jul 2026 21:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785532921;
	bh=KFzDFZrOdmnwh07FCHhUa/y9NUgQtw8SQCpVVE71XkE=;
	h=Date:To:From:Subject;
	b=EV80WCl6i9ILv8/1Gzq2ZXSNDJYi1JC9XwjlQusiv4lMIP5VJP4lwFe1aT31tbeu9
	 FpyQzJvxLnA9bDJBRgqjjCudgQ2HUePGeJFhataDhQE7amIynk29zbc4iss3ak/VlD
	 QFfixuJIjgBHrFWNdx9ys7R/ZqRjYJ7C3+tJpEBg=
Date: Fri, 31 Jul 2026 14:22:00 -0700
To: mm-commits@vger.kernel.org,yabinc@google.com,stable@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,gprocida@google.com,edumazet@google.com,ajordanr@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mark-list_add-and-__list_add-as-__always_inline.patch added to mm-nonmm-unstable branch
Message-Id: <20260731212200.E679B1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/list.h: mark list_add and __list_add as __always_inline
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mark-list_add-and-__list_add-as-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mark-list_add-and-__list_add-as-__always_inline.patch

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

mark-list_add-and-__list_add-as-__always_inline.patch

