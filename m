Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AC114D6F6
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742135; cv=none; b=HFDKznEpT69LzFoug3z4hY9SrE4K97PhfvSydyPtaDSRLe0EIB4jvJ4hfuIZ5sdzOOn/a31epym6+pHbn80Gs+la11KY+gVEJxRZqsuYjEJA6jmit5vwnA5ZniUKef4QZY8LARiv6xAwWuD274xbu6wL5rWy8T0HznRdQ7cR+XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742135; c=relaxed/simple;
	bh=p/MVlDvFKsaQhXgN8bT39kGDIzYPdUqoSOAIlMJVRyo=;
	h=Date:To:From:Subject:Message-Id; b=bEsl73w2VfkhdSqeaOFNLFSF/Z4BAN9WDKqromBD8eLDl3f1jG+BTQ1hA/8JgAq9k6wyLDgHwE8sXFGm49iAn5mZJ5N+tlbdTMy/vM48xN01kF2TXNwDjdmz0GuqTNV2J/oX33ppZgu/Az8HB2NZQ6J6K10xC0tKanZzufTdvao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ztWcMXRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ztWcMXRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE482C4CED6;
	Mon, 13 Jan 2025 04:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742134;
	bh=p/MVlDvFKsaQhXgN8bT39kGDIzYPdUqoSOAIlMJVRyo=;
	h=Date:To:From:Subject:From;
	b=ztWcMXRtpmgfyC0FYocQ0le7T/XcszHjQwyv6nb38g+ixwsHlKJNPcSlfks69CQe3
	 xhISy+YSxInVGFNYLRGsAqRNXHo5RwzdrEen2wQmhbH+nITn+BCuHNLMcOZ72YphVB
	 zug2GGlMsl0Irou4g2lftc+dUyJIs1qFLLorsHRM=
Date: Sun, 12 Jan 2025 20:22:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,aliceryhl@google.com,a.hindborg@kernel.org,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xarray-extract-helper-from-__xa_insertcmpxchg.patch removed from -mm tree
Message-Id: <20250113042214.AE482C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: extract helper from __xa_{insert,cmpxchg}
has been removed from the -mm tree.  Its filename was
     xarray-extract-helper-from-__xa_insertcmpxchg.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tamir Duberstein <tamird@gmail.com>
Subject: xarray: extract helper from __xa_{insert,cmpxchg}
Date: Tue, 12 Nov 2024 14:25:37 -0500

Reduce code duplication by extracting a static inline function.  This
function is identical to __xa_cmpxchg with the exception that it does not
coerce zero entries to null on the return path.

[tamird@gmail.com: fix __xa_erase()]
  Link: https://lkml.kernel.org/r/CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com
Link: https://lkml.kernel.org/r/20241112-xarray-insert-cmpxchg-v1-2-dc2bdd8c4136@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/lib/xarray.c~xarray-extract-helper-from-__xa_insertcmpxchg
+++ a/lib/xarray.c
@@ -1491,7 +1491,7 @@ static void *xas_result(struct xa_state
 {
 	if (xas_error(xas))
 		curr = xas->xa_node;
-	return xa_zero_to_null(curr);
+	return curr;
 }
 
 /**
@@ -1509,7 +1509,7 @@ static void *xas_result(struct xa_state
 void *__xa_erase(struct xarray *xa, unsigned long index)
 {
 	XA_STATE(xas, xa, index);
-	return xas_result(&xas, xas_store(&xas, NULL));
+	return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
 }
 EXPORT_SYMBOL(__xa_erase);
 
@@ -1568,7 +1568,7 @@ void *__xa_store(struct xarray *xa, unsi
 			xas_clear_mark(&xas, XA_FREE_MARK);
 	} while (__xas_nomem(&xas, gfp));
 
-	return xas_result(&xas, curr);
+	return xas_result(&xas, xa_zero_to_null(curr));
 }
 EXPORT_SYMBOL(__xa_store);
 
@@ -1601,6 +1601,9 @@ void *xa_store(struct xarray *xa, unsign
 }
 EXPORT_SYMBOL(xa_store);
 
+static inline void *__xa_cmpxchg_raw(struct xarray *xa, unsigned long index,
+			void *old, void *entry, gfp_t gfp);
+
 /**
  * __xa_cmpxchg() - Store this entry in the XArray.
  * @xa: XArray.
@@ -1620,6 +1623,13 @@ EXPORT_SYMBOL(xa_store);
 void *__xa_cmpxchg(struct xarray *xa, unsigned long index,
 			void *old, void *entry, gfp_t gfp)
 {
+	return xa_zero_to_null(__xa_cmpxchg_raw(xa, index, old, entry, gfp));
+}
+EXPORT_SYMBOL(__xa_cmpxchg);
+
+static inline void *__xa_cmpxchg_raw(struct xarray *xa, unsigned long index,
+			void *old, void *entry, gfp_t gfp)
+{
 	XA_STATE(xas, xa, index);
 	void *curr;
 
@@ -1637,7 +1647,6 @@ void *__xa_cmpxchg(struct xarray *xa, un
 
 	return xas_result(&xas, curr);
 }
-EXPORT_SYMBOL(__xa_cmpxchg);
 
 /**
  * __xa_insert() - Store this entry in the XArray if no entry is present.
@@ -1657,26 +1666,16 @@ EXPORT_SYMBOL(__xa_cmpxchg);
  */
 int __xa_insert(struct xarray *xa, unsigned long index, void *entry, gfp_t gfp)
 {
-	XA_STATE(xas, xa, index);
 	void *curr;
+	int errno;
 
-	if (WARN_ON_ONCE(xa_is_advanced(entry)))
-		return -EINVAL;
 	if (!entry)
 		entry = XA_ZERO_ENTRY;
-
-	do {
-		curr = xas_load(&xas);
-		if (!curr) {
-			xas_store(&xas, entry);
-			if (xa_track_free(xa))
-				xas_clear_mark(&xas, XA_FREE_MARK);
-		} else {
-			xas_set_err(&xas, -EBUSY);
-		}
-	} while (__xas_nomem(&xas, gfp));
-
-	return xas_error(&xas);
+	curr = __xa_cmpxchg_raw(xa, index, NULL, entry, gfp);
+	errno = xa_err(curr);
+	if (errno)
+		return errno;
+	return (curr != NULL) ? -EBUSY : 0;
 }
 EXPORT_SYMBOL(__xa_insert);
 
_

Patches currently in -mm which might be from tamird@gmail.com are


