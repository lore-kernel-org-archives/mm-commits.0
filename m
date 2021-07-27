Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465ECC43216
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BAC260FC2
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhG0VKB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235874AbhG0VJ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 17:09:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B339F60F90;
        Tue, 27 Jul 2021 21:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627420196;
        bh=S7JZkOj/2q5Rv6y/ceVUnF9oRuMjwPPlfVC+Tqnh3ik=;
        h=Date:From:To:Subject:From;
        b=cbgQYUt5ljMSo6zhAM6hL8mtZmil+qoJgjR3elXnRPd5Cqi3jcXrsELF5zR9yQb0P
         EmypODpNGZMjILGxuSM3kJxpVVcIWYib8eDhinjzacNEbgiZBlnwDffIHQjzKrOZiU
         OgFWw+OuOwzEwG2HrrTc6Ct3YMw8gCIyMARZZ4m4=
Date:   Tue, 27 Jul 2021 14:09:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, quentin.casasnovas@oracle.com,
        rdunlap@infradead.org
Subject:  +
 scripts-check_extable-fix-typo-in-user-error-message.patch added to -mm tree
Message-ID: <20210727210954.AOABT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: check_extable: fix typo in user error message
has been added to the -mm tree.  Its filename is
     scripts-check_extable-fix-typo-in-user-error-message.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-check_extable-fix-typo-in-user-error-message.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-check_extable-fix-typo-in-user-error-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: scripts: check_extable: fix typo in user error message

Fix typo ("and" should be "an") in an error message.

Link: https://lkml.kernel.org/r/20210727002943.29774-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/check_extable.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/check_extable.sh~scripts-check_extable-fix-typo-in-user-error-message
+++ a/scripts/check_extable.sh
@@ -4,7 +4,7 @@
 
 obj=$1
 
-file ${obj} | grep -q ELF || (echo "${obj} is not and ELF file." 1>&2 ; exit 0)
+file ${obj} | grep -q ELF || (echo "${obj} is not an ELF file." 1>&2 ; exit 0)
 
 # Bail out early if there isn't an __ex_table section in this object file.
 objdump -hj __ex_table ${obj} 2> /dev/null > /dev/null
_

Patches currently in -mm which might be from rdunlap@infradead.org are

scripts-check_extable-fix-typo-in-user-error-message.patch
scripts-checkversion-modernize-linux-versionh-search-strings.patch

