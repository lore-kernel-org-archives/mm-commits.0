Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48927C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2758C61263
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhKEUk4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhKEUkz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC7446056B;
        Fri,  5 Nov 2021 20:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144696;
        bh=7aqVEQ2BNP1wlsrk4fse+g/i3lItD/S7wyUeyrYH/SY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KiO5BLES9XX+fQuWzlTDf16CBIte6Ybo1cu+8Vul0l4Q+OQERWsWMZLEBZvpiVlvl
         pwQL1iSjFQsvdMpCuNHlDg42RmWwNZE0DwzwQLtZpA4KRbS3nlTXt4o+16ZSkf5+iw
         EFq4sJ865rmo5k5TPiDF7szyZGpbPp34DYTR2GLk=
Date:   Fri, 05 Nov 2021 13:38:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, eb@emlix.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 069/262] mm: use __pfn_to_section() instead of
 open coding it
Message-ID: <20211105203815.dJG5uSPY1%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: use __pfn_to_section() instead of open coding it

It is defined in the same file just a few lines above.

Link: https://lkml.kernel.org/r/4598487.Rc0NezkW7i@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-use-__pfn_to_section-instead-of-open-coding-it
+++ a/include/linux/mmzone.h
@@ -1481,7 +1481,7 @@ static inline int pfn_valid(unsigned lon
 
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	ms = __nr_to_section(pfn_to_section_nr(pfn));
+	ms = __pfn_to_section(pfn);
 	if (!valid_section(ms))
 		return 0;
 	/*
@@ -1496,7 +1496,7 @@ static inline int pfn_in_present_section
 {
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	return present_section(__nr_to_section(pfn_to_section_nr(pfn)));
+	return present_section(__pfn_to_section(pfn));
 }
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
_
