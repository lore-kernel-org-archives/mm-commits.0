Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575F9C46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjAJXiT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjAJXiS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:38:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D79F58332
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:38:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFAA061941
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA99C433EF;
        Tue, 10 Jan 2023 23:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673393896;
        bh=6+OA3KPr/NfpfB3yGF/AIU1ZqVv7n9NhxcHx25Yp+zo=;
        h=Date:To:From:Subject:From;
        b=fGZmywXZdcU1g/pBuIBZeNSHq0tzBWuyPbfseF/Jq+uWRRU5CSkFjJIKkASQwdK6J
         DEgakwiyz48d8zLWIx4aGIQLxK+FpZrzIreks04m6AvGTkdevcoC5thCYMqdMEbyDs
         Wc31s6Uoz6yKnBUTDffYiNw7u0KC6YGRXCZX2GA8=
Date:   Tue, 10 Jan 2023 15:38:15 -0800
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        pali@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-fix-return-value-of-vfat_bad_char-and-vfat_replace_char-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20230110233816.1CA99C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: Fix return value of vfat_bad_char() and vfat_replace_char() functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-fix-return-value-of-vfat_bad_char-and-vfat_replace_char-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-fix-return-value-of-vfat_bad_char-and-vfat_replace_char-functions.patch

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

Subject: fat: Fix return value of vfat_bad_char() and vfat_replace_char() functions
Date: Mon, 26 Dec 2022 15:25:12 +0100

These functions returns boolean value not wide character.

Link: https://lkml.kernel.org/r/20221226142512.13848-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fat/namei_vfat.c~fat-fix-return-value-of-vfat_bad_char-and-vfat_replace_char-functions
+++ a/fs/fat/namei_vfat.c
@@ -200,7 +200,7 @@ static const struct dentry_operations vf
 
 /* Characters that are undesirable in an MS-DOS file name */
 
-static inline wchar_t vfat_bad_char(wchar_t w)
+static inline bool vfat_bad_char(wchar_t w)
 {
 	return (w < 0x0020)
 	    || (w == '*') || (w == '?') || (w == '<') || (w == '>')
@@ -208,7 +208,7 @@ static inline wchar_t vfat_bad_char(wcha
 	    || (w == '\\');
 }
 
-static inline wchar_t vfat_replace_char(wchar_t w)
+static inline bool vfat_replace_char(wchar_t w)
 {
 	return (w == '[') || (w == ']') || (w == ';') || (w == ',')
 	    || (w == '+') || (w == '=');
_

Patches currently in -mm which might be from pali@kernel.org are


