Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DDB1DE4E4
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 18:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728327077; cv=none; b=Un5CfzmxBu/9b8swGjsbm69b6A8BWufwzVYSOB809M8r1ogfNrRxbWEdQLNVBWILCzLph8nXOoApJpGgdxh/zXnZeUsizZ8+fzT9jJeVYe790FcqBykk/OZ90cxw8D4VSzg2qeJ4S2vlywVkPVIkIqJ3X8GgMFHuwYrwLKj+bns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728327077; c=relaxed/simple;
	bh=cAk/FGSX7p2I2e93Stp8oYfXQJIwcDru29sQq+F9MjM=;
	h=Date:To:From:Subject:Message-Id; b=EOsUWvAQ/lHlKKnSkOvmLFZaaloSM39aHdzgCEnennRgWu8qWqHpx6ERLO333Wr5RNxeoN8CajQdIIoah+MzuVvcOhqAbvssvRsoq2nyN87B3woziOdZJL2njkOINu7M7olZCT/69aOR+R7i9eXqaZVEe2XPt/bb7aP9OuMTYyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y9/9BNd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y9/9BNd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5463C4CEC6;
	Mon,  7 Oct 2024 18:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728327076;
	bh=cAk/FGSX7p2I2e93Stp8oYfXQJIwcDru29sQq+F9MjM=;
	h=Date:To:From:Subject:From;
	b=y9/9BNd5oHn0uKY3YFLjwtiL1+/57DcI6z9elCxTXpPgKkh+e6sPb6a6CwscclXhz
	 tRqFw1ei67k0j110of4yptp1AAahKTAHfMC/F4tho4Ggs0hozuLWvVIO6tmGfnE3WH
	 E3lNl5ZY5FdLwVlFUbnflL98lIR18thD9iePjgUg=
Date: Mon, 07 Oct 2024 11:51:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-fix-possible-race-condition-in-kstrdup.patch added to mm-nonmm-unstable branch
Message-Id: <20241007185116.D5463C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/util: fix possible race condition in kstrdup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-util-fix-possible-race-condition-in-kstrdup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-fix-possible-race-condition-in-kstrdup.patch

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
Subject: mm/util: fix possible race condition in kstrdup()
Date: Mon, 7 Oct 2024 22:49:09 +0800

In kstrdup(), it is critical to ensure that the dest string is always
NUL-terminated.  However, potential race condition can occur between a
writer and a reader.

Consider the following scenario involving task->comm:

    reader                    writer

  len = strlen(s) + 1;
                             strlcpy(tsk->comm, buf, sizeof(tsk->comm));
  memcpy(buf, s, len);

In this case, there is a race condition between the reader and the writer.
The reader calculates the length of the string `s` based on the old value
of task->comm.  However, during the memcpy(), the string `s` might be
updated by the writer to a new value of task->comm.

If the new task->comm is larger than the old one, the `buf` might not be
NUL-terminated.  This can lead to undefined behavior and potential
security vulnerabilities.

Let's fix it by explicitly adding a NUL terminator after the memcpy.  It
is worth noting that memcpy() is not atomic, so the new string can be
shorter when memcpy() already copied past the new NUL.

Link: https://lkml.kernel.org/r/20241007144911.27693-6-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matus Jokay <matus.jokay@stuba.sk>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-util-fix-possible-race-condition-in-kstrdup
+++ a/mm/util.c
@@ -62,8 +62,15 @@ char *kstrdup(const char *s, gfp_t gfp)
 
 	len = strlen(s) + 1;
 	buf = kmalloc_track_caller(len, gfp);
-	if (buf)
+	if (buf) {
 		memcpy(buf, s, len);
+		/*
+		 * During memcpy(), the string might be updated to a new value,
+		 * which could be longer than the string when strlen() is
+		 * called. Therefore, we need to add a NUL terminator.
+		 */
+		buf[len - 1] = '\0';
+	}
 	return buf;
 }
 EXPORT_SYMBOL(kstrdup);
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

get-rid-of-__get_task_comm.patch
auditsc-replace-memcpy-with-strscpy.patch
security-replace-memcpy-with-get_task_comm.patch
bpftool-ensure-task-comm-is-always-nul-terminated.patch
mm-util-fix-possible-race-condition-in-kstrdup.patch
mm-util-deduplicate-code-in-kstrdupkstrndupkmemdup_nul.patch
drm-replace-strcpy-with-strscpy.patch

