Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3817BB34
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855617; cv=none; b=UFgfSm+25BvNFifGk9XU5isfUirxTKYLBTqCKrFGPDnLX5ioijYt5bf09yeeZm7Mr+s7/NurVT8vqHFusJBumlfnTgLUlbyk9H82vAF88X1e+zFJ2yFuzXiWK6beusak/sggynHRVzb2FGSmO1W1VkIkYhl4fZzodUAiXtNPGKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855617; c=relaxed/simple;
	bh=WBBrRQmTSMcLUk659FdPUzF6DbcVCuQFxQCMtsUkuTs=;
	h=Date:To:From:Subject:Message-Id; b=uiB1y7SXGvGC7+OBYOm0ESfxS8NBt7AL9JwcTdGGNpiZDfQvingc0L7rtAacDlYMIk/w09jD8Ymoj5lO3Um8OW9MeFY1kM9b6L4fl4ohXXZA/5311sE+cgnVQpYkWN3OXsnJzXplP3hAkFtRPwqxV8mWDdoYabcVH8ssTLcqOYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQUu01lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQUu01lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A711FC4CECF;
	Wed,  6 Nov 2024 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855617;
	bh=WBBrRQmTSMcLUk659FdPUzF6DbcVCuQFxQCMtsUkuTs=;
	h=Date:To:From:Subject:From;
	b=WQUu01lh3t7gPHpYgDZK+nQGYgsiBuV51g8h1zSygztvUBNTGN+89/PXanCuHQs3n
	 s0QlqDLcUQVuoCUdcUVl80foAMKP/Tr21PZLGYJKTJCycqlCxgsl7m3UvTw3Ime/9T
	 u3DjFBYd12AeBk6PsGJjuaqYJj2on/lYs7neqE2I=
Date: Tue, 05 Nov 2024 17:13:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-replace-strcpy-with-strscpy.patch removed from -mm tree
Message-Id: <20241106011337.A711FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm: replace strcpy() with strscpy()
has been removed from the -mm tree.  Its filename was
     drm-replace-strcpy-with-strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


