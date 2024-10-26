Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCE9170A1B
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729984076; cv=none; b=D0FLl2mP1JXQx+WSkHpEkyeII+zD6geDwFRZuBPG3DJP8JlY4centogurlwUKWJ5/DUUoLi1DC764BRuxUeaotfiwsOONK3CroM42Wh5l0y1kronGEyoejyPjET9JpHhHwQ3WnNG8Up3Epz89oiY0o1ECtmeXcifhtgl1xckyXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729984076; c=relaxed/simple;
	bh=vPudrUwB9mKUUOauZg4rbTbicXBmj7TVSs1fMmpyoFY=;
	h=Date:To:From:Subject:Message-Id; b=HhTbygUtybFoxKqhsXi9oB+apkv73brtH8GI5fVsiyrvrTCpjwkS4NtVsOj5s5dDhUd6YC+mZMMbf5ON8LpA6tcNrINnBhvU0TQevdXcYU+fuz7pptKUqbz5NnELB451r317LAHmTJt5n9C3ZRduA1/WUQTNuhLyVWgXuTGVTI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ga8ADacM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ga8ADacM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E5AC4CEC7;
	Sat, 26 Oct 2024 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729984075;
	bh=vPudrUwB9mKUUOauZg4rbTbicXBmj7TVSs1fMmpyoFY=;
	h=Date:To:From:Subject:From;
	b=Ga8ADacMQczQEwv1GdCKVOxiDMi3vU6ZI2sGtsWpgsz8MKSFaxCZPuP+Bv7jmzklP
	 TWKN5W1jHzUAxTa3NZZ7DaHNUEkQ8otl/u+i74s3Nt6jlLeEsn+Q0SAfm2TzbBl5KK
	 kCium/5JmDG1bYcK3n1zzo/t7wL5TytaXNpSdJfM=
Date: Sat, 26 Oct 2024 16:07:55 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch added to mm-unstable branch
Message-Id: <20241026230755.D9E5AC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/show_mem: Use str_yes_no() helper in show_free_areas()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/show_mem: Use str_yes_no() helper in show_free_areas()
Date: Sat, 26 Oct 2024 12:35:53 +0200

Remove hard-coded strings by using the str_yes_no() helper function.

Link: https://lkml.kernel.org/r/20241026103552.6790-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/show_mem.c~mm-show_mem-use-str_yes_no-helper-in-show_free_areas
+++ a/mm/show_mem.c
@@ -285,8 +285,7 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
-				"yes" : "no");
+			str_yes_no(pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES));
 	}
 
 	for_each_populated_zone(zone) {
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-swap-use-str_true_false-helper-function.patch
mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch
mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch
ipc-msg-replace-one-element-array-with-flexible-array-member.patch

