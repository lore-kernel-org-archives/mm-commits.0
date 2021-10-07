Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E18FC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 00:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666F061038
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 00:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhJGAxi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 20:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhJGAxi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 20:53:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E6160184;
        Thu,  7 Oct 2021 00:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633567905;
        bh=4l2ZSDFnpQf4rd3IY9loGmiq86t+nyhZsJjehOSjy5w=;
        h=Date:From:To:Subject:From;
        b=MFXO8XbHokQaBxa4KwI9Gx6MvYDBtwR+dKT55AfarajXhe3/zEUl+0RScqPTN5Zg+
         SxsT3Pa1CmvvX1MEohcKYOipG010c6PzKvud8tU7dpQkYSnYK9VmTJ5yEN9GK1XDvj
         ZQFlxlhvgUZBw1h7CmcfcK/KNOK71u0EguLFdPOo=
Date:   Wed, 06 Oct 2021 17:51:44 -0700
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, hughd@google.com, mm-commits@vger.kernel.org
Subject:  + mm-swapfile-fix-an-integer-overflow-in-swap_show.patch
 added to -mm tree
Message-ID: <20211007005144.kEBOrbud-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: fix an integer overflow in swap_show()
has been added to the -mm tree.  Its filename is
     mm-swapfile-fix-an-integer-overflow-in-swap_show.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-fix-an-integer-overflow-in-swap_show.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-fix-an-integer-overflow-in-swap_show.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm/swapfile: fix an integer overflow in swap_show()

This one is just a minor nuisance for people going through /proc/swaps if
any of their swapareas is bigger than, or equal to 1073741824 pages (4TB).

seq_printf() format string casts as uint the conversion from pages to KB,
and that will overflow in the aforementioned case.

Albeit being almost unthinkable that someone would actually set up such
big of a single swaparea, there is a ticket recently filed against RHEL:
https://bugzilla.redhat.com/show_bug.cgi?id=2008812

Given that all other codesites that use format strings for the same swap
pages-to-KB conversion do cast it as ulong, this patch just follows suit.

Link: https://lkml.kernel.org/r/20211006184011.2579054-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-an-integer-overflow-in-swap_show
+++ a/mm/swapfile.c
@@ -2763,7 +2763,7 @@ static int swap_show(struct seq_file *sw
 	struct swap_info_struct *si = v;
 	struct file *file;
 	int len;
-	unsigned int bytes, inuse;
+	unsigned long bytes, inuse;
 
 	if (si == SEQ_START_TOKEN) {
 		seq_puts(swap, "Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
@@ -2775,7 +2775,7 @@ static int swap_show(struct seq_file *sw
 
 	file = si->swap_file;
 	len = seq_file_path(swap, file, " \t\n\\");
-	seq_printf(swap, "%*s%s\t%u\t%s%u\t%s%d\n",
+	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
 			S_ISBLK(file_inode(file)->i_mode) ?
 				"partition" : "file\t",
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-swapfile-fix-an-integer-overflow-in-swap_show.patch

