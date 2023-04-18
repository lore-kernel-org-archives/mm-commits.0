Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA39EC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjDRXlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjDRXlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195E0196
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD3B663020
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DE9C433D2;
        Tue, 18 Apr 2023 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861212;
        bh=XxvhQdmjb6m7aRlteHWlVNKkKHGFFPsBeDsnMth68pg=;
        h=Date:To:From:Subject:From;
        b=V+FvyqUVfGELAGUOwHJPQkRpZG1CuJM3kiy58DfaPfJejKeid4a/8hmxkmfHtfFrg
         MVGqNouI+df6gAffW1crJDPKC7py+DQjlZJE2zRd+BYvlfJwm5z9bv8w0eg0IOLEmp
         lK7qW6xrI8pU3SyRjyJNiixcnMo7tXpNH24lsQW4=
Date:   Tue, 18 Apr 2023 16:40:11 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, f.fainelli@gmail.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch removed from -mm tree
Message-Id: <20230418234012.08DE9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix lx-timerlist for HRTIMER_MAX_CLOCK_BASES printing
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Liu <liupeng17@lenovo.com>
Subject: scripts/gdb: fix lx-timerlist for HRTIMER_MAX_CLOCK_BASES printing
Date: Tue, 21 Mar 2023 14:20:04 +0800

HRTIMER_MAX_CLOCK_BASES is of enum type hrtimer_base_type.  To print it as
an integer, HRTIMER_MAX_CLOCK_BASES should be converted first.

Link: https://lkml.kernel.org/r/TYCP286MB214640FF0E7F04AC3926A39EC6819@TYCP286MB2146.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing
+++ a/scripts/gdb/linux/timerlist.py
@@ -188,7 +188,8 @@ class LxTimerList(gdb.Command):
         max_clock_bases = gdb.parse_and_eval("HRTIMER_MAX_CLOCK_BASES")
 
         text = "Timer List Version: gdb scripts\n"
-        text += "HRTIMER_MAX_CLOCK_BASES: {}\n".format(max_clock_bases)
+        text += "HRTIMER_MAX_CLOCK_BASES: {}\n".format(
+            max_clock_bases.type.fields()[max_clock_bases].enumval)
         text += "now at {} nsecs\n".format(ktime_get())
 
         for cpu in cpus.each_online_cpu():
_

Patches currently in -mm which might be from liupeng17@lenovo.com are


