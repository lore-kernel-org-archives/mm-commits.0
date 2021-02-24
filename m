Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC10C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5581D64EA4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhBXUBe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234480AbhBXUBa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:01:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DEE64F07;
        Wed, 24 Feb 2021 20:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196828;
        bh=/9aIYVJWZbcNr6F7gti99XLsAT0JIhwvvWlZzB7xumM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jmn1jr8f4YtbG7IS3/0a1F/oDTF6wmZ0Dc1WWtrAyvjnMvjh40A0zK/Sb0hI/mhKs
         0/DmM4avcA0M1eCOy0gkHmWlDkpK88ReXvZ0WO+CNvG+GJKGVjjSGNhNHr9/7iQzKI
         sy27DvpXpDcOpgbrqngLg5Kh7DHz1p8M4WmV9mG0=
Date:   Wed, 24 Feb 2021 12:00:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@tuxera.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 006/173] ntfs: layout.h: delete duplicated words
Message-ID: <20210224200027.a9TRFzIfq%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: ntfs: layout.h: delete duplicated words

Drop the repeated words "the" and "in" in comments.

Link: https://lkml.kernel.org/r/20210125194937.24627-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/layout.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ntfs/layout.h~ntfs-layouth-delete-duplicated-words
+++ a/fs/ntfs/layout.h
@@ -703,7 +703,7 @@ typedef struct {
 /* 14*/	le16 instance;		/* The instance of this attribute record. This
 				   number is unique within this mft record (see
 				   MFT_RECORD/next_attribute_instance notes in
-				   in mft.h for more details). */
+				   mft.h for more details). */
 /* 16*/	union {
 		/* Resident attributes. */
 		struct {
@@ -1838,7 +1838,7 @@ typedef struct {
  * Also, each security descriptor is stored twice in the $SDS stream with a
  * fixed offset of 0x40000 bytes (256kib, the Windows cache manager's max size)
  * between them; i.e. if a SDS_ENTRY specifies an offset of 0x51d0, then the
- * the first copy of the security descriptor will be at offset 0x51d0 in the
+ * first copy of the security descriptor will be at offset 0x51d0 in the
  * $SDS data stream and the second copy will be at offset 0x451d0.
  */
 typedef struct {
_
