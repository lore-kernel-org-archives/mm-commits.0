Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0353B1DE4E4
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 18:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728327075; cv=none; b=HYKo0Wyv32Kwb+BTbuqXV+o/BlUv3rymyXhfzDFXHO82rBjV4gSS+8MnhdCwYUgulUGKsLjXzSfphd4XzJGsrpbpmbhvJq/OUd2rrkiOyh27gVU9U9ndTM1axckAH3d8G1y6xouIMb0XxYMtz1CpiH2Y1jYTzZC1+z/N8Rsyap4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728327075; c=relaxed/simple;
	bh=uOLQX51WixV4o1JgCzBHkeihdiNw3nq6N2jlTaNYIco=;
	h=Date:To:From:Subject:Message-Id; b=hlJfbTGzWXlc8DNTJTp5O8cd4CMVRyl0K5kJT2aphbCEUf0bvlaSRb2JZuEQd3iiMF408DBwpopQLHx2Ljf8zO/anFgXJbSIK47GsUKUIT27x85N5mpn9EHp7f4PdSM0UkayNEsDNvRpDjbQdPx/A0hhtffCIo9MdDw4JJbwGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gw1mrMgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gw1mrMgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F30C4CEC6;
	Mon,  7 Oct 2024 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728327074;
	bh=uOLQX51WixV4o1JgCzBHkeihdiNw3nq6N2jlTaNYIco=;
	h=Date:To:From:Subject:From;
	b=gw1mrMgu2coUEVh8w4XOW3NaeJOswMB7yXXbMOrsjGswdDHYVC1q0HrDNwCrq8XBg
	 //GEl1nyXH4kWkNOmK6c+nv/kFNhj2ggQoxlEDUhXJlcC0QKaBzYBmVPBkAPfoYZxP
	 r4N/bJZXFFQ780rwcsPl/3qRs4TKdFD8m14zzFKo=
Date: Mon, 07 Oct 2024 11:51:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bpftool-ensure-task-comm-is-always-nul-terminated.patch added to mm-nonmm-unstable branch
Message-Id: <20241007185114.90F30C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bpftool: ensure task comm is always NUL-terminated
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bpftool-ensure-task-comm-is-always-nul-terminated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bpftool-ensure-task-comm-is-always-nul-terminated.patch

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
Subject: bpftool: ensure task comm is always NUL-terminated
Date: Mon, 7 Oct 2024 22:49:08 +0800

Let's explicitly ensure the destination string is NUL-terminated.  This
way, it won't be affected by changes to the source string.

Link: https://lkml.kernel.org/r/20241007144911.27693-5-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
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
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/bpf/bpftool/pids.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/bpf/bpftool/pids.c~bpftool-ensure-task-comm-is-always-nul-terminated
+++ a/tools/bpf/bpftool/pids.c
@@ -54,6 +54,7 @@ static void add_ref(struct hashmap *map,
 		ref = &refs->refs[refs->ref_cnt];
 		ref->pid = e->pid;
 		memcpy(ref->comm, e->comm, sizeof(ref->comm));
+		ref->comm[sizeof(ref->comm) - 1] = '\0';
 		refs->ref_cnt++;
 
 		return;
@@ -77,6 +78,7 @@ static void add_ref(struct hashmap *map,
 	ref = &refs->refs[0];
 	ref->pid = e->pid;
 	memcpy(ref->comm, e->comm, sizeof(ref->comm));
+	ref->comm[sizeof(ref->comm) - 1] = '\0';
 	refs->ref_cnt = 1;
 	refs->has_bpf_cookie = e->has_bpf_cookie;
 	refs->bpf_cookie = e->bpf_cookie;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

get-rid-of-__get_task_comm.patch
auditsc-replace-memcpy-with-strscpy.patch
security-replace-memcpy-with-get_task_comm.patch
bpftool-ensure-task-comm-is-always-nul-terminated.patch
mm-util-fix-possible-race-condition-in-kstrdup.patch
mm-util-deduplicate-code-in-kstrdupkstrndupkmemdup_nul.patch
drm-replace-strcpy-with-strscpy.patch

