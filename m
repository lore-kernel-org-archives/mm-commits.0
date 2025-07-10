Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB3D17741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127165; cv=none; b=jooLiVWoyN5sovxacVLrGP6ULPCMbGddjRefPY5Uj9aqjB3x6Bz3jCdc0JnvgpKbJGUwHE3AAD+pjO3mlqxBgVeeUS+eYfoIRaYfTzHQo/nNur7hI8OoswPbcMz+ngsNrC5rrBS5S1WJpfrEpVwTNU3naVUj0khjXy0zLEqBLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127165; c=relaxed/simple;
	bh=g/ehB3E5lx9ASsC4YLrZ9rIWnT5KxAbyXhvt8JCA4mM=;
	h=Date:To:From:Subject:Message-Id; b=CS1VYaTlnxsrLJCcDcTKI2OiikfyYLKankRWsWDIExFeaSEwCisOl+aVfL00bIdbIBTinTmz0vB8HhpXLM3dyKu18xNKP+I5lrT4MAC9Aw0nTQwgdWILFSc3FKBM5o57og282xJBF2Oc9Mnp/LpG5EsvWaWiNap1x2yQEcHg4Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w4ysYbOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w4ysYbOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114FBC4CEE3;
	Thu, 10 Jul 2025 05:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127165;
	bh=g/ehB3E5lx9ASsC4YLrZ9rIWnT5KxAbyXhvt8JCA4mM=;
	h=Date:To:From:Subject:From;
	b=w4ysYbOYFf/+zogys72yMXP62SaNTXaLfvze236EL8lho4tddq+SPtPv4/zztipeK
	 Ax8dJPuZTpeyR19PI7QaTvwFSaOqa2YUQ1bmqii4k2TDxmaObQPSAipWKmdE7Og7iX
	 LPfmSPRSZTUSn+xBw3bnt+bQR8VGI2IoWsIgMmBA=
Date: Wed, 09 Jul 2025 22:59:24 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,jolsa@kernel.org,david@redhat.com,andrii@kernel.org,olsajiri@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] uprobes-revert-ref_ctr_offset-in-uprobe_unregister-error-path.patch removed from -mm tree
Message-Id: <20250710055925.114FBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uprobes: revert ref_ctr_offset in uprobe_unregister error path
has been removed from the -mm tree.  Its filename was
     uprobes-revert-ref_ctr_offset-in-uprobe_unregister-error-path.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -581,8 +581,8 @@ retry:
 
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


