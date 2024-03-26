Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A8213D26F
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711480935; cv=none; b=ZkZNXl/72Ag09lRW8n+GOZiyxH2TO5Sf6WP7m9gFTve+ppzVnyvcX867TtozLHspzOkE+ljIuH+/Y9yOCPDKhNM90eeJRc5hqXSWFtkryZZAP5suHM/HxY1ggX4nWHxf8hJAen67qjoIadPnR5/wrsTZUwsYLgKyf6Ae0l1BvH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711480935; c=relaxed/simple;
	bh=QT5HTiNY9GYk3TsbOM1T+0zsgE30+Pus8p9Ve/NKr4Q=;
	h=Date:To:From:Subject:Message-Id; b=CvFoja6ZQkVvhg0di+P8JMk5rJtP8tcHsQaaUsTltZXhZR6XwglXGeJYnIGReTzU2RMpOd7+OsLCzObMi7PcsIc7uGTOgYFSqPvz7xhX3YN/+Rvcw8h6Y/Ob5h7cDbV53flGRS/pW2gP8FDMigrnkD/SQWCwBygzR/5kYOqPumY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i1HggQcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i1HggQcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7F7C433F1;
	Tue, 26 Mar 2024 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711480934;
	bh=QT5HTiNY9GYk3TsbOM1T+0zsgE30+Pus8p9Ve/NKr4Q=;
	h=Date:To:From:Subject:From;
	b=i1HggQcM1l4AzC5flRhCeRlRhyfulgpR+SC0411UEjma7L+a0PZlXIT4lKzs+rcDW
	 IhJmOyWQaVNW3g8qUezLp3A6T+tZy89gMtuXw/PORnkH6SJBeXCVclkCtw0dhVJ9Ob
	 GEMYyEBJijPea3+qq6o36LapRhbWoyHagKldupWA=
Date: Tue, 26 Mar 2024 12:22:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@ZenIV.linux.org.uk,tujinjiang@huawei.com,jack@suse.cz,brauner@kernel.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix.patch added to mm-unstable branch
Message-Id: <20240326192214.5C7F7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: don't decrease mmap_miss when folio has workingset flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix.patch

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
Subject: mm/filemap: don't decrease mmap_miss when folio has workingset flag
Date: Tue, 26 Mar 2024 14:50:26 +0800

add comments

Link: https://lkml.kernel.org/r/20240326065026.1910584-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/filemap.c~mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix
+++ a/mm/filemap.c
@@ -3492,6 +3492,13 @@ static vm_fault_t filemap_map_folio_rang
 		if (PageHWPoison(page + count))
 			goto skip;
 
+		/*
+		 * If there are too many folios that are recently evicted
+		 * in a file, they will probably continue to be evicted.
+		 * In such situation, read-ahead is only a waste of IO.
+		 * Don't decrease mmap_miss in this scenario to make sure
+		 * we can stop read-ahead.
+		 */
 		if (!folio_test_workingset(folio))
 			(*mmap_miss)++;
 
@@ -3542,6 +3549,7 @@ static vm_fault_t filemap_map_order0_fol
 	if (PageHWPoison(page))
 		return ret;
 
+	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
 		(*mmap_miss)++;
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch
mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch
mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix.patch

