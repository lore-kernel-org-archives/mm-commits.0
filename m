Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A801CD3F
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738408; cv=none; b=PLuxCR/4IEDYVu4Ixf2WIb2is7Cbykio8uNQMt4aWyMqWIhYZ2koItyqVU9Fg3q4OSCauZmsvOlAkAyHvD+PSbUpoV8yGiU2h3zTfS+2bpl8vL3Ot6wMytF6LD64aUPLBgsDbN2ry4VwsiDuOct0YV/6OrXGdB5ahTp3MvY2Sys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738408; c=relaxed/simple;
	bh=6FQ4Pm+nSyGdn1z/CGEsRKaoprmy8oMNr7USvnKiHNU=;
	h=Date:To:From:Subject:Message-Id; b=S/5dWEq6S8aRMeLbhOq/ksCXF6eq58lcUVl+BFthWCAH/QD83/nCkcmiaNFvDpO8zYG0iIn2Eyp7yHubh79uvKWZdvx4aRI8bs5IfdIJp31w/sN46A8Wup2AxLhrbeNyYoOxxisbb4UCIlOId7fS77Z6IgMAfjATYqopUhkepyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XTDdLcyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XTDdLcyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFE4C4CEC6;
	Thu, 24 Oct 2024 02:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738407;
	bh=6FQ4Pm+nSyGdn1z/CGEsRKaoprmy8oMNr7USvnKiHNU=;
	h=Date:To:From:Subject:From;
	b=XTDdLcyH/1YkLhuFom7b7qbfWGWjTzDrS3cZKkwSdaVF4s/kX0p+BLdMtL3VIZg6K
	 hlzmv2Fy69Gu/eIEyF7BESHzTiXjooHdtvy7Kq3OSMdD4Nbx6v3Z/mK+nik7JfVJg4
	 1zCtmByAGpjEbfLq07M5Gzp1L4mLGHmwnQ5HWlRw=
Date: Wed, 23 Oct 2024 19:53:26 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch added to mm-unstable branch
Message-Id: <20241024025326.DFFE4C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: use str_off_on() helper in build_all_zonelists()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch

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
Subject: mm/page_alloc: use str_off_on() helper in build_all_zonelists()
Date: Mon, 21 Oct 2024 11:13:40 +0200

Remove hard-coded strings by using the str_off_on() helper function.

Link: https://lkml.kernel.org/r/20241021091340.5243-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists
+++ a/mm/page_alloc.c
@@ -5497,7 +5497,7 @@ void __ref build_all_zonelists(pg_data_t
 
 	pr_info("Built %u zonelists, mobility grouping %s.  Total pages: %ld\n",
 		nr_online_nodes,
-		page_group_by_mobility_disabled ? "off" : "on",
+		str_off_on(page_group_by_mobility_disabled),
 		vm_total_pages);
 #ifdef CONFIG_NUMA
 	pr_info("Policy zone: %s\n", zone_names[policy_zone]);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-swap-use-str_true_false-helper-function.patch
mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch
ipc-msg-replace-one-element-array-with-flexible-array-member.patch

