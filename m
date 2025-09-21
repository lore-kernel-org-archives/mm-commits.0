Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8105E29ACC3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489892; cv=none; b=d1bALNuFonjfiWOkbNbBQeSn+m1G6NDTUK0HPpTdA7izjv7W9UxGrffsEYzpJ/D0rkEoJ18MK6HdvBFTgJbu3GZljYHxPg1i908jo9FW7V6yoq/zxl02mMqTDmHam18R2a/tqlL6UZUcrV60dzo7CztfxHQf5YJLza2nY2nWWq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489892; c=relaxed/simple;
	bh=SFwhZN+5srvZSNmJfNxgX3tnXhYUHHUX/uSPezhaS9Q=;
	h=Date:To:From:Subject:Message-Id; b=rK4xP332xpeYWRfRwNJ0Z2fwHtIRVgSEYnNdyKo+3o7CB4shAG0uK4LA7HMH7JnfI35xohJd2IsrdUN7zcAJpuLAGmNwCNZ2F02/eqKXt56UK5xAdseitgyIHnxa+fN8lgGmMndFxo++CTxkCWCArE4oxkzL9/YPFGuvEjKXpow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9jfe0fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9jfe0fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8A1C4CEE7;
	Sun, 21 Sep 2025 21:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489892;
	bh=SFwhZN+5srvZSNmJfNxgX3tnXhYUHHUX/uSPezhaS9Q=;
	h=Date:To:From:Subject:From;
	b=Z9jfe0fgJ90pBw5iRcMLxj5948OsBKAMNsSMfgiM+PqqLiLaBHuTpGS+o2mCgc1M7
	 MeGxRjvNjjDikXDfWb2nD0tgTOGe+p542v5ZSpOfBoHkhKQszOztJEfoRmVbiNnc9z
	 kXYf4HuLiPvAXoi/JLSR6ZgG/AJwlPmhIP7QRlu0=
Date: Sun, 21 Sep 2025 14:24:51 -0700
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,viro@zeniv.linux.org.uk,sj1557.seo@samsung.com,linkinjeon@kernel.org,jack@suse.cz,brauner@kernel.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-terminate-read-ahead-on-read-error.patch removed from -mm tree
Message-Id: <20250921212452.4E8A1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mpage: terminate read-ahead on read error
has been removed from the -mm tree.  Its filename was
     mpage-terminate-read-ahead-on-read-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


