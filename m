Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322E613AA27
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749002969; cv=none; b=K1wyN1CfTkppdjUHJjdAZZirpPZw1saIFmlo8OXJgWRhHqVAVRa1tlmszDTIHQxieY7B0EMP3rqhSXgDG2jCpdjCcl7dhNB3DMgXjpLItdb2CxuG62EddYdE218CT68+bH2NT1sZMkvInYhxCJna3b1PkeKctl+5EZSwCJdT58U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749002969; c=relaxed/simple;
	bh=orAuUqt9KNIhsjAZKSkVeWi/WIfG7g+C+ApAYepCR6Y=;
	h=Date:To:From:Subject:Message-Id; b=ZL/V+I+m1TMsK1X2mYjmo0n3wKFKtTjUmzwr13SeM//dz+NKte0DJC6XI5MZYwqXfPq+xsmX+m9wVdMKQtzHQnCeZwE3kPkG3q3wadNElPRYi2H4Ip8Zo8IP7BGpbI/VvFLAwZoSBzDqQHPclvybs2D4ZKFuT5bmN7HuvDdwaec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qzjfbg9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qzjfbg9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DBCC4CEED;
	Wed,  4 Jun 2025 02:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749002969;
	bh=orAuUqt9KNIhsjAZKSkVeWi/WIfG7g+C+ApAYepCR6Y=;
	h=Date:To:From:Subject:From;
	b=Qzjfbg9NhcG7KzfHLJbo0G20vCR8ZqBsLfW2jGSu+5BmZt6Ygr4DQLBxEQ2f32Kg4
	 7m9HKlaKXBk7YkndHiI/x3dVy1U5jKx8Ptn9wT5+OOmpHldR3tvNI+oHQxCh0rYV4c
	 41hRiW2+orTWaDn9Hl40C2hSEIkc/G9XEXvt50RU=
Date: Tue, 03 Jun 2025 19:09:28 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,tursulin@ursulin.net,thomas.weissschuh@linutronix.de,rodrigo.vivi@intel.com,qasdev00@gmail.com,pabeni@redhat.com,nathan@kernel.org,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuniyu@amazon.com,kuba@kernel.org,krzysztof.karas@intel.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,horms@kernel.org,edumazet@google.com,davem@davemloft.net,andrew@lunn.ch,airlied@gmail.com,jlayton@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ref_tracker-eliminate-the-ref_tracker_dir-name-field.patch added to mm-nonmm-unstable branch
Message-Id: <20250604020929.04DBCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ref_tracker: eliminate the ref_tracker_dir name field
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ref_tracker-eliminate-the-ref_tracker_dir-name-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ref_tracker-eliminate-the-ref_tracker_dir-name-field.patch

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
Subject: ref_tracker: eliminate the ref_tracker_dir name field
Date: Tue, 03 Jun 2025 07:27:20 -0400

Now that we have dentries and the ability to create meaningful symlinks to
them, don't keep a name string in each tracker.  Switch the output format
to print "class@address", and drop the name field.

Also, add a kerneldoc header for ref_tracker_dir_init().

Link: https://lkml.kernel.org/r/20250603-reftrack-dbgfs-v13-9-7b2a425019d8@kernel.org
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

 drivers/gpu/drm/display/drm_dp_tunnel.c |    2 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c |    2 +-
 drivers/gpu/drm/i915/intel_wakeref.c    |    2 +-
 include/linux/ref_tracker.h             |   20 ++++++++++++++------
 lib/ref_tracker.c                       |    6 +++---
 lib/test_ref_tracker.c                  |    2 +-
 net/core/dev.c                          |    2 +-
 net/core/net_namespace.c                |    4 ++--
 8 files changed, 24 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_tunnel.c~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/drivers/gpu/drm/display/drm_dp_tunnel.c
@@ -1920,7 +1920,7 @@ drm_dp_tunnel_mgr_create(struct drm_devi
 	}
 
 #ifdef CONFIG_DRM_DISPLAY_DP_TUNNEL_STATE_DEBUG
-	ref_tracker_dir_init(&mgr->ref_tracker, 16, "drm_dptun", "dptun");
+	ref_tracker_dir_init(&mgr->ref_tracker, 16, "drm_dptun");
 #endif
 
 	for (i = 0; i < max_group_count; i++) {
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -61,7 +61,7 @@ static void init_intel_runtime_pm_wakere
 {
 	if (!rpm->debug.class)
 		ref_tracker_dir_init(&rpm->debug, INTEL_REFTRACK_DEAD_COUNT,
-				     "intel_runtime_pm", dev_name(rpm->kdev));
+				     "intel_runtime_pm");
 }
 
 static intel_wakeref_t
--- a/drivers/gpu/drm/i915/intel_wakeref.c~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/drivers/gpu/drm/i915/intel_wakeref.c
@@ -115,7 +115,7 @@ void __intel_wakeref_init(struct intel_w
 
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
 	if (!wf->debug.class)
-		ref_tracker_dir_init(&wf->debug, INTEL_REFTRACK_DEAD_COUNT, "intel_wakeref", name);
+		ref_tracker_dir_init(&wf->debug, INTEL_REFTRACK_DEAD_COUNT, "intel_wakeref");
 #endif
 }
 
