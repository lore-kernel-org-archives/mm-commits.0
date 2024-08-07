Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F569B640
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064754; cv=none; b=FhF+fDAe8UDbKizURBkB4k2OyHfBoPi0zvgKY4z2woeTpAlAj7Hc86EMl4K8NbnsJ8TKJh4jUUlGGSfogH5zSo5Zpc7VV13zflG4Z1e7zWnup+trwu1BNLvTgAp/eOPKWRXIGbJBmjx4uSyavFKNzTcTEjPkqhlo3YhWBHOK4dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064754; c=relaxed/simple;
	bh=J6WJJ+9WFks33M8zvx2iF/Wi/ve/n7dYpfZQOq7xv94=;
	h=Date:To:From:Subject:Message-Id; b=jkBS+oem499w664Y0ptNbuZfh67IuUH9siDN/lH1G1SHcrApC7OqCdtvLGUAQ4gzbuNG7WQAMA2LchZsiqJLuc8EzXg6vE0GtIEgi2lN6kokm/vdyfy2w7zTvjwZQwWk9ThE1c6huPmb1emJc2dKLeFcjj9CWsAU7gHb3LphZB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XceEa3i5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XceEa3i5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED87AC32782;
	Wed,  7 Aug 2024 21:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723064754;
	bh=J6WJJ+9WFks33M8zvx2iF/Wi/ve/n7dYpfZQOq7xv94=;
	h=Date:To:From:Subject:From;
	b=XceEa3i524ZaYaE9Qzw7dZ2/uKLq6OqNRWn097PTOlpBFLRwE0dCTmfaFeAlTQp1d
	 CIpBE3AHZ9Ld4F9TLm+BAjFWlhw86kjHuvtQAOpzdCCgQxCsN3tkBHR6x6VaNlsx5P
	 D547uy9VGy+ac4f5wDZHJcbtCDiSxubdj040CkVo=
Date: Wed, 07 Aug 2024 14:05:53 -0700
To: mm-commits@vger.kernel.org,qiwu.chen@transsion.com,elver@google.com,dvyukov@google.com,qiwuchen55@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-print-the-elapsed-time-for-allocated-freed-track.patch added to mm-unstable branch
Message-Id: <20240807210553.ED87AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kfence: print the elapsed time for allocated/freed track
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-print-the-elapsed-time-for-allocated-freed-track.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-print-the-elapsed-time-for-allocated-freed-track.patch

This patch will later appear in the mm-unstable branch at
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
From: "qiwu.chen" <qiwuchen55@gmail.com>
Subject: mm: kfence: print the elapsed time for allocated/freed track
Date: Wed, 7 Aug 2024 10:56:27 +0800

Print the elapsed time for the allocated or freed track, which can be
useful in some debugging scenarios.

Link: https://lkml.kernel.org/r/20240807025627.37419-1-qiwu.chen@transsion.com
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: chenqiwu <qiwu.chen@transsion.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/report.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/kfence/report.c~mm-kfence-print-the-elapsed-time-for-allocated-freed-track
+++ a/mm/kfence/report.c
@@ -16,6 +16,7 @@
 #include <linux/sprintf.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
+#include <linux/sched/clock.h>
 #include <trace/events/error_report.h>
 
 #include <asm/kfence.h>
@@ -108,11 +109,14 @@ static void kfence_print_stack(struct se
 	const struct kfence_track *track = show_alloc ? &meta->alloc_track : &meta->free_track;
 	u64 ts_sec = track->ts_nsec;
 	unsigned long rem_nsec = do_div(ts_sec, NSEC_PER_SEC);
+	u64 interval_nsec = local_clock() - meta->alloc_track.ts_nsec;
+	unsigned long rem_interval_nsec = do_div(interval_nsec, NSEC_PER_SEC);
 
 	/* Timestamp matches printk timestamp format. */
-	seq_con_printf(seq, "%s by task %d on cpu %d at %lu.%06lus:\n",
+	seq_con_printf(seq, "%s by task %d on cpu %d at %lu.%06lus (%lu.%06lus ago):\n",
 		       show_alloc ? "allocated" : "freed", track->pid,
-		       track->cpu, (unsigned long)ts_sec, rem_nsec / 1000);
+		       track->cpu, (unsigned long)ts_sec, rem_nsec / 1000,
+		       (unsigned long)interval_nsec, rem_interval_nsec / 1000);
 
 	if (track->num_stack_entries) {
 		/* Skip allocation/free internals stack. */
_

Patches currently in -mm which might be from qiwuchen55@gmail.com are

mm-kfence-print-the-elapsed-time-for-allocated-freed-track.patch

