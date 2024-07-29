Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF2518757E
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 22:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722290914; cv=none; b=IvKEVEyLg0AaA4+BE+4u/isWxGNn1GOu7/uO/9rs89D8oRyJZUHc94aM81XoNobOS8iJ2bP0wqTMmx/neMEMxJqGyVraWugafkt0AneMIMDE/gXlbm0dh1AmNFtywTsiKkV+f8UMpW1cDFQdTdrayRHVNbI4BWP6LQgPvVT7waA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722290914; c=relaxed/simple;
	bh=xjynsF42yQ+iteC+TFKFs+SiLp9OowW/NbL4aJqHEOk=;
	h=Date:To:From:Subject:Message-Id; b=nAW0o8oBy0VauzMwoQqRHKrrMuqMDuSc8Vd9E5SbOJBZ1TWWtT9kL52DlzJdgvQ5I+Jd7seAUNuminD38V5YevL0jo8jOn6Id6uDmPlC7ex+PuP8lbQIEJsC9dqo4M+vGH9FojeGfcRGgrvyJA8gUtoNvRIUIp0jvrb0biYS2AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F8Fe+zwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F8Fe+zwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F288FC32786;
	Mon, 29 Jul 2024 22:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722290914;
	bh=xjynsF42yQ+iteC+TFKFs+SiLp9OowW/NbL4aJqHEOk=;
	h=Date:To:From:Subject:From;
	b=F8Fe+zwOGrfacG0pzHjqnQ8s5tfowpJjUqlaJryPm5yzA1aU4ZWPu1OJqduRKSnBR
	 n5/hhTJeGDUAAyrIQNw5wZwv1GRhIapUtdk6ktERFa8jEn/2MhMMi1LQS5w3tfTMdv
	 F0iUR+z2mNXZWBM0KP1uZN8ULZayBSN4hj+rxluU=
Date: Mon, 29 Jul 2024 15:08:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shuah@kernel.org,rmoar@google.com,Liam.Howlett@oracle.com,kees@kernel.org,jack@suse.cz,ebiederm@xmission.com,davidgow@google.com,brendanhiggins@google.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-entry-for-new-vma-files.patch added to mm-unstable branch
Message-Id: <20240729220833.F288FC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add entry for new VMA files
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-entry-for-new-vma-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-entry-for-new-vma-files.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add entry for new VMA files
Date: Mon, 29 Jul 2024 12:50:39 +0100

The vma files contain logic split from mmap.c for the most part and are
all relevant to VMA logic, so maintain the same reviewers for both.

Link: https://lkml.kernel.org/r/bf2581cce2b4d210deabb5376c6aa0ad6facf1ff.1722251717.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rae Moar <rmoar@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-new-vma-files
+++ a/MAINTAINERS
@@ -24385,6 +24385,19 @@ F:	include/uapi/linux/vsockmon.h
 F:	net/vmw_vsock/
 F:	tools/testing/vsock/
 
+VMA
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	https://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/vma.c
+F:	mm/vma.h
+F:	mm/vma_internal.h
+
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch

