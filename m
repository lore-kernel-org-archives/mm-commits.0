Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9079C54FB9
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346174AbjKQRiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbjKQRis (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:38:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13354D7A
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:38:45 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8A7C433C7;
        Fri, 17 Nov 2023 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242724;
        bh=tnWOOtIlJCQCWEzHSI75ybCg/dbivfrkcEaZgjMJCpk=;
        h=Date:To:From:Subject:From;
        b=2NmqQDsTAxS6tCQ5ZRRZHqm6leP8wZogt7oVOfwLfV+JvYemP9mk5Ncr8nOCJiSNE
         yb6JiNbM1W1mile2guvDYoo9cC9eZpXQqmR1W7v94OuOkq2xQ2/H+33LuO3HoMkWZz
         zss2XQTunlrRRfsaWEWkSS0Ii55qNNfVRzlpuaYI=
Date:   Fri, 17 Nov 2023 09:38:44 -0800
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        jim.cromie@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-add-checksum-to-backtrace-report.patch added to mm-unstable branch
Message-Id: <20231117173844.9F8A7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: add checksum to backtrace report
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-add-checksum-to-backtrace-report.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-add-checksum-to-backtrace-report.patch

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
From: Jim Cromie <jim.cromie@gmail.com>
Subject: kmemleak: add checksum to backtrace report
Date: Thu, 16 Nov 2023 15:43:18 -0700

Change /sys/kernel/debug/kmemleak report format slightly, adding
"(extra info)" to the backtrace header:

from: "  backtrace:"
to:   "  backtrace (crc <cksum>):"

The <cksum> allows a user to see recurring backtraces without
detailed/careful reading of multiline stacks.  So after cycling
kmemleak-test a few times, I know some leaks are repeating.

  bash-5.2# grep backtrace /sys/kernel/debug/kmemleak | wc
     62     186    1792
  bash-5.2# grep backtrace /sys/kernel/debug/kmemleak | sort -u | wc
     37     111    1067

syzkaller parses kmemleak for "unreferenced object" only, so is
unaffected by this change.  Other github repos are moribund.

Link: https://lkml.kernel.org/r/20231116224318.124209-3-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~kmemleak-add-checksum-to-backtrace-report
+++ a/mm/kmemleak.c
@@ -362,7 +362,7 @@ static void print_unreferenced(struct se
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 			   object->comm, object->pid, object->jiffies);
 	hex_dump_object(seq, object);
-	warn_or_seq_printf(seq, "  backtrace:\n");
+	warn_or_seq_printf(seq, "  backtrace (crc %x):\n", object->checksum);
 
 	for (i = 0; i < nr_entries; i++) {
 		void *ptr = (void *)entries[i];
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

kmemleak-drop-age-increasing-from-leak-record.patch
kmemleak-add-checksum-to-backtrace-report.patch

