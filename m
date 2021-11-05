Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0EFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E3E160720
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhKEUkD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUkC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C69C56056B;
        Fri,  5 Nov 2021 20:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144643;
        bh=fUsc17QLprrGYCLgQqWtflrIJ6wfV1kBZrogCaoSSp8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rh1TJFOTBRKkkVDF7U4M4smEMsZmkkNauyEZcfhUP13TjARtKIXt9/nkQgI129LgM
         reDWfYpubtHf9kL0q2vOpQUfIriZHeRFThUOePPLbwAVpDPBJZWs6ZCouRRZUxJjDS
         MGQyr/ExA34sfmlZ2o5K4+q3fkEI6Qlt02uFeRhE=
Date:   Fri, 05 Nov 2021 13:37:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aquini@redhat.com, hughd@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 052/262] mm/swapfile: fix an integer overflow in
 swap_show()
Message-ID: <20211105203722.TlSr_OQ9B%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
