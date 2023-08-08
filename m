Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D594AC001B0
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 19:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjHHTyX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbjHHTyB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 15:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8E46A70
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A103962461
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2C7C433C7;
        Tue,  8 Aug 2023 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691517882;
        bh=QEXxogf2rZfhnDwOldTjoIDOPlDZFXB1KTsPX7zXg1I=;
        h=Date:To:From:Subject:From;
        b=keWo6EkIyoRC9qleo/nkwFohO4JMr70wrw9vqh+QaFLs0DNyi6W6MvQxoCu3IECvK
         PcEj4jlvDXbrW6CG6clWGy9a4eK1c/hw7gxYj5vsqNVCeQ2nWETDgXlaIK4IFfO2Gv
         nxPvqLJ4Ik57srH0FyS3r6dE4T4oaFcyezoD/jR8=
Date:   Tue, 08 Aug 2023 11:04:41 -0700
To:     mm-commits@vger.kernel.org, joe@perches.com, jim.cromie@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-special-case-extern-struct-in-c.patch added to mm-nonmm-unstable branch
Message-Id: <20230808180441.ED2C7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: special case extern struct in .c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-special-case-extern-struct-in-c.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-special-case-extern-struct-in-c.patch

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
From: Jim Cromie <jim.cromie@gmail.com>
Subject: checkpatch: special case extern struct in .c
Date: Mon, 7 Aug 2023 21:30:18 -0600

"externs should be avoided in .c files" needs an exception for linker
symbols, like those that mark the start, stop of many kernel sections.

Since checkpatch already checks REALNAME to avoid looking at fragments
changing vmlinux.lds.h, add a new else-if block to look at them
instead.  As a simple heuristic, treat all words (in the patch-line)
as possible symbols, to screen later warnings.

For my test case, the possible-symbols included BOUNDED_BY (a macro),
which is extra, but not troublesome - these are just to screen
WARNINGS that might be issued on later fragments (changing .c files)

Where the WARN is issued, precede it with an else-if block to catch
one common extern-in-c use case: "extern struct foo bar[]".  Here we
can at least issue a softer warning, after checking for a match with a
maybe-linker-symbol parsed earlier from the patch.

Though heuristic, it worked for my test-case, allowing both start__,
stop__ $symbol's (wo the prefixes specifically named).  I've coded it
narrowly, it can be expanded later to cover any other expressions.

It does require that the externs in .c's have the additions to
vmlinux.lds.h in the same patch.  And requires vmlinux.lds.h before .c
fragments.

Link: https://lkml.kernel.org/r/20230808033019.21911-2-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-special-case-extern-struct-in-c
+++ a/scripts/checkpatch.pl
@@ -74,6 +74,8 @@ my $git_command ='export LANGUAGE=en_US.
 my $tabsize = 8;
 my ${CONFIG_} = "CONFIG_";
 
+my %maybe_linker_symbol; # for externs in c exceptions, when seen in *vmlinux.lds.h
+
 sub help {
 	my ($exitcode) = @_;
 
@@ -6051,6 +6053,9 @@ sub process {
 
 # check for line continuations outside of #defines, preprocessor #, and asm
 
+		} elsif ($realfile =~ m@/vmlinux.lds.h$@) {
+		    $line =~ s/(\w+)/$maybe_linker_symbol{$1}++/ge;
+		    #print "REAL: $realfile\nln: $line\nkeys:", sort keys %maybe_linker_symbol;
 		} else {
 			if ($prevline !~ /^..*\\$/ &&
 			    $line !~ /^\+\s*\#.*\\$/ &&		# preprocessor
@@ -7120,6 +7125,21 @@ sub process {
 			}
 
 		} elsif ($realfile =~ /\.c$/ && defined $stat &&
+		    $stat =~ /^\+extern struct\s+(\w+)\s+(\w+)\[\];/)
+		{
+			my ($st_type, $st_name) = ($1, $2);
+
+			for my $s (keys %maybe_linker_symbol) {
+			    #print "Linker symbol? $st_name : $s\n";
+			    goto LIKELY_LINKER_SYMBOL
+				if $st_name =~ /$s/;
+			}
+			WARN("AVOID_EXTERNS",
+			     "found a file-scoped extern type:$st_type name:$st_name in .c file\n"
+			     . "is this a linker symbol ?\n" . $herecurr);
+		  LIKELY_LINKER_SYMBOL:
+
+		} elsif ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*extern\s+/)
 		{
 			WARN("AVOID_EXTERNS",
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

checkpatch-special-case-extern-struct-in-c.patch
checkpatch-reword-long-line-warning-about-commit-msg.patch

