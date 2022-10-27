Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F312FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 19:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbiJ0TPw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiJ0TPs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 15:15:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA594622C
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 12:15:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E97CB827B1
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 19:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BFAC43143;
        Thu, 27 Oct 2022 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666898144;
        bh=k9gUCwu30OAGZgh2WkJUBfL8xqa3sxH2v/6b5F2QNOk=;
        h=Date:To:From:Subject:From;
        b=TcBHqfTKFLoMxpgYacPqQt1MwKG3fDUJSiWKJ3+qLHyDpvZoAYg/54qvtoIVa7d/c
         AD+rTQp3Dvj080a7PLsscHltKgdKjEYyrT/1QwT4OSWfkG/bj0UoMYEamw9giLz0bn
         Jx+oiJFW88Hw3oqBbrW7jeQqtE9WZSB90AK6N8gM=
Date:   Thu, 27 Oct 2022 12:15:43 -0700
To:     mm-commits@vger.kernel.org, joe@perches.com, stf_xl@wp.pl,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkpatch-allow-case-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20221027191544.98BFAC43143@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: checkpatch: allow "case" macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-checkpatch-allow-case-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-checkpatch-allow-case-macros.patch

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
From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: scripts: checkpatch: allow "case" macros
Date: Thu, 27 Oct 2022 15:43:34 +0200

Do not report errors like below:

./scripts/checkpatch.pl -f drivers/net/wireless/ath/ath10k/wmi.h

ERROR: Macros with complex values should be enclosed in parentheses
+#define C2S(x) case x: return #x

since many "case ..." macros are already used by some in-kernel drivers.

Link: https://lkml.kernel.org/r/20221027134334.164301-1-stf_xl@wp.pl
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~scripts-checkpatch-allow-case-macros
+++ a/scripts/checkpatch.pl
@@ -5918,6 +5918,7 @@ sub process {
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
 			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo
+			    $dstat !~ /^case\b/ &&					# case ...
 			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
 			    $dstat !~ /^while\s*$Constant\s*$Constant\s*$/ &&		# while (...) {...}
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
_

Patches currently in -mm which might be from stf_xl@wp.pl are

scripts-checkpatch-allow-case-macros.patch

