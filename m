Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF4A1A01C6
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738972281; cv=none; b=MOXZ7zHk4uBIL2tjHPpfHMHWEHNDrl8d7N7zzK6kxiGDNWbjD0oYNEMOwT2vzfGAEffOLi/43TI+XM0ubJ3f5MH8uqEGL8c8HxeOMvyHDy8WPeEkVX9skuIimCNNRKrNjRaDxzmaSTxmKHkCRLcvefa53ltEzGuDZnFpd3itwu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738972281; c=relaxed/simple;
	bh=GNEvm8cuAXuX5hP6Udee8+z/WZmBq5ozDZukn9fxtM4=;
	h=Date:To:From:Subject:Message-Id; b=NSid0kRScl8fVSCHDj3ftYF4BtbnpQ8XEks/M4dTyPzpBNzFTUimHkfPbfaHPuYOyOuV9EJ5tFzJlois1SQOKt81AYZGyYcfVSolH9JcMMoQCl/zSFScLq40Kh8arv4WxXhbbiJpGAE/VVoIApgXSjMXf/W9Gkl/ps9xUPE5jFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IajqUpqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IajqUpqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F1CC4CED1;
	Fri,  7 Feb 2025 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738972281;
	bh=GNEvm8cuAXuX5hP6Udee8+z/WZmBq5ozDZukn9fxtM4=;
	h=Date:To:From:Subject:From;
	b=IajqUpqhjmTO80lPL6PyOg87KKkix23PtBkKJZJzHCOo8JToU9ug6AsGcGJ+hh/0T
	 5fFWG2lnLS2eEUOaESouXDv2h8a7eYG2+eSm6iwYvud3VjBHPus8tukMfYnz+5r9nu
	 dxNjnjqql+6IzPdjnSpQpWcwVgNM4xVWEXSt7fgE=
Date: Fri, 07 Feb 2025 15:51:20 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,urezki@gmail.com,tglx@linutronix.de,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,mengensun@tencent.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rcu-provide-a-static-initializer-for-hlist_nulls_head.patch added to mm-nonmm-unstable branch
Message-Id: <20250207235121.04F1CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rcu: provide a static initializer for hlist_nulls_head
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rcu-provide-a-static-initializer-for-hlist_nulls_head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rcu-provide-a-static-initializer-for-hlist_nulls_head.patch

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
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: rcu: provide a static initializer for hlist_nulls_head
Date: Mon, 3 Feb 2025 16:05:22 +0100

Patch series "ucount: Simplify refcounting with rcuref_t".

I noticed that the atomic_dec_and_lock_irqsave() in put_ucounts() loops
sometimes even during boot.  Something like 2-3 iterations but still. 
This series replaces the refcounting with rcuref_t and adds a RCU lookup.

This allows a lockless lookup in alloc_ucounts() if the entry is available
and a cmpxchg()less put of the item.


This patch (of 4):

Provide a static initializer for hlist_nulls_head so that it can be used
in statically defined data structures.

Link: https://lkml.kernel.org/r/20250203150525.456525-1-bigeasy@linutronix.de
Link: https://lkml.kernel.org/r/20250203150525.456525-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Acked-by:Thomas Gleixner <tglx@linutronix.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mengen Sun <mengensun@tencent.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: YueHong Wu <yuehongwu@tencent.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_nulls.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/list_nulls.h~rcu-provide-a-static-initializer-for-hlist_nulls_head
+++ a/include/linux/list_nulls.h
@@ -28,6 +28,7 @@ struct hlist_nulls_node {
 #define NULLS_MARKER(value) (1UL | (((long)value) << 1))
 #define INIT_HLIST_NULLS_HEAD(ptr, nulls) \
 	((ptr)->first = (struct hlist_nulls_node *) NULLS_MARKER(nulls))
+#define HLIST_NULLS_HEAD_INIT(nulls) {.first = (struct hlist_nulls_node *)NULLS_MARKER(nulls)}
 
 #define hlist_nulls_entry(ptr, type, member) container_of(ptr,type,member)
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch
ucount-use-rcu-for-ucounts-lookups.patch
ucount-use-rcuref_t-for-reference-counting.patch

