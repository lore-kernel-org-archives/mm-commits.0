Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5C6CCA47B
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 19:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241536AbiFMTSO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346756AbiFMTRh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 15:17:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9802F652
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 10:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D42F2B81186
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 17:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781DAC34114;
        Mon, 13 Jun 2022 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655140450;
        bh=/+TsM7CS3qnrSWbBqrrtiIDbjqThVpqEFS8stjfp6T8=;
        h=Date:To:From:Subject:From;
        b=UB/uCzKJNSyR30o2T7GaxLNkWuMzI5/gsVm4DkhTKJelD/IVTwYGA6iTBrdWHNQ2u
         0ts3CDxXRwoudQAqo/oVytFvy3ls4PfR2KQeuqEmoVoJ0i9mqpnzsHsxtSm5noZGNM
         HB2+Lk5aZd1qEXYGuI0iDsww8y6Xw9ktn3BLcPHE=
Date:   Mon, 13 Jun 2022 10:14:09 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        borneo.antonio@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant.patch added to mm-nonmm-unstable branch
Message-Id: <20220613171410.781DAC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix incorrect camelcase detection on numeric constant
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant.patch

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
From: Antonio Borneo <borneo.antonio@gmail.com>
Subject: checkpatch: fix incorrect camelcase detection on numeric constant
Date: Mon, 13 Jun 2022 12:00:55 +0200

The code fragment below

	int foo(int *array, int index)
	{
		return array[index & 0xFF];
	}

triggers an incorrect camelcase detection by checking a substring of the
hex constant:

	CHECK: Avoid CamelCase: <xFF>
	#3: FILE: test.c:3:
	+	return array[index & 0xFF];

This is caused by passing the whole string "array[index & 0xFF]" to the
inner loop that iterates over a "$Ident" match.  The numeric constant is
not a $Ident as it doesn't start with [A-Za-z_] and should be excluded
from the match.

Similar issue can be detected with other constants like "1uL", "0xffffU".

Force the match to start at word boundary so the $Ident will be properly
checked starting from its first char and the constants will be
filtered-out.

Link: https://lkml.kernel.org/r/20220613100055.77821-1-borneo.antonio@gmail.com
Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant
+++ a/scripts/checkpatch.pl
@@ -5721,7 +5721,7 @@ sub process {
 			    $var !~ /^(?:[a-z0-9_]*|[A-Z0-9_]*)?_?[a-z][A-Z](?:_[a-z0-9_]+|_[A-Z0-9_]+)?$/ &&
 #Ignore some three character SI units explicitly, like MiB and KHz
 			    $var !~ /^(?:[a-z_]*?)_?(?:[KMGT]iB|[KMGT]?Hz)(?:_[a-z_]+)?$/) {
-				while ($var =~ m{($Ident)}g) {
+				while ($var =~ m{\b($Ident)}g) {
 					my $word = $1;
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
 					if ($check) {
_

Patches currently in -mm which might be from borneo.antonio@gmail.com are

checkpatch-fix-incorrect-camelcase-detection-on-numeric-constant.patch

