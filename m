Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81670C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27740619DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhCaFpZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233717AbhCaFpD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 01:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC644619D6;
        Wed, 31 Mar 2021 05:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617169503;
        bh=X2aiEbt4Og47kW/bD7rzshHKFX5yNwNUrh8Ehdk5GXs=;
        h=Date:From:To:Subject:From;
        b=EKjc7nKJ1YGZPfK2058NkP4SwVog0ZEJEHBG1CnPZErbTf9KjCcyhIPm3yg1kjQi7
         4m4XgvixVGwUWbMpEW2lZajUKJxu4/FdGuVfQqorIeKEYb6IgQHjnPQ2Ns1NauPhfw
         JuO2jSKE/vjaNWDM739w4PiF4w4mAyXB99SxAPUg=
Date:   Tue, 30 Mar 2021 22:45:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rf@opensource.cirrus.com
Subject:  + lib-crc8-pointer-to-data-block-should-be-const.patch
 added to -mm tree
Message-ID: <20210331054502.0PVbDW5TV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: crc8: pointer to data block should be const
has been added to the -mm tree.  Its filename is
     lib-crc8-pointer-to-data-block-should-be-const.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-crc8-pointer-to-data-block-should-be-const.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-crc8-pointer-to-data-block-should-be-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: lib: crc8: pointer to data block should be const

crc8() does not change the data passed to it, so the pointer argument
should be declared const.  This avoids callers that receive const data
having to cast it to a non-const pointer to call crc8().

Link: https://lkml.kernel.org/r/20210329122409.3291-1-rf@opensource.cirrus.com
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crc8.h |    2 +-
 lib/crc8.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/crc8.h~lib-crc8-pointer-to-data-block-should-be-const
+++ a/include/linux/crc8.h
@@ -96,6 +96,6 @@ void crc8_populate_msb(u8 table[CRC8_TAB
  * Williams, Ross N., ross<at>ross.net
  * (see URL http://www.ross.net/crc/download/crc_v3.txt).
  */
-u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc);
+u8 crc8(const u8 table[CRC8_TABLE_SIZE], const u8 *pdata, size_t nbytes, u8 crc);
 
 #endif /* __CRC8_H_ */
--- a/lib/crc8.c~lib-crc8-pointer-to-data-block-should-be-const
+++ a/lib/crc8.c
@@ -71,7 +71,7 @@ EXPORT_SYMBOL(crc8_populate_lsb);
  * @nbytes: number of bytes in data buffer.
  * @crc: previous returned crc8 value.
  */
-u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc)
+u8 crc8(const u8 table[CRC8_TABLE_SIZE], const u8 *pdata, size_t nbytes, u8 crc)
 {
 	/* loop over the buffer data */
 	while (nbytes-- > 0)
_

Patches currently in -mm which might be from rf@opensource.cirrus.com are

lib-crc8-pointer-to-data-block-should-be-const.patch

