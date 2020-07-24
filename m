Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DEBC433E4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF0302067D
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564151;
	bh=BJ/HIYBodkX03YLap9T/KhracPCDNd+tIbIwww50i60=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=x7OScW5OuRLP22TMhHwKmHNSOJn+PCXPWfkfzPMN/WxLr1XUICkEKinaS9EgyuBEX
	 Xo+9a5I/OVfyhvUG6BS1S3pZ1VYFEt19rjlE7wgndVkuYwniMOxnT83YlQeN4NCCXW
	 WP7tTo7I+ohqpcD69dNFhcSdeBxa7dktXPlNue2o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGXEPu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXEPu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E34FF2074A;
        Fri, 24 Jul 2020 04:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564150;
        bh=BJ/HIYBodkX03YLap9T/KhracPCDNd+tIbIwww50i60=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VL/8cOtAUgfiILQWTKyzPN0XDAggCZK3pya7HLoxR/fYhfpnqkiaJ/IxOrZ6Cy6ww
         Wsn6zx/LdvYpVxB5ReAXLcPUZCLHadPTaysVQ+O79dXvEOydwIx16jk1DahYMEHMfE
         yupdth+aQG5i63Cu92ksX0FsXv+OI0fRJIFHinl0=
Date:   Thu, 23 Jul 2020 21:15:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 14/15] MAINTAINERS: add KCOV section
Message-ID: <20200724041549.4JVX-UC_Q%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
