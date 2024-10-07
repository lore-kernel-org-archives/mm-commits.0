Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61D1DE887
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728327082; cv=none; b=GEY+ToLoMipg9f6A/59uZJmZTc4VAsFugrMlZoNJAvIKrefeknwCJjZrVLv0sRtn/MpSlLLHpfwyH6JyoeWal29NJyTc3aJnFskLwtou2DynKoNHK6lLYHSahl5G0eFuyQTf9D4gqsP2h21CZsnnZ9AFQJs9rh7vMQus38UEvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728327082; c=relaxed/simple;
	bh=eTvTFs8VsTLsMHGc+lESEJJ0RrPBFLIXMbl4VRUmK5s=;
	h=Date:To:From:Subject:Message-Id; b=cHnbcsMazgVNdVI1rNg3JWCB5kJJ6zsN59S7BTTROmGIyPvRa96wQ5GKpMwsaTjl3CCDbYj7I+AdZRhjYKvoNJXPnpG+ApWgcIsbiTT44IUQhmZXZb686IxkwylWswfrH35Ki/gvwcCnDEBH3F/dRbOm3DHFJ3X3cEBBQc/3VF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ezgjbjjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ezgjbjjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CA5C4CEC6;
	Mon,  7 Oct 2024 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728327081;
	bh=eTvTFs8VsTLsMHGc+lESEJJ0RrPBFLIXMbl4VRUmK5s=;
	h=Date:To:From:Subject:From;
	b=EzgjbjjbjB5/nrznyhW0+0tGYJLjWH4ovb8dh474BkBCpHzzua0cwYYnF4Jaid6k0
	 1KX9pRVNtywkMQoGzR3l/QiYjWm5BlaXBxP9ldN2GfAvLu+S3Z64WOUf7p0tGElLlc
	 CJt9+6iDCE7BVTURTbjbx2XZM1xtF4+eM+Elio7Q=
Date: Mon, 07 Oct 2024 11:51:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-replace-strcpy-with-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20241007185121.67CA5C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm: replace strcpy() with strscpy()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-replace-strcpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-replace-strcpy-with-strscpy.patch

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
From: Yafang Shao <laoar.shao@gmail.com>
Subject: drm: replace strcpy() with strscpy()
Date: Mon, 7 Oct 2024 22:49:11 +0800

To prevent errors from occurring when the src string is longer than the
dst string in strcpy(), we should use strscpy() instead.  This approach
also facilitates future extensions to the task comm.

Link: https://lkml.kernel.org/r/20241007144911.27693-8-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Justin Stitt <justinstitt@google.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matus Jokay <matus.jokay@stuba.sk>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_framebuffer.c     |    2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_framebuffer.c~drm-replace-strcpy-with-strscpy
+++ a/drivers/gpu/drm/drm_framebuffer.c
@@ -868,7 +868,7 @@ int drm_framebuffer_init(struct drm_devi
 	INIT_LIST_HEAD(&fb->filp_head);
 
 	fb->funcs = funcs;
-	strcpy(fb->comm, current->comm);
+	strscpy(fb->comm, current->comm);
 
 	ret = __drm_mode_object_add(dev, &fb->base, DRM_MODE_OBJECT_FB,
 				    false, drm_framebuffer_free);
--- a/drivers/gpu/drm/i915/i915_gpu_error.c~drm-replace-strcpy-with-strscpy
+++ a/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -1113,7 +1113,7 @@ i915_vma_coredump_create(const struct in
 	}
 
 	INIT_LIST_HEAD(&dst->page_list);
-	strcpy(dst->name, name);
+	strscpy(dst->name, name);
 	dst->next = NULL;
 
 	dst->gtt_offset = vma_res->start;
@@ -1413,7 +1413,7 @@ static bool record_context(struct i915_g
 	rcu_read_lock();
 	task = pid_task(ctx->pid, PIDTYPE_PID);
 	if (task) {
-		strcpy(e->comm, task->comm);
+		strscpy(e->comm, task->comm);
 		e->pid = task->pid;
 	}
 	rcu_read_unlock();
@@ -1459,7 +1459,7 @@ capture_vma_snapshot(struct intel_engine
 		return next;
 	}
 
-	strcpy(c->name, name);
+	strscpy(c->name, name);
 	c->vma_res = i915_vma_resource_get(vma_res);
 
 	c->next = next;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

get-rid-of-__get_task_comm.patch
auditsc-replace-memcpy-with-strscpy.patch
security-replace-memcpy-with-get_task_comm.patch
bpftool-ensure-task-comm-is-always-nul-terminated.patch
mm-util-fix-possible-race-condition-in-kstrdup.patch
mm-util-deduplicate-code-in-kstrdupkstrndupkmemdup_nul.patch
drm-replace-strcpy-with-strscpy.patch

