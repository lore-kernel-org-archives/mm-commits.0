Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A33C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F1C60E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWyA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhEHWx7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88FCA61402;
        Sat,  8 May 2021 22:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514377;
        bh=pIhq9gAl9ebd6DrSQ9wmt8KFrOU3BictgHSiBAOpbFs=;
        h=Date:From:To:Subject:From;
        b=jBh7cBRGN4HBHiMfvfcZcQjYowVVsow4QD/jRUkkeNGPeIRIl6PfBG5ZHv4KrCbQS
         apUcAfLtPo1dgbhQ5VDcLg5KOhUI8aqCIFdiKgpOoNDFK8yoo2jvG4Wz2oZ4S6EJn1
         wtAK4omWk/m0EpfVoWYqpKrUS/RqCly3J+sYRSG8=
Date:   Sat, 08 May 2021 15:52:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rf@opensource.cirrus.com
Subject:  [merged]
 lib-crc8-pointer-to-data-block-should-be-const.patch removed from -mm tree
Message-ID: <20210508225257.wBpxKecZ5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: crc8: pointer to data block should be const
has been removed from the -mm tree.  Its filename was
     lib-crc8-pointer-to-data-block-should-be-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


