Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4A5C43331
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42B2964F14
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhB0Cdj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhB0CdD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EACD64F13;
        Sat, 27 Feb 2021 02:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393151;
        bh=/zc+Kf3B0CT19EYm+E5YS07JlHZksv+KRBoWXeTzCcw=;
        h=Date:From:To:Subject:From;
        b=Xt+zJAweV7YjK/QSaL91Ka/IMa2bx8e3rsBPmT+GDdyogsptIBGqDgOsid7Di/+JA
         FLfKa+H3wDJkwG1iHwkSPf0rREVUVbU3rVBfEFKIJDw4NIuwN45Ch7GxeK6M3Q4CAj
         IsDX+0KHuZhzxDQbc+ojojl8p/68kxlP8dqBe+MA=
Date:   Fri, 26 Feb 2021 18:32:31 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org, songliubraving@fb.com
Subject:  [merged]
 checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs.patch
 removed from -mm tree
Message-ID: <20210227023231.YlWPg3Bbi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: do not apply "initialise globals to 0" check to BPF progs
has been removed from the -mm tree.  Its filename was
     checkpatch-do-not-apply-initialise-globals-to-0-check-to-bpf-progs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from songliubraving@fb.com are


