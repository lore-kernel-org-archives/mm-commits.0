Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408763CF049
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773680540; cv=none; b=hjAuipGjBPVj0nz6TnMcIWVD1BULbl8by/6eXF9nRWeCCRJSal56lBOCNxOqiVhZ1oS5Hzk50GLVxviNCrZ5uoZBGHT1Z2CiK+3QOAwSgo5iPirrgQgneWIiz9wU0Is0FA7YYrVsTclNgh6z7L1HJwbT886c8ZTp88QSWWpNjNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773680540; c=relaxed/simple;
	bh=OI/G9//3OZLHhBH1jkEcQuo0fKC/D460/UWXXn5D7Q8=;
	h=Date:To:From:Subject:Message-Id; b=maHS+49V417o8gijcQssn0+H/H8jT+5XYqU0XHO37ua8Xf6cxc0K2oDW99nSIDxWw9M7MSGkqyDx/5a3xF9ESAAnXieG2rPYw5nNrKljTxvuGbzAdWnByNtdLYNdFyLsd2osWyD8sQg8+GMRMNSO8QXe8RYOcHF68X6Krz5kM/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDZHRhYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDZHRhYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD43C19421;
	Mon, 16 Mar 2026 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773680539;
	bh=OI/G9//3OZLHhBH1jkEcQuo0fKC/D460/UWXXn5D7Q8=;
	h=Date:To:From:Subject:From;
	b=IDZHRhYcAklNe0oo3ljnYXWbFhZeaNvmITGnNmiUk1E0FRB9a8cvsgb+FAlXN0CEK
	 F/fLTisZ/Kaq4/Tw5AighhnyVqHD4ggB2rPnNRkaexN9r8sAO/ntiWHzJd+kq5K5IZ
	 fRmEaG6M4U2eYPekfU7yl3EyRhdapoW3JhH0sJYM=
Date: Mon, 16 Mar 2026 10:02:19 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kartikey406@gmail.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-introduce-struct-mfill_state-fix.patch added to mm-unstable branch
Message-Id: <20260316170219.BDD43C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-introduce-struct-mfill_state-fix
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-introduce-struct-mfill_state-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-introduce-struct-mfill_state-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Harry Yoo <harry.yoo@oracle.com>
Subject: userfaultfd-introduce-struct-mfill_state-fix
Date: Mon, 16 Mar 2026 15:19:49 +0900

fix folio_add_new_anon_rmap() WARN

Link: https://lkml.kernel.org/r/abehBY7QakYF9bK4@hyeyoo
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Reported-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/69b703e6.050a0220.248e02.0101.GAE@google.com
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-struct-mfill_state-fix
+++ a/mm/userfaultfd.c
@@ -734,7 +734,7 @@ static __always_inline ssize_t mfill_ato
 		.dst_start = dst_start,
 		.src_start = src_start,
 		.flags = flags,
-
+		.len = len,
 		.src_addr = src_start,
 		.dst_addr = dst_start,
 	};
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

userfaultfd-introduce-struct-mfill_state-fix.patch

