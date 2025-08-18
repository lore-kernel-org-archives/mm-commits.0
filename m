Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141423176F1
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755485166; cv=none; b=CP0ZodLInKhWckG3hQfrlwOvLAbvM+SVhZrCGHq+UMoSCCnAnl5f9ThkooPrFUXH99jYIuNdtWGYRASwhZB8kSORQCn2BNBGpa6cHrJbcMJ0qhSQEV8YtP9nW1Pt7pkCysyrGRafk63jezkEVxsYEVW8z8JmbS3Bfx3nmQ+Eylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755485166; c=relaxed/simple;
	bh=TByEUysuYJAlLh6IvBaPSxrlLt5BtPW7PVPnEyxcUfg=;
	h=Date:To:From:Subject:Message-Id; b=kLuGAHUbg96hveOPWsbdnqZ/IKT7KPmTCBKbG8mYVHmvjqMdhS5+YHPy66BBXfm5k4plLhdwfU8uheCmnEp+lSxEq1mKMgSrSbI7q2DGUkKtTriU8rWf9NmSz/4dybZqHUPHoAHVmVkYQE75bmemxcL9xPAlGz+8+JLt5VyNTF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QfBTy3bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QfBTy3bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A133C4CEEB;
	Mon, 18 Aug 2025 02:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755485164;
	bh=TByEUysuYJAlLh6IvBaPSxrlLt5BtPW7PVPnEyxcUfg=;
	h=Date:To:From:Subject:From;
	b=QfBTy3bnJG49Se93sNHy8lWuK/L2ogQKtVv2hY/pqpztimPjUGCYl3NRhn9pqykQP
	 /kJH/RF2TTqEA/8o6NF/ZzUXKaX7y4bNi5R72LKL/B3X3yLEjuRfqUhdRaV5j7VDwm
	 1BWdXWIT/ZtEw5BEcx+qIEVqzuEWvBEPfCCWk/yA=
Date: Sun, 17 Aug 2025 19:46:03 -0700
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,viro@zeniv.linux.org.uk,sj1557.seo@samsung.com,linkinjeon@kernel.org,jack@suse.cz,brauner@kernel.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-convert-do_mpage_readpage-to-return-int-type.patch added to mm-new branch
Message-Id: <20250818024604.7A133C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mpage: convert do_mpage_readpage() to return int type
has been added to the -mm mm-new branch.  Its filename is
     mpage-convert-do_mpage_readpage-to-return-int-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-convert-do_mpage_readpage-to-return-int-type.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mpage: convert do_mpage_readpage() to return int type
Date: Tue, 12 Aug 2025 15:22:25 +0800

The return value of do_mpage_readpage() is arg->bio, which is already set
in the arg structure.  Returning it again is redundant.

This patch changes the return type to int and always returns 0 since the
caller does not care about the return value.

Link: https://lkml.kernel.org/r/20250812072225.181798-3-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>
Cc: Yuezhang Mo <Yuezhang.Mo@sony.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/mpage.c~mpage-convert-do_mpage_readpage-to-return-int-type
+++ a/fs/mpage.c
@@ -148,7 +148,7 @@ struct mpage_readpage_args {
  * represent the validity of its disk mapping and to decide when to do the next
  * get_block() call.
  */
-static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
+static int do_mpage_readpage(struct mpage_readpage_args *args)
 {
 	struct folio *folio = args->folio;
 	struct inode *inode = folio->mapping->host;
@@ -297,7 +297,7 @@ alloc_new:
 	else
 		args->last_block_in_bio = first_block + blocks_per_folio - 1;
 out:
-	return args->bio;
+	return 0;
 
 confused:
 	if (args->bio)
@@ -360,7 +360,7 @@ void mpage_readahead(struct readahead_co
 		prefetchw(&folio->flags);
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
-		args.bio = do_mpage_readpage(&args);
+		do_mpage_readpage(&args);
 		if (!folio_test_locked(folio) &&
 		    !folio_test_uptodate(folio))
 			break;
@@ -381,7 +381,7 @@ int mpage_read_folio(struct folio *folio
 		.get_block = get_block,
 	};
 
-	args.bio = do_mpage_readpage(&args);
+	do_mpage_readpage(&args);
 	if (args.bio)
 		mpage_bio_submit_read(args.bio);
 	return 0;
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch
mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch
mpage-terminate-read-ahead-on-read-error.patch
mpage-clean-up-do_mpage_readpage.patch
mpage-convert-do_mpage_readpage-to-return-int-type.patch

