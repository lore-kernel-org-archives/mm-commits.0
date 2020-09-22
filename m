Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9442CC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F61B239D4
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600798864;
	bh=6APQlkpkZJtBQ4OxPEtHQk7Apfkbr3BP2wWbQVj7Gyg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=x7/VBMzQduC1WwWg/otfMmdpIsvDIJfrbSLFpAqs6t1AKOymzR6F8grTt/zkXPXuY
	 1lTJMQL1jSiJAbijakhFLDXH4ImgCWy8omzIfEsSRgMQyo8nPgC6TUIMMCwX94Ygtg
	 9AhAeaKiPS8CTLxQepywXbya6b/vWQKTIjnQ2L7g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIVSVE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 14:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVSVD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 14:21:03 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DE9E207C3;
        Tue, 22 Sep 2020 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600798863;
        bh=6APQlkpkZJtBQ4OxPEtHQk7Apfkbr3BP2wWbQVj7Gyg=;
        h=Date:From:To:Subject:From;
        b=0OQQganp0GYye/OZCtVRXVZ1dW3Ck6HBYHKhXpRZnCh3s3Lsj8HekeKrn9l/HPa87
         0cN78vo0pvgRksfxDSAGkvl67t0NFobp96ely00B9QuuaMrhoBLWpPGHGrYtPY8/mN
         wJrcpzK3TFWtwHtI2YCig/xTddnFQeky9AoW4pus=
Date:   Tue, 22 Sep 2020 11:21:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, julia.lawall@inria.fr, joe@perches.com
Subject:  +
 checkpatch-allow-not-using-f-with-files-that-are-in-git-fix.patch added to
 -mm tree
Message-ID: <20200922182102.X80YU%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix git "fatal" warning if file argument outside kernel tree
has been added to the -mm tree.  Its filename is
     checkpatch-allow-not-using-f-with-files-that-are-in-git-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-not-using-f-with-files-that-are-in-git-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-not-using-f-with-files-that-are-in-git-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix git "fatal" warning if file argument outside kernel tree

commit bcf4271d4bc3 ("checkpatch: allow not using -f with files that are
in git") in linux-next causes checkpatch to emit a fatal message:

fatal: <file>: '<file>' is outside repository at '<kernel_dir>'

Fix that by sending git's error output to /dev/null instead.

Link: https://lkml.kernel.org/r/b6afa04112d450c2fc120a308d706acd60cee294.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Reviewed-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-allow-not-using-f-with-files-that-are-in-git-fix
+++ a/scripts/checkpatch.pl
@@ -981,7 +981,7 @@ sub git_is_single_file {
 
 	return 0 if ((which("git") eq "") || !(-e "$gitroot"));
 
-	my $output = `${git_command} ls-files -- $filename`;
+	my $output = `${git_command} ls-files -- $filename 2>/dev/null`;
 	my $count = $output =~ tr/\n//;
 	return $count eq 1 && $output =~ m{^${filename}$};
 }
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
get_maintainer-add-test-for-file-in-vcs.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch
checkpatch-warn-on-self-assignments.patch
checkpatch-allow-not-using-f-with-files-that-are-in-git.patch
checkpatch-allow-not-using-f-with-files-that-are-in-git-fix.patch

