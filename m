Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE934C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0F42177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781154;
	bh=2UE3dQE/YR8k4zIoUAYLHNZ1AerjcU14FqZxzHA1uEE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tHTpbQqK7bXEEbzXciw/JKsfqbpszRJcCLYS3rgqImgw76yz91Axjy/sKSNmG51tb
	 ylRkRQoUMUFwcbj2Z4b5WlT+jkRyExzW9dcLwMJKjaFnAmX6II2m9fzlvItlssxFjo
	 6JuTaae6lihjLznDJV4ixuG/DMMh3czZoJmLcd5M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGGTO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B6722CAF;
        Fri,  7 Aug 2020 06:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781153;
        bh=2UE3dQE/YR8k4zIoUAYLHNZ1AerjcU14FqZxzHA1uEE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0K1uw6CgAKdDBpkkaQoF6X23Dm+oxYxzfkfrGGQtXSoaJ2Uw73n8Mc/h02cDUVzxe
         mo0z78fhfArfol1fxuiUmhUWQ/KhObAofJk40A2qdnF92MQ8FH4HGwbUq+hclZTjCk
         v8D/rnmKx0hH9QwECG4miQNd5UAONdC2jvzyzoQM=
Date:   Thu, 06 Aug 2020 23:19:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, cl@linux.com,
        elver@google.com, glider@google.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org
Subject:  [patch 039/163] mm, kcsan: instrument SLAB/SLUB free with
 "ASSERT_EXCLUSIVE_ACCESS"
Message-ID: <20200807061912.r0alqJmL-%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
