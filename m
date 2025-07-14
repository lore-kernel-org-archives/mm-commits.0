Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A739C5103F
	for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2025 22:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532997; cv=none; b=M82ozBftHvcmp6DtrwakWJWywZq7ZZHLglggwAZLz/SdITL0C4XmyW8jkSKH/pYfugGBk+5vlgNkmDl8Nx5cN81069yifIfQHInHFKgRuKqAz75BNEFkltbRGTPyTArL1z6K/cGpLQ/t9vmhYI318T46gf2+yGo4pXQxVbXKd60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532997; c=relaxed/simple;
	bh=dFc/J4cNQjGfJmUUxScf4jfzrCvnZATgTtJOD6IcHyQ=;
	h=Date:To:From:Subject:Message-Id; b=WP2FmJGXlz5IFcolwrLSh5DqOOEsUbHQxoLQSuxMl0PIC3e5tPhjp/nSvmAk1gxAlRjRDzT0B+FXYO6Ir3oMBf/aIfA1YuoFqDdz1vl5ScNS0Hms0Dt/VbdDOu9v3RXSdJgiJcglUNmjDjlno6naHYieqfYb9RsY6VqSKBbi0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q5NHMeq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q5NHMeq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D665C4CEF0;
	Mon, 14 Jul 2025 22:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752532997;
	bh=dFc/J4cNQjGfJmUUxScf4jfzrCvnZATgTtJOD6IcHyQ=;
	h=Date:To:From:Subject:From;
	b=q5NHMeq/pl7BPmiAQqAipZslEz6agYuZdoemhwCRKRpMrcszxA7ES/fzkUoQcjAnA
	 MR8ce+xJJutlCk3mQYKnUAZpS+LpkO71hjNin0AzrKXhPo4rmBXYMQYgU3Aa3C8JZi
	 FqCPniVBtk/ntppE2ZUJQwejqt1V8M5YykwGJxvk=
Date: Mon, 14 Jul 2025 15:43:16 -0700
To: mm-commits@vger.kernel.org,youling.tang@linux.dev,willy@infradead.org,tangyouling@kylinos.cn,ryan.roberts@arm.com,jack@suse.cz,david@redhat.com,chizhiling@kylinos.cn,klarasmodin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-align-last_index-to-folio-size-fix.patch added to mm-new branch
Message-Id: <20250714224317.5D665C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-filemap-align-last_index-to-folio-size-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-align-last_index-to-folio-size-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-align-last_index-to-folio-size-fix.patch

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
From: Klara Modin <klarasmodin@gmail.com>
Subject: mm-filemap-align-last_index-to-folio-size-fix
Date: Tue, 15 Jul 2025 00:34:12 +0200

fix overflow on 32-bit

iocb->ki_pos is loff_t (long long) while pgoff_t is unsigned long and
this overflow seems to happen in practice, resulting in last_index being
before index.

Link: https://lkml.kernel.org/r/yru7qf5gvyzccq5ohhpylvxug5lr5tf54omspbjh4sm6pcdb2r@fpjgj2pxw7va
Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Cc: Chi Zhiling <chizhiling@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Youling Tang <youling.tang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-align-last_index-to-folio-size-fix
+++ a/mm/filemap.c
@@ -2585,8 +2585,8 @@ static int filemap_get_pages(struct kioc
 	int err = 0;
 
 	/* "last_index" is the index of the folio beyond the end of the read */
-	last_index = round_up(iocb->ki_pos + count, mapping_min_folio_nrbytes(mapping));
-	last_index >>= PAGE_SHIFT;
+	last_index = round_up(iocb->ki_pos + count,
+			mapping_min_folio_nrbytes(mapping)) >> PAGE_SHIFT;
 retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
_

Patches currently in -mm which might be from klarasmodin@gmail.com are

mm-filemap-align-last_index-to-folio-size-fix.patch

