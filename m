Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062603BCD29
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 06:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453438; cv=none; b=vGmt2Oe9cRtSiw3ZuW0ThnHcn+eLjRWDOZC0eGmWucXieuPVuZRlDgB0oSui/Gr0/mMbkn+/jjhjcNLxPGL2Mih1dMzWs5sEiN+0YLG9iVMKHjkNWcc8L7Bv1aYoax5CClTTCKsSRIf28rivy8Afl/Y6gr7dsMuxRnN59AqYV/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453438; c=relaxed/simple;
	bh=S/c/JjKJOFwwdqEjq+m645GtqrG3oKzJPo6Dt1ANcqw=;
	h=Date:To:From:Subject:Message-Id; b=WHmcAjxcDbiBHLTp0FnorU/1+EXK3wh9IkaKctgWhKK2QfJTcreOkQHTOqqqxXgg4QNOpDbWixyu2kuzVHq57Qy43IZGGwiRPAkc1Diltl5JZr7Q9Og26glqNmdfwPtBBmaBE57ZfR0cjrEDkTYHFcS93WrrFugndko3OLemYOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zJm7Md12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zJm7Md12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E29C1F000FF;
	Tue, 15 Sep 2026 06:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789453436;
	bh=thA4l0EhKQwdaUbAvtOhhXSiH1vWAsmHnxtxA5VTZwE=;
	h=Date:To:From:Subject;
	b=zJm7Md120qJojf9HYv2JvvkDq7UXl1uXJP51u490Tu1LnpthV4aKvUdnUZDEOXW8h
	 prMIXv5fG2vbubZm7ERmcfOUt6oWGI2eMN54TwNRwdZqazgw7faBOKE4+cgpiWwKGN
	 ycoU3NQYC+0mBx5cZSR+nMELlgmPuqiSjkBTmn/4=
Date: Mon, 14 Sep 2026 23:23:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-fix-the-enable-parameter-description.patch added to mm-new branch
Message-Id: <20260915062356.6E29C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/secretmem: fix the enable parameter description
has been added to the -mm mm-new branch.  Its filename is
     mm-secretmem-fix-the-enable-parameter-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-fix-the-enable-parameter-description.patch

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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: mm/secretmem: fix the enable parameter description
Date: Sat, 12 Sep 2026 13:48:59 +0200

The module parameter is enable, but its MODULE_PARM_DESC() names the
variable behind it, secretmem_enable.  secretmem is built in, so the
description only reaches modules.builtin.modinfo, where it is filed under
secretmem_enable while the parmtype line and
/sys/module/secretmem/parameters/ say enable.

Use the parameter name in the description.

Link: https://lore.kernel.org/20260912114859.88957-1-kmehltretter@gmail.com
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-fix-the-enable-parameter-description
+++ a/mm/secretmem.c
@@ -39,7 +39,7 @@
 
 static bool secretmem_enable __ro_after_init = 1;
 module_param_named(enable, secretmem_enable, bool, 0400);
-MODULE_PARM_DESC(secretmem_enable,
+MODULE_PARM_DESC(enable,
 		 "Enable secretmem and memfd_secret(2) system call");
 
 static atomic_t secretmem_users;
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch

