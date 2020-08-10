Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BABB2C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99484206E9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026924;
	bh=SIk3yOS9t81XziVrMccZP6uobl8k/Cd9PEQZHg9WyfQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WijRJzSaO5RZahHpC4qGFfdr6QKoXxg8NNQrAeqYH52Dn0XtKDZ5YnHZS2lYSHk/V
	 zxbcRIkehU2RahGTWkOwPgX7eA2MSXfbeWmAUOh2SfUPKLET/LU+ZJhYJZK1HjplwT
	 ulB3Gs2oBLMhWI7VT7g/oECXfLANxQ4MuyfnkciQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B689206C3;
        Mon, 10 Aug 2020 02:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026923;
        bh=SIk3yOS9t81XziVrMccZP6uobl8k/Cd9PEQZHg9WyfQ=;
        h=Date:From:To:Subject:From;
        b=r0vKRaKhuougVopkU0hKJKLBEtHRX784W9ue/79iKQgOdB4Ex+q8CIRHp5gQb5eEw
         lKH51NNRNwUyZshKhhKmLBYdgUp8mtYUuk+3BkOUMpIzc1oYFtlcM7boegpaUPEOWe
         c5u8r7/T2F+2uD9qJZdsimJwo8GTv5lRvgbhoiqQ=
Date:   Sun, 09 Aug 2020 19:35:23 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, cl@linux.com, elver@google.com,
        glider@google.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com
Subject:  [merged]
 mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch
 removed from -mm tree
Message-ID: <20200810023523.JqjImAtlh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kcsan: instrument SLAB/SLUB free with "ASSERT_EXCLUSIVE_ACCESS"
has been removed from the -mm tree.  Its filename was
     mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: mm, kcsan: instrument SLAB/SLUB free with "ASSERT_EXCLUSIVE_ACCESS"

Provide the necessary KCSAN checks to assist with debugging racy
use-after-frees.  While KASAN is more reliable at generally catching such
use-after-frees (due to its use of a quarantine), it can be difficult to
debug racy use-after-frees.  If a reliable reproducer exists, KCSAN can
assist in debugging such issues.

Note: ASSERT_EXCLUSIVE_ACCESS is a convenience wrapper if the size is
simply sizeof(var).  Instead, here we just use __kcsan_check_access()
explicitly to pass the correct size.

Link: http://lkml.kernel.org/r/20200623072653.114563-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 +++++
 mm/slub.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/mm/slab.c~mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access
+++ a/mm/slab.c
@@ -3432,6 +3432,11 @@ static __always_inline void __cache_free
 	if (kasan_slab_free(cachep, objp, _RET_IP_))
 		return;
 
+	/* Use KCSAN to help debug racy use-after-free. */
+	if (!(cachep->flags & SLAB_TYPESAFE_BY_RCU))
+		__kcsan_check_access(objp, cachep->object_size,
+				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+
 	___cache_free(cachep, objp, caller);
 }
 
--- a/mm/slub.c~mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access
+++ a/mm/slub.c
@@ -1549,6 +1549,11 @@ static __always_inline bool slab_free_ho
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(x, s->object_size);
 
+	/* Use KCSAN to help debug racy use-after-free. */
+	if (!(s->flags & SLAB_TYPESAFE_BY_RCU))
+		__kcsan_check_access(x, s->object_size,
+				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+
 	/* KASAN might put x into memory quarantine, delaying its reuse */
 	return kasan_slab_free(s, x, _RET_IP_);
 }
_

Patches currently in -mm which might be from elver@google.com are

kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch

