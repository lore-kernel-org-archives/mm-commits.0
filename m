Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B266A189915
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855613; cv=none; b=oJiT6Mur1eggJR142pXbH452K+KwvYlMQoiHTZvRL4UtpbAy4j+PrrjvMFA9oPsY0wJQiygq2z+kEJF58/DYVpR25m+BcIy5YXC8xFhGaKJXW6hVZKKc3qVR/EJSF0CgQSuvP06jdd14tcUUOBiIPo8PfbfFB69UBh3pX2Ib6Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855613; c=relaxed/simple;
	bh=VKNlF3P7TSfXVl1AcIhJ64TJ9HN15M+bZTaysGZ7ZwI=;
	h=Date:To:From:Subject:Message-Id; b=BIrSBYIMBZT57/GO2lKZpOMgv7TsvTJx9LD0W8eGDe3SHLmCGV5qJucVyxwmuqivGYUxgaRAfxgYjbpPzMkc1aj+OeQBq2TwOOn2P4nlp76/BogF+uanDDCbttOo+NVq2B0SngidzromtSXSEsOUS+yM0kJ7btm3A5/kgHvjLIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i6G48GIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i6G48GIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6CEC4CECF;
	Wed,  6 Nov 2024 01:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855613;
	bh=VKNlF3P7TSfXVl1AcIhJ64TJ9HN15M+bZTaysGZ7ZwI=;
	h=Date:To:From:Subject:From;
	b=i6G48GIZDqdURV1m2FhaHa0NhYV4I4PVlDQQnSGXMfwANwwtQ4pv5qz70SnAkSpOF
	 ufgTmJZGj+qXOcQiDquer02CHNtjIcYYv4x+bgWVuheWV0cckFXU/yNQUthcji608Y
	 1Wr51muihKT+ChDMyxZwLyMaJ20pEnA5SwclCBKA=
Date: Tue, 05 Nov 2024 17:13:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bpftool-ensure-task-comm-is-always-nul-terminated.patch removed from -mm tree
Message-Id: <20241106011333.3F6CEC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bpftool: ensure task comm is always NUL-terminated
has been removed from the -mm tree.  Its filename was
     bpftool-ensure-task-comm-is-always-nul-terminated.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


