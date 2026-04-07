Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6C837C0E3
	for <mm-commits@vger.kernel.org>; Tue,  7 Apr 2026 22:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775600898; cv=none; b=sp034ta7PzSZUr9SMnjaXNCAcWEx8mQz7XsZnNSD1ptZBwLX88VkzGmQch3Boq3pmMngS6efOUl8DtZ3LrPlSmuhZM2+jCZeqLtuqT1VDRqqDPuADwWf/9Ur/Fv18xYJ9st6aY3zNAIEq4X9/PHhmk7Ri3XMu/F/WbQoj+3JT9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775600898; c=relaxed/simple;
	bh=Idg1rAqjCDTIk2ZXbloQ/l2VeqBtCL3Hf9qXD152ymk=;
	h=Date:To:From:Subject:Message-Id; b=u/ZwIDf0xUfgXah16HjQLWNGayCi1F5WgFkwjABLey5Z7elDwErPH+YM8m+4fXi6S+PSWBNASO8VLuBD+lncBXDZMChzG0rZrEr67QrbKMsQGnj374jUirsySaqqC49el1Bc4LU9SVsFS1nMSst9Hpx8M994pZR26YTFCZLJdy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myu1F/vX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myu1F/vX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0706C116C6;
	Tue,  7 Apr 2026 22:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775600897;
	bh=Idg1rAqjCDTIk2ZXbloQ/l2VeqBtCL3Hf9qXD152ymk=;
	h=Date:To:From:Subject:From;
	b=myu1F/vXkk2g7W3Yi2u4c3RuYZLVx6UgVh8cXqxP25nN1GFK+hJyI3f4dfOipwpoa
	 ULpO0aKWOJIPE4A0GqXsQzzn6Yg9ZDIE8gtZ7+AaoGNpIzWPp4KIBiV+8ffoPvflIO
	 BkbE9H3JVIUKUDy4pPf3XNbiY/UFwE6QxpewC5s4=
Date: Tue, 07 Apr 2026 15:28:17 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-get_random_u32-where-appropriate.patch added to mm-nonmm-unstable branch
Message-Id: <20260407222817.B0706C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use get_random_u32() where appropriate
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-get_random_u32-where-appropriate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-get_random_u32-where-appropriate.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Carlier <devnexen@gmail.com>
Subject: ocfs2: use get_random_u32() where appropriate
Date: Sun, 5 Apr 2026 16:47:20 +0100

Use the typed random integer helpers instead of get_random_bytes() when
filling a single integer variable.  The helpers return the value directly,
require no pointer or size argument, and better express intent.

Link: https://lkml.kernel.org/r/20260405154720.4732-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/super.c~ocfs2-use-get_random_u32-where-appropriate
+++ a/fs/ocfs2/super.c
@@ -2124,7 +2124,7 @@ static int ocfs2_initialize_super(struct
 		osb->osb_cluster_stack[0] = '\0';
 	}
 
-	get_random_bytes(&osb->s_next_generation, sizeof(u32));
+	osb->s_next_generation = get_random_u32();
 
 	/*
 	 * FIXME
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-use-sio-len-for-pswpin-accounting-in-sio_read_complete.patch
ocfs2-use-get_random_u32-where-appropriate.patch

