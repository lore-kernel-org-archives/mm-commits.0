Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE4A3B298
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708547794; cv=none; b=WhctKq7IhObaSnWJ9kLM1Gf6X1enMfutYQ3q10CD+v9hlg7dvNe8Y3MHNbgjpAn8N00aDzXoJ68C8kHUeYcH0ql1hzRGSpwpY/QtbfVamlTLY/1fsXAS6X7MihYks3S2Il32g/Y/FAZN0+Ehgkztz0xt77i1tCRBVUsX4YuMaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708547794; c=relaxed/simple;
	bh=j77IX21ZQUAWJ6ZpJA/LyLJHKGVpsflUYHhyEDgyXqk=;
	h=Date:To:From:Subject:Message-Id; b=tm5sfRyttys6nJQOM5I/mlR+fCrKlzO8RKN+O52nHjciwaqozLxUejajxcv9LQWC4SkDrx6gVdtaU7bKRd/WbvtSrnDWk7MvlpamF2RPYo8RbdncquSs7tgxGAufpWIuN0HNyz0cvg3qnX/CT9JqLH/Iwdq7OLn6D1nvNtDXBaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmU/K7VT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmU/K7VT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9862C43394;
	Wed, 21 Feb 2024 20:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708547793;
	bh=j77IX21ZQUAWJ6ZpJA/LyLJHKGVpsflUYHhyEDgyXqk=;
	h=Date:To:From:Subject:From;
	b=UmU/K7VTwvo7h8R6JtVeLnNMGH1v1D0WSCkmrI4sDBYNxJCqVJ8BjJmEfnXi1kcLg
	 vqZnPvBU4pD9a5ceBe82w9XG1NnZ4uR4F862NPf6IrMN2WwP1zEMZBC9ivfvosE9oQ
	 i0maOFvZ548fBf9sxrr0oxyzgGr1MSWXXHAK1JiQ=
Date: Wed, 21 Feb 2024 12:36:33 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch added to mm-unstable branch
Message-Id: <20240221203633.D9862C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile:__swap_duplicate: drop redundant WRITE_ONCE on swap_map for err cases
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch

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
From: Barry Song <21cnbao@gmail.com>
Subject: mm/swapfile:__swap_duplicate: drop redundant WRITE_ONCE on swap_map for err cases
Date: Wed, 21 Feb 2024 22:10:28 +1300


The code is quite hard to read, we are still writing swap_map after
errors happen. Though the written value is as before,

 has_cache = count & SWAP_HAS_CACHE;
 count &= ~SWAP_HAS_CACHE;
 [snipped]
 WRITE_ONCE(p->swap_map[offset], count | has_cache);

It would be better to entirely drop the WRITE_ONCE for both
performance and readability.

Link: https://lkml.kernel.org/r/20240221091028.123122-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swapfile.c~mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases
+++ a/mm/swapfile.c
@@ -3335,6 +3335,9 @@ static int __swap_duplicate(swp_entry_t
 	} else
 		err = -ENOENT;			/* unused swap entry */
 
+	if (err)
+		goto unlock_out;
+
 	WRITE_ONCE(p->swap_map[offset], count | has_cache);
 
 unlock_out:
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch

