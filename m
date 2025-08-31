Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A5C7405A
	for <mm-commits@vger.kernel.org>; Sun, 31 Aug 2025 19:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756668932; cv=none; b=DuXdnYGQLnQOb9HORiTYEwNzaoc+KNCMa5Qc1ybwp16m+hBljaHU3FdMiXnsK/20NWrCg7jgCenPmwqf1LUYvsrivYbQ0KavrECUtuyZCekT7QopAUjGoIX1jo/CXYXuGhNf7X1ayMNER6qy/Z0QL+5k5O7wRpHYaf4kiReRxXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756668932; c=relaxed/simple;
	bh=ImjimR1Ka2Yo16aXLmd/wxb28mxRHWMFSEI4rkhMt0Q=;
	h=Date:To:From:Subject:Message-Id; b=jAVB2OKqEwmpSkhcj92ncd5CvGBTDUyITWp8m15zD9W70m5M0FK1+q/GKr5k3ivR+wsA+tbme9xmu5CKVa8r/HGCSlT3djtnc3oECk0wsOZYZR+HcICMIopONwy9H+nmTs63CPl1J2K/sz8fVg/ErfE7zLKeFD0R88Wf686sx+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=er+NQOCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="er+NQOCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EADC4CEED;
	Sun, 31 Aug 2025 19:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756668932;
	bh=ImjimR1Ka2Yo16aXLmd/wxb28mxRHWMFSEI4rkhMt0Q=;
	h=Date:To:From:Subject:From;
	b=er+NQOCmVy/DE8JeF88/XTDlQVEp9GHuvyyjfUAQmTuE4Ipj0EBvfl2XxHRa1lEgz
	 i9b95jRlGQQSpTbg2bGsTjXIxyt37js3vBQH6IPqen6/28K6yIkVYrVMW/vehd2D3/
	 4hieHYXPatAsOf1z1VYcdbq4VDjEzbJDFdYrTNso=
Date: Sun, 31 Aug 2025 12:35:31 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,joeypabalinas@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-remove-redundant-casts.patch added to mm-new branch
Message-Id: <20250831193532.22EADC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: remove redundant casts
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd-remove-redundant-casts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-remove-redundant-casts.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: mm/memfd: remove redundant casts
Date: Sun, 31 Aug 2025 01:47:48 -1000

MFD_ALL_FLAGS is already an unsigned int.  Remove redundant casts to
unsigned int.

Link: https://lkml.kernel.org/r/efbbe6093b64a5b19f974871d5262d6e75dff2c0.1756639225.git.joeypabalinas@gmail.com
Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Pabalinas <joeypabalinas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~mm-memfd-remove-redundant-casts
+++ a/mm/memfd.c
@@ -385,11 +385,11 @@ static int sanitize_flags(unsigned int *
 	unsigned int flags = *flags_ptr;
 
 	if (!(flags & MFD_HUGETLB)) {
-		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
+		if (flags & ~MFD_ALL_FLAGS)
 			return -EINVAL;
 	} else {
 		/* Allow huge page size encoding in flags. */
-		if (flags & ~(unsigned int)(MFD_ALL_FLAGS |
+		if (flags & ~(MFD_ALL_FLAGS |
 				(MFD_HUGE_MASK << MFD_HUGE_SHIFT)))
 			return -EINVAL;
 	}
_

Patches currently in -mm which might be from joeypabalinas@gmail.com are

mm-memfd-remove-redundant-casts.patch

