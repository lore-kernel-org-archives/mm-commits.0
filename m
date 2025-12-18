Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345D923D2B4
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 21:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766092096; cv=none; b=rBNOKzmhGAxr1JtvxKaQHCaHBgS4dcWm10U19pbIaprv3JrOCgP9zKNOTZaFGetl6NFu+nJjJg/ZXVuN2Ehrv6Y6PzzMoVsxtNLC3+zN2QtjqA+adY7nps2yBYmGvDOIN29mhbfdqbC0bY8l9M2WWp0EZnY3DjIHVHOLSJ188c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766092096; c=relaxed/simple;
	bh=a8iyOmEhqFpxD0TxOO4qH6Uq0k2+6Xn/I9KaBVdr+Lc=;
	h=Date:To:From:Subject:Message-Id; b=amfuQxq4gqOjgltU4S5JFpVN49MJN0U1LlJ1sukRny1Nre6/lODCD6wBEbxJ2aSgW5xc9BwAIR03sic6Kq73BDHccRJw+jEwSxy/OxjJ1gKGnG0UX98Z83tSoQB9OLnfL7R1RuWLRQXvAaJGOYj2owhkFcKhXJvFogGvTwXoorA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apcM9/Hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apcM9/Hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53451C4CEFB;
	Thu, 18 Dec 2025 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766092095;
	bh=a8iyOmEhqFpxD0TxOO4qH6Uq0k2+6Xn/I9KaBVdr+Lc=;
	h=Date:To:From:Subject:From;
	b=apcM9/HglCmljuSSY5w8Bdmh27tuRvJRXBtg9q6gYbNMCh0RgVDhdl9+l1Tgey0eo
	 gZZJfyREDhXIj6Dq741OyqeskG4f5zGAwizHgUwVF8z/afrjLyPAhhfHCLQYHdnr7n
	 gRpG4SSuvhERGH5tmkz5M82Cb3N62HvKrCkp4o8s=
Date: Thu, 18 Dec 2025 13:08:14 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,skhawaja@google.com,rppt@kernel.org,rientjes@google.com,pratyush@kernel.org,pmladek@suse.com,kees@kernel.org,graf@amazon.com,dmatlack@google.com,davidgow@google.com,corbet@lwn.net,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-add-primitives-for-private-list-manipulations.patch added to mm-nonmm-unstable branch
Message-Id: <20251218210815.53451C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: add primitives for private list manipulations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-add-primitives-for-private-list-manipulations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-add-primitives-for-private-list-manipulations.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: list: add primitives for private list manipulations
Date: Thu, 18 Dec 2025 10:57:48 -0500

Patch series "list private v2 & luo flb", v9.


This patch (of 5):

Linux recently added an ability to add private members to structs (i.e. 
__private) and access them via ACCESS_PRIVATE().  This ensures that those
members are only accessible by the subsystem which owns the struct type,
and not to the object owner.

However, struct list_head often needs to be placed into the private
section to be manipulated privately by the subsystem.

Add macros to support private list manipulations in
<linux/list_private.h>.

Link: https://lkml.kernel.org/r/20251218155752.3045808-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20251218155752.3045808-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Gow <davidgow@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/list.rst |    9 +
 include/linux/list_private.h    |  256 ++++++++++++++++++++++++++++++
 2 files changed, 265 insertions(+)

--- a/Documentation/core-api/list.rst~list-add-primitives-for-private-list-manipulations
+++ a/Documentation/core-api/list.rst
@@ -774,3 +774,12 @@ Full List API
 
 .. kernel-doc:: include/linux/list.h
    :internal:
