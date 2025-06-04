Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5981E480
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749002967; cv=none; b=sjpl7yORUnPX+R6sjrZ/s1Bh3qToF6gOv4uBEsiTVWgMNR36pNGrBGpEdcuvI7Nc/YklkMjO8fCVvB0M+OSmOoIkzqo6V9keHL8DuHFELyGgWrGKedlOJT2yy0Qzna1bmvPN49u0oVRraEL3BcgxZzAlGKF8rdLCNJcZMXgGetc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749002967; c=relaxed/simple;
	bh=y5wrFFHoqU4lsxvB3vOoTSkIdCJqo+v2CgWwR3//lbE=;
	h=Date:To:From:Subject:Message-Id; b=aX1CibxF9x1fhIRy8HoyqE8zpVNsETYWE0gTeQDUbZkWH8kPMcx4MPVQElvvAWEtx2gVzQP+61Mli95qSCDPr2BIwoedAdur9gJPrM9Y25C9bKe5xSonue3DYLSZp0maB7halZXy3UsfPuj1LRl4ONGUEzCZTPcH5BQ+8jnyDtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pR8ZIFl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pR8ZIFl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8598C4CEED;
	Wed,  4 Jun 2025 02:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749002966;
	bh=y5wrFFHoqU4lsxvB3vOoTSkIdCJqo+v2CgWwR3//lbE=;
	h=Date:To:From:Subject:From;
	b=pR8ZIFl36Q27J7PIz8TW7IdmbeFb5KWT4BrKNfOpPjnHGNlBd3nnHEY64HCAmUm5q
	 l6Rjsc9apTBL+C9WEv28Tw8TAQMNJ9FPNh5DvcQNwZByjg7HwJvaJNt44COOoxDpx9
	 7wOA3DVtAmzC0pFE75+eJv7uoin7AEQ4yLU+s+EE=
Date: Tue, 03 Jun 2025 19:09:26 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,tursulin@ursulin.net,thomas.weissschuh@linutronix.de,rodrigo.vivi@intel.com,qasdev00@gmail.com,pabeni@redhat.com,nathan@kernel.org,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuniyu@amazon.com,kuba@kernel.org,krzysztof.karas@intel.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,horms@kernel.org,edumazet@google.com,davem@davemloft.net,andrew@lunn.ch,airlied@gmail.com,jlayton@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + net-add-symlinks-to-ref_tracker_dir-for-netns.patch added to mm-nonmm-unstable branch
Message-Id: <20250604020926.A8598C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: net: add symlinks to ref_tracker_dir for netns
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     net-add-symlinks-to-ref_tracker_dir-for-netns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-add-symlinks-to-ref_tracker_dir-for-netns.patch

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
Subject: net: add symlinks to ref_tracker_dir for netns
Date: Tue, 03 Jun 2025 07:27:19 -0400

After assigning the inode number to the namespace, use it to create a
unique name for each netns refcount tracker with the ns.inum and
net_cookie values in it, and register a symlink to the debugfs file for
it.

init_net is registered before the ref_tracker dir is created, so add a
late_initcall() to register its files and symlinks.

Link: https://lkml.kernel.org/r/20250603-reftrack-dbgfs-v13-8-7b2a425019d8@kernel.org
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

 net/core/net_namespace.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/net/core/net_namespace.c~net-add-symlinks-to-ref_tracker_dir-for-netns
+++ a/net/core/net_namespace.c
@@ -791,12 +791,40 @@ struct net *get_net_ns_by_pid(pid_t pid)
 }
 EXPORT_SYMBOL_GPL(get_net_ns_by_pid);
 
+#ifdef CONFIG_NET_NS_REFCNT_TRACKER
+static void net_ns_net_debugfs(struct net *net)
+{
+	ref_tracker_dir_symlink(&net->refcnt_tracker, "netns-%llx-%u-refcnt",
+				net->net_cookie, net->ns.inum);
+	ref_tracker_dir_symlink(&net->notrefcnt_tracker, "netns-%llx-%u-notrefcnt",
+				net->net_cookie, net->ns.inum);
+}
+
+static int __init init_net_debugfs(void)
+{
+	ref_tracker_dir_debugfs(&init_net.refcnt_tracker);
+	ref_tracker_dir_debugfs(&init_net.notrefcnt_tracker);
+	net_ns_net_debugfs(&init_net);
+	return 0;
+}
+late_initcall(init_net_debugfs);
+#else
+static void net_ns_net_debugfs(struct net *net)
+{
+}
+#endif
+
 static __net_init int net_ns_net_init(struct net *net)
 {
+	int ret;
+
 #ifdef CONFIG_NET_NS
 	net->ns.ops = &netns_operations;
 #endif
-	return ns_alloc_inum(&net->ns);
+	ret = ns_alloc_inum(&net->ns);
+	if (!ret)
+		net_ns_net_debugfs(net);
+	return ret;
 }
 
 static __net_exit void net_ns_net_exit(struct net *net)
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

