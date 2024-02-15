Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C251420A8
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 22:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708036083; cv=none; b=bHA4aMmB19lDfNEm7Qwwm4VkZbvJAkWpwyDvKiVi9arX93KV9if0OI0VjKrph8wVsfEK+pYP7EFam/sljwuJpW8b7j/RegtXb3QZyKoR87nQpwtBiiX/t7uHvoL54RWbRpa9qqMGzRay02xk3COezjPbB4FsmWtUkkx3QIcChuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708036083; c=relaxed/simple;
	bh=sHkau0ak4JhBFwUqy5Gwhm7kYYHWKVRGooGAwdhh0zs=;
	h=Date:To:From:Subject:Message-Id; b=TvxMmIyXOU5oXDnFh48Hg/5zcvbofbRVOfCFJEeYGtpp2YVPluDuqxLOD4SfsC9XyECiUx/4E36Q1VUL5gKPvgRTRzLDlpQjF49H+U4id2aPdLNKlSVYSCLm1kvkJjM4L0GAoNx1gp4IUPDxN4OFJAyQsNZs9hWgoyRZ1vSri4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lE66+Rh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lE66+Rh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFE4C433F1;
	Thu, 15 Feb 2024 22:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708036083;
	bh=sHkau0ak4JhBFwUqy5Gwhm7kYYHWKVRGooGAwdhh0zs=;
	h=Date:To:From:Subject:From;
	b=lE66+Rh7zqjnhawvUFy32DFQD4zbX1tIrM54nLIjtwii/LhMmuyn+mID8OS0QBOzQ
	 /pI6KW6ytPSG0SSm+APS3sF5uhs1C1RzsyxaC3ov1w15DVnJBw25LBlbd6HfwTGSL9
	 EetqpQk5PH4q/un40E7q+69t7mUc9+7b4GIEKGcA=
Date: Thu, 15 Feb 2024 14:28:02 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,juntong.deng@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps.patch added to mm-unstable branch
Message-Id: <20240215222803.2DFE4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: increase the number of bits to shift when recording extra timestamps
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps.patch

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

kasan-increase-the-number-of-bits-to-shift-when-recording-extra-timestamps.patch

