Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1264FC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E949A61100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbhIHDCj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347291AbhIHDCg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F24C6109F;
        Wed,  8 Sep 2021 03:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070059;
        bh=FSG8Sa4xdbgyxO+SutKBwXQ2W2yeTN/FVhkTViuykA8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IlBxD6GtHVYdgqRldZT7krBxvbJnNxl82R3e6E/UKHekNxac9YrABxGhG34XHwHzk
         pMwCoxY7vDELZSkSRp0N7fp2Zi29zcqmBkOMXu1X+UVH4xO6J+ISRrfzCDUtqPwIrF
         6aAgh6S3r6nuFyeb7RFWoUoQk3idWgO+P9KOJn8A=
Date:   Tue, 07 Sep 2021 20:00:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, quentin.casasnovas@oracle.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 147/147] scripts: check_extable: fix typo in user
 error message
Message-ID: <20210908030059.B2Gswy-QK%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
