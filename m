Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4886DC4332B
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7FF864F41
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhBZBV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhBZBUS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:20:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7AA64F27;
        Fri, 26 Feb 2021 01:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302377;
        bh=APKQIVXDwW+jFLX591puLeX2AuDyJfLITxA1WUyjakA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M6E8XC4oQSgrMuafxcDawICij5JeTt2VApX6f8tLM6eqNOp148TTzkMRlr1jKE5B7
         44jUeftVmPkhetgBlYpR0F44+GwpsrYS/cizpNyqzv4OG+qjmI50nZeleVUpr5S8vD
         yi54MV1QeGQC4E/9aoTGRnggwK6JIkQWuj8TGtuE=
Date:   Thu, 25 Feb 2021 17:19:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, bp@alien8.de, catalin.marinas@arm.com,
        cl@linux.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        dvyukov@google.com, edumazet@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, hdanton@sina.com,
        hpa@zytor.com, iamjoonsoo.kim@lge.com, jannh@google.com,
        joern@purestorage.com, keescook@chromium.org, linux-mm@kvack.org,
        luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        peterz@infradead.org, rientjes@google.com, sjpark@amazon.de,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz,
        will@kernel.org
Subject:  [patch 065/118] MAINTAINERS: add entry for KFENCE
Message-ID: <20210226011935.AF3n4U53t%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: MAINTAINERS: add entry for KFENCE

Add entry for KFENCE maintainers.

Link: https://lkml.kernel.org/r/20201103175841.3495947-10-elver@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Co-developed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joern Engel <joern@purestorage.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-kfence
+++ a/MAINTAINERS
@@ -9867,6 +9867,18 @@ F:	include/linux/keyctl.h
 F:	include/uapi/linux/keyctl.h
 F:	security/keys/
 
+KFENCE
+M:	Alexander Potapenko <glider@google.com>
+M:	Marco Elver <elver@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
+L:	kasan-dev@googlegroups.com
+S:	Maintained
+F:	Documentation/dev-tools/kfence.rst
+F:	arch/*/include/asm/kfence.h
+F:	include/linux/kfence.h
+F:	lib/Kconfig.kfence
+F:	mm/kfence/
+
 KFIFO
 M:	Stefani Seibold <stefani@seibold.net>
 S:	Maintained
_
