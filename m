Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDED2C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 21:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1FAB20729
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595366414;
	bh=+6WS9OzBfdy5ItIHGo2EZ+jS9GEgNIfmJ0QS/X5QLsc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ewYVkAYl8ed9Uv0ltGyvqZFX6W1H3KOBoQGlB39+CYptNrgcXY1w9YJEObFdftaDS
	 SXDUNI2iezKx4MmgqHw6Z6GKqLVguOkrauK+bNdavhYVIVIxs45NScD5Zh2PQwo8ZJ
	 Hwdp7kRyUBJqKccgZdUHR44PNy+hTfEaYXT9jGZE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbgGUVUO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jul 2020 17:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgGUVUO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jul 2020 17:20:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 909BF20717;
        Tue, 21 Jul 2020 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595366413;
        bh=+6WS9OzBfdy5ItIHGo2EZ+jS9GEgNIfmJ0QS/X5QLsc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qt7kqXqGSkxRBmPWBBX444hcaAdH/q1YF+3I0b9gSP1qNtXohBPDpZ1b1Pw3XLrQi
         SFhWiNuq8MJ+ojQ03nGgQIm16Wsr18wERmETnkIGqNffF/w9+K0PbfrEly4ZN46bCv
         T1280Bb8mhVKjBV8acAOFTjtz0py8vaMOfr7zr2E=
Date:   Tue, 21 Jul 2020 14:20:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  + maintainers-add-kcov-section.patch added to -mm tree
Message-ID: <20200721212013.9FWAa7WST%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add KCOV section
has been added to the -mm tree.  Its filename is
     maintainers-add-kcov-section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-kcov-section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-kcov-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: MAINTAINERS: add KCOV section

To link KCOV to the kasan-dev@ mailing list.

Link: http://lkml.kernel.org/r/5fa344db7ac4af2213049e5656c0f43d6ecaa379.1595331682.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/MAINTAINERS~maintainers-add-kcov-section
+++ a/MAINTAINERS
@@ -9305,6 +9305,17 @@ F:	Documentation/kbuild/kconfig*
 F:	scripts/Kconfig.include
 F:	scripts/kconfig/
 
+KCOV
+R:	Dmitry Vyukov <dvyukov@google.com>
+R:	Andrey Konovalov <andreyknvl@google.com>
+L:	kasan-dev@googlegroups.com
+S:	Maintained
+F:	Documentation/dev-tools/kcov.rst
+F:	include/linux/kcov.h
+F:	include/uapi/linux/kcov.h
+F:	kernel/kcov.c
+F:	scripts/Makefile.kcov
+
 KCSAN
 M:	Marco Elver <elver@google.com>
 R:	Dmitry Vyukov <dvyukov@google.com>
_

Patches currently in -mm which might be from andreyknvl@google.com are

maintainers-add-kcov-section.patch

