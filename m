Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C19C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E59A206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196074;
	bh=wnPMbSG0caMVBJ6q3vTMMTN89+MjMxPvdJRJWBQDxBM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=egKC88funBNnS32+YAxiMgGczdFwHrgESYEygugnkAEiKhPPuWLsprbCssgaKS6wo
	 CRRuNIQhM+FfEE/mym9OzupK1dfLucUS4VpNNLX4S9VSnhFwxdgjg2+cx19dodRc1g
	 9VX2s0Gv0gJwbxL+GKRCbXmRk94ldfNDh7IS26p0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLBee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBed (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94960207F7;
        Wed, 12 Aug 2020 01:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196072;
        bh=wnPMbSG0caMVBJ6q3vTMMTN89+MjMxPvdJRJWBQDxBM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SiNgRQ5d5gN80u28uDfJEP143B8xZRJ0HD+KYCVtmVRXywk62RHU3hF/PnXu/hz28
         WOTv9FS+aItv5kpZZJI+DBILu8Wba4SjtBwxgFQe17OKyYJsEpRlN9cUP6aMURp0qJ
         murHLAfl+8TLm7Y4GP6hKP7Qw3MKWiwdZumRCGQk=
Date:   Tue, 11 Aug 2020 18:34:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, pablo@netfilter.org,
        sbrivio@redhat.com, torvalds@linux-foundation.org,
        yury.norov@gmail.com
Subject:  [patch 081/165] lib/test_bitmap.c: add test for
 bitmap_cut()
Message-ID: <20200812013432.VpkOGljuF%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Subject: lib/test_bitmap.c: add test for bitmap_cut()

Inspired by an original patch from Yury Norov: introduce a test for
bitmap_cut() that also makes sure functionality is as described for
partially overlapping src and dst.

Link: http://lkml.kernel.org/r/5fc45e6bbd4fa837cd9577f8a0c1d639df90a4ce.1592155364.git.sbrivio@redhat.com
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   58 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/lib/test_bitmap.c~bitmap-add-test-for-bitmap_cut
+++ a/lib/test_bitmap.c
@@ -610,6 +610,63 @@ static void __init test_for_each_set_clu
 		expect_eq_clump8(start, CLUMP_EXP_NUMBITS, clump_exp, &clump);
 }
 
+struct test_bitmap_cut {
+	unsigned int first;
+	unsigned int cut;
+	unsigned int nbits;
+	unsigned long in[4];
+	unsigned long expected[4];
+};
+
+static struct test_bitmap_cut test_cut[] = {
+	{  0,  0,  8, { 0x0000000aUL, }, { 0x0000000aUL, }, },
+	{  0,  0, 32, { 0xdadadeadUL, }, { 0xdadadeadUL, }, },
+	{  0,  3,  8, { 0x000000aaUL, }, { 0x00000015UL, }, },
+	{  3,  3,  8, { 0x000000aaUL, }, { 0x00000012UL, }, },
+	{  0,  1, 32, { 0xa5a5a5a5UL, }, { 0x52d2d2d2UL, }, },
+	{  0,  8, 32, { 0xdeadc0deUL, }, { 0x00deadc0UL, }, },
+	{  1,  1, 32, { 0x5a5a5a5aUL, }, { 0x2d2d2d2cUL, }, },
+	{  0, 15, 32, { 0xa5a5a5a5UL, }, { 0x00014b4bUL, }, },
+	{  0, 16, 32, { 0xa5a5a5a5UL, }, { 0x0000a5a5UL, }, },
+	{ 15, 15, 32, { 0xa5a5a5a5UL, }, { 0x000125a5UL, }, },
+	{ 15, 16, 32, { 0xa5a5a5a5UL, }, { 0x0000a5a5UL, }, },
+	{ 16, 15, 32, { 0xa5a5a5a5UL, }, { 0x0001a5a5UL, }, },
+
+	{ BITS_PER_LONG, BITS_PER_LONG, BITS_PER_LONG,
+		{ 0xa5a5a5a5UL, 0xa5a5a5a5UL, },
+		{ 0xa5a5a5a5UL, 0xa5a5a5a5UL, },
+	},
+	{ 1, BITS_PER_LONG - 1, BITS_PER_LONG,
+		{ 0xa5a5a5a5UL, 0xa5a5a5a5UL, },
+		{ 0x00000001UL, 0x00000001UL, },
+	},
+
+	{ 0, BITS_PER_LONG * 2, BITS_PER_LONG * 2 + 1,
+		{ 0xa5a5a5a5UL, 0x00000001UL, 0x00000001UL, 0x00000001UL },
+		{ 0x00000001UL, },
+	},
+	{ 16, BITS_PER_LONG * 2 + 1, BITS_PER_LONG * 2 + 1 + 16,
+		{ 0x0000ffffUL, 0x5a5a5a5aUL, 0x5a5a5a5aUL, 0x5a5a5a5aUL },
+		{ 0x2d2dffffUL, },
+	},
+};
+
+static void __init test_bitmap_cut(void)
+{
+	unsigned long b[5], *in = &b[1], *out = &b[0];	/* Partial overlap */
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cut); i++) {
+		struct test_bitmap_cut *t = &test_cut[i];
+
+		memcpy(in, t->in, sizeof(t->in));
+
+		bitmap_cut(out, in, t->first, t->cut, t->nbits);
+
+		expect_eq_bitmap(t->expected, out, t->nbits);
+	}
+}
+
 static void __init selftest(void)
 {
 	test_zero_clear();
@@ -623,6 +680,7 @@ static void __init selftest(void)
 	test_bitmap_parselist_user();
 	test_mem_optimisations();
 	test_for_each_set_clump8();
+	test_bitmap_cut();
 }
 
 KSTM_MODULE_LOADERS(test_bitmap);
_
