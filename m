Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03CD17B505
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771546774; cv=none; b=YfmgJhYGQbXnfbmQVcyP0L66C5Tsif93/cUoq5j2SIS5VsuXBTMaMJHOQiv832sUjKLEWc5qkKmetkbs0XXoxyMWdT12jwfCnwBDotA3oGPoVTgPLfltU6H773wsjXxMsg+U7nXRATKlxvLYrTYNCIS7F9v4piEDsh3Am1UbzFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771546774; c=relaxed/simple;
	bh=xeRhmL7YCZPFglBSFQR3I7Iw5sgie4KShpYxyfbGSCk=;
	h=Date:To:From:Subject:Message-Id; b=IlzXqagP57rSOOPImTRKf2RzT71FmVPMK52Pehn75k8IYVvr2mxFw2HBvOduZJWq2tCcNANmzWbccyxE0ECdMOMHAmHVEOmFVCJl9sYC3PqfMPBTPqlqH0riL97LiF1CxgLEsXHJ/096yMjBlBftueaMUTtqFWfKDmM74K/2bkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X2CnX0+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X2CnX0+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50797C4CEF7;
	Fri, 20 Feb 2026 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771546774;
	bh=xeRhmL7YCZPFglBSFQR3I7Iw5sgie4KShpYxyfbGSCk=;
	h=Date:To:From:Subject:From;
	b=X2CnX0+HK5Ggd86Fk8zw1kpxKR9O9cZMa5YV/vcwJI0v3XXz2SV1oSZt82iiuzU0a
	 DLBzRyucJAZrASzRjHRgbxPXc4Q77w+hgG+2hyCWDErWH/MJG74wehuzbTyg+7skY/
	 +9+28ZDEFUqMIYr8GOlhs13yuduq5Ts194r+zhqQ=
Date: Thu, 19 Feb 2026 16:19:33 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,mssola@mssola.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typo-in-the-comment-of-mod_zone_state.patch added to mm-new branch
Message-Id: <20260220001934.50797C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix typo in the comment of mod_zone_state()
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-typo-in-the-comment-of-mod_zone_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typo-in-the-comment-of-mod_zone_state.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: : Miquel Sabaté Solà <mssola@mssola.com>
Subject: mm: fix typo in the comment of mod_zone_state()
Date: Fri, 20 Feb 2026 00:44:07 +0100

Use the proper function name, followed by parenthesis as usual.

Link: https://lkml.kernel.org/r/20260219234407.3261196-1-mssola@mssola.com
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-fix-typo-in-the-comment-of-mod_zone_state
+++ a/mm/vmstat.c
@@ -547,7 +547,7 @@ EXPORT_SYMBOL(__dec_node_page_state);
 #ifdef CONFIG_HAVE_CMPXCHG_LOCAL
 /*
  * If we have cmpxchg_local support then we do not need to incur the overhead
- * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
+ * that comes with local_irq_save/restore if we use this_cpu_try_cmpxchg().
  *
  * mod_state() modifies the zone counter state through atomic per cpu
  * operations.
_

Patches currently in -mm which might be from mssola@mssola.com are

mm-fix-typo-in-the-comment-of-mod_zone_state.patch