+
+Private List API
+================
+
+.. kernel-doc:: include/linux/list_private.h
+   :doc: Private List Primitives
+
+.. kernel-doc:: include/linux/list_private.h
+   :internal:
diff --git a/include/linux/list_private.h a/include/linux/list_private.h
new file mode 100644
--- /dev/null
+++ a/include/linux/list_private.h
@@ -0,0 +1,256 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef _LINUX_LIST_PRIVATE_H
+#define _LINUX_LIST_PRIVATE_H
+
+/**
+ * DOC: Private List Primitives
+ *
+ * Provides a set of list primitives identical in function to those in
+ * ``<linux/list.h>``, but designed for cases where the embedded
+ * ``&struct list_head`` is private member.
+ */
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+
+#define __list_private_offset(type, member)					\
+	((size_t)(&ACCESS_PRIVATE(((type *)0), member)))
+
+/**
+ * list_private_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the identifier passed to ACCESS_PRIVATE.
+ */
+#define list_private_entry(ptr, type, member) ({				\
+	const struct list_head *__mptr = (ptr);					\
+	(type *)((char *)__mptr - __list_private_offset(type, member));		\
+})
+
+/**
+ * list_private_first_entry - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the identifier passed to ACCESS_PRIVATE.
+ */
+#define list_private_first_entry(ptr, type, member)				\
+	list_private_entry((ptr)->next, type, member)
+
+/**
+ * list_private_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the identifier passed to ACCESS_PRIVATE.
+ */
+#define list_private_last_entry(ptr, type, member)				\
+	list_private_entry((ptr)->prev, type, member)
+
+/**
+ * list_private_next_entry - get the next element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_next_entry(pos, member)					\
+	list_private_entry(ACCESS_PRIVATE(pos, member).next, typeof(*(pos)), member)
+
+/**
+ * list_private_next_entry_circular - get the next element in list
+ * @pos:	the type * to cursor.
+ * @head:	the list head to take the element from.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Wraparound if pos is the last element (return the first element).
+ * Note, that list is expected to be not empty.
+ */
+#define list_private_next_entry_circular(pos, head, member)			\
+	(list_is_last(&ACCESS_PRIVATE(pos, member), head) ?			\
+	list_private_first_entry(head, typeof(*(pos)), member) :		\
+	list_private_next_entry(pos, member))
+
+/**
+ * list_private_prev_entry - get the prev element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_prev_entry(pos, member)					\
+	list_private_entry(ACCESS_PRIVATE(pos, member).prev, typeof(*(pos)), member)
+
+/**
+ * list_prev_entry_circular - get the prev element in list
+ * @pos:	the type * to cursor.
+ * @head:	the list head to take the element from.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Wraparound if pos is the first element (return the last element).
+ * Note, that list is expected to be not empty.
+ */
+#define list_private_prev_entry_circular(pos, head, member)			\
+	(list_is_first(&ACCESS_PRIVATE(pos, member), head) ?			\
+	list_private_last_entry(head, typeof(*(pos)), member) :			\
+	list_private_prev_entry(pos, member))
+
+/**
+ * list_private_entry_is_head - test if the entry points to the head of the list
+ * @pos:	the type * to cursor
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_entry_is_head(pos, head, member)				\
+	list_is_head(&ACCESS_PRIVATE(pos, member), (head))
+
+/**
+ * list_private_for_each_entry - iterate over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_for_each_entry(pos, head, member)				\
+	for (pos = list_private_first_entry(head, typeof(*pos), member);	\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_next_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_for_each_entry_reverse(pos, head, member)			\
+	for (pos = list_private_last_entry(head, typeof(*pos), member);		\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_prev_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_continue - continue iteration over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define list_private_for_each_entry_continue(pos, head, member)			\
+	for (pos = list_private_next_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_next_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_continue_reverse - iterate backwards from the given point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Start to iterate over list of given type backwards, continuing after
+ * the current position.
+ */
+#define list_private_for_each_entry_continue_reverse(pos, head, member)		\
+	for (pos = list_private_prev_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_prev_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_from - iterate over list of given type from the current point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing from current position.
+ */
+#define list_private_for_each_entry_from(pos, head, member)			\
+	for (; !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_next_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_from_reverse - iterate backwards over list of given type
+ *                                    from the current point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, continuing from current position.
+ */
+#define list_private_for_each_entry_from_reverse(pos, head, member)		\
+	for (; !list_private_entry_is_head(pos, head, member);			\
+	     pos = list_private_prev_entry(pos, member))
+
+/**
+ * list_private_for_each_entry_safe - iterate over list of given type safe against removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_private_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = list_private_first_entry(head, typeof(*pos), member),	\
+		n = list_private_next_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_next_entry(n, member))
+
+/**
+ * list_private_for_each_entry_safe_continue - continue list iteration safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing after current point,
+ * safe against removal of list entry.
+ */
+#define list_private_for_each_entry_safe_continue(pos, n, head, member)		\
+	for (pos = list_private_next_entry(pos, member),			\
+		n = list_private_next_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_next_entry(n, member))
+
+/**
+ * list_private_for_each_entry_safe_from - iterate over list from current point safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type from current point, safe against
+ * removal of list entry.
+ */
+#define list_private_for_each_entry_safe_from(pos, n, head, member)		\
+	for (n = list_private_next_entry(pos, member);				\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_next_entry(n, member))
+
+/**
+ * list_private_for_each_entry_safe_reverse - iterate backwards over list safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, safe against removal
+ * of list entry.
+ */
+#define list_private_for_each_entry_safe_reverse(pos, n, head, member)		\
+	for (pos = list_private_last_entry(head, typeof(*pos), member),		\
+		n = list_private_prev_entry(pos, member);			\
+	     !list_private_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_private_prev_entry(n, member))
+
+/**
+ * list_private_safe_reset_next - reset a stale list_for_each_entry_safe loop
+ * @pos:	the loop cursor used in the list_for_each_entry_safe loop
+ * @n:		temporary storage used in list_for_each_entry_safe
+ * @member:	the name of the list_head within the struct.
+ *
+ * list_safe_reset_next is not safe to use in general if the list may be
+ * modified concurrently (eg. the lock is dropped in the loop body). An
+ * exception to this is if the cursor element (pos) is pinned in the list,
+ * and list_safe_reset_next is called after re-taking the lock and before
+ * completing the current iteration of the loop body.
+ */
+#define list_private_safe_reset_next(pos, n, member)				\
+	n = list_private_next_entry(pos, member)
+
+#endif /* _LINUX_LIST_PRIVATE_H */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

list-add-primitives-for-private-list-manipulations.patch
list-add-kunit-test-for-private-list-primitives.patch
liveupdate-luo_file-use-private-list.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

