Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72A6C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjBCGvc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjBCGvN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF91A4DE31
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799CF61DBB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5002C433D2;
        Fri,  3 Feb 2023 06:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407065;
        bh=PsR1lnMRwR35pt2l6HQbCKgOLLS/at7SCsHwPmq/b9s=;
        h=Date:To:From:Subject:From;
        b=BycZ5l2GHAVn7ZtSTYejyzPUUFiAGp+AKxf01vcGOFOpF9opluDNzVvabr/+OtwPj
         3rWvJx3RqulQpTlvgV/3xnSdNvJTDg6+eFxP9kyCU5v8OgZtqc904SDQYU01JrTmhb
         t9IFVRM171gaeeBsW9ou3ZhsTLhQwuhbM+mzuHZY=
Date:   Thu, 02 Feb 2023 22:51:05 -0800
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        pali@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-fix-return-value-of-vfat_bad_char-and-vfat_replace_char-functions.patch removed from -mm tree
Message-Id: <20230203065105.D5002C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: fix return value of vfat_bad_char() and vfat_replace_char() functions
has been removed from the -mm tree.  Its filename was
     fat-fix-return-value-of-vfat_bad_char-and-vfat_replace_char-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pali Rohár <pali@kernel.org>
Subject: fat: fix return value of vfat_bad_char() and vfat_replace_char() functions
Date: Mon, 26 Dec 2022 15:25:12 +0100

These functions returns boolean value not wide character.

Link: https://lkml.kernel.org/r/20221226142512.13848-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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


