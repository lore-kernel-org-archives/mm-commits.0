Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9FD366
	for <mm-commits@vger.kernel.org>; Sat, 14 Dec 2024 00:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734135928; cv=none; b=N7m/iMOKr/zZSbnxK4CPMDo6veh/i0JtBVzJLPG4cqmeQpg7FdVAjRosoOnZIDr9Y9pyErAaB8uLW+T2j2k/I3y1A9JrFJ5dSmOSspCCOm1BjoTsEt5Hbq1S1GdC6FqgN0NF/p4tbO1EpT78OpW6Az5LYpYo8vy5hKtw81qI1X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734135928; c=relaxed/simple;
	bh=GJQfs1OqW5kPDWgTcEzIaTrEv8IHkwO6+UOft1PXvok=;
	h=Date:To:From:Subject:Message-Id; b=q+g3/Td/roYDNHLj9cI1PU2Kei6wnfMATm6+MbYB0chlmKcmbTdbZqxo4xhz2l47+MTeH67krAk5nQM0SVSm+p2B41Hh3efhh7l756D5SDFhj1N5O8OyB9Ct1XsYzyLbBDjiKgAuMrNbB3/8C/ZjJH0oLQJyQELbhyAUyKnk37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G+1XLSgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G+1XLSgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCBDC4CED0;
	Sat, 14 Dec 2024 00:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734135927;
	bh=GJQfs1OqW5kPDWgTcEzIaTrEv8IHkwO6+UOft1PXvok=;
	h=Date:To:From:Subject:From;
	b=G+1XLSgjmiD12/JiKH5b9eex1B0NDFmzjA52RrqcmurWiFMOOHC5Pk+BAYrhPzINl
	 wQJjjWYXiB8iB0Uu09ETZLzkY6Ag2DzffWMF3de70pqveHhN5vvCjGToCVnp/miaWR
	 wV/o+9eNfEzG2NNWWXsnR7liItbLrVlenqAsuptI=
Date: Fri, 13 Dec 2024 16:25:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,corbet@lwn.net,bagasdotme@gmail.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-minor-documentation-improvements.patch added to mm-nonmm-unstable branch
Message-Id: <20241214002527.ACCBDC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: XArray: minor documentation improvements
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-minor-documentation-improvements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-minor-documentation-improvements.patch

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

xarray-extract-xa_zero_to_null.patch
xarray-extract-helper-from-__xa_insertcmpxchg.patch
xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch
xarray-port-tests-to-kunit.patch
checkpatch-check-return-of-git_commit_info.patch
xarray-minor-documentation-improvements.patch

