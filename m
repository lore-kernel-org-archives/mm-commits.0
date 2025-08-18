Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE38E3176F1
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755485160; cv=none; b=e7YC6KQ9rQIoJhflJpHa1jQ51ydumPz3Lw9zXYDLEkea9A+PLE9QXzbRucRCyUTxqUABOcgXf0OQH2MxSkrIfG9NjzKLhGHEfOHy34R5R9TxYLEwuxL312TlGJgPbejrWdexa8FboL4uqzBqlqbBmPgPsPzasfrs4TNoDA6YCxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755485160; c=relaxed/simple;
	bh=awVz2u4X2EsqSzn9VbDr9p3CZU/+U41dc+rijdNXe40=;
	h=Date:To:From:Subject:Message-Id; b=uTmRz4L8iHPy9TY/Qfbef3VluidGhLa4ImQ8dcEz007tGpmK4gUuzuxe+GvXytALOAiruZgDYiN55fbDpEZZOIEpnskXsRub02Q+f2rJTISxtjC48LsezcmqegAuWp2r3fj6YzCtHX0EjeHTKxyj3mVpYuVWPK78B8bofuNA8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yYmpcCnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yYmpcCnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E388C4CEEB;
	Mon, 18 Aug 2025 02:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755485160;
	bh=awVz2u4X2EsqSzn9VbDr9p3CZU/+U41dc+rijdNXe40=;
	h=Date:To:From:Subject:From;
	b=yYmpcCnXDgyoqe2bSA83NJ/f9u5n6qq6fqmU9uMwhvdOlmsuUu2hJatzDVgPcu4bi
	 UMxiSyT3q7rpiwU8j60XOqXmgDeDAB/ekf8b08SokFagKWySUPD/NQ1xjj0IfR6OpM
	 78KmPkYgQV69kCzG8kT3/DEk5oRJUN7jx70eUrus=
Date: Sun, 17 Aug 2025 19:45:59 -0700
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,viro@zeniv.linux.org.uk,sj1557.seo@samsung.com,linkinjeon@kernel.org,jack@suse.cz,brauner@kernel.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-terminate-read-ahead-on-read-error.patch added to mm-new branch
Message-Id: <20250818024600.0E388C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mpage: terminate read-ahead on read error
has been added to the -mm mm-new branch.  Its filename is
     mpage-terminate-read-ahead-on-read-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-terminate-read-ahead-on-read-error.patch

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
Subject: mpage: terminate read-ahead on read error
Date: Tue, 12 Aug 2025 15:22:23 +0800

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

Link: https://lkml.kernel.org/r/20250812072225.181798-1-chizhiling@163.com
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

 fs/mpage.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/mpage.c~mpage-terminate-read-ahead-on-read-error
+++ a/fs/mpage.c
@@ -369,6 +369,9 @@ void mpage_readahead(struct readahead_co
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
 		args.bio = do_mpage_readpage(&args);
+		if (!folio_test_locked(folio) &&
+		    !folio_test_uptodate(folio))
+			break;
 	}
 	if (args.bio)
 		mpage_bio_submit_read(args.bio);
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch
mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch
mpage-terminate-read-ahead-on-read-error.patch
mpage-clean-up-do_mpage_readpage.patch
mpage-convert-do_mpage_readpage-to-return-int-type.patch

