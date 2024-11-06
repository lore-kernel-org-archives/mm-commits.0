Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672F3189BAC
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855616; cv=none; b=jViV4GQsQiv8mfZSUEy5Wah0C2ygIBaP7rWy+vb80ysVeU6ACAhZOEQYrUyh4TfhCj04G0tbi/zCYXfTD71EDGzun5tQIdSSe1N3qhhpi0zLMcHZUIyAFJxcuKSNfNnfyIUcXWoCqQ9g+TNtA/oUDp2iV2BpNHQb033iZ2Lf9RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855616; c=relaxed/simple;
	bh=3A3YYb8HK59bUnY1mJEkHCndYqpPqOyFu1XGj3suomI=;
	h=Date:To:From:Subject:Message-Id; b=Fs9xpC2Wj2Hz1Cru0naDkBZoo1gnGi0GNs8OvED0afkH9o+h+7FW9TRn1oahMSiJnz6o9QhfRGuKIdx6IDV6XWbDZNmKFrKwd4QP3lc/s1h9ROoWaWx4Hcba4Z0jwiv22wNj2hyeeZmt+CN0Z+n6EcyrAWaGqNoHiRlKyZXMApI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wuL98UF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wuL98UF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35869C4CECF;
	Wed,  6 Nov 2024 01:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855616;
	bh=3A3YYb8HK59bUnY1mJEkHCndYqpPqOyFu1XGj3suomI=;
	h=Date:To:From:Subject:From;
	b=wuL98UF4OvCzkBSwVvwnQbfU/jiOqVe2LjkVD5rqva4MwBGQpF+drSZW7O+QSfeiC
	 xFBI95usIpydbEZ9cRfIeIZxTfWHGWsaJ2ocWrZbmnLU+WmusofzQpat9q+4Rc/2Nh
	 tpw8fw46Vd4qH8uAEhGxFE/Gv7+Sfne24eQzXwBQ=
Date: Tue, 05 Nov 2024 17:13:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,akpm@linux-foundation.org,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-util-deduplicate-code-in-kstrdupkstrndupkmemdup_nul.patch removed from -mm tree
Message-Id: <20241106011336.35869C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/util: deduplicate code in {kstrdup,kstrndup,kmemdup_nul}
has been removed from the -mm tree.  Its filename was
     mm-util-deduplicate-code-in-kstrdupkstrndupkmemdup_nul.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/util: deduplicate code in {kstrdup,kstrndup,kmemdup_nul}
Date: Mon, 7 Oct 2024 22:49:10 +0800

These three functions follow the same pattern.  To deduplicate the code,
let's introduce a common helper __kmemdup_nul().

Link: https://lkml.kernel.org/r/20241007144911.27693-7-laoar.shao@gmail.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
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
Cc: Matus Jokay <matus.jokay@stuba.sk>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   69 ++++++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 42 deletions(-)

--- a/mm/util.c~mm-util-deduplicate-code-in-kstrdupkstrndupkmemdup_nul
+++ a/mm/util.c
@@ -45,34 +45,41 @@ void kfree_const(const void *x)
 EXPORT_SYMBOL(kfree_const);
 
 /**
- * kstrdup - allocate space for and copy an existing string
- * @s: the string to duplicate
+ * __kmemdup_nul - Create a NUL-terminated string from @s, which might be unterminated.
+ * @s: The data to copy
+ * @len: The size of the data, not including the NUL terminator
  * @gfp: the GFP mask used in the kmalloc() call when allocating memory
  *
- * Return: newly allocated copy of @s or %NULL in case of error
+ * Return: newly allocated copy of @s with NUL-termination or %NULL in
+ * case of error
  */
-noinline
-char *kstrdup(const char *s, gfp_t gfp)
+static __always_inline char *__kmemdup_nul(const char *s, size_t len, gfp_t gfp)
 {
-	size_t len;
 	char *buf;
 
-	if (!s)
+	/* '+1' for the NUL terminator */
+	buf = kmalloc_track_caller(len + 1, gfp);
+	if (!buf)
 		return NULL;
 
-	len = strlen(s) + 1;
-	buf = kmalloc_track_caller(len, gfp);
-	if (buf) {
-		memcpy(buf, s, len);
-		/*
-		 * During memcpy(), the string might be updated to a new value,
-		 * which could be longer than the string when strlen() is
-		 * called. Therefore, we need to add a NUL terminator.
-		 */
-		buf[len - 1] = '\0';
-	}
+	memcpy(buf, s, len);
+	/* Ensure the buf is always NUL-terminated, regardless of @s. */
+	buf[len] = '\0';
 	return buf;
 }
+
+/**
+ * kstrdup - allocate space for and copy an existing string
+ * @s: the string to duplicate
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
+ *
+ * Return: newly allocated copy of @s or %NULL in case of error
+ */
+noinline
+char *kstrdup(const char *s, gfp_t gfp)
+{
+	return s ? __kmemdup_nul(s, strlen(s), gfp) : NULL;
+}
 EXPORT_SYMBOL(kstrdup);
 
 /**
@@ -107,19 +114,7 @@ EXPORT_SYMBOL(kstrdup_const);
  */
 char *kstrndup(const char *s, size_t max, gfp_t gfp)
 {
-	size_t len;
-	char *buf;
-
-	if (!s)
-		return NULL;
-
-	len = strnlen(s, max);
-	buf = kmalloc_track_caller(len+1, gfp);
-	if (buf) {
-		memcpy(buf, s, len);
-		buf[len] = '\0';
-	}
-	return buf;
+	return s ? __kmemdup_nul(s, strnlen(s, max), gfp) : NULL;
 }
 EXPORT_SYMBOL(kstrndup);
 
@@ -193,17 +188,7 @@ EXPORT_SYMBOL(kvmemdup);
  */
 char *kmemdup_nul(const char *s, size_t len, gfp_t gfp)
 {
-	char *buf;
-
-	if (!s)
-		return NULL;
-
-	buf = kmalloc_track_caller(len + 1, gfp);
-	if (buf) {
-		memcpy(buf, s, len);
-		buf[len] = '\0';
-	}
-	return buf;
+	return s ? __kmemdup_nul(s, len, gfp) : NULL;
 }
 EXPORT_SYMBOL(kmemdup_nul);
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


