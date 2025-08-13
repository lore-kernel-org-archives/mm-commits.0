Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F91B301462
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755127001; cv=none; b=hu2dGMl5Emb9DKNrHr+vDDewxXXBm/Lp7/Jn5ug6zj2NMI/Gkvw0RAPWJgEo9iXhnLq0G3SmOmpamgQcB8wc0tosL1LEB1Zaon5UNB1E1sQSYOESLjdGJmAFm6lwex6IbZnNzWSqjSCtH+IEbYEQaDlvjmKKm5Z+4KUk5FShyRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755127001; c=relaxed/simple;
	bh=d5FKmRP9KBlF+CZ6C4FQfGALKrQ3SzL+Kfx1941hJls=;
	h=Date:To:From:Subject:Message-Id; b=YkURFFKLSD9iSAl5+RmgPYKsj1VhmsDhfK6ZQoez+IeKPFbarTHrKCYXy0xjykYnYmiGUcUJfA4sRDwT5XAF/cCO/yrF+fKb60UR1zgzfhgkQmumMEN9D4Z/HS2Z1sJQ04OldiJKsG2GcdqKJeZcgqPpg3SKIgSh1CEHjYIZytY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZQSUgQi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZQSUgQi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E61C4CEEB;
	Wed, 13 Aug 2025 23:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126999;
	bh=d5FKmRP9KBlF+CZ6C4FQfGALKrQ3SzL+Kfx1941hJls=;
	h=Date:To:From:Subject:From;
	b=ZQSUgQi/SyGlThz/lX68XQfcPBSkrQNcsS/d+4TqiLCJgSORcYJmWAM1zka6eWXST
	 8qbiBgOAKFS69OhGNLKLN9mAAOY/NGdTmWnXPTqLx24JF55kqBwFRqq4yfygE6ATkK
	 62zT4bOjDstcMPof/f1kfYOjvEcGY8Hzxl3nDkyE=
Date: Wed, 13 Aug 2025 16:16:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,ryan@lahfa.xyz,maximilian@mbosch.me,dhowells@redhat.com,ct@flyingcircus.io,brauner@kernel.org,arnout@bzzt.net,asmadeus@codewreck.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch added to mm-nonmm-unstable branch
Message-Id: <20250813231639.B7E61C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: iov_folioq_get_pages: don't leave empty slot behind
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Dominique Martinet <asmadeus@codewreck.org>
Subject: iov_iter: iov_folioq_get_pages: don't leave empty slot behind
Date: Wed, 13 Aug 2025 15:04:56 +0900

After advancing into a folioq it makes more sense to point to the next
slot than at the end of the current slot.  This should not be needed for
correctness, but this also happens to "fix" the 9p bug with
iterate_folioq() not copying properly.

Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-0-a0ffad2b665a@codewreck.org
Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-2-a0ffad2b665a@codewreck.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Acked-by: David Howells <dhowells@redhat.com>
Tested-by: Arnout Engelen <arnout@bzzt.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian Theune <ct@flyingcircus.io>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maximilian Bosch <maximilian@mbosch.me>
Cc: Ryan Lahfa <ryan@lahfa.xyz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/iov_iter.c~iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind
+++ a/lib/iov_iter.c
@@ -1032,9 +1032,6 @@ static ssize_t iter_folioq_get_pages(str
 			maxpages--;
 		}
 
-		if (maxpages == 0 || extracted >= maxsize)
-			break;
-
 		if (iov_offset >= fsize) {
 			iov_offset = 0;
 			slot++;
@@ -1043,6 +1040,9 @@ static ssize_t iter_folioq_get_pages(str
 				slot = 0;
 			}
 		}
+
+		if (maxpages == 0 || extracted >= maxsize)
+			break;
 	}
 
 	iter->count = count;
_

Patches currently in -mm which might be from asmadeus@codewreck.org are

iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch
iov_iter-iov_folioq_get_pages-dont-leave-empty-slot-behind.patch

