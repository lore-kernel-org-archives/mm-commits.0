Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D6D1EA7CE
	for <mm-commits@vger.kernel.org>; Fri,  5 Sep 2025 01:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757034767; cv=none; b=tX37XQFHmE/+spYslJ2sUh4ZmIKz/hyUY/Jc/TwfsSvX6lLXwsfF8Yaz0SkVO0s+qWcY3MYOK7rWV8+9MVAh2WHBmqwuI4n+rK0tYksFShERWlJKVOwSEGQlGeGTDXM0TytzUqSo+ABIOsaH17qBtU4ZyG/YpFRAZUSGjN0Icbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757034767; c=relaxed/simple;
	bh=vZw2uO8bls3SGyrwnSe49GWqmFDj6R1QDW49PWEZ/Cg=;
	h=Date:To:From:Subject:Message-Id; b=IL9YtRVfEHZoDb3XBazTiYcdZkCd4TmtfHhl1+gXDA24VtBiuXTpc+ALlJuPkDJYNTUSXuSVugyKVh4TOdZfcW2OsNvWAQOc0ykOVADqc7XOFgkfMdnDOXtB6n7kZ1ISgmZM1vor9P/3HcFQ0sBdFQLFnV6pM+iO8XZ6dbz0dro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbz8xYiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbz8xYiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3903C4CEF5;
	Fri,  5 Sep 2025 01:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757034766;
	bh=vZw2uO8bls3SGyrwnSe49GWqmFDj6R1QDW49PWEZ/Cg=;
	h=Date:To:From:Subject:From;
	b=kbz8xYiOnDzJI4iTzQmCcWSJYoYOqCMVPt3tCFuY5go9RlxyIyUKku2u1KR9k1Ohd
	 dKfOBgWpfPBIgUfEOMFjUFA7qGXsg9XPZ5dOBaiwajN4pujfZolUbPL5ZQD5w0IycE
	 w5AVjZQh5mFCr9r9rEQM8OgPE/9rZQK2qescoaj4=
Date: Thu, 04 Sep 2025 18:12:46 -0700
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,viro@zeniv.linux.org.uk,sj1557.seo@samsung.com,linkinjeon@kernel.org,jack@suse.cz,brauner@kernel.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-convert-do_mpage_readpage-to-return-void-type.patch added to mm-unstable branch
Message-Id: <20250905011246.A3903C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mpage: convert do_mpage_readpage() to return void type
has been added to the -mm mm-unstable branch.  Its filename is
     mpage-convert-do_mpage_readpage-to-return-void-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-convert-do_mpage_readpage-to-return-void-type.patch

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
Subject: mpage: convert do_mpage_readpage() to return void type
Date: Fri, 29 Aug 2025 10:36:59 +0800

The return value of do_mpage_readpage() is arg->bio, which is already set
in the arg structure.  Returning it again is redundant.

This patch changes the return type to void since the caller doesn't care
about the return value.

Link: https://lkml.kernel.org/r/20250829023659.688649-2-chizhiling@163.com
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

 fs/mpage.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/mpage.c~mpage-convert-do_mpage_readpage-to-return-void-type
+++ a/fs/mpage.c
@@ -148,7 +148,7 @@ struct mpage_readpage_args {
  * represent the validity of its disk mapping and to decide when to do the next
  * get_block() call.
  */
-static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
+static void do_mpage_readpage(struct mpage_readpage_args *args)
 {
 	struct folio *folio = args->folio;
 	struct inode *inode = folio->mapping->host;
@@ -305,7 +305,7 @@ alloc_new:
 	else
 		args->last_block_in_bio = first_block + blocks_per_folio - 1;
 out:
-	return args->bio;
+	return;
 
 confused:
 	if (args->bio)
@@ -368,7 +368,7 @@ void mpage_readahead(struct readahead_co
 		prefetchw(&folio->flags);
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
-		args.bio = do_mpage_readpage(&args);
+		do_mpage_readpage(&args);
 		/*
 		 * If read ahead failed synchronously, it may cause by removed
 		 * device, or some filesystem metadata error.
@@ -392,7 +392,7 @@ int mpage_read_folio(struct folio *folio
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
mpage-convert-do_mpage_readpage-to-return-void-type.patch

