Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9C7757E6
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 18:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133792; cv=none; b=Lz23Kr2kze+1mfDgCIkwd5UvMDhN2sFkCXdNCqTcFTmrnH6FeXX/voF9owr+ASsjR/5/hV28lQbRMPEitOjlA1vPclllpPgt1Ebn1gRauxeVqfzQOXZDFM6yAoHs2zaNoQWxAx45HuLxDXBDjyxuGeTJv4WvB8BOBSb1MfqRdGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133792; c=relaxed/simple;
	bh=CzgYhEYRtx0M6uZxcTABefDac2DL2uTVeyszQPRhhAQ=;
	h=Date:To:From:Subject:Message-Id; b=uv8OYUO6TqXxJgl6tqSqp0wcxlz1Hxx0XEW2XiL7vZZInbPUHaL/XWHMWkw5Oiiw36yeWM0/a6GyOIZkN8eWrwchUoLazk7ekpA97RFmzihUc1F8qOLj+/qyL3YkItm0bIzp5ii1vyrVcbrSiDvc3BT3OVxN9xii2xOvZ2/Ev10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gYNXl0lx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gYNXl0lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1569CC433F1;
	Fri, 22 Mar 2024 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711133792;
	bh=CzgYhEYRtx0M6uZxcTABefDac2DL2uTVeyszQPRhhAQ=;
	h=Date:To:From:Subject:From;
	b=gYNXl0lxas4fFY/d7szDn4U0lt8Xo8ze7G256ZXOkApSb2BfsEwD70P7aggQQFGbh
	 ErVI9wy0Gj3Hy3V+OWXkKlXzK+YhWZiki7gdhl5RvO63WWGu4AcyfZYUNTmS8OK7kz
	 IS3I1Pj9lxzrtzYwtfW1Z9uQs72ZYR9h9prylhKg=
Date: Fri, 22 Mar 2024 11:56:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@ZenIV.linux.org.uk,tujinjiang@huawei.com,jack@suse.cz,brauner@kernel.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch added to mm-unstable branch
Message-Id: <20240322185632.1569CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: don't decrease mmap_miss when folio has workingset flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/readahead: don't decrease mmap_miss when folio has workingset flags
Date: Fri, 22 Mar 2024 17:35:55 +0800

If there are too many folios that are recently evicted in a file, then
they will probably continue to be evicted.  In such situation, there is no
positive effect to read-ahead this file since it is only a waste of IO.

The mmap_miss is increased in do_sync_mmap_readahead() and decreased in
both do_async_mmap_readahead() and filemap_map_pages().  In order to skip
read-ahead in above scenario, the mmap_miss have to increased exceed
MMAP_LOTSAMISS.  This can be done by stop decreased mmap_miss when folio
has workingset flags.  The async path is not to care because in above
scenario, it's hard to run into the async path.

Link: https://lkml.kernel.org/r/20240322093555.226789-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags
+++ a/mm/filemap.c
@@ -3492,7 +3492,8 @@ static vm_fault_t filemap_map_folio_rang
 		if (PageHWPoison(page + count))
 			goto skip;
 
-		(*mmap_miss)++;
+		if (!folio_test_workingset(folio))
+			(*mmap_miss)++;
 
 		/*
 		 * NOTE: If there're PTE markers, we'll leave them to be
@@ -3541,7 +3542,8 @@ static vm_fault_t filemap_map_order0_fol
 	if (PageHWPoison(page))
 		return ret;
 
-	(*mmap_miss)++;
+	if (!folio_test_workingset(folio))
+		(*mmap_miss)++;
 
 	/*
 	 * NOTE: If there're PTE markers, we'll leave them to be
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch
mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch

