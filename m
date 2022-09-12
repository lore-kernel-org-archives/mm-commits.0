Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96C0ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiILE6g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiILE5F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1E128720
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37261B80BA9
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA998C433D7;
        Mon, 12 Sep 2022 04:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958622;
        bh=yjC9bNZiC3GNLIdg2RT4gkEcBxo5D/xeNm/tsFCE0Yk=;
        h=Date:To:From:Subject:From;
        b=NFwsfyY/wKE3dkgQa0HNykiUlkhAfbNJEp2Hub1hhBfoeebQtHlfX/4gCmpaH8oRY
         m3ziH81o0o77mUwbe0En9MOWUjA7/Vg4gvMuRiXUAdoq7tpAxyNgup+g7U6swFojMx
         HZQKOxJqxBu97U4IkitI6zFO8TeOV9AYlrrl/a2Q=
Date:   Sun, 11 Sep 2022 21:57:02 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, akpm@linux-foudation.org,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] profile-simplify-redundant-code-in-profile_setup.patch removed from -mm tree
Message-Id: <20220912045702.CA998C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/profile.c: simplify duplicated code in profile_setup()
has been removed from the -mm tree.  Its filename was
     profile-simplify-redundant-code-in-profile_setup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch

