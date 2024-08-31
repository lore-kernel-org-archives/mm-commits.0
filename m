Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F285B3FC2
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725066174; cv=none; b=ao2szCNLkFNFBOrp4l4GwZ69m1UX0XrnVbJ9xlzAnw3RiCvG0KcM0TPNWklyRupcw0JtMa2vjs3Z5YWWYHdGL/Idn8jyeR8jVIZ7T+rFL6NsFlIz1VF3LF6CLi8/pifJNb1Ou5pad60n6kVuGrvkXdVKHb3n0j4oKs2FJ5z4Auk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725066174; c=relaxed/simple;
	bh=DhIVRI00Qv/ijA4oQnyRIyyxdZxjyZqdR7obUW0BKxI=;
	h=Date:To:From:Subject:Message-Id; b=A/WNskqRr08Tr480KGeo13jpRjlcdeAWqj0k3FTP3DJolmAtI8FtXwxuxOmBtbcw/k2jujDc9+U3vVWh67nBLq87JQtWGWgGKKFOGud65nHTNZi2YPmklBgg/obdcnldwXagLy0aVuZkz9KVPtsLHiou+qvILcy5cOL+mTJSiwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cpvuGFvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cpvuGFvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581A3C4CEC5;
	Sat, 31 Aug 2024 01:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725066173;
	bh=DhIVRI00Qv/ijA4oQnyRIyyxdZxjyZqdR7obUW0BKxI=;
	h=Date:To:From:Subject:From;
	b=cpvuGFviQ1bjRgfxTQbDAl4eWIAgIC5q5WxqQ1Fa44quBiUutSaYrea/b+vJ0dVN7
	 yg4FzWL5Q14IJr+cHLR/s7EpulrI+DotZxmLB0kz2BQsNM3XDTkyvkXNhh6ii+2mDT
	 tnIqHSWLuTYJA8WPSyhDaUd4wPcNteh0irn7cUaw=
Date: Fri, 30 Aug 2024 18:02:52 -0700
To: mm-commits@vger.kernel.org,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-rm-thp_swap_allocator_test-when-make-clean.patch added to mm-nonmm-unstable branch
Message-Id: <20240831010253.581A3C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: rm thp_swap_allocator_test when make clean
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-mm-rm-thp_swap_allocator_test-when-make-clean.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-rm-thp_swap_allocator_test-when-make-clean.patch

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
From: zhangjiao <zhangjiao2@cmss.chinamobile.com>
Subject: tools/mm: rm thp_swap_allocator_test when make clean
Date: Thu, 29 Aug 2024 12:20:08 +0800

rm thp_swap_allocator_test when make clean

Link: https://lkml.kernel.org/r/20240829042008.6937-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhangjiao <zhangjiao2@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/Makefile~tools-mm-rm-thp_swap_allocator_test-when-make-clean
+++ a/tools/mm/Makefile
@@ -23,7 +23,7 @@ $(LIBS):
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
-	$(RM) page-types slabinfo page_owner_sort
+	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are

tools-mm-rm-thp_swap_allocator_test-when-make-clean.patch

