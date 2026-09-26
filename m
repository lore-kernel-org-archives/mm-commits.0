Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569CA33970F;
	Sat, 26 Sep 2026 20:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456138; cv=none; b=WScfF5i5ILkCo2D3URtchBoD51a7uW8ThHLGlzOPazPQS80P0L5VmL5jmsf92+IFMZ+1nlXkOehIfQNGSIF4kIkX5HBaMCjDtXeYW2SPH09UxLaGR8ZTn36At24eiJp0S4osQU3dDbrfBaVaKA0zVMkpoBEikHdqxoKwUq3SNGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456138; c=relaxed/simple;
	bh=tB8kSMdgyGkDfl8v7WHsvPJyniwfXEwrWP66Q6+TwZ0=;
	h=Date:To:From:Subject:Message-Id; b=c3LPU7UZVIFv5XlvGrdLBXCST9yB2hxbQNBT8YlMwtD0S6af1oDGlIs4oDcK9LZRL/fg//Kasj2m4j7AzN3+0dQ1PqKNOvh/G3mXbSphh/p+HWNBDxMhkTqQPw/Y3SkhxkcHa9N1Ikfbzs0Q2K5ncUsWvUGCwZlFxBWweESnlks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ap3A5Nvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ap3A5Nvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF3A1F000FF;
	Sat, 26 Sep 2026 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456137;
	bh=6nuf1nVEhXAd9UmKZiFNwrosi/Xlnx1o5dYQ2Z9zchQ=;
	h=Date:To:From:Subject;
	b=Ap3A5NvoFH72G1Fhr+EV9JZFlnyrmRMTm8x8kyXQKTgx3SbzYcaa9ezaSe+OPFP1s
	 FXwkQZgJOWhccZW4olRRrE/JEmKdU8aomOSczZABhIGl5dUs0UnxUYpGPxVRr0Notz
	 vVf9n21opFUEBpH3kauan2ij9QtyO1GXmlS51u3o=
Date: Sat, 26 Sep 2026 13:55:36 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,mcgrof@kernel.org,brads@mainlining.org,atomlin@atomlin.com,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] module-fix-lost-error-code-from-codetag_load_module.patch removed from -mm tree
Message-Id: <20260926205536.DBF3A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: module: fix lost error code from codetag_load_module()
has been removed from the -mm tree.  Its filename was
     module-fix-lost-error-code-from-codetag_load_module.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: module: fix lost error code from codetag_load_module()
Date: Thu, 27 Aug 2026 11:05:03 +0800

If codetag_load_module() fails, err is not set to reflect the failure
and load_module() returns 0 after the module has been torn down.

Also, if the module is a livepatch, mod->klp_info allocated by
copy_module_elf() leaks on this error path.  Free it via a new
livepatch_cleanup label.

Link: https://lore.kernel.org/20260827030503.49171-1-hao.ge@linux.dev
Fixes: 044d2aee6c57 ("alloc_tag: handle module codetag load errors as module load failures")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
---

 kernel/module/main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/module/main.c~module-fix-lost-error-code-from-codetag_load_module
+++ a/kernel/module/main.c
@@ -3581,8 +3581,9 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
-	if (codetag_load_module(mod))
-		goto sysfs_cleanup;
+	err = codetag_load_module(mod);
+	if (err)
+		goto livepatch_cleanup;
 
 	/* Get rid of temporary copy. */
 	free_copy(info, flags);
@@ -3592,6 +3593,9 @@ static int load_module(struct load_info
 
 	return do_init_module(mod);
 
+ livepatch_cleanup:
+	if (is_livepatch_module(mod))
+		free_module_elf(mod);
  sysfs_cleanup:
 	mod_sysfs_teardown(mod);
  coming_cleanup:
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch

