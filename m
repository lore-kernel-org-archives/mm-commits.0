Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BAB41C309
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774544685; cv=none; b=vGWbB9oYo71asu2XzlkTzozXH/fF3wFy3P0gZl90olGDPONAqETZUehOjU2pP2XTmw4F70l5JhEeKZiFgtFhtYzbk6i5XODlDU//s//rmxf2m3Q79sV74QNdgCMRYTQiPqYM8AWtSu5/hrIVB7Z17xC92178ZU5wDxvUtbYzzUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774544685; c=relaxed/simple;
	bh=Bu0MFSTGYe05egbej4pVEEnIHfDTM5u/crzO/DF1WEk=;
	h=Date:To:From:Subject:Message-Id; b=LbeSKrnezvQszP2LnuUaxK/4A64sfhKBIOrhU6X3x8LUx9W5lL4ai7N6wrX8PC2p/ZQqyEuSxBMpGGcMgDHfuEgumjl75KpGAkl0uYHXz8rwttkt0TtWdzf8+rI9oYWD3GuhKoS3qNRgR4fEeu/9FhefgnrcgeQmIGDl10LzH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HOv7p3tK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HOv7p3tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4358AC116C6;
	Thu, 26 Mar 2026 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774544685;
	bh=Bu0MFSTGYe05egbej4pVEEnIHfDTM5u/crzO/DF1WEk=;
	h=Date:To:From:Subject:From;
	b=HOv7p3tK8s6GQtrqNLoMkI2Vr+txXI0ClyNiejEpMnY/Zgj0FpQTkYy/pUn1YfjdR
	 LuEB6ReseO8tTQ+z4koAWaGkAgrMqF5aOiERoO7vZVw8dfMTnSUp7slOXnMJp1QCGu
	 KpmE1YzBBy4v0NX7/P5V2y4yFrLILmczRiPeKcOI=
Date: Thu, 26 Mar 2026 10:04:44 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kartikey406@gmail.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-introduce-struct-mfill_state-fix.patch removed from -mm tree
Message-Id: <20260326170445.4358AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd-introduce-struct-mfill_state-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-struct-mfill_state-fix.patch

This patch was dropped because it was folded into userfaultfd-introduce-struct-mfill_state.patch

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

userfaultfd-introduce-struct-mfill_state.patch

