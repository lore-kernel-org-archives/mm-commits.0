Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A601A5A2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644514; cv=none; b=Sljj4fO7YJo+8rNpo1HYbfG7cpY5cJMnjdvvTUJ87uBCWL9WP8KL5CzkcCYoYb38n5fpguyf0xG6XYlUlpO8wsR4j5d+oFL/1g/eLwMUGUEzP0hz2Pw7+CpV9WfDDgfIiSuTfoNvH1doYBBm4b9dd6ehBXfFVpikr7iQJvog4lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644514; c=relaxed/simple;
	bh=xVrbsRwtUbb6IgIGdrgu1OtzHrfixl9wRGyDbFsGwUM=;
	h=Date:To:From:Subject:Message-Id; b=rrjAimM/spzXmjooep7O5K/dcFjTpZnl8d7v90Ia3NcfqJSlvN9qOhSWu5qZ/99kJj0uSB9wZ83BjMEmuZJgtO8rTXPzXhT/m01QaVeX1xp5npTqrIaawbPbSZ2rDVclhqy+kER5RnyeKNQEnXKnJuj5CGh9lUYmWe45Bb0YF+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zCnCzU+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zCnCzU+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1E9C43390;
	Thu, 22 Feb 2024 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644514;
	bh=xVrbsRwtUbb6IgIGdrgu1OtzHrfixl9wRGyDbFsGwUM=;
	h=Date:To:From:Subject:From;
	b=zCnCzU+sfPxQiZw4485oKMv+IRJPM48L1qB7TC9uPY7nXEqEo4L1kUtBonMvDLfq3
	 UtCOfn+xFKYMw00LlTF2I3HgoJo3Uj6+s+8kNEQNrv34l400ClGJ1EGrlK9QV1dmwT
	 u544zd/hHunGDYAXjFeBYWw2vctRPXa7GlDrKMq0=
Date: Thu, 22 Feb 2024 15:28:33 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,juntong.deng@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps.patch removed from -mm tree
Message-Id: <20240222232834.7B1E9C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: increase the number of bits to shift when recording extra timestamps
has been removed from the -mm tree.  Its filename was
     kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Juntong Deng <juntong.deng@outlook.com>
Subject: kasan: increase the number of bits to shift when recording extra timestamps
Date: Thu, 15 Feb 2024 18:39:55 +0000

In 5d4c6ac94694 ("kasan: record and report more information") I thought
that printk only displays a maximum of 99999 seconds, but actually printk
can display a larger number of seconds.

So increase the number of bits to shift when recording the extra timestamp
(44 bits), without affecting the precision, shift it right by 9 bits,
discarding all bits that do not affect the microsecond part (nanoseconds
will not be shown).

Currently the maximum time that can be displayed is 9007199.254740s,
because

11111111111111111111111111111111111111111111 (44 bits) << 9
= 11111111111111111111111111111111111111111111000000000
= 9007199.254740

Link: https://lkml.kernel.org/r/AM6PR03MB58481629F2F28CE007412139994D2@AM6PR03MB5848.eurprd03.prod.outlook.com
Fixes: 5d4c6ac94694 ("kasan: record and report more information")
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 mm/kasan/report.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/common.c~kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps
+++ a/mm/kasan/common.c
@@ -55,7 +55,7 @@ void kasan_set_track(struct kasan_track
 	u64 ts_nsec = local_clock();
 
 	track->cpu = cpu;
-	track->timestamp = ts_nsec >> 3;
+	track->timestamp = ts_nsec >> 9;
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 	track->pid = current->pid;
 	track->stack = stack;
--- a/mm/kasan/report.c~kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps
+++ a/mm/kasan/report.c
@@ -267,7 +267,7 @@ static void print_track(struct kasan_tra
 	u64 ts_nsec = track->timestamp;
 	unsigned long rem_usec;
 
-	ts_nsec <<= 3;
+	ts_nsec <<= 9;
 	rem_usec = do_div(ts_nsec, NSEC_PER_SEC) / 1000;
 
 	pr_err("%s by task %u on cpu %d at %lu.%06lus:\n",
_

Patches currently in -mm which might be from juntong.deng@outlook.com are


