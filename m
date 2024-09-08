Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43021799D
	for <mm-commits@vger.kernel.org>; Sun,  8 Sep 2024 03:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725765538; cv=none; b=cWt9wNi7SHdROnElsj2tiXs+xKnPSlGtO2AZPb1XtdDH8eFCowEUa50xB7xdkHuSnhyklqhrbOzk/cGmQQLReDdAcfoVjXNvFDMzpOWr2+LfWi1yT+cek1Akh3uhm4H+LVlyoJp1bm27qGEGVnUGzJsrGAmvlMTN3mRq1tyFd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725765538; c=relaxed/simple;
	bh=p8JzryF/HdHPLxEvtgttGubUJuedtki8CpGIOxLyu8s=;
	h=Date:To:From:Subject:Message-Id; b=elcaKEIbGlAWvOIjLJ45dE1aFdOCZatLXjctRcA9GMIlYV856/m2WdVVQf+HsDYbR3+lQp5qDeu62hMyK6NsYXZEqW6aZlbSsQv3GO28Q2db88JbggJtBPUu9MuH+GhgdEVei24PVcRVSE9xPY5TryEZ+quhXlVM34t4IiqofPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U26u09wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U26u09wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53361C4CEC4;
	Sun,  8 Sep 2024 03:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725765538;
	bh=p8JzryF/HdHPLxEvtgttGubUJuedtki8CpGIOxLyu8s=;
	h=Date:To:From:Subject:From;
	b=U26u09wyQxTzlZXvjMdGdQZO4f4b+C3meRZ+ytKvNDJpVSf4OErTtKnms3FPTqNpL
	 83EyMEUn9VANFH2l5r5uXVSGFvv1Z5K0D+MV4pn/4UaGa32S7ynQOy0YEuBejVS86t
	 YwNfqrNbtvylP4YCk7LbOyGihT3OsN1crzwzmnis=
Date: Sat, 07 Sep 2024 20:18:57 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,muchun.song@linux.dev,kent.overstreet@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-fix-a-typo.patch added to mm-unstable branch
Message-Id: <20240908031858.53361C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: fix a typo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-codetag-fix-a-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-fix-a-typo.patch

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
Subject: mm/codetag: fix a typo
Date: Thu, 5 Sep 2024 22:21:06 -0600

Link: https://lkml.kernel.org/r/20240906042108.1150526-1-yuzhao@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~mm-codetag-fix-a-typo
+++ a/include/linux/alloc_tag.h
@@ -70,7 +70,7 @@ static inline struct alloc_tag *ct_to_al
 /*
  * When percpu variables are required to be defined as weak, static percpu
  * variables can't be used inside a function (see comments for DECLARE_PER_CPU_SECTION).
- * Instead we will accound all module allocations to a single counter.
+ * Instead we will account all module allocations to a single counter.
  */
 DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch
mm-codetag-fix-a-typo.patch
mm-codetag-fix-pgalloc_tag_split.patch
mm-codetag-add-pgalloc_tag_copy.patch

