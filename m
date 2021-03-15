Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A592DC43331
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8844964F07
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCOR4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236133AbhCORsl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954C864F39;
        Mon, 15 Mar 2021 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830495;
        bh=KccAoHKq1xDWvm98Syg0B/cG6EDNQUL/ZK57GFcECLs=;
        h=Date:From:To:Subject:From;
        b=OdY3cMOXeAV/HH5QpB+Vxvhrh8n90domjTL1NXoGakPGaXupCP7+oXHeGf8Zp2xTQ
         g5QYgcIGp0X6+m2viLB4A/gAa6Zz6Y9DTPGuDLikXyssTAnMIr9JaDVvD/mhETcU53
         UAiF9spocke1Vewlv4O6a3/TeFef4dzWF9bT8CHE=
Date:   Mon, 15 Mar 2021 10:48:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mtk.manpages@gmail.com, vbabka@suse.cz
Subject:  [merged]
 maintainers-exclude-uapi-directories-in-api-abi-section.patch removed from
 -mm tree
Message-ID: <20210315174815.zeJjnsdQc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: exclude uapi directories in API/ABI section
has been removed from the -mm tree.  Its filename was
     maintainers-exclude-uapi-directories-in-api-abi-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: exclude uapi directories in API/ABI section

Commit 7b4693e644cb ("MAINTAINERS: add uapi directories to API/ABI
section") added include/uapi/ and arch/*/include/uapi/ so that patches
modifying them CC linux-api.  However that was already done in the past
and resulted in too much noise and thus later removed, as explained in
b14fd334ff3d ("MAINTAINERS: trim the file triggers for ABI/API")

To prevent another round of addition and removal in the future, change the
entries to X: (explicit exclusion) for documentation purposes, although
they are not subdirectories of broader included directories, as there is
apparently no defined way to add plain comments in subsystem sections.

Link: https://lkml.kernel.org/r/20210301100255.25229-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>
Acked-by: Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-exclude-uapi-directories-in-api-abi-section
+++ a/MAINTAINERS
@@ -261,8 +261,8 @@ ABI/API
 L:	linux-api@vger.kernel.org
 F:	include/linux/syscalls.h
 F:	kernel/sys_ni.c
-F:	include/uapi/
-F:	arch/*/include/uapi/
+X:	include/uapi/
+X:	arch/*/include/uapi/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
_

Patches currently in -mm which might be from vbabka@suse.cz are


