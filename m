Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D93C10F09
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441946AbjLGANc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441989AbjLGAN1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73F918D
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:31 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44975C433C9;
        Thu,  7 Dec 2023 00:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908011;
        bh=9WD1wAGYhjrCyk90QtJ4lOnF8ebhQSAKs5c17ysIlkA=;
        h=Date:To:From:Subject:From;
        b=MBRKJCGDEboozCgtr8DNmCHwdLGSPw8qwzOUoCQ3QzURe+hn1uKrXqkOUIqvpPx0w
         OClaf8X63RqEn9vBs1lZuNMFKbsr2OPRCWiwj4xPZwKXHHhz+OnXaqQZ3jBhyHDeiE
         fh+HkhC+nafa2yyau7wf9lL1ET0KbNqf//gM5E7w=
Date:   Wed, 06 Dec 2023 16:13:30 -0800
To:     mm-commits@vger.kernel.org, v.narang@samsung.com,
        stable@vger.kernel.org, masahiroy@kernel.org,
        maninder1.s@samsung.com, hca@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] checkstack-fix-printed-address.patch removed from -mm tree
Message-Id: <20231207001331.44975C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkstack: fix printed address
has been removed from the -mm tree.  Its filename was
     checkstack-fix-printed-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: checkstack: fix printed address
Date: Mon, 20 Nov 2023 19:37:17 +0100

All addresses printed by checkstack have an extra incorrect 0 appended at
the end.

This was introduced with commit 677f1410e058 ("scripts/checkstack.pl: don't
display $dre as different entity"): since then the address is taken from
the line which contains the function name, instead of the line which
contains stack consumption. E.g. on s390:

0000000000100a30 <do_one_initcall>:
...
  100a44:       e3 f0 ff 70 ff 71       lay     %r15,-144(%r15)

So the used regex which matches spaces and hexadecimal numbers to extract
an address now matches a different substring. Subsequently replacing spaces
with 0 appends a zero at the and, instead of replacing leading spaces.

Fix this by using the proper regex, and simplify the code a bit.

Link: https://lkml.kernel.org/r/20231120183719.2188479-2-hca@linux.ibm.com
Fixes: 677f1410e058 ("scripts/checkstack.pl: don't display $dre as different entity")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vaneet Narang <v.narang@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/scripts/checkstack.pl~checkstack-fix-printed-address
+++ a/scripts/checkstack.pl
@@ -139,15 +139,11 @@ $total_size = 0;
 while (my $line = <STDIN>) {
 	if ($line =~ m/$funcre/) {
 		$func = $1;
-		next if $line !~ m/^($xs*)/;
+		next if $line !~ m/^($x*)/;
 		if ($total_size > $min_stack) {
 			push @stack, "$intro$total_size\n";
 		}
-
-		$addr = $1;
-		$addr =~ s/ /0/g;
-		$addr = "0x$addr";
-
+		$addr = "0x$1";
 		$intro = "$addr $func [$file]:";
 		my $padlen = 56 - length($intro);
 		while ($padlen > 0) {
_

Patches currently in -mm which might be from hca@linux.ibm.com are

arch-remove-arch_thread_stack_allocator.patch
arch-remove-arch_task_struct_allocator.patch
arch-remove-arch_task_struct_on_stack.patch
checkstack-sort-output-by-size-and-function-name.patch
checkstack-allow-to-pass-minstacksize-parameter.patch

