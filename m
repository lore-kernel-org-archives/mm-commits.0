Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F6717BB08
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855615; cv=none; b=gfxpBSFYwcsiBE1conkD9CaHafVXFLPdzX9Ju53CxBHpZZwym35HEvcsM+vCLAplZlEbHtCiXfEyurmySKA1Qkr+S2B/o2j7u2DLZ+dzLw8iWElZGCaDNHNS1x707JpQVbhTiWkTlC1u0yahC5drEDjcxBPmeKtLYcUNqu8dVkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855615; c=relaxed/simple;
	bh=r8/BlN5CDX5O7JZvKsyAanovMTDzsoMbGhhpkrdExQs=;
	h=Date:To:From:Subject:Message-Id; b=UdDe/wZXyG5LKMdwbhJ6K89/QP6IhAProPX6e1O7PT3FrBULlwpc58h/hJ4SCew5VgDYZ4Lrldm0BNFaAdSvxmReJGYtNd20EnMAWHAgAHo3Qs88QS0HS7sW6J7JwK6IKJVimRKFaIhwePlvaWaz0u4DnXLA+wMCAwsfG0LHD2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mzgAfTMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mzgAfTMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4554C4CECF;
	Wed,  6 Nov 2024 01:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855614;
	bh=r8/BlN5CDX5O7JZvKsyAanovMTDzsoMbGhhpkrdExQs=;
	h=Date:To:From:Subject:From;
	b=mzgAfTMBTH80KiN8Q2DBBqCCyH3yUhtXeWvArKB7fTbuwasOB2lUxMWsKUqZNbncJ
	 8WD3cFmPYWd+RSNHtswZHwXzFSPuxl9o9lzPuzDo4Banv8wA8Voym6tx7l2wjFVTaZ
	 g2RIQ58Ou9YOKmRmMrzXLt4u3ZsAx9/bCYSyv5Y0=
Date: Tue, 05 Nov 2024 17:13:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-util-fix-possible-race-condition-in-kstrdup.patch removed from -mm tree
Message-Id: <20241106011334.B4554C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/util: fix possible race condition in kstrdup()
has been removed from the -mm tree.  Its filename was
     mm-util-fix-possible-race-condition-in-kstrdup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


