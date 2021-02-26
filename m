Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B816C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F0364F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZBX0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhBZBWu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A25D964F1A;
        Fri, 26 Feb 2021 01:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302529;
        bh=MM4I6H40qqg7fp2p+asungIUj0TbK4OK2ow2x3jlkbY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i2JN1DE47WALl/Ao77f5UDBkHbiNVAGnplbpbUB77aNFy271W11fcGxTTAO1j0Iac
         9X2vSjeQCPECidG4U7Y3gfZIzO8hfQdZMiuXf2E2bkcdg01xxtaj8+cWF0zI9JBLmS
         0lgaXjoa1sLGzSMkYV9mhol916nx/7aG+pKkux9g=
Date:   Thu, 25 Feb 2021 17:22:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        torvalds@linux-foundation.org
Subject:  [patch 107/118] checkpatch: do not apply "initialise
 globals to 0" check to BPF progs
Message-ID: <20210226012208.MXxMP4kfE%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
 
@@ -4358,7 +4367,8 @@ sub process {
 		}
 
 # check for global initialisers.
-		if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*($zero_initializer)\s*;/) {
+		if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*($zero_initializer)\s*;/ &&
+		    !exclude_global_initialisers($realfile)) {
 			if (ERROR("GLOBAL_INITIALISERS",
 				  "do not initialise globals to $1\n" . $herecurr) &&
 			    $fix) {
_
