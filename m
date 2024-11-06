Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9D618858C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855612; cv=none; b=Kyfgij8QcY/aRvr9+A5zAty6H5icoclI55jQNcz68KCoV2oCkWupm9Wc10EXIC+Rpph5r8EGq1c1lNMy+8/dNWc88JRfbk0uWSO1yI9Jfp5p0CyH3yjCeDJNfTZ+t59EoWPXHzVxBd1OMA7EwhClueHgFhuyDhv+9363vUw0DY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855612; c=relaxed/simple;
	bh=p66aC31DK9XBr900Ate97AedmryrOmUys5vBbL/EX5g=;
	h=Date:To:From:Subject:Message-Id; b=VOiPdD+4dDb1F8pxfeWkRUYDDdk/FDUgxrn+7JC8r6MAVyFNCUG6VSusLjhNamnhv956jQ3hl9VpsoHASa0X6jmmlNDWPJ1CmQeeRlSJduzSj13tOhOzDsMyF1mXRP6wy9mE1prCmZ0uhXMZ6E30lUJeCHNfdwz9RYDT6PmhNxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nCVBsuhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nCVBsuhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AA6C4CECF;
	Wed,  6 Nov 2024 01:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855611;
	bh=p66aC31DK9XBr900Ate97AedmryrOmUys5vBbL/EX5g=;
	h=Date:To:From:Subject:From;
	b=nCVBsuhzbMc84aWf/gsLDcGR8OYJ2+Nrp1pi4IVIaO4X0AImKRBJkZM3TYKu7e6A4
	 6RMH5VH6FS6T3Pyuybw/YK8HKIPDnTDYT0f0T+F+Pq3Ab59JIy7HTXeWqekfU6eJj4
	 T0V2qDyaFnOy4Dm4AedMvh1ukl2L8/k3ZU1sbCeg=
Date: Tue, 05 Nov 2024 17:13:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] security-replace-memcpy-with-get_task_comm.patch removed from -mm tree
Message-Id: <20241106011331.D1AA6C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: security: replace memcpy() with get_task_comm()
has been removed from the -mm tree.  Its filename was
     security-replace-memcpy-with-get_task_comm.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: security: replace memcpy() with get_task_comm()
Date: Mon, 7 Oct 2024 22:49:07 +0800

Quoted from Linus [0]:

  selinux never wanted a lock, and never wanted any kind of *consistent*
  result, it just wanted a *stable* result.

Using get_task_comm() to read the task comm ensures that the name is
always NUL-terminated, regardless of the source string. This approach also
facilitates future extensions to the task comm.

Link: https://lkml.kernel.org/r/20241007144911.27693-4-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/all/CAHk-=wivfrF0_zvf+oj6==Sh=-npJooP8chLPEfaFV0oNYTTBA@mail.gmail.com/ [0]
Acked-by: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matus Jokay <matus.jokay@stuba.sk>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/lsm_audit.c         |    4 ++--
 security/selinux/selinuxfs.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/security/lsm_audit.c~security-replace-memcpy-with-get_task_comm
+++ a/security/lsm_audit.c
@@ -207,7 +207,7 @@ static void dump_common_audit_data(struc
 	BUILD_BUG_ON(sizeof(a->u) > sizeof(void *)*2);
 
 	audit_log_format(ab, " pid=%d comm=", task_tgid_nr(current));
-	audit_log_untrustedstring(ab, memcpy(comm, current->comm, sizeof(comm)));
+	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 
 	switch (a->type) {
 	case LSM_AUDIT_DATA_NONE:
@@ -302,7 +302,7 @@ static void dump_common_audit_data(struc
 				char comm[sizeof(tsk->comm)];
 				audit_log_format(ab, " opid=%d ocomm=", pid);
 				audit_log_untrustedstring(ab,
-				    memcpy(comm, tsk->comm, sizeof(comm)));
+				    get_task_comm(comm, tsk));
 			}
 		}
 		break;
--- a/security/selinux/selinuxfs.c~security-replace-memcpy-with-get_task_comm
+++ a/security/selinux/selinuxfs.c
@@ -708,7 +708,7 @@ static ssize_t sel_write_checkreqprot(st
 	if (new_value) {
 		char comm[sizeof(current->comm)];
 
-		memcpy(comm, current->comm, sizeof(comm));
+		strscpy(comm, current->comm);
 		pr_err("SELinux: %s (%d) set checkreqprot to 1. This is no longer supported.\n",
 		       comm, current->pid);
 	}
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


