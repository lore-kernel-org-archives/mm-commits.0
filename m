Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93BA140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189505; cv=none; b=R9Km8zrw0ZBO4Zbwzb93xoeQdVdA3ZhphwkGB6uVAXH1qfp0PwASH7WEsGEjiWDw/LoJ1JYetRSbuQ2OAicvEdFnSimklLds2ioz7XsSvVG9LdU/RMZLAC/cES/zgrY1neMl6uL6mKPdgKWMnK1523SCo1cYy7P3oFcaSNaVmKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189505; c=relaxed/simple;
	bh=ML0RyGb0NoDvpFE35FRKwFCt1qR60sBhlfM8LNh1sL4=;
	h=Date:To:From:Subject:Message-Id; b=MG/vSrWVWDepfloTHdzeDPs7QP3Gdo+11HZdmVyhJgVh1vknUUZhiGj1lKrnkqMH9PYF3zL2ZPab4eNr8sHMsupGhiHK0//o4/dSF28d6UxuvRNwQ7Bu7h3GRy9b2d1r77cm4NHpSPfEqWuikCKugolxRRwTigoYywy/IjCvLLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ahmCoG67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ahmCoG67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749FAC4CEEC;
	Mon, 17 Mar 2025 05:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189505;
	bh=ML0RyGb0NoDvpFE35FRKwFCt1qR60sBhlfM8LNh1sL4=;
	h=Date:To:From:Subject:From;
	b=ahmCoG67YFos+6ar1k9f7W0q8cIAiD+TwjPRQj0MJCXOXfyhkKkbOmmomRGZ3VBr/
	 OjLcrE/+C9cidkwr6QRLbxKOiCzVCYGjCjr1pp7Yvs3JltoNGJenKfwfBdsbgSRLSt
	 MN9Xrengs84BtnFbaIXjKyJ5cdwKVbqeWZCibpTw=
Date: Sun, 16 Mar 2025 22:31:44 -0700
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,urezki@gmail.com,tglx@linutronix.de,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,mengensun@tencent.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rcu-provide-a-static-initializer-for-hlist_nulls_head.patch removed from -mm tree
Message-Id: <20250317053145.749FAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rcu: provide a static initializer for hlist_nulls_head
has been removed from the -mm tree.  Its filename was
     rcu-provide-a-static-initializer-for-hlist_nulls_head.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Thomas Gleixner <tglx@linutronix.de>
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


