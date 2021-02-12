Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CE8C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDBA064DDF
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhBLATa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 19:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBLAT1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 19:19:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A7E64DD5;
        Fri, 12 Feb 2021 00:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613089126;
        bh=KP6PvI8Y6PJeXZbFPlczKNVT9MN8wGE/Hhui6sKKuLE=;
        h=Date:From:To:Subject:From;
        b=s4mLt/JPHzXkb/qmOT9bPao1D8VjBkktOIaVn2D0Lk6J6QW6rjy1k+UcLeBs5em3Y
         3/llsAy1ggXMUd1SmDVyElfQzq4CMqPKZrgUA/uEXAFZrvDjXUjcJD64mrUCjguNXx
         Ydlx3a7GrWSMJLdWYtMtwyRAzB0Q5MBn1+9f9Dgg=
Date:   Thu, 11 Feb 2021 16:18:46 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com, songliubraving@fb.com
Subject:  +
 checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs.patch
 added to -mm tree
Message-ID: <20210212001846.N_2Mi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: do not apply "initialise globals to 0" check to BPF progs
has been added to the -mm tree.  Its filename is
     checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Song Liu <songliubraving@fb.com>
Subject: checkpatch: do not apply "initialise globals to 0" check to BPF progs

BPF programs explicitly initialise global variables to 0 to make sure
clang (v10 or older) do not put the variables in the common section.  Skip
"initialise globals to 0" check for BPF programs to elimiate error
messages like:

    ERROR: do not initialise globals to 0
    #19: FILE: samples/bpf/tracex1_kern.c:21:

Link: https://lkml.kernel.org/r/20210209211954.490077-1-songliubraving@fb.com
Signed-off-by: Song Liu <songliubraving@fb.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs
+++ a/scripts/checkpatch.pl
@@ -2453,6 +2453,15 @@ sub get_raw_comment {
 	return $comment;
 }
 
+sub exclude_global_initialisers {
+	my ($realfile) = @_;
+
+	# Do not check for BPF programs (tools/testing/selftests/bpf/progs/*.c, samples/bpf/*_kern.c, *.bpf.c).
+	return $realfile =~ m@^tools/testing/selftests/bpf/progs/.*\.c$@ ||
+		$realfile =~ m@^samples/bpf/.*_kern\.c$@ ||
+		$realfile =~ m@/bpf/.*\.bpf\.c$@;
+}
+
 sub process {
 	my $filename = shift;
 
@@ -4360,7 +4369,8 @@ sub process {
 		}
 
 # check for global initialisers.
-		if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*($zero_initializer)\s*;/) {
+		if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*($zero_initializer)\s*;/ &&
+		    !exclude_global_initialisers($realfile)) {
 			if (ERROR("GLOBAL_INITIALISERS",
 				  "do not initialise globals to $1\n" . $herecurr) &&
 			    $fix) {
_

Patches currently in -mm which might be from songliubraving@fb.com are

checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs.patch

