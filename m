Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2DD1DE8BE
	for <mm-commits@vger.kernel.org>; Fri,  5 Sep 2025 01:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757034765; cv=none; b=T3bSAxT6lE/ZBQhnMzeCE2+aJ5uagzkMHd+Z7ecVh+VP4upL8stjir3b8kA13aaQAumpjlORvNQticF/pZ/4pMruOm4qy9KEzUOv821rJUmgT4Tx+SSv+zVFHvo1iUCAta6W/F2SGQ+s+pCuBTLwGq5C/JBqSYFaTDcgiJgebik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757034765; c=relaxed/simple;
	bh=eO/2daqCSNuiJ53IpjEFMmwB4MktH470BVr51KkkHI4=;
	h=Date:To:From:Subject:Message-Id; b=rpam7++uJwXqS4fOUmS5L95csvR8yBR4GrtY7EkBaC4FO1Tn7qdvB91H4pbEL3hYGK4Z1ZIP63drW3N2nCSZtevYcPZYUCNWvBKJBZV39JR0YJPEaJIaciaSUgu578Qqu5Fxim+iNFz2/eZc9QgcN0qlFTD1KafFaTLinpY56iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CtCqUTHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CtCqUTHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E354C4CEF7;
	Fri,  5 Sep 2025 01:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757034764;
	bh=eO/2daqCSNuiJ53IpjEFMmwB4MktH470BVr51KkkHI4=;
	h=Date:To:From:Subject:From;
	b=CtCqUTHPKA4pr2viL4T0uEV7L3iZh0raeckLIZGbQNKIECy/eRMdN0ZndwnZ/eIqF
	 ApImnAlfw8v3ZGOVEMie2Q3QX9Y/1JhpeHJi3c/z+uNLZlrJzBbuG4fIsLNLCGETMR
	 Jc8X4J69VzFZVa+dk7jYprOevqHtBs6I+bx6EkuY=
Date: Thu, 04 Sep 2025 18:12:43 -0700
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,viro@zeniv.linux.org.uk,sj1557.seo@samsung.com,linkinjeon@kernel.org,jack@suse.cz,brauner@kernel.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-terminate-read-ahead-on-read-error.patch added to mm-unstable branch
Message-Id: <20250905011244.8E354C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mpage: terminate read-ahead on read error
has been added to the -mm mm-unstable branch.  Its filename is
     mpage-terminate-read-ahead-on-read-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-terminate-read-ahead-on-read-error.patch

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: mpage: terminate read-ahead on read error
Date: Fri, 29 Aug 2025 10:36:58 +0800

For exFAT filesystems with 4MB read_ahead_size, removing the storage
device during read operations can delay EIO error reporting by several
minutes.  This occurs because the read-ahead implementation in mpage
doesn't handle errors.

Another reason for the delay is that the filesystem requires metadata to
issue file read request.  When the storage device is removed, the metadata
buffers are invalidated, causing mpage to repeatedly attempt to fetch
metadata during each get_block call.

The original purpose of this patch is terminate read ahead when we fail to
get metadata, to make the patch more generic, implement it by checking
folio status, instead of checking the return of get_block().

So, if a folio is synchronously unlocked and non-uptodate, should we quit
the read ahead?

I think it depends on whether the error is permanent or temporary, and
whether further read ahead might succeed.  A device being unplugged is one
reason for returning such a folio, but we could return it for many other
reasons (e.g., metadata errors).  I think most errors won't be restored in
a short time, so we should quit read ahead when they occur.

Link: https://lkml.kernel.org/r/20250829023659.688649-1-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>
Cc: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/mpage.c~mpage-terminate-read-ahead-on-read-error
+++ a/fs/mpage.c
@@ -369,6 +369,12 @@ void mpage_readahead(struct readahead_co
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
 		args.bio = do_mpage_readpage(&args);
+		/*
+		 * If read ahead failed synchronously, it may cause by removed
+		 * device, or some filesystem metadata error.
+		 */
+		if (!folio_test_locked(folio) && !folio_test_uptodate(folio))
+			break;
 	}
 	if (args.bio)
 		mpage_bio_submit_read(args.bio);
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch
mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch
mpage-terminate-read-ahead-on-read-error.patch
mpage-convert-do_mpage_readpage-to-return-void-type.patch

