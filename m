Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AAF1AAE33
	for <mm-commits@vger.kernel.org>; Thu, 14 Nov 2024 23:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731628686; cv=none; b=l1ym5aTMeXlECwms7afziP2iNUsd3xFsvUMmk5YCt8SgQHHAdAfAJe11SXMRf8PgOdPLgK8xZ6apeO2tS57IdbZY4scK+h+irXmNuYM7h3i+t89pk/V74HwQHH9NYYf1aoT+UD4Nlur1E4jI+tgmtiaqtKZtZj6vWLwQfN94VN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731628686; c=relaxed/simple;
	bh=onc5wBJORiYnCpmqAZc7reaCQ+/1s0x2WvGvh1on9IQ=;
	h=Date:To:From:Subject:Message-Id; b=MVvLeS+oRo3KYWOnPHYF0VRS5eJn13lWz9KI9T2CnBitTIHXk++Cj85H9nH5ByTbjtdXP0Lcxa6/vsb8qG/P4nsGT70oERKhQpTkbH+nCFow7pgiCrU9Wym7IUQA3736eUWBZdGBNewWx5078uOSyW/lTrk3hAVKLsrdzUK9YIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IcXCKgXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IcXCKgXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F69C4CECD;
	Thu, 14 Nov 2024 23:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731628686;
	bh=onc5wBJORiYnCpmqAZc7reaCQ+/1s0x2WvGvh1on9IQ=;
	h=Date:To:From:Subject:From;
	b=IcXCKgXgVgdVP+9TpLx1uGZt02gA15C7r/uqZyd5x5FYZxs/XGmwEmcgLU1gAeTfb
	 T2GFBBXQmZ7u0eRlUWHkJVJO72QeMW4rTnMHEEYjli46a5+UJ67jEv9/rPZZKVo8E8
	 MmZBVmp4j01Eo4p8DRyJXnoT3M1nf3SrStzI9WT8=
Date: Thu, 14 Nov 2024 15:58:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-doc-update-read_ahead_kb-for-madv_hugepage.patch added to mm-hotfixes-unstable branch
Message-Id: <20241114235805.A3F69C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, doc: update read_ahead_kb for MADV_HUGEPAGE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-doc-update-read_ahead_kb-for-madv_hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-doc-update-read_ahead_kb-for-madv_hugepage.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, doc: update read_ahead_kb for MADV_HUGEPAGE
Date: Wed, 13 Nov 2024 23:07:11 +0800

MADV_HUGEPAGE is a new addition to readahead with behavior distinct from
normal pages.  To prevent confusion, we should update the documentation
accordingly.

Link: https://lkml.kernel.org/r/20241113150711.1685-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-block |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/ABI/stable/sysfs-block~mm-doc-update-read_ahead_kb-for-madv_hugepage
+++ a/Documentation/ABI/stable/sysfs-block
@@ -594,6 +594,9 @@ Description:
 		[RW] Maximum number of kilobytes to read-ahead for filesystems
 		on this block device.
 
+		For MADV_HUGEPAGE, the readahead size may exceed this setting
+		since its granularity is based on the hugepage size.
+
 
 What:		/sys/block/<disk>/queue/rotational
 Date:		January 2009
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-readahead-fix-large-folio-support-in-async-readahead.patch
mm-doc-update-read_ahead_kb-for-madv_hugepage.patch

