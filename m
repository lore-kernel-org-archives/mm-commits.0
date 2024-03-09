Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B812D051
	for <mm-commits@vger.kernel.org>; Sat,  9 Mar 2024 03:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709954806; cv=none; b=mEBd9sJ+RyVncNG9gWceJt9c6KBtjYrwkX+ukM1HdZYfXS6fJKO+cQUZ0St4Zma/i9mgBwuFIHV6PNk2vLxQSfJHS8PEQx6wzzLFZgbWq62N7/Ibub9g8S17OEUjTa6mOvEyaNc591jqCunW9S6WUh8qmd4BYzISDq8v2zU+BQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709954806; c=relaxed/simple;
	bh=EVEOcD0fJiI5W9zQhxX/6wVyK1TQ/3tuTe4BgZoAnwQ=;
	h=Date:To:From:Subject:Message-Id; b=UZHerB4jhld9IjXgCDMZhgujoIUHoDljRvMBPlHM2h6cNczl0IAtrwhU2TmZQm3FLGCRfdnyaDWLvLG/lMCQ3YWYwSinKfMA7KcXRRdLFwk35H//F/6nmLOwi2wFAMBFr9IjeJqIxomilY7I3p3Dm9+96qKGLXzOfI0imbVHHw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OWtDQ7RF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OWtDQ7RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764D2C433C7;
	Sat,  9 Mar 2024 03:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709954805;
	bh=EVEOcD0fJiI5W9zQhxX/6wVyK1TQ/3tuTe4BgZoAnwQ=;
	h=Date:To:From:Subject:From;
	b=OWtDQ7RFHtdc0t7rl/h01fSVZ7F+WcHOzKzmk2YiCwpiOxXt0xHo2ri/zz+j4Fbl1
	 5OgAhEHCIs7Lbb1bhemT56MQqLGqinwuGuJWnhbz8qAV/hoFYghozcXGonS+ZllLqo
	 fKi3qQ3pN1NSE4Mdmt2nKchytFkxqPA+9CBIwkqc=
Date: Fri, 08 Mar 2024 19:26:44 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch added to mm-unstable branch
Message-Id: <20240309032645.764D2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prohibit the last subpage from reusing the entire large folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: prohibit the last subpage from reusing the entire large folio
Date: Fri, 8 Mar 2024 22:27:21 +1300

In a Copy-on-Write (CoW) scenario, the last subpage will reuse the entire
large folio, resulting in the waste of (nr_pages - 1) pages.  This wasted
memory remains allocated until it is either unmapped or memory reclamation
occurs.

The following small program can serve as evidence of this behavior

 main()
 {
 #define SIZE 1024 * 1024 * 1024UL
         void *p = malloc(SIZE);
         memset(p, 0x11, SIZE);
         if (fork() == 0)
                 _exit(0);
         memset(p, 0x12, SIZE);
         printf("done\n");
         while(1);
 }

For example, using a 1024KiB mTHP by:
 echo always > /sys/kernel/mm/transparent_hugepage/hugepages-1024kB/enabled

(1) w/o the patch, it takes 2GiB,

Before running the test program,
 / # free -m
                total        used        free      shared  buff/cache   available
 Mem:            5754          84        5692           0          17        5669
 Swap:              0           0           0

 / # /a.out &
 / # done

After running the test program,
 / # free -m
                 total        used        free      shared  buff/cache   available
 Mem:            5754        2149        3627           0          19        3605
 Swap:              0           0           0

(2) w/ the patch, it takes 1GiB only,

Before running the test program,
 / # free -m
                 total        used        free      shared  buff/cache   available
 Mem:            5754          89        5687           0          17        5664
 Swap:              0           0           0

 / # /a.out &
 / # done

After running the test program,
 / # free -m
                total        used        free      shared  buff/cache   available
 Mem:            5754        1122        4655           0          17        4632
 Swap:              0           0           0

This patch migrates the last subpage to a small folio and immediately
returns the large folio to the system. It benefits both memory availability
and anti-fragmentation.

Link: https://lkml.kernel.org/r/20240308092721.144735-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memory.c~mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio
+++ a/mm/memory.c
@@ -3499,6 +3499,16 @@ static bool wp_can_reuse_anon_folio(stru
 				    struct vm_area_struct *vma)
 {
 	/*
+	 * We could currently only reuse a subpage of a large folio if no
+	 * other subpages of the large folios are still mapped. However,
+	 * let's just consistently not reuse subpages even if we could
+	 * reuse in that scenario, and give back a large folio a bit
+	 * sooner.
+	 */
+	if (folio_test_large(folio))
+		return false;
+
+	/*
 	 * We have to verify under folio lock: these early checks are
 	 * just an optimization to avoid locking the folio and freeing
 	 * the swapcache if there is little hope that we can reuse.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch

