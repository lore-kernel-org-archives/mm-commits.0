Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCE3370D54
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 04:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787804287; cv=none; b=RVVOaTkboySx5eD+NBPZgURvoiR/18ubgt+T8oRRkRmRkGn+3HFnkRnD37MoJR7kABgYVWv4Zwph9yhSH6qOZ6GY2vn4jaSfFolsP2KeBdPongFlq0D8v9jzt1Qrf+NervlmnYuzkHE6xJXTMDIfjxonKHFd25+nmQObBQPpMcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787804287; c=relaxed/simple;
	bh=vEDknXa9CQ6ewM2VLmKbrOG+rx7VACUjmb+qhEcRox0=;
	h=Date:To:From:Subject:Message-Id; b=FuEDe2sxXT5/D5IgzMK5lNcwGcSIDZKWyfGVBha0VncVLWBN0yT8EvYkZSp2Ewpxwy0tSv1vMrqkABpaCfwfi/XuOU2AfuiDR9BZsOtQJsvuLSU+5KlE+kWbKyTLu+SJKzEqBhli3FanBi2oEw+d8JBTBI3+xwyzA5kQUpvfy9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uU0AuPt1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uU0AuPt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD0B1F000E9;
	Thu, 27 Aug 2026 04:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787804285;
	bh=AsSzQ1VtP/gZcW3OzeR0mWeGG+Lfu5P3ObUR6bK4uV0=;
	h=Date:To:From:Subject;
	b=uU0AuPt1blc37D73GyNvXUU/j/2ljiF0jk3QN8Rj6Xz1sCcDA9be0/GjSYgsp7CC9
	 XcYyezWwXTV8x6GNIQW6Y2WrVcD9h5kClptc4dCJsfQ7YIme4+fiNmBtc59d4KUWh3
	 ftUcqeLTYIalHH2X1flbZoxZO+RR4F1KH8cy5jxg=
Date: Wed, 26 Aug 2026 21:18:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshumantewari123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped.patch added to mm-new branch
Message-Id: <20260827041805.CCD0B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix line buffer leak in mremap_test is_range_mapped()
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped.patch

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
From: Anshuman <anshumantewari123@gmail.com>
Subject: selftests/mm: fix line buffer leak in mremap_test is_range_mapped()
Date: Wed, 26 Aug 2026 11:43:00 +0530

is_range_mapped() uses getline() to read /proc/self/maps line by line, but
never frees the buffer it allocates.  Every exit path (parse failure,
match found, or reaching EOF) returns without calling free(line), leaking
the buffer on each call.  The function is called multiple times in this
test, so the leak accumulates across calls.

Free line before returning.

Link: https://lore.kernel.org/20260826061300.14038-1-anshumantewari123@gmail.com
Signed-off-by: Anshuman <anshumantewari123@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -156,6 +156,7 @@ static bool is_range_mapped(FILE *maps_f
 		}
 	}
 
+	free(line);
 	return success;
 }
 
_

Patches currently in -mm which might be from anshumantewari123@gmail.com are

selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped.patch

