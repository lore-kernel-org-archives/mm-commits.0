Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD62F855
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733448271; cv=none; b=csvbp8TQMIn6fouXfnWeeyTjQTTrx1MCY77njN70Ez4iblAvPi8kaPbJk5SHaKer1Vs+aUX+NMPfV2sZ191dMX4M0l9nndYSu38qbiyQ98MkOLk3kc5YTE327vCq+HpBilPrEsHfBVoj7rQSYzhXVqFny17h+IrUPs3aZj3MHWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733448271; c=relaxed/simple;
	bh=7WsWwfaL6Y5a/9QEmNuanpffcGofOsy83aeCYuwcE5c=;
	h=Date:To:From:Subject:Message-Id; b=D3gDCahTBrynMviGGP3t+L2DIEIsmbFkNgzKue7DMUtVGJLzc+mEROiQXlbhbuFd7RYs9LJfBCQsxWSxERrmiuvhswSCVvea9NkInouryXLZ9ga2vU+bpO9pfoYMFrmxi66Swg4ovp4zxQyoAga3hB0G1KlQeBtnBJQj81ex4+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rcMzPkq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rcMzPkq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B593C4CED1;
	Fri,  6 Dec 2024 01:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733448271;
	bh=7WsWwfaL6Y5a/9QEmNuanpffcGofOsy83aeCYuwcE5c=;
	h=Date:To:From:Subject:From;
	b=rcMzPkq+OX9TjbvswmtPEr0uM5k+0T3GVx1pcbyHFQAu/W58Ya8vtQRQQFrlmwEc3
	 5t55C7jEWmtStE9UkJ+Vy2r6ZITpo4n3EVR4cJY0tYegzUykIj82NkOcnaCN/8+gFB
	 qv7L18GSZOJbTKl6karci9gnLimO7Opz+JU6Ln5A=
Date: Thu, 05 Dec 2024 17:24:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com,axboe@kernel.dk,asml.silence@gmail.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241206012431.4B593C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray-extract-helper-from-__xa_insertcmpxchg-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch

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
From: Tamir Duberstein <tamird@gmail.com>
Subject: xarray-extract-helper-from-__xa_insertcmpxchg-fix
Date: Wed, 4 Dec 2024 10:21:59 -0500

fix __xa_erase()

Link: https://lkml.kernel.org/r/CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Reported-by: <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-extract-helper-from-__xa_insertcmpxchg-fix
+++ a/lib/xarray.c
@@ -1509,7 +1509,7 @@ static void *xas_result(struct xa_state
 void *__xa_erase(struct xarray *xa, unsigned long index)
 {
 	XA_STATE(xas, xa, index);
-	return xas_result(&xas, xas_store(&xas, NULL));
+	return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
 }
 EXPORT_SYMBOL(__xa_erase);
 
_

Patches currently in -mm which might be from tamird@gmail.com are

xarray-extract-xa_zero_to_null.patch
xarray-extract-helper-from-__xa_insertcmpxchg.patch
xarray-extract-helper-from-__xa_insertcmpxchg-fix.patch
xarray-port-tests-to-kunit.patch

