Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CA5EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjFSX1L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjFSXZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32281BCF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D00560FC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4791C433C0;
        Mon, 19 Jun 2023 23:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217002;
        bh=IgT5G6JQLMJvZ5y/9xIlf7j5Lu8TxcNeRO/MN/JOXUc=;
        h=Date:To:From:Subject:From;
        b=D+D5KbZ+HIub/ME/Kl6nyzqfCLiLlD53am3yoii6Y7caoRZhbmc9FkKodMP+/0SW9
         sUmV/MmDd2BNRcAqKiwmCFEwMq72AnA4AIsOlMEFPRuWORwvViDrriXF/RiQOhRADb
         GGUT+wD9QJwhCK/avVPM/5foS5ZFW6D8Vze6K1ac=
Date:   Mon, 19 Jun 2023 16:23:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmzone-introduce-folio_is_zone_movable.patch removed from -mm tree
Message-Id: <20230619232322.B4791C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmzone: introduce folio_is_zone_movable()
has been removed from the -mm tree.  Its filename was
     mmzone-introduce-folio_is_zone_movable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mmzone: introduce folio_is_zone_movable()
Date: Tue, 13 Jun 2023 19:13:08 -0700

Patch series "Replace is_longterm_pinnable_page()", v2.

This patchset introduces some more helper functions for the folio
conversions, and converts all callers of is_longterm_pinnable_page() to
use folios.


This patch (of 5):

Introduce folio_is_zone_movable() to act as a folio equivalent for
is_zone_movable_page().  This is to assist in later folio conversions.

Link: https://lkml.kernel.org/r/20230614021312.34085-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230614021312.34085-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mmzone.h~mmzone-introduce-folio_is_zone_movable
+++ a/include/linux/mmzone.h
@@ -1116,6 +1116,11 @@ static inline bool is_zone_movable_page(
 {
 	return page_zonenum(page) == ZONE_MOVABLE;
 }
+
+static inline bool folio_is_zone_movable(const struct folio *folio)
+{
+	return folio_zonenum(folio) == ZONE_MOVABLE;
+}
 #endif
 
 /*
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch

