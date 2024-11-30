Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF41FB3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732943349; cv=none; b=X7OIiKItSHKMORb+jFAto0NiWtsvmcZf4PhI3C91h/KAmiZttqpoJzcXw0KSXT7eqdfGNnv+5HF4Y6twABbyMqD6g6mvm8U5JId8mUQV6THD88tV2oRb9tTfrUxxBw/4odBN6SV2e5N9fHzKiEPSfVw309OKicGksBRDflv4LmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732943349; c=relaxed/simple;
	bh=TWgbM9FH774WTEuv7LG7XkYmTY/4ai5CC4XoAFZdeiI=;
	h=Date:To:From:Subject:Message-Id; b=QDFjtvPRMTGgOBhndi32H8kO1huR4fX7I+yeOJme3v45Iwm92IdkJJzZLugS8qU2EqsPQ4MmkZHoaE5WM9uCu0vvReCrYtMhjeqA5KNFOOxGitF4dlsG7f2Ns3+NMxw5e5G1WHkqKP6e3jZX71PM6A+1rBW0Y216nUWb0X9/iu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/vIljYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/vIljYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721FEC4CECC;
	Sat, 30 Nov 2024 05:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732943348;
	bh=TWgbM9FH774WTEuv7LG7XkYmTY/4ai5CC4XoAFZdeiI=;
	h=Date:To:From:Subject:From;
	b=o/vIljYWLMPksgYoC6BMvnyPkWWuL2pT9BkEvYChmfcrDU55XdH3mVU6a4a2u5Pli
	 QCmSCUOircnSY1AM+sWwBJN082yzaTBkwKl7uhgVYxuaqub3iLj65cPfIiE2bQFO4Y
	 qTLjUKFGV701riONTqt+44zgG8dMDmECChu5O0+w=
Date: Fri, 29 Nov 2024 21:09:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,aliceryhl@google.com,a.hindborg@kernel.org,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-extract-helper-from-__xa_insertcmpxchg.patch added to mm-nonmm-unstable branch
Message-Id: <20241130050908.721FEC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: extract helper from __xa_{insert,cmpxchg}
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-extract-helper-from-__xa_insertcmpxchg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-extract-helper-from-__xa_insertcmpxchg.patch

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
Subject: xarray: extract helper from __xa_{insert,cmpxchg}
Date: Tue, 12 Nov 2024 14:25:37 -0500

Reduce code duplication by extracting a static inline function.  This
function is identical to __xa_cmpxchg with the exception that it does not
coerce zero entries to null on the return path.

Link: https://lkml.kernel.org/r/20241112-xarray-insert-cmpxchg-v1-2-dc2bdd8c4136@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

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

xarray-extract-xa_zero_to_null.patch
xarray-extract-helper-from-__xa_insertcmpxchg.patch

