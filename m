Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C054CC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbjDFCya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbjDFCxd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA70B7
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 374C164229
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9042FC433D2;
        Thu,  6 Apr 2023 02:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749594;
        bh=8z9QSABfUnpqyho0q5Cg4IYtoliYRjHmgc4R+AZCSwM=;
        h=Date:To:From:Subject:From;
        b=rSMq/UJ44iMKio8Ezp0geWXH64eljhR90VW8tXOj4CtyTH9PAXyySzZ/jH0ukDoOC
         +bHSbupjDIvX3fXjBoarLJmWyhugGsP6NsOG7jgUvxyD4qPuiiS8VWa3mTwAjsJRaA
         qbmn/H6FxVrod8a+KwjjRaYLR/r9+JF6/70cZvUc=
Date:   Wed, 05 Apr 2023 19:53:14 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch removed from -mm tree
Message-Id: <20230406025314.9042FC433D2@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
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


