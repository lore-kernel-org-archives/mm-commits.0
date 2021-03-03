Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A091C43333
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF7364E02
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381954AbhCCNar (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235055AbhCCA5d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 19:57:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB78364FA0;
        Wed,  3 Mar 2021 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614733005;
        bh=CBz9/iQYGic7bgackAKkG4RHhRUd4O9xdiCnU6pUEXM=;
        h=Date:From:To:Subject:From;
        b=nGt08lMLQQAXXTzrCEKjNGimUf/XgFZzuN+vhSgMTYjT0Yt2i4q+4e5Tf2l1D928S
         fQKf1U+zQI6xtbEiGUZh0eJmwg884YfSAjUmpnWKckE9RIX3mJ/KEfyaVg+Snbmeaa
         V3M0gEbG43vKHtD9rjdnXHRAqfdrh/FDN1uYevD0=
Date:   Tue, 02 Mar 2021 16:56:45 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mtk.manpages@gmail.com, vbabka@suse.cz
Subject:  +
 maintainers-exclude-uapi-directories-in-api-abi-section.patch added to -mm
 tree
Message-ID: <20210303005645.PnS_LAxzP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: exclude uapi directories in API/ABI section
has been added to the -mm tree.  Its filename is
     maintainers-exclude-uapi-directories-in-api-abi-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-exclude-uapi-directories-in-api-abi-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-exclude-uapi-directories-in-api-abi-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-exclude-uapi-directories-in-api-abi-section.patch

