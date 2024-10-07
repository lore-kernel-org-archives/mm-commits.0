Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167941DE4E2
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 18:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728327070; cv=none; b=Efr9+W+a1RkzStsnqiY0kAKk+5xjnnPPS6MHh0pspt9GbmCuAFF9iPH4aLowJfrMzh4cg9ZtaqeLtEiCslwiP/dsAFHO87xCgvcdCatJd1LF8xhLN6ZbggkMBEyHB6Ko1ql3DF9v/Z1a/uNzPiAyzJLOCqrPOjHpQ7zz8KW5WM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728327070; c=relaxed/simple;
	bh=PK/9Xh1ESZl/5eBmPpSyU9OXLcWydnl8AOBoEZpRx0Q=;
	h=Date:To:From:Subject:Message-Id; b=TwsW4lZ69/FHJaRZEii8pkCDDEYAcgYSXT7ya6FdkNhekXjvMRd2/RTRI2k9Mod/RyZYkCD7ijE3SdK3cN7uGOVm+gUgSkN5D7wnhVNwBylWkirTOfJu7V8Iiw2FXUAbXgTd+DQerEAZFeMXfX4vIiK60CxRl0wsXyJQEiVprPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S/PkyU1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S/PkyU1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865C6C4CEC7;
	Mon,  7 Oct 2024 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728327069;
	bh=PK/9Xh1ESZl/5eBmPpSyU9OXLcWydnl8AOBoEZpRx0Q=;
	h=Date:To:From:Subject:From;
	b=S/PkyU1XAzcXxk5g+SyIXCVWJsRz5UoJEA+0581F1oogA0fHuThb4IklJFtqkFvv4
	 JeZCo+3M553xDIPvSpHT4CQcSZcJ64gOxwbuWyt8J95cNDTTD3M+/Ep3JfBYUp5tXo
	 6CcKKbsMEWJiK4VxRtzdGscflfHOmn18M8p/HjaE=
Date: Mon, 07 Oct 2024 11:51:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + auditsc-replace-memcpy-with-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20241007185109.865C6C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: auditsc: replace memcpy() with strscpy()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     auditsc-replace-memcpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/auditsc-replace-memcpy-with-strscpy.patch

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
Subject: auditsc: replace memcpy() with strscpy()
Date: Mon, 7 Oct 2024 22:49:06 +0800

Using strscpy() to read the task comm ensures that the name is always
NUL-terminated, regardless of the source string.  This approach also
facilitates future extensions to the task comm.

Link: https://lkml.kernel.org/r/20241007144911.27693-3-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matus Jokay <matus.jokay@stuba.sk>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/auditsc.c~auditsc-replace-memcpy-with-strscpy
+++ a/kernel/auditsc.c
@@ -2730,7 +2730,7 @@ void __audit_ptrace(struct task_struct *
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid_obj(t, &context->target_sid);
-	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
+	strscpy(context->target_comm, t->comm);
 }
 
 /**
@@ -2757,7 +2757,7 @@ int audit_signal_info_syscall(struct tas
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid_obj(t, &ctx->target_sid);
-		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
+		strscpy(ctx->target_comm, t->comm);
 		return 0;
 	}
 
@@ -2778,7 +2778,7 @@ int audit_signal_info_syscall(struct tas
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid_obj(t, &axp->target_sid[axp->pid_count]);
-	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
+	strscpy(axp->target_comm[axp->pid_count], t->comm);
 	axp->pid_count++;
 
 	return 0;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

get-rid-of-__get_task_comm.patch
auditsc-replace-memcpy-with-strscpy.patch
security-replace-memcpy-with-get_task_comm.patch
bpftool-ensure-task-comm-is-always-nul-terminated.patch
mm-util-fix-possible-race-condition-in-kstrdup.patch
mm-util-deduplicate-code-in-kstrdupkstrndupkmemdup_nul.patch
drm-replace-strcpy-with-strscpy.patch

