Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A125761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742201; cv=none; b=J5VJdRBPxEJwcmhLTKS59CL3R3/blOW0NOaVbAKfI79VK0/pMWtnipWioojoNUJJ+x3yunuAc8nIY74yzV0NLiQlVX9SuRQGfvIULWZmjL6Spyz/32zNg80lFuKYDRxVo+Gbg9jFp1q57MEfLN/BV1B1vr0Lq5KJC1E5UigdZSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742201; c=relaxed/simple;
	bh=N3YZqevQxhYULAnSGrbWA8/fRgPiXo+HKrAzg62bdlk=;
	h=Date:To:From:Subject:Message-Id; b=NqujTval520v+ygeC+cA4RvUIfnvdQS+oqPMkYSfeXdPbViGI+ukMGE4+HupvvGE2nWiZUn4KUDxIomcLvMxLbkzb5BBxyxc9pXbImFVTOP2YeRow0FKWpCbqn0ClpgfTg04xQbVhXBkQb2d4EFYhdkWioxAq6DSztJcQBAGNoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0raGCsDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0raGCsDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA61DC4CED6;
	Mon, 13 Jan 2025 04:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742200;
	bh=N3YZqevQxhYULAnSGrbWA8/fRgPiXo+HKrAzg62bdlk=;
	h=Date:To:From:Subject:From;
	b=0raGCsDKqTatza+KQX8DHFQjsXfTawVIkdrbEQxbVblpaS/c03acOwuPr3a+w27AZ
	 tYtifN9uSb3VsN2qUCHVH6p+Nzv5IzbEUtLTQqy3yYJW+UGRIQHrgwQCLFqSB8Vt9q
	 S1GSeuzkwrn8uAHsvTUTiDivKVIyNa+gmEWoPDTg=
Date: Sun, 12 Jan 2025 20:23:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,corbet@lwn.net,bagasdotme@gmail.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xarray-minor-documentation-improvements.patch removed from -mm tree
Message-Id: <20250113042320.CA61DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: XArray: minor documentation improvements
has been removed from the -mm tree.  Its filename was
     xarray-minor-documentation-improvements.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tamir Duberstein <tamird@gmail.com>
Subject: XArray: minor documentation improvements
Date: Tue, 05 Nov 2024 08:03:42 -0400

- Replace "they" with "you" where "you" is used in the preceding
  sentence fragment.
- Mention `xa_erase` in discussion of multi-index entries.  Split this
  into a separate sentence.
- Add "call" parentheses on "xa_store" for consistency and
  linkification.
- Add caveat that `xa_store` and `xa_erase` are not equivalent in the
  presence of `XA_FLAGS_ALLOC`.

Link: https://lkml.kernel.org/r/20241105-xarray-documentation-v5-1-8e1702321b41@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/xarray.rst |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/Documentation/core-api/xarray.rst~xarray-minor-documentation-improvements
+++ a/Documentation/core-api/xarray.rst
@@ -42,8 +42,8 @@ call xa_tag_pointer() to create an entry
 to turn a tagged entry back into an untagged pointer and xa_pointer_tag()
 to retrieve the tag of an entry.  Tagged pointers use the same bits that
 are used to distinguish value entries from normal pointers, so you must
-decide whether they want to store value entries or tagged pointers in
-any particular XArray.
+decide whether you want to store value entries or tagged pointers in any
+particular XArray.
 
 The XArray does not support storing IS_ERR() pointers as some
 conflict with value entries or internal entries.
@@ -52,8 +52,9 @@ An unusual feature of the XArray is the
 occupy a range of indices.  Once stored to, looking up any index in
 the range will return the same entry as looking up any other index in
 the range.  Storing to any index will store to all of them.  Multi-index
-entries can be explicitly split into smaller entries, or storing ``NULL``
-into any entry will cause the XArray to forget about the range.
+entries can be explicitly split into smaller entries. Unsetting (using
+xa_erase() or xa_store() with ``NULL``) any entry will cause the XArray
+to forget about the range.
 
 Normal API
 ==========
@@ -63,13 +64,14 @@ for statically allocated XArrays or xa_i
 allocated ones.  A freshly-initialised XArray contains a ``NULL``
 pointer at every index.
 
-You can then set entries using xa_store() and get entries
-using xa_load().  xa_store will overwrite any entry with the
-new entry and return the previous entry stored at that index.  You can
-use xa_erase() instead of calling xa_store() with a
-``NULL`` entry.  There is no difference between an entry that has never
-been stored to, one that has been erased and one that has most recently
-had ``NULL`` stored to it.
+You can then set entries using xa_store() and get entries using
+xa_load().  xa_store() will overwrite any entry with the new entry and
+return the previous entry stored at that index.  You can unset entries
+using xa_erase() or by setting the entry to ``NULL`` using xa_store().
+There is no difference between an entry that has never been stored to
+and one that has been erased with xa_erase(); an entry that has most
+recently had ``NULL`` stored to it is also equivalent except if the
+XArray was initialized with ``XA_FLAGS_ALLOC``.
 
 You can conditionally replace an entry at an index by using
 xa_cmpxchg().  Like cmpxchg(), it will only succeed if
_

Patches currently in -mm which might be from tamird@gmail.com are


