Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A98B136352
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749002964; cv=none; b=Abj3pPbzuA0DrS6SBYu74chm11hbzdd8ncFbSbkBARJxxrdcNvL8yOk0SCO5HMWvVYhagydQhQ8pHxQ4SlxQwOUltGrkWjkuPcSCVoFewj97tsyUXrJdlrI0ZPLAohIG+FjxaLNummz3n6XffTJ5vHwSJS9r5LlFpsduDzjAlr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749002964; c=relaxed/simple;
	bh=i6XM69rUNLSQisnfvD7vcrUq3x3qbGUIqu/wxLsARDk=;
	h=Date:To:From:Subject:Message-Id; b=Y+4kQ1Mkx9bEKXYXMaL/oeivWl+gD/xbwRme/LpINKPeokWD5nuqv0MkhztARObn9fHvWNH6KiBdpJb0W6BNdPTjEf+teHGrsDI9Km2+80n8Pi0+cjhENWRyVlm3QGMcmukfrFk47hlI3N4Beon7GHaPMNLgFGMSKLBDZr9+5iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jKcbDUR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jKcbDUR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132B9C4CEED;
	Wed,  4 Jun 2025 02:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749002964;
	bh=i6XM69rUNLSQisnfvD7vcrUq3x3qbGUIqu/wxLsARDk=;
	h=Date:To:From:Subject:From;
	b=jKcbDUR3wLpwXNi7L6xEcQEGouCsWRK5BGbI3qbWYIv4nVi2tutfQZFcYc9W8sxfj
	 3cpq3JfAEj6Pfz5kiiPcs7agi/nknez0C6Vgcf3v6ZvL70uZrZ/jM0IN0z/85LRrTC
	 CbRptk8pA5zt117ma3xcYH0wOLr/T+taJU9GhOMA=
Date: Tue, 03 Jun 2025 19:09:23 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,tursulin@ursulin.net,thomas.weissschuh@linutronix.de,rodrigo.vivi@intel.com,qasdev00@gmail.com,pabeni@redhat.com,nathan@kernel.org,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuniyu@amazon.com,kuba@kernel.org,krzysztof.karas@intel.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,horms@kernel.org,edumazet@google.com,davem@davemloft.net,andrew@lunn.ch,airlied@gmail.com,jlayton@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ref_tracker-add-a-way-to-create-a-symlink-to-the-ref_tracker_dir-debugfs-file.patch added to mm-nonmm-unstable branch
Message-Id: <20250604020924.132B9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ref_tracker: add a way to create a symlink to the ref_tracker_dir debugfs file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ref_tracker-add-a-way-to-create-a-symlink-to-the-ref_tracker_dir-debugfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ref_tracker-add-a-way-to-create-a-symlink-to-the-ref_tracker_dir-debugfs-file.patch

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
From: Jeff Layton <jlayton@kernel.org>
Subject: ref_tracker: add a way to create a symlink to the ref_tracker_dir debugfs file
Date: Tue, 03 Jun 2025 07:27:18 -0400

Add the ability for a subsystem to add a user-friendly symlink that points
to a ref_tracker_dir's debugfs file.

Link: https://lkml.kernel.org/r/20250603-reftrack-dbgfs-v13-7-7b2a425019d8@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Krzysztof Karas <krzysztof.karas@intel.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Qasim Ijaz <qasdev00@gmail.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ref_tracker.h |   13 +++++++++++++
 lib/ref_tracker.c           |   22 ++++++++++++++++++++++
 2 files changed, 35 insertions(+)

--- a/include/linux/ref_tracker.h~ref_tracker-add-a-way-to-create-a-symlink-to-the-ref_tracker_dir-debugfs-file
+++ a/include/linux/ref_tracker.h
@@ -22,6 +22,7 @@ struct ref_tracker_dir {
 	const char		*class; /* object classname */
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
+	struct dentry		*symlink;
 #endif
 	char			name[32];
 #endif
@@ -32,6 +33,7 @@ struct ref_tracker_dir {
 #ifdef CONFIG_DEBUG_FS
 
 void ref_tracker_dir_debugfs(struct ref_tracker_dir *dir);
+void ref_tracker_dir_symlink(struct ref_tracker_dir *dir, const char *fmt, ...);
 
 #else /* CONFIG_DEBUG_FS */
 
@@ -39,6 +41,11 @@ static inline void ref_tracker_dir_debug
 {
 }
 
+static inline __ostream_printf
+void ref_tracker_dir_symlink(struct ref_tracker_dir *dir, const char *fmt, ...)
+{
+}
+
 #endif /* CONFIG_DEBUG_FS */
 
 static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
@@ -56,6 +63,7 @@ static inline void ref_tracker_dir_init(
 	dir->class = class;
 #ifdef CONFIG_DEBUG_FS
 	dir->dentry = NULL;
+	dir->symlink = NULL;
 #endif
 	strscpy(dir->name, name, sizeof(dir->name));
 	ref_tracker_dir_debugfs(dir);
@@ -91,6 +99,11 @@ static inline void ref_tracker_dir_debug
 {
 }
 
+static inline __ostream_printf
+void ref_tracker_dir_symlink(struct ref_tracker_dir *dir, const char *fmt, ...)
+{
+}
+
 static inline void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
 {
 }
--- a/lib/ref_tracker.c~ref_tracker-add-a-way-to-create-a-symlink-to-the-ref_tracker_dir-debugfs-file
+++ a/lib/ref_tracker.c
@@ -385,8 +385,30 @@ void ref_tracker_dir_debugfs(struct ref_
 }
 EXPORT_SYMBOL(ref_tracker_dir_debugfs);
 
+void __ostream_printf ref_tracker_dir_symlink(struct ref_tracker_dir *dir, const char *fmt, ...)
+{
+	char name[NAME_MAX + 1];
+	va_list args;
+	int ret;
+
+	/* Already created, or dentry doesn't exist? Do nothing */
+	if (!IS_ERR_OR_NULL(dir->symlink) || IS_ERR_OR_NULL(dir->dentry))
+		return;
+
+	va_start(args, fmt);
+	ret = vsnprintf(name, sizeof(name), fmt, args);
+	va_end(args);
+	name[sizeof(name) - 1] = '\0';
+
+	if (ret < sizeof(name))
+		dir->symlink = debugfs_create_symlink(name, ref_tracker_debug_dir,
+						      dir->dentry->d_name.name);
+}
+EXPORT_SYMBOL(ref_tracker_dir_symlink);
+
 static void ref_tracker_debugfs_remove(struct ref_tracker_dir *dir)
 {
+	debugfs_remove(dir->symlink);
 	debugfs_remove(dir->dentry);
 }
 
_

Patches currently in -mm which might be from jlayton@kernel.org are

ref_tracker-dont-use-%pk-in-pr_ostream-output.patch
ref_tracker-add-a-top-level-debugfs-directory-for-ref_tracker.patch
ref_tracker-have-callers-pass-output-function-to-pr_ostream.patch
ref_tracker-add-a-static-classname-string-to-each-ref_tracker_dir.patch
ref_tracker-allow-pr_ostream-to-print-directly-to-a-seq_file.patch
ref_tracker-automatically-register-a-file-in-debugfs-for-a-ref_tracker_dir.patch
ref_tracker-add-a-way-to-create-a-symlink-to-the-ref_tracker_dir-debugfs-file.patch
net-add-symlinks-to-ref_tracker_dir-for-netns.patch
ref_tracker-eliminate-the-ref_tracker_dir-name-field.patch

