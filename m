Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2620E030
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 02:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787969378; cv=none; b=boXWmNOJ8bgP5FM4Nrmyf6dD9wguQKp8sK2A5T+GrVnArn+mxL/NIvPNIqf+OEbNZYcHmH230H2cn6JngnerWzxIxw7lARxGhWfSA5cHlSGeUXmaEkSGnRMZYsUNgyXXFhkCZFonLEyGcDTf1AW3Hfp6PoNDwrnu9SSpidcS+Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787969378; c=relaxed/simple;
	bh=ym3z6+6YZfgBJ2l8Qkuuxal1CgVp2b9sWbdZEstrKM0=;
	h=Date:To:From:Subject:Message-Id; b=QCWbj2JWEmy9trDBRQd4t8g1j/2V2abBsWDzwpZVcTSP1Fxivj96/JHGlyd9AHkW/J+cqdMVafJpqcln78w1jcNp8JFcsQAYUDYjzF/whM7SuFGcU2QT8/cAgx4eRxJ+ulUrupcQ28+IeJDZeM/WtQ0bDpEtEE5ovVKPXtqUIOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iMl/sRR0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iMl/sRR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D341F000E9;
	Sat, 29 Aug 2026 02:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787969376;
	bh=R/iGMVnpUqB7X1Dujsqq34KpUfbZaVy8SA0Z0JowSec=;
	h=Date:To:From:Subject;
	b=iMl/sRR0KpL42avU5Iyko4ofblfky8QNCUV9PVWho3c/Pc3O16a7DiiFu+3Tl2zpB
	 wIDmFo8Tf6nMqrmfkJZb7vBNrOB2lqf+dfB3ObzpCXQygN0UFKDvbgsBht3b86YMbT
	 PBVNqb4of8dLCH1dL0gD+ZSDaui5SZLM7Zfsuuyc=
Date: Fri, 28 Aug 2026 19:09:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liujing@cmss.chinamobile.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,chenyichong@uniontech.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch added to mm-new branch
Message-Id: <20260829020936.55D341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: show available sort keys in usage text
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page_owner_sort: show available sort keys in usage text
Date: Wed, 19 Aug 2026 10:16:11 +0800

The --sort option accepts abbreviated or complete key names, but the usage
text never listed them.  Users had to read the source or the documentation
to discover valid keys.

List all available keys (full form and abbreviation) with a brief
description and examples directly in the --sort help section.

Link: https://lore.kernel.org/20260819021611.2910835-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yichong Chen <chenyichong@uniontech.com>
Cc: Liu Jing <liujing@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text
+++ a/tools/mm/page_owner_sort.c
@@ -772,6 +772,15 @@ static void usage(void)
 		"\t\t\targument in the form of a comma-separated list with some\n"
 		"\t\t\tcommon fields predefined (pid, tgid, comm, stacktrace, allocator, module)\n"
 		"--sort <order>\t\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
+		"\t\t\tAvailable keys:\n"
+		"\t\t\t  pid(p), tgid(tg), name(n), stacktrace(st),\n"
+		"\t\t\t  txt(T), alloc_ts(at), allocator(ator), module(mod)\n"
+		"\t\t\tThe \"+\" is optional since default direction is\n"
+		"\t\t\tincreasing numerical or lexicographic order.\n"
+		"\t\t\tMixed use of abbreviated and complete-form is allowed.\n"
+		"\t\t\tExamples:\n"
+		"\t\t\t  --sort=n,+pid,-tgid\n"
+		"\t\t\t  --sort=mod,at\n"
 	);
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch

