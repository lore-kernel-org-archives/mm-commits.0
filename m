Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD62AECAAD2
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 23:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiIAXHD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 19:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiIAXHC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 19:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075C17C30A
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 16:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EEFC62013
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 23:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A2DC433D6;
        Thu,  1 Sep 2022 23:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662073618;
        bh=cLHD+cBfkMjBnaeRzzil5KMrtKmd4BzrP/sjiAopt3s=;
        h=Date:To:From:Subject:From;
        b=nT/RXrCHABo+CETfDsgkervwRk9X6u8entWcPte7F4II3FizNtLEhBADw+iWVU8OI
         cBJN9cXLWeUIH1gQHOefUSRqqa5xwwRySzA0Gn5q7IGz1kFuvo7HFhSk/4M6jTteeF
         tUQYBERg9+XtpBT/8WHGj2urUAo4Uu8vYxNLcwu0=
Date:   Thu, 01 Sep 2022 16:06:57 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, akpm@linux-foudation.org,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + profile-simplify-redundant-code-in-profile_setup.patch added to mm-nonmm-unstable branch
Message-Id: <20220901230657.E0A2DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/profile.c: simplify duplicated code in profile_setup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     profile-simplify-redundant-code-in-profile_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/profile-simplify-redundant-code-in-profile_setup.patch

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
From: wuchi <wuchi.zero@gmail.com>
Subject: kernel/profile.c: simplify duplicated code in profile_setup()
Date: Thu, 1 Sep 2022 08:31:21 +0800

The code to parse option string "schedule/sleep/kvm" of cmdline in
function profile_setup is redundant, so simplify that.

Link: https://lkml.kernel.org/r/20220901003121.53597-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/kernel/profile.c~profile-simplify-redundant-code-in-profile_setup
+++ a/kernel/profile.c
@@ -59,43 +59,39 @@ int profile_setup(char *str)
 	static const char schedstr[] = "schedule";
 	static const char sleepstr[] = "sleep";
 	static const char kvmstr[] = "kvm";
+	const char *select = NULL;
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
 #ifdef CONFIG_SCHEDSTATS
 		force_schedstat_enabled();
 		prof_on = SLEEP_PROFILING;
-		if (str[strlen(sleepstr)] == ',')
-			str += strlen(sleepstr) + 1;
-		if (get_option(&str, &par))
-			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
-		pr_info("kernel sleep profiling enabled (shift: %u)\n",
-			prof_shift);
+		select = sleepstr;
 #else
 		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
 		prof_on = SCHED_PROFILING;
-		if (str[strlen(schedstr)] == ',')
-			str += strlen(schedstr) + 1;
-		if (get_option(&str, &par))
-			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
-		pr_info("kernel schedule profiling enabled (shift: %u)\n",
-			prof_shift);
+		select = schedstr;
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
-		if (str[strlen(kvmstr)] == ',')
-			str += strlen(kvmstr) + 1;
-		if (get_option(&str, &par))
-			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
-		pr_info("kernel KVM profiling enabled (shift: %u)\n",
-			prof_shift);
+		select = kvmstr;
 	} else if (get_option(&str, &par)) {
 		prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
 		prof_on = CPU_PROFILING;
 		pr_info("kernel profiling enabled (shift: %u)\n",
 			prof_shift);
 	}
+
+	if (select) {
+		if (str[strlen(select)] == ',')
+			str += strlen(select) + 1;
+		if (get_option(&str, &par))
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel %s profiling enabled (shift: %u)\n",
+			select, prof_shift);
+	}
+
 	return 1;
 }
 __setup("profile=", profile_setup);
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
initramfs-mask-my_inptr-as-__initdata.patch
profile-simplify-redundant-code-in-profile_setup.patch

