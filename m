Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1E8C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8C3364FB5
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhCMFIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231383AbhCMFHp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8123164F94;
        Sat, 13 Mar 2021 05:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612064;
        bh=w2PFJ+IWtWXABLgdaeiVIyx3jhKcHvFY5oq604YvHDs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YtBycZ1HD1rTh5DEE79W4h/vcztzXeZg2yERHKQlRXffYPI/aZQefn/Tq6YSfPzQ/
         P1R4wtsbjjK4C2lONJap3B3N0rAjrcaB7/TLLY1fTZbopmQC6WrEbllrGKD4gOT7/k
         Tcb2nI+9xI/T0aDFLZRie1lx6FhQqa/DXaxFXDxU=
Date:   Fri, 12 Mar 2021 21:07:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 13/29] MAINTAINERS: exclude uapi directories in
 API/ABI section
Message-ID: <20210313050744.Av1odencQ%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
