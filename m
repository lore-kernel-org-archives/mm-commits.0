Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5E0C433E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BBD20737
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633928;
	bh=N8O8XpNEs4SVJsDwbgIvi/pjx/yCOlLLzVM5Crig3aQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OdScR7SKRqUK3MrUcwmbcV0vWHwl8Vi0gBUaNGscVp25bWEKnEkqOnGbOVZcZgtgI
	 tkYkS04aczZk0HNR8Ffqr4x2zv3AAV5luBJbzpr2EwS8su3iyUMqD1jxeuaOytvgQB
	 P/q7LbIqdVXL9NQMVqROMAxeiR35T8oJYicY+Fmg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgGXXis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgGXXis (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75B902070E;
        Fri, 24 Jul 2020 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633927;
        bh=N8O8XpNEs4SVJsDwbgIvi/pjx/yCOlLLzVM5Crig3aQ=;
        h=Date:From:To:Subject:From;
        b=ljFRYvh+HxoKWJhXlY7DzlXn7oUDvedq12ppJU0hMOlhICfDhKx4bWQmUMMGOHcyr
         gMV/Yg7ITOELsHVMwsYU6txBL8lEtCirFWrPoljP7UOt4uIA95v7PDWH6jPipES4Yj
         ODwUNYpYMUDMGn5vKet2xkzncoLX9ceFKK2G8D20=
Date:   Fri, 24 Jul 2020 16:38:47 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] maintainers-add-kcov-section.patch removed from
 -mm tree
Message-ID: <20200724233847.Gtznf0-9E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add KCOV section
has been removed from the -mm tree.  Its filename was
     maintainers-add-kcov-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -9306,6 +9306,17 @@ F:	Documentation/kbuild/kconfig*
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