--- a/include/linux/ref_tracker.h~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/include/linux/ref_tracker.h
@@ -24,7 +24,6 @@ struct ref_tracker_dir {
 	struct dentry		*dentry;
 	struct dentry		*symlink;
 #endif
-	char			name[32];
 #endif
 };
 
@@ -48,10 +47,21 @@ void ref_tracker_dir_symlink(struct ref_
 
 #endif /* CONFIG_DEBUG_FS */
 
+/**
+ * ref_tracker_dir_init - initialize a ref_tracker dir
+ * @dir: ref_tracker_dir to be initialized
+ * @quarantine_count: max number of entries to be tracked
+ * @class: pointer to static string that describes object type
+ *
+ * Initialize a ref_tracker_dir. If debugfs is configured, then a file
+ * will also be created for it under the top-level ref_tracker debugfs
+ * directory.
+ *
+ * Note that @class must point to a static string.
+ */
 static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 					unsigned int quarantine_count,
-					const char *class,
-					const char *name)
+					const char *class)
 {
 	INIT_LIST_HEAD(&dir->list);
 	INIT_LIST_HEAD(&dir->quarantine);
@@ -65,7 +75,6 @@ static inline void ref_tracker_dir_init(
 	dir->dentry = NULL;
 	dir->symlink = NULL;
 #endif
-	strscpy(dir->name, name, sizeof(dir->name));
 	ref_tracker_dir_debugfs(dir);
 	stack_depot_init();
 }
@@ -90,8 +99,7 @@ int ref_tracker_free(struct ref_tracker_
 
 static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 					unsigned int quarantine_count,
-					const char *class,
-					const char *name)
+					const char *class)
 {
 }
 
--- a/lib/ref_tracker.c~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/lib/ref_tracker.c
@@ -124,7 +124,7 @@ __ref_tracker_dir_pr_ostream(struct ref_
 	stats = ref_tracker_get_stats(dir, display_limit);
 	if (IS_ERR(stats)) {
 		pr_ostream(s, "%s%s@%p: couldn't get stats, error %pe\n",
-			   s->prefix, dir->name, dir, stats);
+			   s->prefix, dir->class, dir, stats);
 		return;
 	}
 
@@ -135,14 +135,14 @@ __ref_tracker_dir_pr_ostream(struct ref_
 		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
 			sbuf[0] = 0;
 		pr_ostream(s, "%s%s@%p has %d/%d users at\n%s\n", s->prefix,
-			   dir->name, dir, stats->stacks[i].count,
+			   dir->class, dir, stats->stacks[i].count,
 			   stats->total, sbuf);
 		skipped -= stats->stacks[i].count;
 	}
 
 	if (skipped)
 		pr_ostream(s, "%s%s@%p skipped reports about %d/%d users.\n",
-			   s->prefix, dir->name, dir, skipped, stats->total);
+			   s->prefix, dir->class, dir, skipped, stats->total);
 
 	kfree(sbuf);
 
--- a/lib/test_ref_tracker.c~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/lib/test_ref_tracker.c
@@ -64,7 +64,7 @@ static int __init test_ref_tracker_init(
 {
 	int i;
 
-	ref_tracker_dir_init(&ref_dir, 100, "selftest", "selftest");
+	ref_tracker_dir_init(&ref_dir, 100, "selftest");
 
 	timer_setup(&test_ref_tracker_timer, test_ref_tracker_timer_func, 0);
 	mod_timer(&test_ref_tracker_timer, jiffies + 1);
--- a/net/core/dev.c~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/net/core/dev.c
@@ -11714,7 +11714,7 @@ struct net_device *alloc_netdev_mqs(int
 
 	dev->priv_len = sizeof_priv;
 
-	ref_tracker_dir_init(&dev->refcnt_tracker, 128, "netdev", name);
+	ref_tracker_dir_init(&dev->refcnt_tracker, 128, "netdev");
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
--- a/net/core/net_namespace.c~ref_tracker-eliminate-the-ref_tracker_dir-name-field
+++ a/net/core/net_namespace.c
@@ -403,8 +403,8 @@ static __net_init void preinit_net(struc
 {
 	refcount_set(&net->passive, 1);
 	refcount_set(&net->ns.count, 1);
-	ref_tracker_dir_init(&net->refcnt_tracker, 128, "net_refcnt", "net_refcnt");
-	ref_tracker_dir_init(&net->notrefcnt_tracker, 128, "net_notrefcnt", "net_notrefcnt");
+	ref_tracker_dir_init(&net->refcnt_tracker, 128, "net_refcnt");
+	ref_tracker_dir_init(&net->notrefcnt_tracker, 128, "net_notrefcnt");
 
 	get_random_bytes(&net->hash_mix, sizeof(u32));
 	net->dev_base_seq = 1;
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

