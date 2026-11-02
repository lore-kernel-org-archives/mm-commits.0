Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640277;
	b=DfEfOklVJHgUwV2oeSjYYxID52368T7JJnBcKEIgH5MDwcJOlA1idu9BhX+Ou1LtEGN4
	 vykFVE8mO6SwHf4DvyBRw6PxLrduInQ/soOadVpiP0m21c1EK9v62TBWdILejIVSvalPn
	 SsU7YCvXumXh2tHR1apRKKHvREqnNmAp31Gbcbu01bxX+J7dh0y6OAVu5Rxab/AiO4DYr
	 pXcKHQqTkuLbpXJREDUuJOv9Ri+yMA/c+8PCrs3c9ZVivk5eyoajdyUXsEMqDjda7RrAA
	 ocB/gCpN2yBx9XoBI5IcBmG0e12aiqo+mgshCxyAjM86ZMTH4aI3He4shDHcgWYhcdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640277;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=01bCdiH3Hv8nhTVsDqtnHLwlifpBorAZWX9/XA4ahG8=;
	b=kZpPvQws4zNI6JUL69JiLZJT/RV8OYhgqvUaN6wEkyVhxU/2C76hIRBoCXQVMe39oHc9
	 bIvNgBqh+UJyCG1eJmmDtCnU4vvhZM07+HrDu/6CnvWBWa+KGLc6EipvkMdLjVhhG+dg3
	 b/M8ivYrhmduQ735CbMJ9z1GebLumVh7cYdIkeMi3Gi/Vug/Ur4wuIexcbvNXh+Us1nDI
	 3n3OGTj0PP2zfynjp6/8ncBZKICbnNntsHiRIk74n9GAVbaadhSrSsTH1pnK4jFzV/fyB
	 idGYsythEOC86YnIfkhqHJGcjAemgdIaQ+14eBRJ6jIhF25FNsRekBk1My2/v/yIa3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IveF1qko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F2606B922
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IveF1qko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248491F00A16;
	Mon,  2 Nov 2026 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640276;
	bh=01bCdiH3Hv8nhTVsDqtnHLwlifpBorAZWX9/XA4ahG8=;
	h=Date:To:From:Subject;
	b=IveF1qko3dKJ+yVma6C+1NTyX/r3xS7fVImZ84/BLMJQF3VKR4xwIEkuhHGuDWbOo
	 qdBkAYP1KmFtbuo1KoEyX80ZeG8e5lX6YXFSdgzsolQLXAHytHfmSDxvb+c+CaHLEJ
	 VA2NJ1gCKtV9a5r2kbQpX3XFPzVT5JN9TB+GUzd0=
Date: Mon, 02 Nov 2026 09:24:35 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	sh@gentwo.org,rdunlap@infradead.org,manuelebnerli@mailbox.org,
	lienze@kylinos.cn,jm5905938@gmail.com,jaeyeon.lee.dev@gmail.com,
	corbet@lwn.net,adrianhuang0701@gmail.com,ruanjinjie@huawei.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-reclaim-document-how-to-disable-watermarks.patch added to mm-new branch
Message-Id: <20261102172436.248491F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-reclaim-document-how-to-disable-watermarks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-reclaim-document-how-to-disable-watermarks.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks
Date: Mon, 02 Nov 2026 07:07:56 -0800

DAMON_RECLAIM runs its scheme only while the free memory rate is
between `wmarks_low` and `wmarks_mid`.

But some users want to reclaim cold pages even while the system has
plenty of free memory, and it is not obvious that the existing
watermarks parameters can already do that. So Document the setup.

Link: https://lore.kernel.org/20261102150757.93058-10-sj@kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Aveline Noir <jm5905938@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-document-how-to-disable-watermarks
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -193,6 +193,10 @@ DAMON_RECLAIM becomes inactive, so it do
 watermarks.  In the case, the system falls back to the LRU-list based page
 granularity reclamation logic.
 
+To keep DAMON_RECLAIM always active regardless of the free memory rate, set
+``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
+``0``, respectively.
+
 sample_interval
 ---------------
 
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

docs-admin-guide-mm-damon-reclaim-document-how-to-disable-watermarks.patch

