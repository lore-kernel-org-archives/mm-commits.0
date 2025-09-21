Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E162BCF41
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489894; cv=none; b=JHn6t66AnI680e3yDgR9JVXSks2ra4yBM+/NbjujDmzfuR4RWmIUX49mVHYAbyN8Sqtemh8852TLHfzR67JJPng8eMBqg+8JnSfodHtW9Wu+wljDCEswsCxWDykcQ8qRte0MpBSVowgbx0FYjpn3K8RdRYMwTIUXmxDrpM68K24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489894; c=relaxed/simple;
	bh=nVDGaObQrHU9b6Gn+0+83KR5tll5P3mJCezyH68Xyno=;
	h=Date:To:From:Subject:Message-Id; b=EmEerwXMEqbSQBczZkZUh7zgUW/vGNxZJuA7JpnrpM9AkuC4J0p2sOIQXybYMsG9S2uLuKDnxvWP+AEWhVAjP5JPuIw7ixtxgx07TLGi7IX3MXXWGlRChZrHVvJaH7bya+x33jk2GxNHp2uvDW8/MF8ZcWmqi/WiRJsYv/4iSm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZifPbFcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZifPbFcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62FBC4CEE7;
	Sun, 21 Sep 2025 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489893;
	bh=nVDGaObQrHU9b6Gn+0+83KR5tll5P3mJCezyH68Xyno=;
	h=Date:To:From:Subject:From;
	b=ZifPbFcMSQhBDCickHXQ9OB1ZktRof1Rg8XC/+DcMOWV3pd5pkKyNjaCHzibNyVTu
	 ttqFxhnxXISB+shyd/6QDcp7PiptTaMi0/1UMATq1F7/w+yxNkAyG7E7O/k9dRtpCh
	 Qwj3TG8zzNpUjJ5QrTO6kmMIrddeg5af+tFDLWVA=
Date: Sun, 21 Sep 2025 14:24:53 -0700
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,viro@zeniv.linux.org.uk,sj1557.seo@samsung.com,linkinjeon@kernel.org,jack@suse.cz,brauner@kernel.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-convert-do_mpage_readpage-to-return-void-type.patch removed from -mm tree
Message-Id: <20250921212453.C62FBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mpage: convert do_mpage_readpage() to return void type
has been removed from the -mm tree.  Its filename was
     mpage-convert-do_mpage_readpage-to-return-void-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


