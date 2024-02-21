Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC03C488
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548681; cv=none; b=jPc1pPqE8D75XgeWHQy++sxqqo2Sh5jcPno2YboJp4bI30KkZ7lXSPxAgBRXiJ108C3U+sHGWalu91GRqtYmBONAwuaKSmUbKoS+3Istf+G6VO/J2L66Svvkpy+muRyIgIhM8R17ZB+ZqLO9nXzZbL62Ukvpr0KNubeD/1ukM84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548681; c=relaxed/simple;
	bh=xiUUbTRG4nuAqSyA7c1HaCYP2bJiePRbvx05pF+jyIQ=;
	h=Date:To:From:Subject:Message-Id; b=SZBoDT2Ik1Mpd2pY/9N3nbP0nQVWSKZAw26J7m1Q2CR6qWe1p3Y1vXnaG/CHbTTzn5UTp5blYnyMghnyejkIZBnIkirvD50kdh/m6IUdd9T+3Qk/2fyzzbjjgRtXG+NhndWdP7PpgWSTqptOcGKRLBqZ4YM7DlK2xw27MD1WB+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q5Plyy55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q5Plyy55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1921C433F1;
	Wed, 21 Feb 2024 20:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548681;
	bh=xiUUbTRG4nuAqSyA7c1HaCYP2bJiePRbvx05pF+jyIQ=;
	h=Date:To:From:Subject:From;
	b=Q5Plyy554FOHlfSXeCQqK1L8GE8x5y8HLU4ZbxaoHTm3+KwBncNlrnfQuim8VDzvP
	 WxIaQPw98daEKhLySLWsLHzPurOIi9I03E5Dl7HBvQ6m1VeLXrFybuqeZplkZ8mJQ/
	 QNxfUd2MRbwl/TVcD3f5Keo1OUy4lAp7OYKr9ibM=
Date: Wed, 21 Feb 2024 12:51:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch added to mm-unstable branch
Message-Id: <20240221205120.F1921C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: don't call mapping_set_error on AOP_WRITEPAGE_ACTIVATE
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch

This patch will later appear in the mm-unstable branch at
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
From: Christoph Hellwig <hch@lst.de>
Subject: writeback: don't call mapping_set_error on AOP_WRITEPAGE_ACTIVATE
Date: Thu, 15 Feb 2024 07:36:36 +0100

Patch series "convert write_cache_pages() to an iterator", v8.

This is an evolution of the series Matthew Wilcox originally sent in June
2023, which has changed quite a bit since and now has a while based
iterator.


This patch (of 14):

mapping_set_error should only be called on 0 returns (which it ignores) or
a negative error code.

writepage_cb ends up being able to call writepage_cb on the magic
AOP_WRITEPAGE_ACTIVATE return value from ->writepage which means success
but the caller needs to unlock the page.  Ignore that and just call
mapping_set_error on negative errors.

(no fixes tag as this goes back more than 20 years over various renames
and refactors so I've given up chasing down the original introduction)

Link: https://lkml.kernel.org/r/20240215063649.2164017-1-hch@lst.de
Link: https://lkml.kernel.org/r/20240215063649.2164017-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~writeback-dont-call-mapping_set_error-on-aop_writepage_activate
+++ a/mm/page-writeback.c
@@ -2535,7 +2535,9 @@ static int writepage_cb(struct folio *fo
 {
 	struct address_space *mapping = data;
 	int ret = mapping->a_ops->writepage(&folio->page, wbc);
-	mapping_set_error(mapping, ret);
+
+	if (ret < 0)
+		mapping_set_error(mapping, ret);
 	return ret;
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch
writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch
writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch
writeback-only-update-writeback_index-for-range_cyclic-writeback.patch
writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch
writeback-add-a-writeback-iterator.patch

