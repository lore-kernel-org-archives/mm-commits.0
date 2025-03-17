Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13FF140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189506; cv=none; b=MnMXv4o0pVy6vvaslUwFucM9E3ayNg/ZZEfjlRdI9bYEz2fa4yyzuJEiYdGN3MxRaQFgBwjxwEB2E3MHmjdICOi0S94QWfFcsTp8r5SCWOvNZBZ3shskNhpPiUbPZpf77ZrWtigtMC18rzXGCN92S4OiI/QD5mZTdhcVrtvHUfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189506; c=relaxed/simple;
	bh=dtpzwUmWAVw0O4v9S4GRcP71NxhQflffTOB422HNLDA=;
	h=Date:To:From:Subject:Message-Id; b=E4PjtkCNDvDlv/BN3JbAwVVOIF6Tujcfu3VA+qBh9Js0FP3Fon/k66sAGUJJIIff+JX/9diso2ZhDV2S/krOGr74LeHRV0DErqy1HxXURufDOJ6NLL7gwjH2BEUy+yNOPxNO/Xwpeb0dflSFXJe5ATsoLEJLG02F4N9gt7X4y1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U9RLvd6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U9RLvd6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A737CC4CEEC;
	Mon, 17 Mar 2025 05:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189506;
	bh=dtpzwUmWAVw0O4v9S4GRcP71NxhQflffTOB422HNLDA=;
	h=Date:To:From:Subject:From;
	b=U9RLvd6yfQqhnea1e5WLA/iFYxntlo0nSNVhtwh0IMXKV4CX0Pxs88pS9j9GY2kwH
	 XlYevxUghb0UGjXunUz4xNug2SIEArx8PrOTkxfgpAqeGdA040GGKfcQwX9wo8mqle
	 H4RnTCTA6B9w8LUushtSOYvtI4jgusyTBG649xoo=
Date: Sun, 16 Mar 2025 22:31:46 -0700
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,urezki@gmail.com,tglx@linutronix.de,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,mengensun@tencent.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch removed from -mm tree
Message-Id: <20250317053146.A737CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucount: replace get_ucounts_or_wrap() with atomic_inc_not_zero()
has been removed from the -mm tree.  Its filename was
     ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: ucount: replace get_ucounts_or_wrap() with atomic_inc_not_zero()
Date: Mon, 3 Feb 2025 16:05:23 +0100

get_ucounts_or_wrap() increments the counter and if the counter is
negative then it decrements it again in order to reset the previous
increment.  This statement can be replaced with atomic_inc_not_zero() to
only increment the counter if it is not yet 0.

This simplifies the get function because the put (if the get failed) can
be removed.  atomic_inc_not_zero() is implement as a cmpxchg() loop which
can be repeated several times if another get/put is performed in parallel.
This will be optimized later.

Increment the reference counter only if not yet dropped to zero.

Link: https://lkml.kernel.org/r/20250203150525.456525-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mengen Sun <mengensun@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: YueHong Wu <yuehongwu@tencent.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/kernel/ucount.c~ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero
+++ a/kernel/ucount.c
@@ -146,25 +146,16 @@ static void hlist_add_ucounts(struct uco
 	spin_unlock_irq(&ucounts_lock);
 }
 
-static inline bool get_ucounts_or_wrap(struct ucounts *ucounts)
-{
-	/* Returns true on a successful get, false if the count wraps. */
-	return !atomic_add_negative(1, &ucounts->count);
-}
-
 struct ucounts *get_ucounts(struct ucounts *ucounts)
 {
-	if (!get_ucounts_or_wrap(ucounts)) {
-		put_ucounts(ucounts);
-		ucounts = NULL;
-	}
-	return ucounts;
+	if (atomic_inc_not_zero(&ucounts->count))
+		return ucounts;
+	return NULL;
 }
 
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
-	bool wrapped;
 	struct ucounts *ucounts, *new = NULL;
 
 	spin_lock_irq(&ucounts_lock);
@@ -189,14 +180,11 @@ struct ucounts *alloc_ucounts(struct use
 			return new;
 		}
 	}
-
-	wrapped = !get_ucounts_or_wrap(ucounts);
+	if (!atomic_inc_not_zero(&ucounts->count))
+		ucounts = NULL;
 	spin_unlock_irq(&ucounts_lock);
 	kfree(new);
-	if (wrapped) {
-		put_ucounts(ucounts);
-		return NULL;
-	}
+
 	return ucounts;
 }
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


