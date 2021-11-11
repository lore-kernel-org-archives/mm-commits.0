Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08DAC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978DD610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhKKCpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhKKCpU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19DB61108;
        Thu, 11 Nov 2021 02:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598551;
        bh=wcEm4l7CyCd/vquxKbUfroir5YYjGuH0fcJX96bfJlk=;
        h=Date:From:To:Subject:From;
        b=EZOBWtqdJKSX8McyQ7acuaNrprihCLrCkhRqYKeaLmn8iG/EtApqxHnRiEelseRkW
         7Tf2fI5/9sZomiK9RMk4GX8nJSfSE6KqJDl2uIMVY3pvnpGPHR5um7OeHmfV9RYSNQ
         mvBhT+8n5yn4OqvvkSGVTQH0Iu4d/qbPvMSchzrY=
Date:   Wed, 10 Nov 2021 18:42:31 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, eb@emlix.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-use-__pfn_to_section-instead-of-open-coding-it.patch removed from -mm
 tree
Message-ID: <20211111024231.f5Y1Z0Exv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use __pfn_to_section() instead of open coding it
has been removed from the -mm tree.  Its filename was
     mm-use-__pfn_to_section-instead-of-open-coding-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from eb@emlix.com are


