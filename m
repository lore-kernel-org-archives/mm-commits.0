Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9DEC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA99C611CC
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345878AbhIIVGE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348104AbhIIVFR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74FA6611BD;
        Thu,  9 Sep 2021 21:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221443;
        bh=Y5E/juNKZJPrhp9ZqWx2L8hnF0yDWZna+wCLLWrOqXs=;
        h=Date:From:To:Subject:From;
        b=Q1PQdCFWRMhWOLtNMsPyUu8xu7S2mlXWr96m+AJP1iV6gqtHZSB/SDsXwqRMd+aTv
         o5j4w2DlGCpYaKCyqaMeHixbF43iHJRakmfIa29U6zX1VkUKwU6CdqF+vwoWE5GzBm
         Kl7gtsprqRqerZ03OL3qRhLbiWoYvx0KmF0eEeJg=
Date:   Thu, 09 Sep 2021 14:04:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, paskripkin@gmail.com,
        penguin-kernel@i-love.sakura.ne.jp, rostedt@goodmis.org,
        tglx@linutronix.de
Subject:  [merged] profiling-fix-shift-out-of-bounds-bugs.patch
 removed from -mm tree
Message-ID: <20210909210403.KvBBvnv5i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: profiling: fix shift-out-of-bounds bugs
has been removed from the -mm tree.  Its filename was
     profiling-fix-shift-out-of-bounds-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Skripkin <paskripkin@gmail.com>
Subject: profiling: fix shift-out-of-bounds bugs

Syzbot reported shift-out-of-bounds bug in profile_init().
The problem was in incorrect prof_shift. Since prof_shift value comes from
userspace we need to clamp this value into [0, BITS_PER_LONG -1]
boundaries.

Second possible shiht-out-of-bounds was found by Tetsuo:
sample_step local variable in read_profile() had "unsigned int" type,
but prof_shift allows to make a BITS_PER_LONG shift. So, to prevent
possible shiht-out-of-bounds sample_step type was changed to
"unsigned long".

Also, "unsigned short int" will be sufficient for storing
[0, BITS_PER_LONG] value, that's why there is no need for
"unsigned long" prof_shift.

Link: https://lkml.kernel.org/r/20210813140022.5011-1-paskripkin@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+e68c89a9510c159d9684@syzkaller.appspotmail.com
Suggested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/kernel/profile.c~profiling-fix-shift-out-of-bounds-bugs
+++ a/kernel/profile.c
@@ -41,7 +41,8 @@ struct profile_hit {
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
 static atomic_t *prof_buffer;
-static unsigned long prof_len, prof_shift;
+static unsigned long prof_len;
+static unsigned short int prof_shift;
 
 int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
@@ -67,8 +68,8 @@ int profile_setup(char *str)
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel sleep profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel sleep profiling enabled (shift: %u)\n",
 			prof_shift);
 #else
 		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
@@ -78,21 +79,21 @@ int profile_setup(char *str)
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel schedule profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel schedule profiling enabled (shift: %u)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel KVM profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel KVM profiling enabled (shift: %u)\n",
 			prof_shift);
 	} else if (get_option(&str, &par)) {
-		prof_shift = par;
+		prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
 		prof_on = CPU_PROFILING;
-		pr_info("kernel profiling enabled (shift: %ld)\n",
+		pr_info("kernel profiling enabled (shift: %u)\n",
 			prof_shift);
 	}
 	return 1;
@@ -468,7 +469,7 @@ read_profile(struct file *file, char __u
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned int sample_step = 1 << prof_shift;
+	unsigned long sample_step = 1UL << prof_shift;
 
 	profile_flip_buffers();
 	if (p >= (prof_len+1)*sizeof(unsigned int))
_

Patches currently in -mm which might be from paskripkin@gmail.com are


