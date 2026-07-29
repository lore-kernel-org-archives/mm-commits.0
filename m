Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECE614ABE
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297131; cv=none; b=fVuJ7H67ezKLS/8+OIQXZFKRtICS8f7/yXr9fRcrr6fTjLf9mUXT/d3IZ2CCu6VIPJOdLxjBYbfTqi9YHECq8t690mRs+dIYn9xeupTDjAkDdL5Gwc12fxWUZHmySPj4F1+0KLSZ2jco9gSBg7f/s+RPpkdfH7C1MVvOpaqptbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297131; c=relaxed/simple;
	bh=4UfjQd+CN9fMASXQCrVehZzoam2MY/7dTr4g+wQCBVo=;
	h=Date:To:From:Subject:Message-Id; b=fuegA4LkqMmIDEwJbsoQ6kcNSN2mPEZjOJrqRHiII6/ytfLPjSNBl4npEmlnUHEFSmsH5Tub/aWwBHF5hqYgHrIauSloIMjtvmCD7A70S7nJYM4110fl0zF9bJI4OEfB0P6wyQldGs0b2jaPg8pY0WWdBPclnX60ye/3mfsMkWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=APM/DBnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="APM/DBnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D171F000E9;
	Wed, 29 Jul 2026 03:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297129;
	bh=8D50Czt5N2ofkvXyt4r4jG4XNtnjHtQGXkuGsJ5UYb8=;
	h=Date:To:From:Subject;
	b=APM/DBnvbRDHHPSR0n64lDfowt8he3+XWNwzGVKKt1RpUex8JsZNmGwb/E71qfa7h
	 r1uJlbsEFZLDbusixp/G8dIXT3g4jlpB3ff8OmAVB3EJw0DSxfULva6dHXnYiaMUtD
	 OW0XClyYd3QixSFTYsFLkPXAyYY6pfMjQH5rnmzs=
Date: Tue, 28 Jul 2026 20:52:09 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_owner-document-page_owner-filter-fix.patch removed from -mm tree
Message-Id: <20260729035209.A7D171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: avoid docs build warning
has been removed from the -mm tree.  Its filename was
     mm-page_owner-document-page_owner-filter-fix.patch

This patch was dropped because it was folded into mm-page_owner-document-page_owner-filter.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/page_owner: avoid docs build warning
Date: Wed, 8 Jul 2026 14:35:48 -0700

Fix literal block and indentation to prevent a docs build warning:

Documentation/mm/page_owner.rst:70: WARNING: Literal block expected; none found. [docutils]

Link: https://lore.kernel.org/20260708213548.469155-1-rdunlap@infradead.org
Fixes: c34eea8cecca ("mm/page_owner: document page_owner filter")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_owner.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/mm/page_owner.rst~mm-page_owner-document-page_owner-filter-fix
+++ a/Documentation/mm/page_owner.rst
@@ -65,14 +65,15 @@ un-tracking state.
 Usage
 =====
 
-1) Build user-space helpers::
+1) Build user-space helpers:
+::
 
-To filter page_owner output:
+   To filter page_owner output:
 
 	cd tools/mm
 	make page_owner_filter
 
-To sort and analyze page_owner output:
+   To sort and analyze page_owner output:
 
 	cd tools/mm
 	make page_owner_sort
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-page_owner-document-page_owner-filter.patch
radix-tree-add-correct-some-kernel-doc.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch
rbtree-fixup-kernel-doc-names.patch
llist-use-correct-function-parameter-name.patch
stacktrace-header-repair-kernel-doc-comments.patch

