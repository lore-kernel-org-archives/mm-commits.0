Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5913D347D5
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749002959; cv=none; b=S/ux2i9knUoIXbZxyqmd7tlG6NGqT82Xx2JAdykgv6YMSJyz5X+CfjBLTVlvxYq75SBH7Sj2XRzQ/ejB8rDZ6WvCxlOHlQL7oi4W6bCgOcC17do/Zu0OvFk0Zlfud94KxYy5IO8WTkfc5w50VzKG0pY4XzSCcNfUT54J25/iILg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749002959; c=relaxed/simple;
	bh=sQ2bgj/vmpmMKMBUMQUWK8QniRh621AeNc1mAKJ0r+E=;
	h=Date:To:From:Subject:Message-Id; b=iCVq3kWv8bqHUXnIX5oN0Kaa5J2NwXfGCJHyJrfgd7/XAV9e3Da6vPw07ak/hIzodz73UU+wp9ZuPSq0jYDEWFRVf2a7ejSkKaWmsjjHepcANOVDNhEZbeKS7jpfU/qwgb27lRFHW5nAGvTjFUADua1VLH1Y83S6t2qI9uFhBZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m1pp2tt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m1pp2tt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C08DC4CEED;
	Wed,  4 Jun 2025 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749002959;
	bh=sQ2bgj/vmpmMKMBUMQUWK8QniRh621AeNc1mAKJ0r+E=;
	h=Date:To:From:Subject:From;
	b=m1pp2tt4bpb2mu2EjZ3eI/+KFg/3SfDvGxL946U90ra4yqh2D2nA11fgXGIGI7fDB
	 8xW9yDCGTZ4bQt0QpI8Es7lvhDTh2F9bdBSffjVMH/cuQGxBcjS2djTBmCv5dM+bmE
	 g5BjeFl/j48C3eOxDvSLb8IPdrNg4cbqEy+g9jhw=
Date: Tue, 03 Jun 2025 19:09:18 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,tursulin@ursulin.net,thomas.weissschuh@linutronix.de,rodrigo.vivi@intel.com,qasdev00@gmail.com,pabeni@redhat.com,nathan@kernel.org,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuniyu@amazon.com,kuba@kernel.org,krzysztof.karas@intel.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,horms@kernel.org,edumazet@google.com,davem@davemloft.net,andrew@lunn.ch,airlied@gmail.com,jlayton@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ref_tracker-allow-pr_ostream-to-print-directly-to-a-seq_file.patch added to mm-nonmm-unstable branch
Message-Id: <20250604020919.1C08DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ref_tracker: allow pr_ostream() to print directly to a seq_file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ref_tracker-allow-pr_ostream-to-print-directly-to-a-seq_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ref_tracker-allow-pr_ostream-to-print-directly-to-a-seq_file.patch

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
Subject: ref_tracker: allow pr_ostream() to print directly to a seq_file
Date: Tue, 03 Jun 2025 07:27:16 -0400

Allow pr_ostream to also output directly to a seq_file without an
intermediate buffer.  The first caller of +ref_tracker_dir_seq_print()
will come in a later patch, so mark that __maybe_unused for now.  That
designation will be removed once it is used.

Link: https://lkml.kernel.org/r/20250603-reftrack-dbgfs-v13-5-7b2a425019d8@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

 lib/ref_tracker.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/lib/ref_tracker.c~ref_tracker-allow-pr_ostream-to-print-directly-to-a-seq_file
+++ a/lib/ref_tracker.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
 #include <linux/stackdepot.h>
+#include <linux/seq_file.h>
 
 #define REF_TRACKER_STACK_ENTRIES 16
 #define STACK_BUF_SIZE 1024
@@ -66,6 +67,7 @@ struct ostream {
 	void __ostream_printf (*func)(struct ostream *stream, char *fmt, ...);
 	char *prefix;
 	char *buf;
+	struct seq_file *seq;
 	int size, used;
 };
 
@@ -301,6 +303,30 @@ EXPORT_SYMBOL_GPL(ref_tracker_free);
 
 static struct dentry *ref_tracker_debug_dir = (struct dentry *)-ENOENT;
 
+static void __ostream_printf pr_ostream_seq(struct ostream *stream, char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	seq_vprintf(stream->seq, fmt, args);
+	va_end(args);
+}
+
+static __maybe_unused int
+ref_tracker_dir_seq_print(struct ref_tracker_dir *dir, struct seq_file *seq)
+{
+	struct ostream os = { .func = pr_ostream_seq,
+			      .prefix = "",
+			      .seq = seq };
+	unsigned long flags;
+
+	spin_lock_irqsave(&dir->lock, flags);
+	__ref_tracker_dir_pr_ostream(dir, 16, &os);
+	spin_unlock_irqrestore(&dir->lock, flags);
+
+	return os.used;
+}
+
 static int __init ref_tracker_debugfs_init(void)
 {
 	ref_tracker_debug_dir = debugfs_create_dir("ref_tracker", NULL);
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

