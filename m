Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100711FB3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732943347; cv=none; b=mEkkaNkb1MBRRU3XfkLYHZ4+tz7gcfMqO1aKiOi2o+QRyn/ifx5PylmlJ2/OIwwySg7YNtrahVT1k/0yf8bTrbepYcCTUSUxC4ZPHBkz1hPRWIve9QtHc5rGSgklvYn4vJ+sXmDQFh6W+VS4hGkGQwUN1uOOLms8Mr0Cd4fMUyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732943347; c=relaxed/simple;
	bh=JTAiltfKV6u+Ydn8ugjcSW+7adxL2hr96679lcq4wq8=;
	h=Date:To:From:Subject:Message-Id; b=IeIlgPKcCbJbdviV8m8Vi6R2J8NmKRv/MRWE2jDefYAGZhHbWMSXfAXAV+DLJzGlvFQsg1w0wy9x5asu+gyb/Yrc4lj5SH2kyw4ysb0atKtLv5MZJou2Qgihfs+ZdXkmPe9/mqmcCKsPD0PJKzfn8H8W8Chfg72D9DN/EbtKuOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wwmEq5DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wwmEq5DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1D7C4CECC;
	Sat, 30 Nov 2024 05:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732943346;
	bh=JTAiltfKV6u+Ydn8ugjcSW+7adxL2hr96679lcq4wq8=;
	h=Date:To:From:Subject:From;
	b=wwmEq5DNbQSPnoZrslLlkAL+ZRGud4Ficv9/+IOiF/YNCMEnU6wSl0WFQMrGk0NHg
	 aZr1sUyxxRVIFYbp3iFLy7vIXdajcZadkuJhKWhLArUqUShkJ0HuuVWi5dBw9osXPk
	 Ba2yD0ETxdYKk/GTHuDSk4WrvTB5y4eISRPqg0Rw=
Date: Fri, 29 Nov 2024 21:09:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,aliceryhl@google.com,a.hindborg@kernel.org,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-extract-xa_zero_to_null.patch added to mm-nonmm-unstable branch
Message-Id: <20241130050906.6F1D7C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: extract xa_zero_to_null
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-extract-xa_zero_to_null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-extract-xa_zero_to_null.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tamir Duberstein <tamird@gmail.com>
Subject: xarray: extract xa_zero_to_null
Date: Tue, 12 Nov 2024 14:25:36 -0500

Patch series "xarray: extract __xa_cmpxchg_raw".

This series reduces duplication between __xa_cmpxchg and __xa_insert by
extracting a new function that does not coerce zero entries to null on the
return path.

The new function may be used by the upcoming Rust xarray abstraction in
its reservation API where it is useful to tell the difference between zero
entries and null slots.


This patch (of 2):

Reduce code duplication by extracting a static inline function that
returns its argument if it is non-zero and NULL otherwise.

This changes xas_result to check for errors before checking for zero but
this cannot change the behavior of existing callers:
- __xa_erase: passes the result of xas_store(_, NULL) which cannot fail.
- __xa_store: passes the result of xas_store(_, entry) which may fail.
  xas_store calls xas_create when entry is not NULL which returns NULL
  on error, which is immediately checked. This should not change
  observable behavior.
- __xa_cmpxchg: passes the result of xas_load(_) which might be zero.
  This would previously return NULL regardless of the outcome of
  xas_store but xas_store cannot fail if xas_load returns zero
  because there is no need to allocate memory.
- xa_store_range: same as __xa_erase.

Link: https://lkml.kernel.org/r/20241112-xarray-insert-cmpxchg-v1-0-dc2bdd8c4136@gmail.com
Link: https://lkml.kernel.org/r/20241112-xarray-insert-cmpxchg-v1-1-dc2bdd8c4136@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/lib/xarray.c~xarray-extract-xa_zero_to_null
+++ a/lib/xarray.c
@@ -435,6 +435,11 @@ static unsigned long max_index(void *ent
 	return (XA_CHUNK_SIZE << xa_to_node(entry)->shift) - 1;
 }
 
+static inline void *xa_zero_to_null(void *entry)
+{
+	return xa_is_zero(entry) ? NULL : entry;
+}
+
 static void xas_shrink(struct xa_state *xas)
 {
 	struct xarray *xa = xas->xa;
@@ -451,8 +456,8 @@ static void xas_shrink(struct xa_state *
 			break;
 		if (!xa_is_node(entry) && node->shift)
 			break;
-		if (xa_is_zero(entry) && xa_zero_busy(xa))
-			entry = NULL;
+		if (xa_zero_busy(xa))
+			entry = xa_zero_to_null(entry);
 		xas->xa_node = XAS_BOUNDS;
 
 		RCU_INIT_POINTER(xa->xa_head, entry);
@@ -1474,9 +1479,7 @@ void *xa_load(struct xarray *xa, unsigne
 
 	rcu_read_lock();
 	do {
-		entry = xas_load(&xas);
-		if (xa_is_zero(entry))
-			entry = NULL;
+		entry = xa_zero_to_null(xas_load(&xas));
 	} while (xas_retry(&xas, entry));
 	rcu_read_unlock();
 
@@ -1486,11 +1489,9 @@ EXPORT_SYMBOL(xa_load);
 
 static void *xas_result(struct xa_state *xas, void *curr)
 {
-	if (xa_is_zero(curr))
-		return NULL;
 	if (xas_error(xas))
 		curr = xas->xa_node;
-	return curr;
+	return xa_zero_to_null(curr);
 }
 
 /**
_

Patches currently in -mm which might be from tamird@gmail.com are

xarray-extract-xa_zero_to_null.patch
xarray-extract-helper-from-__xa_insertcmpxchg.patch

