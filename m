Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62A32F5316
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750204079; cv=none; b=cEwPCy8u085qw+mSJ2Cq1HQQc/HaWiVpaMONP6BVD+eNF6+fBLnITFgUUG5F1uwtRFnqRoVS6/CgecIBPnOMg8T585rtxTqTIpobODqiZorW+EGyy2lsj6w7ejue6lauceLFNjSWYMrMG8c92wKGfEkx6ENlPq2xE5/n9Xk5WwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750204079; c=relaxed/simple;
	bh=ZGYQ5Hl05DDeCc5QTtnNbYFUEj7u7A6MKMlfoIEKHWg=;
	h=Date:To:From:Subject:Message-Id; b=lX4tpimuA61NJ5G73TWcp6xRWm2RcxtfLFygncMtKEsnsiL+1No2CN185iUAXGbOdz5ikAV1tZDXCjYJM7yEY0Wbe6/grCaC1++Dvrc7FzY90VooT0pJK/59Pm39DxBvOcCk0do9CjfhhM8NOIzcxsm7SCcndaVBJ8XTs80B/RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwFP8Gxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwFP8Gxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B90C4CEE3;
	Tue, 17 Jun 2025 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750204079;
	bh=ZGYQ5Hl05DDeCc5QTtnNbYFUEj7u7A6MKMlfoIEKHWg=;
	h=Date:To:From:Subject:From;
	b=qwFP8Gxgsgxqja0cpIYcLl7fjw+cmIoCExPcWEXrIQHyz/VifIfPVVlaqnv4VZQW5
	 OJLx1dCv9xDVccDFq26veNqybEJ1043nQ99NnCLj4RFNxITCP2z+ATxpPyBRXxbXlD
	 ZukuIfnJ+jIVMoUx1IKIiUc4FSLiC+BpOTXswnzQ=
Date: Tue, 17 Jun 2025 16:47:58 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,jolsa@kernel.org,david@redhat.com,andrii@kernel.org,olsajiri@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uprobes-revert-ref_ctr_offset-in-uprobe_unregister-error-path.patch added to mm-nonmm-unstable branch
Message-Id: <20250617234759.52B90C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uprobes: revert ref_ctr_offset in uprobe_unregister error path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uprobes-revert-ref_ctr_offset-in-uprobe_unregister-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uprobes-revert-ref_ctr_offset-in-uprobe_unregister-error-path.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jiri Olsa <olsajiri@gmail.com>
Subject: uprobes: revert ref_ctr_offset in uprobe_unregister error path
Date: Wed, 14 May 2025 12:18:09 +0200

There's error path that could lead to inactive uprobe:

  1) uprobe_register succeeds - updates instruction to int3 and
     changes ref_ctr from 0 to 1
  2) uprobe_unregister fails  - int3 stays in place, but ref_ctr
     is changed to 0 (it's not restored to 1 in the fail path)
     uprobe is leaked
  3) another uprobe_register comes and re-uses the leaked uprobe
     and succeds - but int3 is already in place, so ref_ctr update
     is skipped and it stays 0 - uprobe CAN NOT be triggered now
  4) uprobe_unregister fails because ref_ctr value is unexpected

Fix this by reverting the updated ref_ctr value back to 1 in step 2),
which is the case when uprobe_unregister fails (int3 stays in place), but
we have already updated refctr.

The new scenario will go as follows:

  1) uprobe_register succeeds - updates instruction to int3 and
     changes ref_ctr from 0 to 1
  2) uprobe_unregister fails  - int3 stays in place and ref_ctr
     is reverted to 1..  uprobe is leaked
  3) another uprobe_register comes and re-uses the leaked uprobe
     and succeds - but int3 is already in place, so ref_ctr update
     is skipped and it stays 1 - uprobe CAN be triggered now
  4) uprobe_unregister succeeds

Link: https://lkml.kernel.org/r/20250514101809.2010193-1-jolsa@kernel.org
Fixes: 1cc33161a83d ("uprobes: Support SDT markers having reference count (semaphore)")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-revert-ref_ctr_offset-in-uprobe_unregister-error-path
+++ a/kernel/events/uprobes.c
@@ -580,8 +580,8 @@ retry:
 
 out:
 	/* Revert back reference counter if instruction update failed. */
-	if (ret < 0 && is_register && ref_ctr_updated)
-		update_ref_ctr(uprobe, mm, -1);
+	if (ret < 0 && ref_ctr_updated)
+		update_ref_ctr(uprobe, mm, is_register ? -1 : 1);
 
 	/* try collapse pmd for compound page */
 	if (ret > 0)
_

Patches currently in -mm which might be from olsajiri@gmail.com are

uprobes-revert-ref_ctr_offset-in-uprobe_unregister-error-path.patch

