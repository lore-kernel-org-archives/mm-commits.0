Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CD03D7D70
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778271060; cv=none; b=bzFACk6Og6j7EjDYQOPulTupUFBee6o4gXVQFfILqoLiueUwRnnwAg36f+8IlM+e2xifQ20Usnjq71rGd7fas2Hid7aWfz55lLWuDH/puTx741vQd/pf03VhqBrOU5KUbXHoQRPSMx9H1jE8UOBy03W8CU42P8d1Tf/6QRKHplA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778271060; c=relaxed/simple;
	bh=7Ktk8RRPeUx/uV1mNvDzZeDEJqeN2XnfLP7xbISSeCs=;
	h=Date:To:From:Subject:Message-Id; b=samue97eo3ADGdkv3mbrGno641p52JQ6jjC5yZBUqPGSoJVF/ocB9LXEFYW3N9Xr8mnYOovf1RsHJkV7ItTEGdhItPx314JQ4m7GwpI2a3IqiOrysd6zpWAUTebj9qM4408Qf2MPazwrCT8/z4p+CRNj5yOZzE1q6sI5BfrdqLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rR+zVgHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rR+zVgHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9098BC2BCB0;
	Fri,  8 May 2026 20:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778271059;
	bh=7Ktk8RRPeUx/uV1mNvDzZeDEJqeN2XnfLP7xbISSeCs=;
	h=Date:To:From:Subject:From;
	b=rR+zVgHIhJ2/0BIv0lJcH4i3wSvpVxyLXNqkfi2R6zvtlg+sGNpCFfLCRxxTzPBxs
	 LwqVD2ac/L50RCy3+uRb1tDxZ/GOHr/XEiOgfr4C6SRqH5UDUV/q0TOOWVh+8EO2fy
	 VfgpTNqESVLzl9V5uaXN2IA8t9344jnU+mjx8P+M=
Date: Fri, 08 May 2026 13:10:58 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,paulmck@kernel.org,axboe@kernel.dk,phasta@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + llist-make-locking-comments-consistent.patch added to mm-nonmm-unstable branch
Message-Id: <20260508201059.9098BC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: llist: make locking comments consistent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     llist-make-locking-comments-consistent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/llist-make-locking-comments-consistent.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Philipp Stanner <phasta@kernel.org>
Subject: llist: make locking comments consistent
Date: Thu, 7 May 2026 11:49:19 +0200

llist's locking requirement table has a legend which claims that all
operations not needing a lock a marked with '-', whereas in truth for some
table entries just a whitespace is used.

Add the '-' to all appropriate places.

Link: https://lore.kernel.org/20260507094918.23910-2-phasta@kernel.org
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/llist.h~llist-make-locking-comments-consistent
+++ a/include/linux/llist.h
@@ -26,8 +26,8 @@
  *
  *           |   add    | del_first |  del_all
  * add       |    -     |     -     |     -
- * del_first |          |     L     |     L
- * del_all   |          |           |     -
+ * del_first |    -     |     L     |     L
+ * del_all   |    -     |     -     |     -
  *
  * Where, a particular row's operation can happen concurrently with a column's
  * operation, with "-" being no lock needed, while "L" being lock is needed.
_

Patches currently in -mm which might be from phasta@kernel.org are

llist-make-locking-comments-consistent.patch

