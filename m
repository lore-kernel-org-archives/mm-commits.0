Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6ECAC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8069864F34
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhBZBWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhBZBWO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF61264F3D;
        Fri, 26 Feb 2021 01:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302475;
        bh=QQawAVI/0ab3G1ojotv4HGa0cgPiX6B2i9uFzB/wBdg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EjX+F232NGOtpNwAnzzRjKaZdqHSUNBb2WlH0SJnXojF48YYAL+MQqvm9M90giKq5
         RC9qFAwQj/CQLH5lRvlrWBDpaSVnA1Q+CGIBVjlb42UT0BB4aATDuICsP9drTPGaDV
         6kUvFG6gGEmoHqH2dEYqRAIfU6lb362LrKnolykk=
Date:   Thu, 25 Feb 2021 17:21:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 091/118] MAINTAINERS: add uapi directories to
 API/ABI section
Message-ID: <20210226012114.nmlpmyIrt%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: add uapi directories to API/ABI section

Let's add include/uapi/ and arch/*/include/uapi/ to API/ABI section, so
that for patches modifying them, get_maintainers.pl suggests CCing
linux-api@ so people don't forget.

Link: https://lkml.kernel.org/r/20210217174745.13591-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: David Hildenbrand <david@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-uapi-directories-to-api-abi-section
+++ a/MAINTAINERS
@@ -261,6 +261,8 @@ ABI/API
 L:	linux-api@vger.kernel.org
 F:	include/linux/syscalls.h
 F:	kernel/sys_ni.c
+F:	include/uapi/
+F:	arch/*/include/uapi/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
_
