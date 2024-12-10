Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA711D0F62
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 03:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733800507; cv=none; b=aDW06OPOIxPESwH6gnIesVPL5O+XssRU7jvVJB04SI7KBYrCkYjTe3WkVIfUSoIwg5m7TxSdxbElCK2XMGA5TIvwC+Qmnz34OfcY11nKq+Xm59bfKNYd2vhLVLvOaR5jEeX9wN+CvmVugLZXZPyIfzv21VXfPJBd2ngnyerRjcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733800507; c=relaxed/simple;
	bh=P7NtjkYty6TfrVg0rPdP4eI8DVfKm9ANwF0lCNBqR3Y=;
	h=Date:To:From:Subject:Message-Id; b=tWw02zWM30DQRtZmZ1YamRKSmL4JyJDH4aXr2y0LiNhafxvB/0OJWQOst0v37Jn/LcXnnXzOksKnqZq1fOY5Q1gXLRB7m+49PhLdqEu/Qb3Wy0QZnEiGt2W9XuI8m0hzvuIUzUkGxJLiPqEmpvqQJwcIvtQSmdE3hdMHg5peqKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fySMBqr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fySMBqr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D1FC4CED1;
	Tue, 10 Dec 2024 03:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733800505;
	bh=P7NtjkYty6TfrVg0rPdP4eI8DVfKm9ANwF0lCNBqR3Y=;
	h=Date:To:From:Subject:From;
	b=fySMBqr+acYJkLWoD5F01W+2SCb9WYujtnmOz8J6uydXQIj3Zh4RRikErrgoITZXC
	 fUcbvfvkKCq4lg75aiIIznJXOyTlsfaFzrLCA004Fg73MxIFX1m7JfNkXRHZEqJVwR
	 a21eoXtdtzV8smKDzKm9DVvTkV4Qscjlpm5+hwXk=
Date: Mon, 09 Dec 2024 19:15:04 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,mhiramat@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed.patch added to mm-nonmm-unstable branch
Message-Id: <20241210031505.89D1FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-inject: use prandom where cryptographically secure randomness is not needed
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed.patch

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
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: use prandom where cryptographically secure randomness is not needed
Date: Sun, 8 Dec 2024 23:24:15 +0900

Currently get_random*() is used to determine the probability of fault
injection, but cryptographically secure random numbers are not required.

There is no big problem in using prandom instead of get_random*() to
determine the probability of fault injection, and it also avoids acquiring
a spinlock, which is unsafe in some contexts.

Link: https://lore.kernel.org/lkml/20241129120939.GG35539@noisy.programming.kicks-ass.net
Link: https://lkml.kernel.org/r/20241208142415.205960-1-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/lib/fault-inject.c~fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed
+++ a/lib/fault-inject.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/random.h>
+#include <linux/prandom.h>
 #include <linux/debugfs.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
@@ -13,6 +13,24 @@
 #include <linux/fault-inject.h>
 
 /*
+ * The should_fail() use prandom instead of the normal Linux RNG since they don't
+ * need cryptographically secure random numbers.
+ */
+static DEFINE_PER_CPU(struct rnd_state, fault_rnd_state);
+
+static u32 fault_prandom_u32_below_100(void)
+{
+	struct rnd_state *state;
+	u32 res;
+
+	state = &get_cpu_var(fault_rnd_state);
+	res = prandom_u32_state(state);
+	put_cpu_var(fault_rnd_state);
+
+	return res % 100;
+}
+
+/*
  * setup_fault_attr() is a helper function for various __setup handlers, so it
  * returns 0 on error, because that is what __setup handlers do.
  */
@@ -31,6 +49,8 @@ int setup_fault_attr(struct fault_attr *
 		return 0;
 	}
 
+	prandom_init_once(&fault_rnd_state);
+
 	attr->probability = probability;
 	attr->interval = interval;
 	atomic_set(&attr->times, times);
@@ -146,7 +166,7 @@ bool should_fail_ex(struct fault_attr *a
 			return false;
 	}
 
-	if (attr->probability <= get_random_u32_below(100))
+	if (attr->probability <= fault_prandom_u32_below_100())
 		return false;
 
 fail:
@@ -219,6 +239,8 @@ struct dentry *fault_create_debugfs_attr
 	if (IS_ERR(dir))
 		return dir;
 
+	prandom_init_once(&fault_rnd_state);
+
 	debugfs_create_ul("probability", mode, dir, &attr->probability);
 	debugfs_create_ul("interval", mode, dir, &attr->interval);
 	debugfs_create_atomic_t("times", mode, dir, &attr->times);
@@ -431,6 +453,8 @@ static const struct config_item_type fau
 
 void fault_config_init(struct fault_config *config, const char *name)
 {
+	prandom_init_once(&fault_rnd_state);
+
 	config_group_init_type_name(&config->group, name, &fault_config_type);
 }
 EXPORT_SYMBOL_GPL(fault_config_init);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed.patch

