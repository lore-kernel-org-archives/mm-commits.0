Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7175DC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA84611C5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347859AbhIIVHE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346632AbhIIVGt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83D2B61186;
        Thu,  9 Sep 2021 21:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221539;
        bh=2Qnv6FGFFGo7kbra5ckHNJzoNjedpCevul9t8E3eivs=;
        h=Date:From:To:Subject:From;
        b=ghtiHfVA93zGEUFRI9ileKUVaq25VA7XQCZ871kC4UPkdHD2f3xWC+oLPtMoocVsy
         cdIQ+3hRdvld2G8DoYLvL72ydIB2VhUTCHu6VzpP77VHC1NF3ZqJ8XOudMbutA1VF9
         d0P/Xyi0pDK46x/ju2ZGsxcgCMyqZuVtp1Yxy1Tw=
Date:   Thu, 09 Sep 2021 14:05:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, quentin.casasnovas@oracle.com,
        rdunlap@infradead.org
Subject:  [merged]
 scripts-check_extable-fix-typo-in-user-error-message.patch removed from -mm
 tree
Message-ID: <20210909210539.wOj56v2q5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: check_extable: fix typo in user error message
has been removed from the -mm tree.  Its filename was
     scripts-check_extable-fix-typo-in-user-error-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


