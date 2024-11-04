Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262801FA272
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730756328; cv=none; b=nCzhHKzR9YdavI6RMC/ig8ACMuMi4rhuFbS+oG950Tn/ClNKandZpyR0EIGO857jLbI6AlXP6LorC9XPOuv94RETPBoCcsECibjEDw1sxjjPrd7KVckHa3Ll1cKtNJOBVDUY7L4m6Ox7XtZeTjsBOG99OAH/Bbn91ybT4gxTRT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730756328; c=relaxed/simple;
	bh=dK1jIQlC/f65WK8NVxfJZHthGcX5F3Fw8zJ9OwIJAIA=;
	h=Date:To:From:Subject:Message-Id; b=cJWUUU7vYzc1TtvnvI/5q4TgkA6Og1p8Xpea/pPEu35XOb7mb3h6DHhel/1H8a/sJQo3umqP3SB4hEiPWfcDdzA/gB360qdP+kqBRBtwhct9UVaQQ+IQ/sTkELNm5luzX51Jp47sqH3lQp8QkAV772cIadUOCVcJnbWbxkfY/mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mSp7P54L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mSp7P54L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAC9C4CECE;
	Mon,  4 Nov 2024 21:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730756327;
	bh=dK1jIQlC/f65WK8NVxfJZHthGcX5F3Fw8zJ9OwIJAIA=;
	h=Date:To:From:Subject:From;
	b=mSp7P54Lg6wkAY7qHSIy4afN7tfaxTnhpsjFRi9p0lVF+P/+bgamN7nBcf9bvxhUj
	 CNcuhZS5nI0enIE96d6koGP3wzWHEsqdDbW/YZFAoPHFUPpKmOTsy1tVY2z+pxjaJK
	 MQBcF116AL7EFkiaDK5RukgU/k6Aak34dc+7OQSw=
Date: Mon, 04 Nov 2024 13:38:47 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch added to mm-unstable branch
Message-Id: <20241104213847.AFAC9C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
Date: Mon, 4 Nov 2024 10:30:29 -0700

remove !rcu_read_lock_held() assertion

  WARNING: CPU: 0 PID: 85 at mm/vmscan.c:3140 folio_update_gen+0x23d/0x250 mm/vmscan.c:3140
  ...

Link: https://lkml.kernel.org/r/ZykEtcHrQRq-KrBC@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru-fix
+++ a/mm/vmscan.c
@@ -3137,7 +3137,6 @@ static int folio_update_gen(struct folio
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
 
 	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
-	VM_WARN_ON_ONCE(!rcu_read_lock_held());
 
 	do {
 		/* lru_gen_del_folio() has isolated this page? */
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-page_alloc-keep-track-of-free-highatomic.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch

