Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A79C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0A72186A
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689034;
	bh=Ky8jW70FJV2esHBte0wcPBr3pIgdg4vZannmnojYHHc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fS6Y0g0mF+/GWkMGe1V2Pj2jDs294645FyPP8FOcI+fdKL2DWSjebF0IY0RtzBeSU
	 +xEAGp1nBbMzquNFFRPXEbL/zO2cnbOfs6mCESr7Bn00MzoMbLMSZNL0rRiibdt6Su
	 TEI737fK7MLYt+r7/Y1ZCYgtIf743+KPo/OQ4weA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgGNBKe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgGNBKe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:10:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C367E21841;
        Tue, 14 Jul 2020 01:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689033;
        bh=Ky8jW70FJV2esHBte0wcPBr3pIgdg4vZannmnojYHHc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qScH5+ZngemFZyxBlyULnUgzfrzau0a4v8+p4/dJaCgueR7aUH/3dQZ3xrdvy+m9V
         oDvuTfJc7mT+f6uS8Zxih7IeALkMFk1926DJmQx4KYgW4zcW1qjsZ6aT58cxrlr7yi
         9nB1xnA8UeWYhWzcELSj5kEXm+tj6/FcwgPSQEm0=
Date:   Mon, 13 Jul 2020 18:10:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     apw@canonical.com, colin.king@canonical.com, corbet@lwn.net,
        dan.j.williams@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, jslaby@suse.cz, mishi@linux.com,
        mm-commits@vger.kernel.org, sj38.park@gmail.com, sjpark@amazon.de,
        skhan@linuxfoundation.org
Subject:  +
 scripts-deprecated_terms-sync-with-inclusive-terms.patch added to -mm tree
Message-ID: <20200714011032.PByZDJkC5%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/deprecated_terms: sync with inclusive terms
has been added to the -mm tree.  Its filename is
     scripts-deprecated_terms-sync-with-inclusive-terms.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-deprecated_terms-sync-with-inclusive-terms.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-deprecated_terms-sync-with-inclusive-terms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: scripts/deprecated_terms: sync with inclusive terms

# NOTE: this patch is based on next/master, as this is a followup of
# commit 0d8b43e5876a ("scripts/deprecated_terms: recommend
# denylist/allowlist instead of blacklist/whitelist"), which merged in
# next tree only.

Commit a5f526ecb075 ("CodingStyle: Inclusive Terminology") introduced
more terms to be deprecated with more alternatives.  This commit updates
'deprecated_terms.txt' to sync with it.

Link: http://lkml.kernel.org/r/20200713071912.24432-1-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mishi Choudhary <mishi@linux.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/deprecated_terms.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/scripts/deprecated_terms.txt~scripts-deprecated_terms-sync-with-inclusive-terms
+++ a/scripts/deprecated_terms.txt
@@ -3,5 +3,8 @@
 # The format of each line is:
 # deprecated||suggested
 #
-blacklist||denylist
-whitelist||allowlist
+blacklist||(denylist|blocklist)
+# For other alternatives of 'slave', Please refer to
+# Documentation/process/coding-style.rst
+slave||(secondary|target|...)
+whitelist||(allowlist|passlist)
_

Patches currently in -mm which might be from sjpark@amazon.de are

checkpatch-support-deprecated-terms-checking.patch
scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch
scripts-deprecated_terms-sync-with-inclusive-terms.patch

