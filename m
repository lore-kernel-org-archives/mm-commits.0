Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24130C2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjKTSqN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjKTSqN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:46:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B05C9
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:46:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF01C433C7;
        Mon, 20 Nov 2023 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700505969;
        bh=r/kSYhcxbHOYlZOdvalEV2HjpQvPmf0wbxtavbWfiXg=;
        h=Date:To:From:Subject:From;
        b=Ptv6C8Uhgoe1dQwZIqPchDwXK6vqH92wC8V7UE449Q+2cHLYJnLf1XDolhV5+N5H5
         0iLsPY8zp3fPlm3yOkgc7rmYZxQVWqXE54UJLqWBOhyGcTEN3JUYmAV4hdXP+KAvvH
         PUNoSV3dlJWbgeMyE3/pPZo2Sl6Nien2NnZ49yCE=
Date:   Mon, 20 Nov 2023 10:46:08 -0800
To:     mm-commits@vger.kernel.org, v.narang@samsung.com,
        masahiroy@kernel.org, maninder1.s@samsung.com, hca@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkstack-sort-output-by-size-and-function-name.patch added to mm-nonmm-unstable branch
Message-Id: <20231120184608.DAF01C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkstack: sort output by size and function name
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkstack-sort-output-by-size-and-function-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkstack-sort-output-by-size-and-function-name.patch

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
From: Heiko Carstens <hca@linux.ibm.com>
Subject: checkstack: sort output by size and function name
Date: Mon, 20 Nov 2023 19:37:18 +0100

Sort output by size and in addition by function name.  This increases
readability for cases where there are many functions with the same stack
usage.

Link: https://lkml.kernel.org/r/20231120183719.2188479-3-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/scripts/checkstack.pl~checkstack-sort-output-by-size-and-function-name
+++ a/scripts/checkstack.pl
@@ -190,5 +190,20 @@ if ($total_size > $min_stack) {
 	push @stack, "$intro$total_size\n";
 }
 
-# Sort output by size (last field)
-print sort { ($b =~ /:\t*(\d+)$/)[0] <=> ($a =~ /:\t*(\d+)$/)[0] } @stack;
+# Sort output by size (last field) and function name if size is the same
+sub sort_lines {
+	my ($a, $b) = @_;
+
+	my $num_a = $1 if $a =~ /:\t*(\d+)$/;
+	my $num_b = $1 if $b =~ /:\t*(\d+)$/;
+	my $func_a = $1 if $a =~ / (.*):/;
+	my $func_b = $1 if $b =~ / (.*):/;
+
+	if ($num_a != $num_b) {
+		return $num_b <=> $num_a;
+	} else {
+		return $func_a cmp $func_b;
+	}
+}
+
+print sort { sort_lines($a, $b) } @stack;
_

Patches currently in -mm which might be from hca@linux.ibm.com are

checkstack-fix-printed-address.patch
arch-remove-arch_thread_stack_allocator.patch
arch-remove-arch_task_struct_allocator.patch
arch-remove-arch_task_struct_on_stack.patch
checkstack-sort-output-by-size-and-function-name.patch
checkstack-allow-to-pass-minstacksize-parameter.patch

