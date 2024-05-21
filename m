Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C059475
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 23:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716334456; cv=none; b=jvqoTGjzkfVLsTr1fkeh8AGFezAyuLerFx0SKdELW4d2zqWWXUjUynyPeIqC07SNHALqIzytzRykuVkpCZu1VD7x3iBNBipKcqoPdnpKTAVAB7e6b+7G5RoeTSyfIVAcIbXofnT4rZmZ2Yfpimm/ljbSnGEo5bcDaHMwct9n9jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716334456; c=relaxed/simple;
	bh=/a9d7mx2aJY08G+Bp4tF+cZgZq3R/mgL6XB5wzrRaxM=;
	h=Date:To:From:Subject:Message-Id; b=hDjdNB1ytDPoiDNNLFiG1m+N4tSndxGJyCOeR7KCio5Vq5Q+c1z+FwcNcEdqruHUbxUY6BvgqdN4RLqa6Fc7ZLGekd84rJUgPL8Ypdbpu3siQSfnJLk1neBVvdTTmcQi6QxEj8wDTRempXEkFFCa472/sax+FaFDLgP8WFNDbSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PSqfbxVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PSqfbxVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA91C2BD11;
	Tue, 21 May 2024 23:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716334455;
	bh=/a9d7mx2aJY08G+Bp4tF+cZgZq3R/mgL6XB5wzrRaxM=;
	h=Date:To:From:Subject:From;
	b=PSqfbxVXHX0nMHVtCZuGBR055pK/oF580El2KUpvmBOaQaK5VcbtanRoqIyvE96qy
	 6I17AWDPvrTHZeMZ8AyrIKZyNy7ZvTF6d3F6yt+J6lfhrPh5PAjk2RktrPs+c+DVJu
	 kfXBzn0nh852Z7JZz2Rl/DJbMVJoMyv3o2uU1p8Q=
Date: Tue, 21 May 2024 16:34:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-setclearhpage-macros.patch added to mm-unstable branch
Message-Id: <20240521233415.AAA91C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove {Set,Clear}Hpage macros
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-setclearhpage-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-setclearhpage-macros.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: remove {Set,Clear}Hpage macros
Date: Mon, 20 May 2024 15:44:07 -0700

All users have been converted to use the folio version of these macros, we
can safely remove the page based interface.

Link: https://lkml.kernel.org/r/20240520224407.110062-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-setclearhpage-macros
+++ a/include/linux/hugetlb.h
@@ -625,18 +625,14 @@ static __always_inline						\
 void folio_set_hugetlb_##flname(struct folio *folio)		\
 	{	void *private = &folio->private;		\
 		set_bit(HPG_##flname, private);			\
-	}							\
-static inline void SetHPage##uname(struct page *page)		\
-	{ set_bit(HPG_##flname, &(page->private)); }
+	}
 
 #define CLEARHPAGEFLAG(uname, flname)				\
 static __always_inline						\
 void folio_clear_hugetlb_##flname(struct folio *folio)		\
 	{	void *private = &folio->private;		\
 		clear_bit(HPG_##flname, private);		\
-	}							\
-static inline void ClearHPage##uname(struct page *page)		\
-	{ clear_bit(HPG_##flname, &(page->private)); }
+	}
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
@@ -648,15 +644,11 @@ static inline int HPage##uname(struct pa
 #define SETHPAGEFLAG(uname, flname)				\
 static inline void						\
 folio_set_hugetlb_##flname(struct folio *folio) 		\
-	{ }							\
-static inline void SetHPage##uname(struct page *page)		\
 	{ }
 
 #define CLEARHPAGEFLAG(uname, flname)				\
 static inline void						\
 folio_clear_hugetlb_##flname(struct folio *folio)		\
-	{ }							\
-static inline void ClearHPage##uname(struct page *page)		\
 	{ }
 #endif
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-remove-setclearhpage-macros.patch

