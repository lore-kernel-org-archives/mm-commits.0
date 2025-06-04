Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13548E555
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749002948; cv=none; b=oKmJZPNSC8VVPG9vzF5VjN/nhjOc7Xlbe9r3P5PO6oawIg1MAhnkDHxaHVzTuIELeebmomYJ0zM0V8VoHIAZPJ81781kkpTsxOP28DGI7Mwv4yqrBEh8OxoW2Up5pbvGDkrfw+ePWHDBCgwR6PlMGLrHCe9t6w+EDvycAAgkRw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749002948; c=relaxed/simple;
	bh=a+c1NwJCOi678SzsGo03el2l3aYXyq/mM8/f9As7ihs=;
	h=Date:To:From:Subject:Message-Id; b=Fiz+cPPbFWDgSvji8Yc5OqX2vuyzHOWUh7d1XfW0wXMzdElpp+UnPXH3wcyd5JmDPvZ96dTeQGwgjhXc8A6kx9n2S1ftZtIfDmTEY6TB0LHDjlO/KDyS7xsdUIiwqibEN6eYu/6+DeB5L9pjVUdMTB4pTYqhlcTdv9w7BJwCI/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IaZjhvy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IaZjhvy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CBFC4CEED;
	Wed,  4 Jun 2025 02:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749002947;
	bh=a+c1NwJCOi678SzsGo03el2l3aYXyq/mM8/f9As7ihs=;
	h=Date:To:From:Subject:From;
	b=IaZjhvy/nBfRFyuA1rU4w2sBfiRdVWlg6iUgXxW+iT+c427/BIx9NpXjR2hAPiJ/+
	 LGqkgaexPQH5I4Slf3BtufgBQdiZ0eknDRkDc9f5Eaac5rCFGYr4eU9j/6NrKmqRN3
	 SiMihoLqoKNdCKj7ELIiJ2ITXOIpyBGN26DJAooQ=
Date: Tue, 03 Jun 2025 19:09:06 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,tursulin@ursulin.net,thomas.weissschuh@linutronix.de,rodrigo.vivi@intel.com,qasdev00@gmail.com,pabeni@redhat.com,nathan@kernel.org,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuniyu@amazon.com,kuba@kernel.org,krzysztof.karas@intel.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,horms@kernel.org,edumazet@google.com,davem@davemloft.net,andrew@lunn.ch,airlied@gmail.com,jlayton@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ref_tracker-dont-use-%pk-in-pr_ostream-output.patch added to mm-nonmm-unstable branch
Message-Id: <20250604020907.64CBFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ref_tracker: don't use %pK in pr_ostream() output
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ref_tracker-dont-use-%pk-in-pr_ostream-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ref_tracker-dont-use-%pk-in-pr_ostream-output.patch

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
Subject: ref_tracker: don't use %pK in pr_ostream() output
Date: Tue, 03 Jun 2025 07:27:12 -0400

Patch series "ref_tracker: add ability to register a debugfs", v13.

This series adds a new top-level "ref_tracker" debugfs directory, and has
each ref_tracker_dir register a file in there as part of its
initialization.  It also adds the ability to register a symlink with a
more human-usable name that points to the file, and does some general
cleanup of how the ref_tracker object names are handled.


This patch (of 13):

As Thomas Weißschuh points out [1], it is now preferable to use %p
instead of hashed pointers with printk(), since raw pointers should no
longer be leaked into the kernel log.  Change the ref_tracker
infrastructure to use %p instead of %pK in its formats.

Link: https://lkml.kernel.org/r/20250603-reftrack-dbgfs-v13-0-7b2a425019d8@kernel.org
Link: https://lore.kernel.org/netdev/20250414-restricted-pointers-net-v1-0-12af0ce46cdd@linutronix.de/ [1]
Link: https://lkml.kernel.org/r/20250603-reftrack-dbgfs-v13-1-7b2a425019d8@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Qasim Ijaz <qasdev00@gmail.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ref_tracker.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/ref_tracker.c~ref_tracker-dont-use-%pk-in-pr_ostream-output
+++ a/lib/ref_tracker.c
@@ -96,7 +96,7 @@ __ref_tracker_dir_pr_ostream(struct ref_
 
 	stats = ref_tracker_get_stats(dir, display_limit);
 	if (IS_ERR(stats)) {
-		pr_ostream(s, "%s@%pK: couldn't get stats, error %pe\n",
+		pr_ostream(s, "%s@%p: couldn't get stats, error %pe\n",
 			   dir->name, dir, stats);
 		return;
 	}
@@ -107,13 +107,13 @@ __ref_tracker_dir_pr_ostream(struct ref_
 		stack = stats->stacks[i].stack_handle;
 		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
 			sbuf[0] = 0;
-		pr_ostream(s, "%s@%pK has %d/%d users at\n%s\n", dir->name, dir,
+		pr_ostream(s, "%s@%p has %d/%d users at\n%s\n", dir->name, dir,
 			   stats->stacks[i].count, stats->total, sbuf);
 		skipped -= stats->stacks[i].count;
 	}
 
 	if (skipped)
-		pr_ostream(s, "%s@%pK skipped reports about %d/%d users.\n",
+		pr_ostream(s, "%s@%p skipped reports about %d/%d users.\n",
 			   dir->name, dir, skipped, stats->total);
 
 	kfree(sbuf);
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

