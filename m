Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BB41891A9
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855610; cv=none; b=f6YZRhVCiOyPkx72DeEfKyMVuThZHOg+C8WSF0+8YH8jq40c9SiJ7PcQ3r87WmerrbCzAyWeEIw9kIGUAF8N6oIEvlSZ9LgIP3Ll0Uv4U4KgGdUgfLGUCb5jJoh9lPthWPG6eaLnWPWzebwoWPWbI93v92Ud8erLCy/YLDaMSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855610; c=relaxed/simple;
	bh=zzsm6pP2lFaAXRChjqkWGLIRY6CTx9UyunAm6Bqsgwg=;
	h=Date:To:From:Subject:Message-Id; b=c1QFr+yYEtcS7aU9Pl/Z8JAwHpdy/nTCZSCJOUPAszjj4ZbF3YpzHCyrH2i/su7KSXUxzHsNimX0e5NgCPmhA+PTaznnKqUSAwQfH0WKHnhnWtpG5XYRqLty+p0fC433v9hTbu5m4dHy2FHmOP8FSCrsIcl9Ny8SUc26IMfUbtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jvLEsNK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jvLEsNK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6092EC4CECF;
	Wed,  6 Nov 2024 01:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855610;
	bh=zzsm6pP2lFaAXRChjqkWGLIRY6CTx9UyunAm6Bqsgwg=;
	h=Date:To:From:Subject:From;
	b=jvLEsNK+wZ0WlPsSZ2sgpCNPW8oTTrAs5NEbSw3Df2qFMyr9qoYMcX7Mb5CNAbUHa
	 nGDkmL4yiQYqJ/aRBmJyDZXj7qLWi5npPRd+37+goFKf7vCYhn/jXrSuhjZGidqq0h
	 tk1+dt4YWRuFF7XzFpfYa9N2YtEELomqGRL/si2U=
Date: Tue, 05 Nov 2024 17:13:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] auditsc-replace-memcpy-with-strscpy.patch removed from -mm tree
Message-Id: <20241106011330.6092EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: auditsc: replace memcpy() with strscpy()
has been removed from the -mm tree.  Its filename was
     auditsc-replace-memcpy-with-strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


